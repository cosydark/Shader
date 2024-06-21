#ifdef PM_HEADER
#attribute Plugin.Author = "QP4B"
#attribute Plugin.Name = "TerrainBlend"
#attribute Plugin.Priority = 0
#attribute Plugin.AlwaysEnable = False

#pluginoption.CustomNormal = Enable
#pluginfunction.PostProcessMaterialInput = Enable

#stylesheet
# Terrain Blend
- _TerrainBlend_UseHeightLerp @Drawer(Toggle)
- _TerrainBlend_BlendHeight
- _TerrainBlend_HeightOffset @Hide(_TerrainBlend_UseHeightLerp == 0)
- _TerrainBlend_BlendRadius @Hide(_TerrainBlend_UseHeightLerp == 0)


#endstylesheet

#properties
_TerrainBlend_UseHeightLerp ("Use Height Lerp", Int) = 0
_TerrainBlend_BlendHeight ("Blend Height", Range(0, 3)) = 1
_TerrainBlend_HeightOffset ("Height Offset", Range(0, 1)) = 0.5
_TerrainBlend_BlendRadius ("Blend Radius", Range(0.001, 0.5)) = 0.1

#endproperties

#endif

#include "Packages/com.funplus.xrender/Shaders/Library/Common.hlsl"
#include "Packages/com.funplus.xrender/Shaders/Library/CommonHeader.hlsl"
#include "Assets/Res/Shader/Includes/CustomTerrainVTBlend.hlsl"
#include "Assets/Res/Shader/Includes/HeightLerp.hlsl"

void BlendTerrainVTWithOutHeight(FPixelInput PixelIn, inout MInputType MInput, float BlendHeight)
{
    float QuadIndex = 0;
    float2 NodeUV = float2(0, 0);
    ComputeNodeUVAndQuadIndex(PixelIn.PositionWS, NodeUV, QuadIndex);
    float TerrainHeight = GetTerrainHeight(PixelIn.PositionWS, NodeUV, QuadIndex);
    
    if(PixelIn.PositionWS.y >= TerrainHeight - 0.5 && PixelIn.PositionWS.y <= TerrainHeight + BlendHeight + 0.1)
    {
        float BlendAlpha = saturate(1.0 - (PixelIn.PositionWS.y - TerrainHeight) / BlendHeight);
        BlendAlpha = smoothstep(0, 1, BlendAlpha);
        
        ZERO_INITIALIZE(TerrainData, Data);
        SampleAVT(PixelIn.PositionWS, -PixelIn.GeometricNormalWS.xz, NodeUV, QuadIndex, Data);
        MInput.Base.Color = lerp(MInput.Base.Color, Data.TerrainColor, BlendAlpha);
        MInput.Base.Metallic = lerp(MInput.Base.Metallic, Data.TerrainMetallic, BlendAlpha);
        MInput.Base.Roughness = lerp(MInput.Base.Roughness, Data.TerrainRoughness, BlendAlpha);
        MInput.AO.AmbientOcclusion = lerp(MInput.AO.AmbientOcclusion, Data.TerrainAmbientOcclusion, BlendAlpha);
        MInput.Detail.Height = lerp(MInput.Detail.Height, Data.TerrainHeight, BlendAlpha);
        MInput.Geometry.NormalWS = normalize(lerp(MInput.Geometry.NormalWS, Data.TerrainNormalWS, BlendAlpha));
        MInput.Geometry.BinormalWS = normalize(lerp(MInput.Geometry.BinormalWS, Data.TerrainBinormalWS, BlendAlpha));
        MInput.Geometry.TangentWS = normalize(lerp(MInput.Geometry.TangentWS, Data.TerrainTangentWS, BlendAlpha));
    }
}
void BlendTerrainVTWithHeight(FPixelInput PixelIn, inout MInputType MInput, float BlendHeight, float HeightOffset, float BlendRadius, float BlendMode)
{
    float QuadIndex = 0;
    float2 NodeUV = float2(0, 0);
    ComputeNodeUVAndQuadIndex(PixelIn.PositionWS, NodeUV, QuadIndex);
    float TerrainHeight = GetTerrainHeight(PixelIn.PositionWS, NodeUV, QuadIndex);
    
    if(PixelIn.PositionWS.y >= TerrainHeight - 0.5 && PixelIn.PositionWS.y <= TerrainHeight + BlendHeight + 0.1)
    {
        float BlendAlpha = saturate(1.0 - (PixelIn.PositionWS.y - TerrainHeight) / BlendHeight);
        BlendAlpha = smoothstep(0, 1, BlendAlpha);
        
        ZERO_INITIALIZE(TerrainData, Data);
        SampleAVT(PixelIn.PositionWS, -PixelIn.GeometricNormalWS.xz,NodeUV, QuadIndex, Data);

        float HeightBlendMask = ComputeHeightBlendMask(saturate(ModifyHeight(Data.TerrainHeight, HeightOffset)), MInput.Detail.Height, BlendAlpha, BlendRadius, BlendMode);

        MInput.Base.Color = lerp(MInput.Base.Color, Data.TerrainColor, HeightBlendMask);
        MInput.Base.Metallic = lerp(MInput.Base.Metallic, Data.TerrainMetallic, HeightBlendMask);
        MInput.Base.Roughness = lerp(MInput.Base.Roughness, Data.TerrainRoughness, HeightBlendMask);
        MInput.AO.AmbientOcclusion = lerp(MInput.AO.AmbientOcclusion, Data.TerrainAmbientOcclusion, HeightBlendMask);
        MInput.Detail.Height = lerp(MInput.Detail.Height, Data.TerrainHeight, HeightBlendMask);
        MInput.Geometry.NormalWS = normalize(lerp(MInput.Geometry.NormalWS, Data.TerrainNormalWS, HeightBlendMask));
        MInput.Geometry.BinormalWS = normalize(lerp(MInput.Geometry.BinormalWS, Data.TerrainBinormalWS, HeightBlendMask));
        MInput.Geometry.TangentWS = normalize(lerp(MInput.Geometry.TangentWS, Data.TerrainTangentWS, HeightBlendMask));
    }
}

void PostProcessMaterialInput_New(FPixelInput PixelIn, FSurfacePositionData PosData, inout MInputType MInput)
{
    if(_TerrainBlend_UseHeightLerp > FLT_EPS)
    {
        BlendTerrainVTWithHeight(PixelIn, MInput, _TerrainBlend_BlendHeight, _TerrainBlend_HeightOffset, _TerrainBlend_BlendRadius, 0);
    }
    else
    {
        BlendTerrainVTWithOutHeight(PixelIn, MInput, _TerrainBlend_BlendHeight);
    }
}
