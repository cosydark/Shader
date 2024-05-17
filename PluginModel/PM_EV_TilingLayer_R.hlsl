#ifdef PM_HEADER
#attribute Plugin.Author = "QP4B"
#attribute Plugin.Name = "TilingLayer_R"
#attribute Plugin.Priority = 0
#attribute Plugin.AlwaysEnable = False

#pluginoption.UseUV1 = Enable
#pluginfunction.PostProcessMaterialInput = Enable

#stylesheet
# Tilling (R)
- _TilingLayer_R_BaseMap @TryInline(1)
- _TilingLayer_R_BaseColor
- _TilingLayer_R_NormalMap @TryInline(1)
- _TilingLayer_R_NormalScale
- _TilingLayer_R_MaskMap @TryInline(0)
- _TilingLayer_R_Reflectance
- _TilingLayer_R_HeightOffset
###
### Tiling Option
- _TilingLayer_R_Tiling
- _TilingLayer_R_MatchScaling @Drawer(Toggle)
- _TilingLayer_R_UVIndex @Drawer(Enum, 0, 1)
###
### Mask Filter
- _TilingLayer_R_MaskContrast
- _TilingLayer_R_MaskIntensity
###
### Blend Option
- _TilingLayer_R_BlendMode  @Drawer(Enum, Lerp, Height Max, Height Min)
- _TilingLayer_R_BlendRadius
#endstylesheet

#properties
_TilingLayer_R_BaseMap ("Base Map", 2D) = "white" {}
_TilingLayer_R_BaseColor ("Base Color", Color) = (1, 1, 1, 1)
_TilingLayer_R_NormalMap ("Normal Map", 2D) = "bump" {}
_TilingLayer_R_NormalScale ("Normal Scale", Range(0, 2)) = 1
_TilingLayer_R_MaskMap ("Mask Map (MOHR)", 2D) = "linearGrey" {}
_TilingLayer_R_Reflectance ("Reflectance", Range(0, 1)) = 0.5
_TilingLayer_R_HeightOffset ("Height Offset", Range(-1, 1)) = 0
_TilingLayer_R_Tiling ("Tiling", Float) = 1
_TilingLayer_R_MatchScaling ("Match Scaling", Int) = 0
_TilingLayer_R_UVIndex ("UV Index", Int) = 0
_TilingLayer_R_BlendMode ("Blend Mode", Float) = 1
_TilingLayer_R_BlendRadius ("Blend Radius", Range(0.001, 0.5)) = 0.1
_TilingLayer_R_MaskContrast ("Mask Contrast R", Float) = 1
_TilingLayer_R_MaskIntensity ("Mask Intensity R", Float) = 1
#endproperties
#endif

#include "Packages/com.funplus.xrender/Shaders/Library/Common.hlsl"
#include "Packages/com.funplus.xrender/Shaders/Library/CommonHeader.hlsl"
#include "Packages/com.funplus.xrender/Shaders/Library/CommonSampler.hlsl"
#include "Packages/com.funplus.xrender/Shaders/Library/CommonMaterial.hlsl"
#include "Assets/Res/Shader/Includes/LayeredSurface.hlsl"

void PostProcessMaterialInput_New(FPixelInput PixelIn, FSurfacePositionData PosData, inout MInputType MInput)
{
    float4 BlendMask = MInput.PluginChannelData.Data0;
    BlendMask.r = saturate(pow(BlendMask.r, _TilingLayer_R_MaskContrast) * _TilingLayer_R_MaskIntensity);
    float LocalScaleX = MInput.PluginChannelData.Data1.x;
    float2 TilingLayer_2_Coordinate = PrepareTextureCoordinates(_TilingLayer_R_UVIndex, PixelIn);
    BlendWithHeight(	_TilingLayer_R_BaseMap,
                        _TilingLayer_R_BaseColor,
                        _TilingLayer_R_NormalMap,
                        _TilingLayer_R_NormalScale,
                        _TilingLayer_R_MaskMap,
                        _TilingLayer_R_Reflectance,
                        TilingLayer_2_Coordinate * _TilingLayer_R_Tiling * (_TilingLayer_R_MatchScaling > FLT_EPS ? LocalScaleX : 1),
                        BlendMask.r,
                        _TilingLayer_R_BlendRadius,
                        _TilingLayer_R_HeightOffset,
                        _TilingLayer_R_BlendMode,
                        MInput.Base.Color,
                        MInput.TangentSpaceNormal.NormalTS,
                        MInput.Base.Metallic,
                        MInput.AO.AmbientOcclusion,
                        MInput.Detail.Height,
                        MInput.Base.Roughness,
                        MInput.Specular.Reflectance
            );
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
