// Author: QP4B
#ifndef XRENDER_RES_AVT_HLSL_INCLUDED
#define XRENDER_RES_AVT_HLSL_INCLUDED

#include "Packages/com.funplus.xrender/Shaders/Library/CommonSampler.hlsl"
#include "Packages/com.funplus.xrender/Shaders/Library/CommonTransform.hlsl"
#include "Packages/com.funplus.xrender/Shaders/Library/CommonHeader.hlsl"
#include "Packages/com.funplus.xrender/Shaders/Modules/XTerrain/XTerrainVTFunction.hlsl"

struct TerrainData
{
    float3 TerrainColor;
    float TerrainMetallic;
    float TerrainAmbientOcclusion;
    float TerrainHeight;// HeightMap
    float TerrainRoughness;
    float3 TerrainPositionWS;
    float3 TerrainNormalWS;
    float3 TerrainTangentWS;
    float3 TerrainBinormalWS;
};

void GetTerrainNormalWS(float2 NodeUV, float QuadIndex, float3 NormalTS, inout TerrainData TData)
{
    float3 NormalWS = SampleTerrainNormalData(NodeUV, QuadIndex);
    float4 TangentWS = GetTerrainTangentData(NormalWS);
    float BinormalSymmetry = TangentWS.w > 0.0 ? 1.0 : -1.0;
    float3x3 TangentToWorldMatrix = BuildTangentToWorldMatrix(TangentWS.xyz, NormalWS, BinormalSymmetry);

    TData.TerrainNormalWS = SafeNormalize(TransformVectorTSToVectorWS_RowMajor(NormalTS, TangentToWorldMatrix));
    TData.TerrainTangentWS = Orthonormalize(TangentWS, TData.TerrainNormalWS);
    TData.TerrainBinormalWS = ComputeBinormal(TData.TerrainNormalWS, TData.TerrainTangentWS, BinormalSymmetry);
}
void GetAVTData(float2 SectorUV, float2 QuadUV, float2 VirtualImageUV, float VirtualImageSize, float QuadIndex, out float4 Albedo, out float4 Normal)
{
    VirtualTextureContext ctx = InitialVirtualTextureContext();

    if(VirtualImageSize <= ctx.VirtualTextureMaxMip)
    {
        float2 InnerUV = SectorUV * exp2(VirtualImageSize) * ctx.VirtualPageSize;
        float2 VTCoord = VirtualImageUV + InnerUV;
        float4 IndirectPageValue = GetTerrainIndirectData(InnerUV, VTCoord, VirtualImageSize, ctx.VirtualPageSize);

        if (IndirectPageValue.w < 1.0f)
        {
            float2 PhysicalUV = GetTerrainPhysicalUV(IndirectPageValue, SectorUV, VirtualImageSize, ctx);

            Albedo = SAMPLE_TEXTURE2D_LOD(_DiffusePhysicalPage, sampler_LinearClampAniso8, PhysicalUV, 0);
            Normal = SAMPLE_TEXTURE2D_LOD(_NormalPhysicalPage, sampler_LinearClampAniso8, PhysicalUV, 0);
        }
        else
        {
            float2 AtlasUV = GetTerrainAtlasUV(QuadUV, ctx);

            Albedo = SAMPLE_TEXTURE2D_ARRAY_LOD(_AtlasDiffuseMapArray, sampler_LinearClampAniso8, AtlasUV, QuadIndex, 0);
            Normal = SAMPLE_TEXTURE2D_ARRAY_LOD(_AtlasNormalMapArray, sampler_LinearClampAniso8, AtlasUV, QuadIndex, 0);
        }
    }
    else
    {
        float2 AtlasUV = GetTerrainAtlasUV(QuadUV, ctx);

        Albedo = SAMPLE_TEXTURE2D_ARRAY_LOD(_AtlasDiffuseMapArray, sampler_LinearClampAniso8, AtlasUV, QuadIndex, 0);
        Normal = SAMPLE_TEXTURE2D_ARRAY_LOD(_AtlasNormalMapArray, sampler_LinearClampAniso8, AtlasUV, QuadIndex, 0);
    }
}

void ComputeNodeUVAndQuadIndex(float3 PositionWS, inout float2 NodeUV, inout float QuadIndex)
{
    float2 GlobalUV = PositionWS.xz * GetInvTerrainSize() + 0.5;
    SampleTerrainLODData(GlobalUV, PositionWS, NodeUV, QuadIndex);
}
float GetTerrainHeight(float3 PositionWS, float2 NodeUV, float QuadIndex)
{
    return SampleTerrainHeightData(NodeUV, QuadIndex);
}
void SampleAVT(float3 PositionWS, float2 Offset, float2 NodeUV, float QuadIndex, inout TerrainData TData)
{
    float TerrainHeightWS = GetTerrainHeight(PositionWS, NodeUV, QuadIndex);
    PositionWS.xz += (PositionWS.y - TerrainHeightWS) * Offset;// Offset With Normal
    float2 GlobalUV = PositionWS.xz * GetInvTerrainSize() + 0.5;
    SampleTerrainLODData(GlobalUV, PositionWS, NodeUV, QuadIndex);
    float2 SectorUV = frac(PositionWS.xz / GetSectorSizeMeter());
    float2 VirtualImageUV;
    float VirtualImageSize;
    float VirtualImageIDHash;
    SampleTerrainVTData(GlobalUV, VirtualImageUV, VirtualImageSize, VirtualImageIDHash);
    // Sample AVT
    float4 Albedo;
    float4 Normal;
    GetAVTData(SectorUV, NodeUV, VirtualImageUV, VirtualImageSize, QuadIndex, Albedo, Normal);
    // Decode
    TData.TerrainColor = GetTerrainBaseColor(Albedo, true);
    TData.TerrainMetallic = 0;
    TData.TerrainRoughness = GetTerrainRoughness(Normal);
    TData.TerrainAmbientOcclusion = GetTerrainAO(Albedo);
    TData.TerrainHeight = GetTerrainHeight(Normal);
    TData.TerrainPositionWS = float3(PositionWS.x, TerrainHeightWS, PositionWS.z);
    GetTerrainNormalWS(NodeUV, QuadIndex, GetTerrainNormalTS(Normal), TData);
}
#endif