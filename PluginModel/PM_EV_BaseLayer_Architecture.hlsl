#ifdef PM_HEADER
#attribute Plugin.Author = "QP4B"
#attribute Plugin.Name = "BaseLayer_Architecture"
#attribute Plugin.Priority = 0
#attribute Plugin.AlwaysEnable = True

#pluginoption.UseUV1 = Enable
#pluginfunction.PostProcessMaterialInput = Enable

#stylesheet
# Base
- _BaseLayer_Architecture_NormalMap @TryInline(1)
- _BaseLayer_Architecture_NormalScale
- _BaseLayer_Architecture_MaskMap @TryInline(0)
- _BaseLayer_Architecture_UVIndex @Drawer(Enum, 0, 1)
#endstylesheet

#properties
_BaseLayer_Architecture_NormalMap ("Normal Map", 2D) = "bump" {}
_BaseLayer_Architecture_NormalScale ("Normal Scale", Range(0, 1)) = 1
_BaseLayer_Architecture_MaskMap ("Mask Map (MOHR)", 2D) = "linearGrey" {}
_BaseLayer_Architecture_UVIndex ("UV Index", Int) = 0
#endproperties
#endif

#include "Packages/com.funplus.xrender/Shaders/Library/CommonHeader.hlsl"
#include "Packages/com.funplus.xrender/Shaders/Library/CommonSampler.hlsl"
#include "Packages/com.funplus.xrender/Shaders/Library/CommonMaterial.hlsl"
#include "Assets/Res/Shader/Includes/LayeredSurface.hlsl"

void PostProcessMaterialInput_New(FPixelInput PixelIn, FSurfacePositionData PosData, inout MInputType MInput)
{
    float2 BaseCoordinate = PrepareTextureCoordinates(_BaseLayer_Architecture_UVIndex, PixelIn);
    float4 MaskMap = SAMPLE_TEXTURE2D(_BaseLayer_Architecture_MaskMap, SamplerLinearRepeat, BaseCoordinate);
    float4 NormalMap = SAMPLE_TEXTURE2D(_BaseLayer_Architecture_NormalMap, SamplerLinearRepeat, BaseCoordinate);
    float3 NormalTS = GetNormalTSFromNormalTex(NormalMap, _BaseLayer_Architecture_NormalScale);
    
    MInput.TangentSpaceNormal.NormalTS = BlendAngelCorrectedNormals(NormalTS, MInput.TangentSpaceNormal.NormalTS);
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
