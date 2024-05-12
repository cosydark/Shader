#ifdef PM_HEADER
#attribute Plugin.Author = "QP4B"
#attribute Plugin.Name = "TilingLayer"
#attribute Plugin.Priority = 0
#attribute Plugin.AlwaysEnable = True

#pluginoption.UseUV1 = Enable
#pluginfunction.PostProcessMaterialInput = Enable

#stylesheet
# Tiling
- _TilingLayer_BaseMap @TryInline(1)
- _TilingLayer_BaseColor
- _TilingLayer_NormalMap @TryInline(1)
- _TilingLayer_NormalScale
- _TilingLayer_MaskMap @TryInline(0)
- _TilingLayer_Reflectance
- _TilingLayer_HeightOffset
###
### Tiling Option
- _TilingLayer_Tiling
- _TilingLayer_MatchScaling @Drawer(Toggle)
- _TilingLayer_UVIndex @Drawer(Enum, 0, 1)
#endstylesheet

#properties
_TilingLayer_BaseMap ("Base Map", 2D) = "white" {}
_TilingLayer_BaseColor ("Base Color", Color) = (1, 1, 1, 1)
[Normal] _TilingLayer_NormalMap ("Normal Map", 2D) = "bump" {}
_TilingLayer_NormalScale ("Normal Scale", Range(0, 2)) = 1
_TilingLayer_MaskMap ("Mask Map (MOHR)", 2D) = "grey" {}
_TilingLayer_Reflectance ("Reflectance", Range(0, 1)) = 0.5
_TilingLayer_HeightOffset ("Height Offset", Range(-1, 1)) = 0
_TilingLayer_Tiling ("Tiling", Float) = 1
_TilingLayer_MatchScaling ("Match Scaling", Int) = 0
_TilingLayer_UVIndex ("UV Index", Int) = 0
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
    float2 TilingLayer_2_Coordinate = PrepareTextureCoordinates(_TilingLayer_UVIndex, PixelIn);
    SetupTilingLayer(	_TilingLayer_BaseMap,
                        _TilingLayer_BaseColor.rgb,
                        _TilingLayer_NormalMap,
                        _TilingLayer_NormalScale,
                        _TilingLayer_MaskMap,
                        _TilingLayer_Reflectance,
                        _TilingLayer_HeightOffset,
                        TilingLayer_2_Coordinate * _TilingLayer_Tiling * (_TilingLayer_MatchScaling > FLT_EPS ? LocalScaleX : 1),
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
