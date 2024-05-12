#ifdef PM_HEADER
#attribute Plugin.Author = "QP4B"
#attribute Plugin.Name = "DetailLayer"
#attribute Plugin.Priority = 0
#attribute Plugin.AlwaysEnable = False
// #attribute Plugin.AlphaClip = False

#pluginoption.UseUV1 = Enable
#pluginfunction.PostProcessMaterialInput = Enable

#stylesheet

# Detail (A)
- _DetailLayer_DetailMap @TryInline(1)
- _DetailLayer_DetailIntensity
- _DetailLayer_DetailNormalScale
###
### Tiling Option
- _DetailLayer_Tiling_Detail
- _DetailLayer_MatchScaling_Detail @Drawer(Toggle)
- _DetailLayer_UVIndex_Detail @Drawer(Enum, 0, 1)
- _DetailLayer_HexTilingInfo
###
### Mask Filter
- _DetailLayer_MaskContrast_Detail
- _DetailLayer_MaskIntensity_Detail

#endstylesheet

#properties
_DetailLayer_DetailIntensity ("Detail Intensity", Range(0, 1)) = 1
_DetailLayer_DetailMap ("Detail Map", 2D) = "bump" {}
_DetailLayer_DetailNormalScale ("Detail Normal Scale", Range(0, 2)) = 1
_DetailLayer_Tiling_Detail ("Tiling Detail", Float) = 1
_DetailLayer_MatchScaling_Detail ("Match Scaling Detail", Int) = 0
_DetailLayer_UVIndex_Detail ("UV Index", Int) = 0
_DetailLayer_MaskContrast_Detail ("Mask Contrast R", Float) = 1
_DetailLayer_MaskIntensity_Detail ("Mask Intensity R", Float) = 1
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
    float4 BlendMask = MInput.PluginChannelData.Data0;
    float LocalScaleX = MInput.PluginChannelData.Data1.x;
    float2 DetailCoordinate = PrepareTextureCoordinates(_DetailLayer_UVIndex_Detail, PixelIn);
    DetailCoordinate = DetailCoordinate * _DetailLayer_Tiling_Detail * (_DetailLayer_MatchScaling_Detail > FLT_EPS ? LocalScaleX : 1);
    
    ApplyDetailMapHex(	_DetailLayer_DetailMap,
                        _DetailLayer_DetailIntensity,
                        _DetailLayer_DetailNormalScale,
                        DetailCoordinate,
                        _DetailLayer_DetailIntensity * BlendMask.a,
                        MInput.Base.Color,
                        MInput.TangentSpaceNormal.NormalTS,
                        MInput.AO.AmbientOcclusion,
                        _DetailLayer_HexTilingInfo
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
