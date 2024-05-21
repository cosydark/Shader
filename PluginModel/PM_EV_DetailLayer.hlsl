#ifdef PM_HEADER
#attribute Plugin.Author = "QP4B"
#attribute Plugin.Name = "DetailLayer"
#attribute Plugin.Priority = 0
#attribute Plugin.AlwaysEnable = False
// #attribute Plugin.AlphaClip = False

#pluginoption.UseUV1 = Enable
#pluginfunction.PostProcessMaterialInput = Enable

#stylesheet

# Detail
- _DetailLayer_NormalMap @TryInline(1)
- _DetailLayer_NormalScale
- _DetailLayer_MaskMap @TryInline(0)
###
### Tiling Option
- _DetailLayer_Tiling_Detail
- _DetailLayer_MatchScaling_Detail @Drawer(Toggle)
- _DetailLayer_UVIndex_Detail @Drawer(Enum, 0, 1)
- _DetailLayer_HexTilingInfo

#endstylesheet

#properties
_DetailLayer_NormalMap ("Normal Map", 2D) = "bump" {}
_DetailLayer_NormalScale ("Normal Scale", Range(0, 1)) = 1
_DetailLayer_MaskMap ("Mask Map", 2D) = "linearGrey" {}

_DetailLayer_Tiling_Detail ("Tiling Detail", Float) = 1
_DetailLayer_MatchScaling_Detail ("Match Scaling Detail", Int) = 0
_DetailLayer_UVIndex_Detail ("UV Index", Int) = 0
_DetailLayer_HexTilingInfo ("Hex Tiling Info", Vector) = (-0.5, 0.456, 10, 0.2)
#endproperties
#endif

#include "Packages/com.funplus.xrender/Shaders/Library/Common.hlsl"
#include "Packages/com.funplus.xrender/Shaders/Library/CommonHeader.hlsl"
#include "Packages/com.funplus.xrender/Shaders/Library/CommonSampler.hlsl"
#include "Packages/com.funplus.xrender/Shaders/Library/CommonMaterial.hlsl"
#include "Assets/Res/Shader/Includes/LayeredSurface.hlsl"

void PostProcessMaterialInput_New(FPixelInput PixelIn, FSurfacePositionData PosData, inout MInputType MInput)
{
    float LocalScaleX = MInput.PluginChannelData.Data1.x;
    float2 DetailCoordinate = PrepareTextureCoordinates(_DetailLayer_UVIndex_Detail, PixelIn);
    DetailCoordinate = DetailCoordinate * _DetailLayer_Tiling_Detail * (_DetailLayer_MatchScaling_Detail > FLT_EPS ? LocalScaleX : 1);
    
    float4 MaskMap = SampleTexture2DHex(_DetailLayer_MaskMap, SamplerLinearRepeat, DetailCoordinate, _DetailLayer_HexTilingInfo.x, _DetailLayer_HexTilingInfo.y, _DetailLayer_HexTilingInfo.z, _DetailLayer_HexTilingInfo.w);
    float4 NormalMap = SampleTexture2DHex(_DetailLayer_NormalMap, SamplerLinearRepeat, DetailCoordinate, _DetailLayer_HexTilingInfo.x, _DetailLayer_HexTilingInfo.y, _DetailLayer_HexTilingInfo.z, _DetailLayer_HexTilingInfo.w);
    float3 NormalTS = GetNormalTSFromNormalTex(NormalMap, _DetailLayer_NormalScale);
    NormalTS = BlendAngelCorrectedNormals(NormalTS, MInput.TangentSpaceNormal.NormalTS);
    MInput.TangentSpaceNormal.NormalTS = lerp(NormalTS, MInput.TangentSpaceNormal.NormalTS, MInput.PluginChannelData.Data1.y);
    MInput.AO.AmbientOcclusion *= GetMaterialAOFromMaskMap(MaskMap);
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
