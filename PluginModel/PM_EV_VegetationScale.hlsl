#ifdef PM_HEADER
#attribute Plugin.Author = "QP4B"
#attribute Plugin.Name = "VegetationScale"
#attribute Plugin.Priority = 0
#attribute Plugin.AlwaysEnable = False

// #pluginoption.UseUV1 = Enable
// #pluginoption.UseUV2 = Enable
// #pluginoption.UseUV3 = Enable
 #pluginoption.CustomizeVertexOutput = Enable
// #pluginoption.CustomizeVertexOutputData = Enable

//#pluginfunction.PostProcessMaterialInput = Enable
//#pluginfunction.PostProcessFinalColor = Enable
// #pluginfunction.CalculateVertexOffsetObjectSpace = Enable
// #pluginfunction.CalculateVertexOffsetWorldSpace = Enable
// #pluginfunction.PrepareMaterialVertexCustomOutputData = Enable
 #pluginfunction.PrepareMaterialVertexCustomOutput = Enable

#stylesheet
# VegetationScale
- _VegetationScale_MaximumEffectiveDistance
- _VegetationScale_MaximumScale
#endstylesheet

#properties
_VegetationScale_MaximumEffectiveDistance ("MaximumEffectiveDistance", Range(20, 250)) = 65
_VegetationScale_MaximumScale ("Scale", Range(0, 2)) = 0
#endproperties
#endif

#include "Packages/com.funplus.xrender/Shaders/Library/Common.hlsl"
#include "Packages/com.funplus.xrender/Shaders/Library/CommonHeader.hlsl"
#include "Packages/com.funplus.xrender/Shaders/Library/CommonSampler.hlsl"
#include "Packages/com.funplus.xrender/Shaders/Library/CommonMaterial.hlsl"
#include "Packages/com.funplus.xrender/Shaders/Library/CommonNoise.hlsl"

//void PostProcessMaterialInput(FPixelInput PixelIn, FSurfacePositionData PosData, inout FMaterialInput MInput)
//{
//}

//void PostProcessFinalColor(FPixelInput PixelIn, FSurfacePositionData PosData, inout float4 FinalColor)
//{
//}

// float4 PrepareMaterialVertexCustomOutputData(in FVertexOutput VertexOut, in FVertexInput VertexIn, float3 OffsetOS, float3 OffsetWS)
// {
//     return float4(0.0, 0.0, 0.0, 0.0);
// }
float3 GetGrassPivot(float4 VertexColor)
{
     return float3(-(VertexColor.b - 0.5) * 4, 0.0, -(VertexColor.a - 0.5) * 4);
}

 void PrepareMaterialVertexCustomOutput(inout FVertexOutput VertexOut, in FVertexInput VertexIn)
 {
     float3 PositionWS = VertexOut.PositionWS;
     float3 CameraPositionWS = GetCurrentViewPositionWS();
     float3 PivotPositionWS = mul(GetObjectToWorldMatrix(), float4(GetGrassPivot(VertexIn.VertexColor), 1)).xyz;
     float Depth = saturate(distance(CameraPositionWS, PivotPositionWS) / _VegetationScale_MaximumEffectiveDistance);
     float3 ScaleDirection = normalize(PositionWS - PivotPositionWS);
     ScaleDirection.xz *= _VegetationScale_MaximumScale;
     ScaleDirection.y *= _VegetationScale_MaximumScale * 0.25;
     VertexOut.PositionWS += ScaleDirection * max(0, 1.33333333 * Depth - 0.33333333);
     VertexOut.PositionCS = TransformPositionWSToPositionCS(VertexOut.PositionWS, GetWorldToClipMatrix());
 }

//float3 CalculateVertexOffsetObjectSpace(in FVertexInput VertIn)
//{
//return float3(0.0, 0.0, 0.0);
//}

//float3 CalculateVertexOffsetWorldSpace(in FVertexInput VertIn)
//{
//return float3(0.0, 0.0, 0.0);
//}
