#ifdef MM_HEADER
#attribute Material.Author = "QP4B"
#attribute Material.Name = "CommonHolographic"
#attribute Material.ShadingModel = "Emissive"

#stylesheet

# Effect
- _MainTexture @TryInline(1)
- _MainTint

###  
### Line
- _LineEndable @Drawer(Toggle)
- _LineReverse @Drawer(Toggle)
- _LineAlpha
- _LinePower
- _LineFrequency

###  
### Fresnel       [ Transparent Only ]
- _FresnelEndable @Drawer(Toggle)
- _FresnelReverse @Drawer(Toggle)
- _FresnelAlpha
- _FresnelAlphaPower

###  
### Mask
- _MaskEndable @Drawer(Toggle)
- _MaskAlpha
- _MaskMap @TryInline(1)
- _MaskMapTiling

###  
### Triplanar
- _TriplanarEndable @Drawer(Toggle)
- _TriplanarReverse @Drawer(Toggle)
- _TriplanarAlpha
- _TriplanarMask @TryInline(1)
- _TriplanarMaskTiling

# Post Processing
### General
- _MaxHeight

###  
### Alpha
- _AlphaScale
- _VerticalAlphaEnable @Drawer(Toggle)
- _VerticalAlphaMap @Drawer(RampMap)

###
### Backgound       [ Transparent Only ]
- _BackgoundAlpha


#endstylesheet


#properties
_MainTexture ("Main Texture", 2D) = "white" {}
[HDR] _MainTint ("Main Tint", Color) = (1, 1, 1, 1)
// Line
_LineEndable ("Line Endable", Int) = 1
_LineReverse ("Line Reverse", Int) = 0
_LineAlpha ("Line Alpha", Range(0, 1)) = 1
_LinePower ("Line Power", Range(1, 3)) = 1
_LineFrequency ("Line Frequency", Float) = 50 
// Fresnel
_FresnelEndable ("Fresnel Endable", Int) = 1
_FresnelReverse ("Fresnel Reverse", Int) = 0
_FresnelAlpha ("Fresnel Alpha", Range(0, 3)) = 1
_FresnelAlphaPower ("Fresnel Alpha Power", Range(0.5, 4)) = 1
// Mask
_MaskEndable ("Mask Endable", Int) = 0
_MaskAlpha ("Mask Alpha", Range(0, 1)) = 1
_MaskMap ("Mask Map", 2D) = "black" {}
_MaskMapTiling ("Mask Map Tiling", Float) = 1

// Triplanar
_TriplanarEndable ("Triplanar Endable", Int) = 1
_TriplanarReverse ("Triplanar Reverse", Int) = 1
_TriplanarAlpha ("Triplanar Alpha", Range(0, 1)) = 1
[NoScaleOffset] _TriplanarMask ("Triplanar Texture", 2D) = "black" {}
_TriplanarMaskTiling ("Triplanar Mask Tiling", Float) = 1

// Post Processing
// Common
_MaxHeight ("Max Height", Float) = 3
// Alpha
_AlphaScale ("Alpha Scale", Range(0, 3)) = 1
_VerticalAlphaEnable ("Vertical Alpha Enable", Int) = 0
_VerticalAlphaMap ("Vertical Alpha Map", 2D) = "white" {}
// Background
_BackgoundAlpha ("Backgound Alpha", Range(0, 1)) = 0

#endproperties

#propertyoption.GenST = _NormalMap
#materialoption.Emissive = Enable
#materialoption.VertexAnimationObjectSpace = Enable
#materialoption.UseSlab = Enable

#else
#include "./MM_CommonHolographic.Header.hlsl"
#endif

#include "Packages/com.funplus.xrender/Shaders/Library/Common.hlsl"
#include "Packages/com.funplus.xrender/Shaders/Library/CommonHeader.hlsl"
#include "Packages/com.funplus.xrender/Shaders/Library/CommonSampler.hlsl"
#include "Packages/com.funplus.xrender/Shaders/Library/CommonMaterial.hlsl"
#include "Assets//Res/Shader/Includes/ResShaderIncludesIndex.hlsl"

float4 TriplanarSample(Texture2D Tex, float3 NormalWS, float3 PositionWS, float Tiling)
{
	float3 Weight = abs(NormalWS);
	float3 PositionOS = PositionWS - TransformPositionOSToPositionWS(float3(0, 0, 0), GetObjectToWorldMatrix());
	float4 Color0 = Weight.x > 0.0 ? SAMPLE_TEXTURE2D_BIAS(Tex, SamplerLinearRepeat, PositionOS.yz * Tiling, -2) : float4(0, 0, 0, 0);
	float4 Color1 = Weight.y > 0.0 ? SAMPLE_TEXTURE2D_BIAS(Tex, SamplerLinearRepeat, PositionOS.zx * Tiling, -2) : float4(0, 0, 0, 0);
	float4 Color2 = Weight.z > 0.0 ? SAMPLE_TEXTURE2D_BIAS(Tex, SamplerLinearRepeat, PositionOS.xy * Tiling, -2) : float4(0, 0, 0, 0);
	float4 Color3 = float4(1, 1, 1, 0);
	float4 Weight4 = (Weight.x + Weight.y + Weight.z) > 0.0 ? float4(Weight, 0) : float4(Weight, 1);
	return (Color0 * Weight4.x + Color1 * Weight4.y + Color2 * Weight4.z + Color3 * Weight4.w) / (Weight4.x + Weight4.y + Weight4.z + Weight4.w);
}

