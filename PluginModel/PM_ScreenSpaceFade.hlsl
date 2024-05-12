#ifdef PM_HEADER
#attribute Plugin.Author = "QP4B"
#attribute Plugin.Name = "ScreenSpaceFade"
#attribute Plugin.Priority = 0
#attribute Plugin.AlwaysEnable = False
#attribute Plugin.AlphaClip = True

// #pluginoption.UseUV1 = Enable
// #pluginoption.UseUV2 = Enable
// #pluginoption.UseUV3 = Enable
// #pluginoption.CustomizeVertexOutput = Enable
// #pluginoption.CustomizeVertexOutputData = Enable

#pluginfunction.PostProcessMaterialInput = Enable
#pluginfunction.PostProcessFinalColor = Enable
// #pluginfunction.CalculateVertexOffsetObjectSpace = Enable
// #pluginfunction.CalculateVertexOffsetWorldSpace = Enable
// #pluginfunction.PrepareMaterialVertexCustomOutputData = Enable
// #pluginfunction.PrepareMaterialVertexCustomOutput = Enable

#stylesheet
# Screen Space Fade

- _ScreenSpaceFade_RadiusScale
- _ScreenSpaceFade_Blur
- _ScreenSpaceFade_ForwardOffset
- _ScreenSpaceFade_UpOffset

#endstylesheet

#properties
_ScreenSpaceFade_RadiusScale ("Radius Scale", Range(0, 14)) = 12.7
_ScreenSpaceFade_Blur ("Blur", Range(0, 4)) = 1
_ScreenSpaceFade_ForwardOffset ("ForwardOffset", Range(0, 3)) = 0.5
_ScreenSpaceFade_UpOffset ("UpOffset", Range(0, 3)) = 1.3
#endproperties
#endif

#include "Packages/com.funplus.xrender/Shaders/Library/Common.hlsl"
#include "Packages/com.funplus.xrender/Shaders/Library/CommonHeader.hlsl"
#include "Packages/com.funplus.xrender/Shaders/Library/CommonSampler.hlsl"
#include "Packages/com.funplus.xrender/Shaders/Library/CommonMaterial.hlsl"
#include "Packages/com.funplus.xrender/Shaders/Library/CommonNoise.hlsl"

static float _Alpha1 = 0.17;
static float2 _Alpha2 = float2(0.75487762, 0.56984027);

float noise(in float2 x)
{
	float2 p = floor(x);
	float2 f = frac(x);
	f = f * f * (3.0 - 2.0 * f);
	float a = hash(p + float2(0, 0));
	float b = hash(p + float2(1, 0));
	float c = hash(p + float2(0, 1));
	float d = hash(p + float2(1, 1));
	return lerp(lerp(a, b, f.x), lerp( c, d, f.x), f.y);
}
const float4 mtx = float4(0.80,  0.60, -0.60,  0.80);
float fbm4(float2 p)
{
	float f = 0.0;
	f  += 0.5000 * (-1.0 + 2.0 * noise(p)); p = mtx * p * 2.02;
	f  += 0.2500 * (-1.0 + 2.0 * noise(p)); p = mtx * p * 2.03;
	f  += 0.1250 * (-1.0 + 2.0 * noise(p)); p = mtx * p * 2.01;
	f  += 0.0625 * (-1.0 + 2.0 * noise(p));
	return f / 0.9375;
}

float _ScreenSpaceFade_BlueNoise(float2 TC)
{
    float N = fbm4(TC);
    float V = frac(N + _Alpha1);
    return V;
}

float _ScreenSpaceFade_Remap(float In, float2 InMinMax)
{
	float2 OutMinMax = float2(0, 1);
	return OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
}

float PolygonOcclusionMask(float3 PositionWS, float3 CameraPositionWS, float3 PivotPositionWS)
{
	float3 Camera2Pivot = normalize(PivotPositionWS - CameraPositionWS);
	PivotPositionWS.y += _ScreenSpaceFade_UpOffset;
	PivotPositionWS += float3(Camera2Pivot.x, 0, Camera2Pivot.z) * _ScreenSpaceFade_ForwardOffset;
	
	float Cos = dot(normalize(PositionWS - PivotPositionWS), -Camera2Pivot);
	float Sin = sqrt(1 - Cos * Cos);
	float X = distance(PositionWS, PivotPositionWS.xyz) * Sin;
	
	Cos = dot(normalize(PositionWS - CameraPositionWS), normalize(PivotPositionWS - CameraPositionWS));
	float Y = distance(CameraPositionWS, PivotPositionWS.xyz) - distance(CameraPositionWS, PositionWS) * Cos;
	float Internal = max(0, pow(X * (14 - _ScreenSpaceFade_RadiusScale), 2) - Y);
	
	return _ScreenSpaceFade_Remap(Internal, float2(0, _ScreenSpaceFade_Blur));
}

void PostProcessMaterialInput(FPixelInput PixelIn, FSurfacePositionData PosData, inout FMaterialInput MInput)
{
	float3 PlayerPosition = GetGlobalUniformBufferParam(0).xyz;
	float IsPlayingFlag = GetGlobalUniformBufferParam(2).x;
	
	float Mask = PolygonOcclusionMask(PosData.PositionWS, PosData.CameraPositionWS, PlayerPosition);
	if (Mask < 1.0 && IsPlayingFlag > FLT_EPS)
	{
		if(_ScreenSpaceFade_BlueNoise(PosData.ScreenUV * _ScreenParams.xy) > Mask)
		{
			#if SHADER_PASS == SHADERPASS_SHADOW_CAST
			#else
			MInput.Opacity = 0;
			#endif
		}
	}
}

void PostProcessMaterialInput_New(FPixelInput PixelIn, FSurfacePositionData PosData, inout MInputType MInput)
{
	float3 PlayerPosition = GetGlobalUniformBufferParam(0).xyz;
	float IsPlayingFlag = GetGlobalUniformBufferParam(2).x;
	
	float Mask = PolygonOcclusionMask(PosData.PositionWS, PosData.CameraPositionWS, PlayerPosition);
	if (Mask < 1.0 && IsPlayingFlag > FLT_EPS)
	{
		if(_ScreenSpaceFade_BlueNoise(PosData.ScreenUV * _ScreenParams.xy) > Mask)
		{
			#if SHADER_PASS == SHADERPASS_SHADOW_CAST
			#else
			MInput.Base.Opacity = 0;
			#endif
		}
	}
}


void PostProcessFinalColor(FPixelInput PixelIn, FSurfacePositionData PosData, inout float4 FinalColor)
{
}

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
