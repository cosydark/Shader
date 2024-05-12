#ifdef PM_HEADER
#attribute Plugin.Author = "QP4B"
#attribute Plugin.Name = "WinterSuite"
#attribute Plugin.Priority = 0
#attribute Plugin.AlwaysEnable = False

// #pluginoption.UseUV1 = Enable
// #pluginoption.UseUV2 = Enable
// #pluginoption.UseUV3 = Enable
// #pluginoption.CustomizeVertexOutput = Enable
// #pluginoption.CustomizeVertexOutputData = Enable

#pluginfunction.PostProcessMaterialInput = Enable
// #pluginfunction.PostProcessFinalColor = Enable
// #pluginfunction.CalculateVertexOffsetObjectSpace = Enable
// #pluginfunction.CalculateVertexOffsetWorldSpace = Enable
// #pluginfunction.PrepareMaterialVertexCustomOutputData = Enable
// #pluginfunction.PrepareMaterialVertexCustomOutput = Enable

#stylesheet

# WinterSuite
- _WinterSuite_HeightCulling @Drawer(Toggle)

### Map
- _WinterSuite_Tiling
- _WinterSuite_BaseMap @TryInline(0)
- _WinterSuite_NormalMap @TryInline(1)
- _WinterSuite_NormalScale
- _WinterSuite_MaskMap @TryInline(0)

### Fuzz
- _WinterSuite_FuzzColorMap @TryInline(1)
- _WinterSuite_FuzzColor
- _WinterSuite_FuzzRoughness

### Surface
- _WinterSuite_Coverage
- _WinterSuite_Spread
- _WinterSuite_Transition


#endstylesheet


#properties
_WinterSuite_HeightCulling ("Height Culling", Int) = 1

_WinterSuite_Tiling ("Tiling", Float) = 1
_WinterSuite_BaseMap ("Base Map", 2D) = "white" {}
_WinterSuite_NormalMap ("Normal Map", 2D) = "bump" {}
_WinterSuite_NormalScale ("Normal Scale", Range(0, 1)) = 1
_WinterSuite_MaskMap ("Mask Map", 2D) = "white" {}

_WinterSuite_FuzzColorMap ("Fuzz Color Map", 2D) = "white" {}
[HDR] _WinterSuite_FuzzColor ("Fuzz Color", Color) = (1, 1, 1)
_WinterSuite_FuzzRoughness ("Fuzz Roughness", Range(0, 1)) = 0.5

_WinterSuite_Coverage ("Coverage", Range(0, 1)) = 0.5
_WinterSuite_Spread ("Spread", Range(0, 1)) = 0.5
_WinterSuite_Transition ("Transition", Range(0, 1)) = 0.5

#endproperties
#endif

#include "Packages/com.funplus.xrender/Shaders/Library/Common.hlsl"
#include "Packages/com.funplus.xrender/Shaders/Library/CommonHeader.hlsl"
#include "Packages/com.funplus.xrender/Shaders/Library/CommonSampler.hlsl"
#include "Packages/com.funplus.xrender/Shaders/Library/CommonMaterial.hlsl"
#include "Packages/com.funplus.xrender/Shaders/Modules/VectorField/VectorTextureUtils.hlsl"

void PostProcessMaterialInput(FPixelInput PixelIn, FSurfacePositionData PosData, inout FMaterialInput MInput)
{
    
}