void PrepareMaterialInput_New(FPixelInput PixelIn, FSurfacePositionData PosData, inout MInputType MInput)
{
	// Prepare
	float3 PivotPositionWS = GetObjectToWorldMatrix()._m03_m13_m23;
	float3 PositionWS = PosData.PositionWS;
	const float VerticalDistance = abs(PivotPositionWS.y - PositionWS.y);
	const float3 CameraPositionWS = PosData.CameraPositionWS;
	float CameraToPivot = distance(CameraPositionWS, PivotPositionWS);
	
	float LineFrequency = _LineFrequency;
	// Sample MainTex
	float4 MainTextureColor = SAMPLE_TEXTURE2D(_MainTexture, SamplerLinearRepeat, PixelIn.UV0) * _MainTint;
	// Line
	float LineAlpha = 0;
	if(_LineEndable == 1)
	{
		const float FrequencyVerticalDistance = VerticalDistance * LineFrequency;
		float LineWave = sin(FrequencyVerticalDistance);
		LineWave = _LineReverse ? 1 - LineWave : LineWave;
		LineAlpha = pow(saturate(LineWave), _LinePower) * _LineAlpha;
	}
	
	// Fresnel
	float FresnelAlpha = 0;
	if(_FresnelEndable == 1)
	{
		float NDotV = dot(PosData.CameraVectorWS, PixelIn.GeometricNormalWS);
		NDotV = pow(1 - NDotV, _FresnelAlphaPower);
		FresnelAlpha = saturate(_FresnelAlpha * NDotV);
		FresnelAlpha = _FresnelReverse? 1 - FresnelAlpha : FresnelAlpha;
	}

	// Mask
	float MaskAlpha = 0;
	if(_MaskEndable == 1)
	{
		MaskAlpha = SAMPLE_TEXTURE2D(_MaskMap, SamplerLinearRepeat, PixelIn.UV0 * _MaskMapTiling).r * _MaskAlpha;
	}
	
	// Triplanar Mapping
	float TriplanarAlpha = 0;
	if(_TriplanarEndable == 1)
	{
		TriplanarAlpha = TriplanarSample(_TriplanarMask, PixelIn.GeometricNormalWS, PosData.PositionWS, _TriplanarMaskTiling).r;
		TriplanarAlpha = saturate(TriplanarAlpha);
		TriplanarAlpha = step(0.1, TriplanarAlpha) * _TriplanarAlpha;
		TriplanarAlpha = _TriplanarReverse ? 1 - TriplanarAlpha : TriplanarAlpha;
	}

	// Effect Result
	float Alpha = max(LineAlpha, FresnelAlpha);;
	Alpha = max(MaskAlpha, Alpha);
	Alpha = max(Alpha, TriplanarAlpha) * MainTextureColor.a;
	
	float3 EmissiveColor = MainTextureColor.rgb * _AlphaScale;
	
	// Post Processing
	Alpha = max(_BackgoundAlpha / 2, Alpha); // Alpha Is Not Liner !
	Alpha = saturate(_AlphaScale * Alpha);

	float VerticalGradient = 1;
	if(_VerticalAlphaEnable == 1)
	{
		VerticalGradient = SAMPLE_TEXTURE2D(_VerticalAlphaMap, SamplerLinearClamp, float2(VerticalDistance / _MaxHeight, 1)).x;
	}
	Alpha *= VerticalGradient;
	
	EmissiveColor *= VerticalGradient * Alpha;
	
	MInput.Emission.Color = EmissiveColor;
	MInput.Base.Opacity = Alpha;
}

//#materialoption.CustomizeVertexOutputData
float4 PrepareMaterialVertexCustomOutputData(in FVertexOutput VertexOut, in FVertexInput VertexIn, float3 OffsetOS, float3 OffsetWS)
{
	// VertexOut.CustomVertexData = ...;
	return float4(0.0, 0.0, 0.0, 0.0);
}

//#materialoption.CustomizeVertexOutput
void PrepareMaterialVertexCustomOutput(inout FVertexOutput VertexOut, in FVertexInput VertexIn)
{
}

//#materialoption.VertexAnimationObjectSpace
float3 CalculateVertexOffsetObjectSpace(in FVertexInput VertIn)
{
	return float3(0.0, 0.0, 0.0);
}

//#materialoption.VertexAnimationWorldSpace
float3 CalculateVertexOffsetWorldSpace(in FVertexInput VertIn)
{
	return float3(0.0, 0.0, 0.0);
}

/*
Support Option List:
	#materialoption.TangentSpaceNormalMap
	#materialoption.TangentMap
	#materialoption.CustomNormal
	#materialoption.CustomTBN
	#materialoption.Reflectance
	#materialoption.Anisotropic
	#materialoption.Matcap
	#materialoption.Clearcoat
	#materialoption.Emissive
	#materialoption.Fuzz
	#materialoption.Height
	#materialoption.SubsurfaceScattering
	#materialoption.ThinFilm
	#materialoption.Transmission
	#materialoption.VertexAnimationObjectSpace
	#materialoption.VertexAnimationWorldSpace
	#materialoption.AmbientOcclusion
	#materialoption.VertexAmbientOcclusion
	#materialoption.UseUV1
	#materialoption.UseUV2
	#materialoption.UseUV3
	#materialoption.CustomData
	#materialoption.CustomDataLite
	#materialoption.CustomizeVertexOutput
	#materialoption.CustomizeVertexOutputData
*/

	
// Color Glitch
// const float GlitchCoordinate = 15 * _TimeParameters.x;
// float ColorGlitch = SAMPLE_TEXTURE2D(_GlitchMap, sampler_LinearRepeat, GlitchCoordinate).r;
// ColorGlitch = saturate(RemapValue(ColorGlitch, 0, 1, -0.6, 2));
// ColorGlitch = lerp(1, ColorGlitch, (1 - _GlitchAffect));
