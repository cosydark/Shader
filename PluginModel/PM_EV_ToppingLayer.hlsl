#ifdef PM_HEADER
#attribute Plugin.Author = "QP4B"
#attribute Plugin.Name = "ToppingLayer"
#attribute Plugin.Priority = 0
#attribute Plugin.AlwaysEnable = False
// #attribute Plugin.AlphaClip = False

#pluginoption.UseUV1 = Enable
#pluginfunction.PostProcessMaterialInput = Enable

#stylesheet

# Topping
- _ToppingLayer_BaseMap @TryInline(1)
- _ToppingLayer_BaseColor
- _ToppingLayer_NormalMap @TryInline(1)
- _ToppingLayer_NormalScale
- _ToppingLayer_MaskMap @TryInline(0)
- _ToppingLayer_Reflectance
- _ToppingLayer_HeightOffset
###
### Topping Option
- _ToppingLayer_NormalIntensity
- _ToppingLayer_Coverage
- _ToppingLayer_Spread
###
### Tiling Option
- _ToppingLayer_Tiling
- _ToppingLayer_MatchScaling @Drawer(Toggle)
- _ToppingLayer_UVIndex @Drawer(Enum, 0, 1)
###
### Blend Option
- _ToppingLayer_BlendMode  @Drawer(Enum, Lerp, Height Max, Height Min)
- _ToppingLayer_BlendRadius

#endstylesheet

#properties
_ToppingLayer_BaseMap ("BaseMap", 2D) = "white" {}
_ToppingLayer_BaseColor ("Base Color", Color) = (1, 1, 1, 1)
_ToppingLayer_NormalMap ("NormalMap", 2D) = "bump" {}
_ToppingLayer_NormalScale ("Normal Scale", Range(0, 2)) = 1
_ToppingLayer_MaskMap ("MaskMap", 2D) = "black" {}
_ToppingLayer_Reflectance ("Reflectance", Range(0, 1)) = 0.5
_ToppingLayer_HeightOffset ("Height Offset", Range(0, 1)) = 0.5
_ToppingLayer_NormalIntensity ("Normal Intensity", Range(0, 1)) = 0.5
_ToppingLayer_Coverage ("Coverage", Range(0, 1)) = 0.5
_ToppingLayer_Spread ("Spread", Range(0, 1)) = 0.5
_ToppingLayer_Tiling ("Tiling", Float) = 1
_ToppingLayer_MatchScaling ("Match Scaling", Int) = 0
_ToppingLayer_UVIndex ("UV Index", Int) = 0
_ToppingLayer_BlendMode ("Blend Mode", Float) = 1
_ToppingLayer_BlendRadius ("Blend Radius", Range(0.001, 0.5)) = 0.1
#endproperties
#endif

#include "Packages/com.funplus.xrender/Shaders/Library/Common.hlsl"
#include "Packages/com.funplus.xrender/Shaders/Library/CommonHeader.hlsl"
#include "Packages/com.funplus.xrender/Shaders/Library/CommonSampler.hlsl"
#include "Packages/com.funplus.xrender/Shaders/Library/CommonMaterial.hlsl"
#include "Assets/Res/Shader/Includes/LayeredSurface.hlsl"

void PostProcessMaterialInput_New(FPixelInput PixelIn, FSurfacePositionData PosData, inout MInputType MInput)
{
    float LocalScaleX = length(float3(GetObjectToWorldMatrix()[0].x, GetObjectToWorldMatrix()[1].x, GetObjectToWorldMatrix()[2].x));
    float2 ToppingCoordinates = _ToppingLayer_UVIndex < FLT_EPS ? PixelIn.UV0 : PixelIn.UV1;
    ToppingCoordinates = ToppingCoordinates * _ToppingLayer_Tiling * (_ToppingLayer_MatchScaling > FLT_EPS ? LocalScaleX : 1);
    // Compute N Dot Up
    float3 NormalWS = TransformVectorTSToVectorWS_RowMajor(MInput.TangentSpaceNormal.NormalTS, PixelIn.TangentToWorldMatrix, true);
    NormalWS = lerp(PixelIn.GeometricNormalWS, NormalWS, _ToppingLayer_NormalIntensity);
    float3 NdotUp = dot(NormalWS, normalize(float3(0, 1, 0)));
    float Coverage = NdotUp - lerp(1, -1, _ToppingLayer_Coverage);
    Coverage = saturate(Coverage / _ToppingLayer_Spread);
    
    BlendWithHeight(    _ToppingLayer_BaseMap,
                        _ToppingLayer_BaseColor,
                        _ToppingLayer_NormalMap,
                        _ToppingLayer_NormalScale,
                        _ToppingLayer_MaskMap,
                        _ToppingLayer_Reflectance,
                        ToppingCoordinates * _ToppingLayer_Tiling * (_ToppingLayer_MatchScaling > FLT_EPS ? LocalScaleX : 1),
                        Coverage,
                        _ToppingLayer_BlendRadius,
                        _ToppingLayer_HeightOffset,
                        _ToppingLayer_BlendMode,
                        MInput.Base.Color,
                        MInput.TangentSpaceNormal.NormalTS,
                        MInput.Base.Metallic,
                        MInput.AO.AmbientOcclusion,
                        MInput.Detail.Height,
                        MInput.Base.Roughness,
                        MInput.Base.Roughness
                    );
    // Apply Topping Layer
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
