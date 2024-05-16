#ifdef PM_HEADER
#attribute Plugin.Author = "QP4B"
#attribute Plugin.Name = "AdditionalLayer"
#attribute Plugin.Priority = 0
#attribute Plugin.AlwaysEnable = False

#pluginoption.UseUV1 = Enable
#pluginfunction.PostProcessMaterialInput = Enable

#stylesheet
# Additional (B)
- _AdditionalLayer_BaseColor
- _AdditionalLayer_NormalScale
- _AdditionalLayer_Metallic
- _AdditionalLayer_AmbientOcclusion
- _AdditionalLayer_Height
- _AdditionalLayer_Roughness
- _AdditionalLayer_Reflectance
###
### Mask Filter
- _AdditionalLayer_MaskContrast
- _AdditionalLayer_MaskIntensity
###
### Blend Option
- _AdditionalLayer_BlendMode  @Drawer(Enum, Lerp, Height Max\, Height Min)
- _AdditionalLayer_BlendRadius
#endstylesheet

#properties
_AdditionalLayer_BaseColor ("Base Color", Color) = (1, 1, 1, 1)
_AdditionalLayer_NormalScale ("Normal Scale", Range(0, 1)) = 0.5
_AdditionalLayer_Metallic ("Metallic", Range(0, 1)) = 0
_AdditionalLayer_AmbientOcclusion ("AmbientOcclusion", Range(0, 1)) = 1
_AdditionalLayer_Height ("Height", Range(0, 1)) = 0.5
_AdditionalLayer_Roughness ("Roughness", Range(0, 1)) = 0.5
_AdditionalLayer_Reflectance ("Reflectance", Range(0, 1)) = 0.5
_AdditionalLayer_BlendMode ("Blend Mode", Float) = 1
_AdditionalLayer_BlendRadius ("Blend Radius", Range(0.001, 0.5)) = 0.1
_AdditionalLayer_MaskContrast ("Mask Contrast R", Float) = 1
_AdditionalLayer_MaskIntensity ("Mask Intensity R", Float) = 1
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
    BlendMask.b = saturate(pow(BlendMask.b, _AdditionalLayer_MaskContrast) * _AdditionalLayer_MaskIntensity);
    float LocalScaleX = MInput.PluginChannelData.Data1.x;
    BlendWithHeightNoTexture(   _AdditionalLayer_BaseColor,
                                _AdditionalLayer_NormalScale,
                                _AdditionalLayer_Metallic,
                                _AdditionalLayer_AmbientOcclusion,
                                _AdditionalLayer_Height,
                                _AdditionalLayer_Roughness,
                                _AdditionalLayer_Reflectance,
                                BlendMask.b,
                                _AdditionalLayer_BlendRadius,
                                _AdditionalLayer_BlendMode,
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