void PostProcessMaterialInput_New(FPixelInput PixelIn, FSurfacePositionData PosData, inout MInputType MInput)
{
    // TODO Clean
    float3 SurfaceNormal = MInput.TangentSpaceNormal.NormalTS;
    float Depth = 1 - MInput.Detail.Height;
    // Height Cull
    float HeightCullingAttenuation  = 1;

    BRANCH
    if(_WinterSuite_HeightCulling == 1)
    {
        TryGetSnowHeightAttenSmooth(PixelIn.PositionWS, PixelIn.GeometricNormalWS, PosData.ScreenPixelCoord, HeightCullingAttenuation);
    }
    // Snow Map
    float4 SnowBaseColor = SAMPLE_TEXTURE2D(_WinterSuite_BaseMap, SamplerLinearRepeat, PixelIn.UV0 * _WinterSuite_Tiling);
    float4 SnowMaskMap = SAMPLE_TEXTURE2D(_WinterSuite_MaskMap, SamplerLinearRepeat, PixelIn.UV0 * _WinterSuite_Tiling);
    
    float3 NormalWS = TransformVectorTSToVectorWS_RowMajor(SurfaceNormal, PixelIn.TangentToWorldMatrix, true);
    float3 NdotD = dot(NormalWS, normalize(float3(0, 1, 0)));
    float Coverage = NdotD - lerp(1, -1, _WinterSuite_Coverage);
    Coverage = saturate(Coverage / _WinterSuite_Spread);
    Coverage *= HeightCullingAttenuation;
    
    float HeightCoverage = saturate(Depth - lerp(1, -1, Coverage));
    float NormalCoverage = saturate(NdotD - lerp(1, -1, HeightCoverage + _WinterSuite_Transition));
    
    // MInput
    MInput.Base.Color = lerp(MInput.Base.Color, SnowBaseColor.rgb, HeightCoverage);
    MInput.Base.Metallic = lerp(MInput.Base.Metallic, GetMaterialMetallicFromMaskMap(SnowMaskMap), HeightCoverage);
    MInput.Base.Roughness = lerp(MInput.Base.Roughness, GetPerceptualRoughnessFromMaskMap(SnowMaskMap), HeightCoverage);
    float FuzzMask = HeightCoverage;
    MInput.Fuzz.Weight = lerp(MInput.Fuzz.Weight, 1, FuzzMask);
    float4 FuzzColorMap = SAMPLE_TEXTURE2D(_WinterSuite_FuzzColorMap, SamplerLinearRepeat, PixelIn.UV0 * _WinterSuite_Tiling);
    MInput.Fuzz.Color = lerp(MInput.Fuzz.Color, FuzzColorMap.rgb * _WinterSuite_FuzzColor.rgb * _WinterSuite_FuzzColor.a, FuzzMask);
    MInput.Fuzz.Roughness = lerp(MInput.Fuzz.Roughness, _WinterSuite_FuzzRoughness, FuzzMask);
    MInput.Detail.Height = lerp(MInput.Detail.Height, _WinterSuite_FuzzRoughness, FuzzMask);

    float4 SnowNormalMap = SAMPLE_TEXTURE2D(_WinterSuite_NormalMap, SamplerLinearRepeat, PixelIn.UV0 * _WinterSuite_Tiling);
    float3 SnowNormal = GetNormalTSFromNormalTex(SnowNormalMap, _WinterSuite_NormalScale);
    MInput.TangentSpaceNormal.NormalTS = lerp(SurfaceNormal, SnowNormal, NormalCoverage);
    MInput.AO.AmbientOcclusion = lerp(MInput.AO.AmbientOcclusion, GetMaterialHeightFromMaskMap(SnowMaskMap), HeightCoverage);
}

// void PostProcessFinalColor(FPixelInput PixelIn, FSurfacePositionData PosData, inout float4 FinalColor)
// {
// }

// float4 PrepareMaterialVertexCustomOutputData(in FVertexOutput VertexOut, in FVertexInput VertexIn, float3 OffsetOS, float3 OffsetWS)
// {
//     return float4(0.0, 0.0, 0.0, 0.0);
// }

// void PrepareMaterialVertexCustomOutput(inout FVertexOutput VertexOut, in FVertexInput VertexIn)
// {
// }

//float3 CalculateVertexOffsetObjectSpace(in FVertexInput VertIn)
//{
//return float3(0.0, 0.0, 0.0);
//}

//float3 CalculateVertexOffsetWorldSpace(in FVertexInput VertIn)
//{
//return float3(0.0, 0.0, 0.0);
//}