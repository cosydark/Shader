// ===================================================================================================================

#ifdef MM_HEADER
#attribute Material.Author = "QP4B"
#attribute Material.Name = "CH_TransmissionSlime"
#attribute Material.ShadingModel = "Transmission"

// ==========================================================

#stylesheet

# Base Layer
- _BaseMap @TryInline(1)
- _BaseColor
- _NormalMap @TryInline(1)
- _NormalScale
- _DetailNormalMap @TryInline(1)
- _DetailNormalScale
- _DetailNormalTiling
- _MaskMap @TryInline(0)
- _EmissiveMap @TryInline(1)
- _EmissiveColor
- _Metallic
- _Occlusion
- _Roughness
- _Reflectance
# Transmission Layer
- _Weight
- _TransmissionColorMap @TryInline(1)
- _TransmissionColor
- _ThicknessMap @TryInline(1)
- _Thickness
- _MFPScale
- _PhaseAniso
# ThinFilm Layer
- _ThinFilmThicknessMap @TryInline(1)
- _ThinFilmThickness
- _ThinFilmFactorMask @TryInline(1)
- _ThinFilmFactor
# Rim @Hide(_CustomOption1 == 0)
- _AlphaRimPower
- _AlphaRimIntensity
- _RoughnessRimPower
- _RoughnessRimIntensity
- _IORRimPower
- _IORRimIntensity
- _HGRimPower
- _HGRimIntensity
# Flow @Hide(_CustomOption0 == 0)
- _FlowNoiseMap @TryInline(0)
- _FlowMatcap @TryInline(0)
- _FlowIntensity
- _FlowSpeed
- _FlowNoiseTiling
- _EmissiveFlowColor

# Refraction @Hide(_Refraction == 0)
- _IORMap @TryInline(1)
- _IORScale
- _RoughRefractionDepthOffset

#endstylesheet

// ==========================================================

#properties
// Base Layer
_BaseMap ("Base Map", 2D) = "white" {}
[HDR] _BaseColor ("Base Color", Color) = (1, 1, 1, 1)
[Normal] _NormalMap ("Normal Map", 2D) = "bump" {}
_NormalScale ("Normal Scale", Range(0, 2)) = 1
[Normal] _DetailNormalMap ("Detail Normal Map", 2D) = "bump" {}
_DetailNormalScale ("Detail Normal Scale", Range(0, 2)) = 1
_DetailNormalTiling ("Detail Normal Tiling", Float) = 1
_MaskMap ("MaskMap (MOHR)", 2D) = "linearGrey" {}
_EmissiveMap ("Emissive Map", 2D) = "white" {}
[HDR] _EmissiveColor ("Emissive Color", Color) = (0, 0, 0, 1)
_Metallic ("Metallic", Range(0, 1)) = 0
_Occlusion ("Occlusion", Range(0, 1)) = 1
_Roughness ("Roughness", Range(0, 1)) = 1
_Reflectance ("Reflectance", Range(0, 1)) = 0.5
// Rim
_AlphaRimPower ("Alpha Rim Power", Range(0, 3)) = 1
_AlphaRimIntensity ("Alpha Rim Intensity", Range(1, 3)) = 1
_RoughnessRimPower ("Roughness Rim Power", Range(0, 3)) = 1
_RoughnessRimIntensity ("Roughness Rim Intensity", Range(1, 3)) = 1
_IORRimPower ("IOR Rim Power", Range(0, 3)) = 1
_IORRimIntensity ("IOR Rim Intensity", Range(1, 3)) = 1
_HGRimPower ("HG Rim Power", Range(0, 3)) = 2.8
_HGRimIntensity ("HG Rim Intensity", Range(1, 3)) = 2
// Transmission
_Weight ("Transmission Weight", Range(0, 1)) = 1
_TransmissionColorMap ("Transmission Color Map", 2D) = "white" {}
[HDR] _TransmissionColor ("Transmission Color", Color) = (1, 1, 1, 1)
_ThicknessMap ("Thickness Map", 2D) = "white" {}
_Thickness ("Thickness", Range(0, 100)) = 1
_MFPScale ("MFP Scale", Range(0.001, 100)) = 1
_PhaseAniso ("Phase Aniso", Range(-1, 1)) = 0
// ThinFilm
_ThinFilmThicknessMap ("Thin Film Thickness Map", 2D) = "white" {}
_ThinFilmThickness ("Thin Film Thickness", Range(0, 1)) = 0.27
_ThinFilmFactorMask ("Thin Film Factor Mask", 2D) = "white" {}
_ThinFilmFactor ("Thin Film Factor", Range(0, 2)) = 1
// Flow
_FlowNoiseMap ("Flow Noise Map", 2D) = "white" {}
_FlowMatcap ("Flow Matcap", 2D) = "white" {}
_FlowIntensity ("Flow Intensity", Range(0, 3)) = 1
_FlowSpeed ("Flow Speed", Range(0, 0.2)) = 0.1
_FlowNoiseTiling ("Flow NoiseTiling", Range(1, 5)) = 1
[HDR] _EmissiveFlowColor ("Emissive Flow Color", Color) = (1, 1, 1, 1)
// Refraction
_IORMap ("IOR Map", 2D) = "white" {}
_IORScale ("IOR Map Scale", Range(0, 3)) = 0.1
_RoughRefractionDepthOffset ("Rough Refraction Depth Offset", Range(-3, 3)) = 0
#endproperties

// ===================================================================================================================

#materialoption.ThinWalled 	              = Enable
#materialoption.ShadowTerminator 		  = Enable
#materialoption.TangentSpaceNormalMap     = Enable
#materialoption.PixelDepthOffset          = Disable
#materialoption.PerObjectShadow           = Enable
#materialoption.CustomizeVertexOutputData = Enable
#materialoption.Reflectance 			  = Enable
#materialoption.IsCharacter				  = Enable
#materialoption.CustomSkyTransmission     = Enable
#materialoption.ThinFilm				  = Enable
#materialoption.CustomOption0.Flow        = OptionDisable
#materialoption.CustomOption1.Rim         = OptionDisable

// ===================================================================================================================

#else
#include "./MM_CH_TransmissionSlime.Header.hlsl"
#endif

#include "Packages/com.funplus.xrender/Shaders/Library/Common.hlsl"
#include "Packages/com.funplus.xrender/Shaders/Library/CommonHeader.hlsl"
#include "Packages/com.funplus.xrender/Shaders/Library/CommonSampler.hlsl"
#include "Packages/com.funplus.xrender/Shaders/Library/CommonMaterial.hlsl"
#include "Packages/com.funplus.xrender/Shaders/Library/CommonLighting.hlsl"
#include "Assets/Res/Shader/Includes/ResShaderIncludesIndex.hlsl"

// ===================================================================================================================
// for vs

float4 _EllipsoidCenter;
float4 _EllipsoidRadius;
float4x4 _EllipsoidRotation; 

float4 PrepareMaterialVertexCustomOutputData(in FVertexOutput VertexOut, in FVertexInput VertexIn, float3 OffsetOS, float3 OffsetWS)
{
	float Thickness = 1.0;
	// return float4(Thickness, 0.0, 0.0, 0.0);
	
	float3 RayDir = GetMainLightDirection();
	
	float3 Center = _EllipsoidCenter.xyz;
	float3 Radius = _EllipsoidRadius.xyz;
	float4x4 Rotation = _EllipsoidRotation;
	
	float3 ro = VertexOut.PositionWS - Center;
	ro = mul(Rotation, float4(ro, 0));
	float3 rd = mul(Rotation, float4(RayDir, 0));
	float3 ra = Radius;

	float3 ocn = ro / ra;
	float3 rdn = normalize(rd / ra);
	float a = dot(rdn, rdn);
	float b = dot(ocn, rdn);
	float c = dot(ocn, ocn);
	float h = b * b - a * (c - 1.0);
	if(h > 0.0)	// make sure that ellipsoid contain the object fully, otherwise there is error
	{
		h = sqrt(h);
		Thickness = (-b + h) / a;
		// Thickness = clamp(Thickness, 0, 1.0);
	}
    Thickness *= ra;	// world space thickness
	
	return float4(Thickness, 0.0, 0.0, 0.0);
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

// ===================================================================================================================
// for ps

float4 TriPlanarProjection( float3 PositionWS, Texture2D Tex, float Tiling, float3 Weight )
{
	float3 PositionOS = PositionWS - TransformPositionOSToPositionWS(float3(0, 0, 0), GetObjectToWorldMatrix());
	float4 Color0 = Weight.x > 0.0 ? SAMPLE_TEXTURE2D(Tex, SamplerLinearRepeat, PositionOS.yz * Tiling) : float4(0, 0, 0, 0);
	float4 Color1 = Weight.y > 0.0 ? SAMPLE_TEXTURE2D(Tex, SamplerLinearRepeat, PositionOS.zx * Tiling) : float4(0, 0, 0, 0);
	float4 Color2 = Weight.z > 0.0 ? SAMPLE_TEXTURE2D(Tex, SamplerLinearRepeat, PositionOS.xy * Tiling) : float4(0, 0, 0, 0);
	float4 Color3 = float4(1, 1, 1, 0);
	float4 Weight4 = (Weight.x + Weight.y + Weight.z) > 0.0 ? float4(Weight, 0) : float4(Weight, 1);
	return (Color0 * Weight4.x + Color1 * Weight4.y + Color2 * Weight4.z + Color3 * Weight4.w) / (Weight4.x + Weight4.y + Weight4.z + Weight4.w);
}
float3 SampleMatap(float3 NormalWS, Texture2D<float4> Tex)
{
	float2 Coordinate = mul(GetWorldToViewMatrix(), NormalWS).xy * 0.5 + 0.5;
	return SAMPLE_TEXTURE2D(Tex, SamplerLinearRepeat, Coordinate).xyz;
}
float3 BlendAngelCorrectedNormals(float3 BaseNormal, float3 AdditionalNormal)
{
	float3 Temp_0 = float3(BaseNormal.xy, BaseNormal.z + 1);
	float3 Temp_1 = float3(-AdditionalNormal.xy, AdditionalNormal.z);
	float3 Temp_2 = dot(Temp_0, Temp_1);
	return normalize(Temp_0 * Temp_2 - Temp_1 * Temp_2);
}
void PrepareMaterialInput_New(FPixelInput PixelIn, FSurfacePositionData PosData, inout MInputType MInput)
{
	// Fresnel And Rim
	float AlphaRim = 0;
	float RoughnessRim = 0;
	float IORRim = 0;
	float EmissiveRim = 0;
	#if defined(MATERIAL_USE_RIM)
	PixelIn.GeometricNormalWS *= PixelIn.IsFrontFacing ? 1 : -1;
	float NDotV = saturate(dot(PixelIn.GeometricNormalWS, PosData.CameraVectorWS));
	AlphaRim = _AlphaRimPower < 2.99 ? saturate(pow(1 - NDotV, _AlphaRimPower) * _AlphaRimIntensity) : 0;
	RoughnessRim = _RoughnessRimPower < 2.99 ? saturate(pow(1 - NDotV, _RoughnessRimPower) * _RoughnessRimIntensity) : 0;
	IORRim = _IORRimPower < 2.99 ? saturate(pow(1 - NDotV, _IORRimPower) * _IORRimIntensity) : 0;
	EmissiveRim = _HGRimPower < 2.99 ? saturate(pow(1 - NDotV, _HGRimPower) * _HGRimIntensity) : 0;
	#else
	#endif
	// Base
    float2 BaseMapUV = PixelIn.UV0;
    float4 BaseMap = SAMPLE_TEXTURE2D(_BaseMap, SamplerLinearRepeat, BaseMapUV);
    float4 MaskMap = SAMPLE_TEXTURE2D(_MaskMap, SamplerLinearRepeat, BaseMapUV);
	float4 BaseColor = BaseMap * _BaseColor;
	MInput.Base.Color = BaseColor.rgb;
	MInput.Base.Opacity = lerp(BaseColor.a, 0, AlphaRim);
	MInput.Base.Metallic = GetMaterialMetallicFromMaskMap(MaskMap) * _Metallic;
	MInput.Base.Roughness = lerp(GetPerceptualRoughnessFromMaskMap(MaskMap) * _Roughness, 0, RoughnessRim);
	MInput.AO.AmbientOcclusion = LerpWhiteTo(GetMaterialAOFromMaskMap(MaskMap), _Occlusion);

    float4 NormalMap = SAMPLE_TEXTURE2D(_NormalMap, SamplerLinearRepeat, BaseMapUV);
    float4 DetailNormalMap = SAMPLE_TEXTURE2D(_DetailNormalMap, SamplerLinearRepeat, BaseMapUV * _DetailNormalTiling);
    MInput.TangentSpaceNormal.NormalTS = BlendAngelCorrectedNormals(GetNormalTSFromNormalTex(NormalMap, _NormalScale), GetNormalTSFromNormalTex(DetailNormalMap, _DetailNormalScale));
    MInput.Emission.Color = SAMPLE_TEXTURE2D(_EmissiveMap, SamplerLinearRepeat, BaseMapUV).rgb * _EmissiveColor.rgb;
	// Flow
	#if defined(MATERIAL_USE_FLOW)
	float3 PositionWS = PixelIn.PositionWS * _FlowNoiseTiling + float3(0, _Time.y * _FlowSpeed * 2, _Time.y * _FlowSpeed * -1);
	float3 NormalWS = PixelIn.GeometricNormalWS;
	float3 FlowNoise = normalize(TriPlanarProjection(PositionWS, _FlowNoiseMap, 1, float3(1, 1, 1))) * _FlowIntensity;
	float3 FlowNormalWS = normalize(float4(NormalWS.x + FlowNoise.x, NormalWS.y + FlowNoise.y, NormalWS.z, 0));
	float MatcapColor = SampleMatap(FlowNormalWS, _FlowMatcap).r;
	#else
	#endif
	// Distortion
	float IOR = 1 + SAMPLE_TEXTURE2D(_IORMap, SamplerLinearRepeat, BaseMapUV) * _IORScale;
	MInput.Specular.IOR = lerp(IOR, 1, IORRim);
	MInput.Specular.Reflectance = _Reflectance;
	MInput.Specular.RoughRefractionDepthOffset = _RoughRefractionDepthOffset;
	// Transmission
    MInput.Transmission.Weight = _Weight;
	float3 TransmittanceColor;
	
	#if defined(MATERIAL_USE_FLOW)
	MInput.Emission.Color += MatcapColor * _EmissiveFlowColor.rgb;
	#else
	#endif
	
	TransmittanceColor = SAMPLE_TEXTURE2D(_TransmissionColorMap, SamplerLinearRepeat, BaseMapUV).rgb * _TransmissionColor.rgb;
    MInput.Transmission.SSSMFP = TransmittanceToMeanFreePath(TransmittanceColor, VOLUME_DEFAULT_THICKNESS_M);
    MInput.Transmission.SSSMFPScale = _MFPScale;
    MInput.Transmission.Thickness = SAMPLE_TEXTURE2D(_ThicknessMap, SamplerLinearRepeat, BaseMapUV).r * _Thickness;
	// Trick
    MInput.Transmission.SSSPhaseAniso = lerp(_PhaseAniso, 0, EmissiveRim);// https://www.desmos.com/calculator/my4rjztv04
	// Thin Film
	float2 ThinFilmUV = PixelIn.UV0;
	MInput.ThinFilm.Thickness = SAMPLE_TEXTURE2D(_ThinFilmThicknessMap, SamplerLinearRepeat, ThinFilmUV).r * _ThinFilmThickness;
	MInput.ThinFilm.Factor = SAMPLE_TEXTURE2D(_ThinFilmFactorMask, SamplerLinearRepeat, BaseMapUV).r * _ThinFilmFactor;
	
    #if defined(USE_VERTEX_ATTR_CUSTOM_OUTPUT_DATA)
    // SSS MFP Scale is a material params, it means color(1, 1, 1) trans through cur mat by this thick will turn to transmittance_color
    // so this place no need multi really object's thickness to SSSMFPScale
    // todo, thickness may get from thickness map, this situation must transform from [0, 1] to world space thickness
    MInput.Transmission.Thickness *= PixelIn.CustomVertexData.r;
    #endif
}

// ===================================================================================================================

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

// Capsule Proxy Thickness

// StructuredBuffer<float4> _CapsuleBuffer;
// uint _ThicknessCapsuleCount;
//#materialoption.CustomizeVertexOutputData
// float4 PrepareMaterialVertexCustomOutputData(in FVertexOutput VertexOut, in FVertexInput VertexIn, float3 OffsetOS, float3 OffsetWS)
// {
// 	float thickness = 0;
// 	float SumThickness = 0;
// 	float SumWeight = 0;
// 	float3 ro = VertexOut.PositionWS;
// 	float3 rd = -normalize(_Forward.xyz);
//
// 	int Index = -1;
// 	for(int i = 0; i < _ThicknessCapsuleCount; ++i)
// 	{
// 		float Weight = 0;
// 		if(CapsuleInvolve(i, ro, Weight))
// 		{
// 			// Index = i;
// 			// break;	// calculate once only
// 			SumWeight += Weight;
//
// 			float3 pa = _CapsuleBuffer[i * 2].xyz;	// Transform Local Position to World Position in C# script 
// 			float3 pb = _CapsuleBuffer[i * 2 + 1].xyz;
// 			float ra = _CapsuleBuffer[i * 2].a;
//
// 			// Intersect
// 			float3  ba = pb - pa;
// 			float3  oa = ro - pa;
// 			float3  ob = ro - pb;
// 			float baba = dot(ba,ba);
// 			float bard = dot(ba,rd);
// 			float baoa = dot(ba,oa);
// 			float rdoa = dot(rd,oa);
// 			float oaoa = dot(oa,oa);
// 			float a = baba      - bard*bard;
// 			float b = baba*rdoa - baoa*bard;
// 			float c = baba*oaoa - baoa*baoa - ra*ra*baba;
// 			float delta = b*b - a*c;
//                 
// 			float BodyT2 = (-b+sqrt(delta))/a;
// 			float y2 = baoa + BodyT2*bard;
//
// 			// hit body
// 			if(y2 > 0.0 && y2 < baba)
// 			{
// 				SumThickness += BodyT2 * Weight;
// 				// thickness = max(thickness, BodyT2);
// 			}
// 			// hit caps
// 			else
// 			{
// 				float3 oc = y2 <= 0.0 ? oa : ob;
// 				b = dot(rd,oc);
// 				c = dot(oc,oc) - ra*ra;
// 				delta = b*b - c;
// 				delta = sqrt(delta);
// 				// thickness = max(thickness, -b + delta);
// 				SumThickness += (-b + delta) * Weight;
// 			}
// 		}
// 	}

	// if(Index == -1)
	// {
	// 	return float4(0.0, 0.0, 0.0, 0.0); 
	// }
	
	// float3 pa = _CapsuleBuffer[Index * 2].xyz;	// Transform Local Position to World Position in C# script 
	// float3 pb = _CapsuleBuffer[Index * 2 + 1].xyz;
	// float ra = _CapsuleBuffer[Index * 2].a;
	//
	// // Intersect
	// float3  ba = pb - pa;
	// float3  oa = ro - pa;
	// float3  ob = ro - pb;
	// float baba = dot(ba,ba);
	// float bard = dot(ba,rd);
	// float baoa = dot(ba,oa);
	// float rdoa = dot(rd,oa);
	// float oaoa = dot(oa,oa);
	// float a = baba      - bard*bard;
	// float b = baba*rdoa - baoa*bard;
	// float c = baba*oaoa - baoa*baoa - ra*ra*baba;
	// float delta = b*b - a*c;
 
	// float BodyT2 = (-b+sqrt(delta))/a;
	// float y2 = baoa + BodyT2*bard;
	//
	// // hit body
	// if(y2 > 0.0 && y2 < baba)
	// {
	// 	thickness = BodyT2;
	// }
	// // hit caps
	// else
	// {
	// 	float3 oc = y2 <= 0.0 ? oa : ob;
	// 	b = dot(rd,oc);
	// 	c = dot(oc,oc) - ra*ra;
	// 	delta = b*b - c;
	// 	delta = sqrt(delta);
	// 	thickness = -b + delta;
	// }
	// thickness = IsNaN(thickness) ? 1.0 : thickness;
// 	return float4(SumThickness / SumWeight * 0.95, 0.0, 0.0, 0.0);
// 	return float4(thickness, 0.0, 0.0, 0.0);
// }


// bool CapsuleInvolve(int Index, float3 PositionWS, out float Weight)
// {
// 	float4 PosAR = _CapsuleBuffer[Index * 2];
// 	float4 PosBL = _CapsuleBuffer[Index * 2 + 1];
// 	float Radius = PosAR.w;
// 	Weight = 0;
//
// 	float3 AO = PositionWS - PosAR.xyz;
// 	float3 AB = PosBL.xyz - PosAR.xyz;
// 	float3 BO = PositionWS - PosBL.xyz;
// 	float3 NormalizedAO = normalize(AO);
// 	float3 NormalizedBO = normalize(BO);
// 	float3 NormalizedAB = normalize(AB);
// 	float CosOAB = dot(NormalizedAO, NormalizedAB);
// 	float CosOBA = dot(NormalizedBO, -NormalizedAB);
// 	
// 	if(CosOAB <= 0)  // caps A
// 		{
// 		if(length(AO) < Radius)
// 		{
// 			Weight = 1.0 - length(AO) / Radius;
// 			return true;
// 		}
// 		}
// 	else if(CosOBA <= 0) // caps B
// 		{
// 		if(length(BO) < Radius)
// 		{
// 			Weight = 1.0 - length(BO) / Radius;
// 			return true;
// 		}
// 		}
// 	else // body
// 		{
// 		float3 ProjectedPoint = PosAR.xyz + NormalizedAB * CosOAB * length(AO);
// 		if(length(ProjectedPoint - PositionWS) < Radius)
// 		{
// 			Weight = 1.0 - length(ProjectedPoint - PositionWS) / Radius;
// 			return true;
// 		}
//
// 		// float dist = length(AO) * sqrt(1 - CosOAB * CosOAB);
// 		// if(dist < Radius)
// 		// {
// 		// 	return true;
// 		// }
// 		}
//
// 	return false;
// }

// Sphere Proxy Volume

// StructuredBuffer<float4> _SphereBuffer;
// uint _ThicknessSphereCount;

//#materialoption.CustomizeVertexOutputData
// float4 PrepareMaterialVertexCustomOutputData(in FVertexOutput VertexOut, in FVertexInput VertexIn, float3 OffsetOS, float3 OffsetWS)
// {
// 	float Thickness = 0;
// 	float3 PositionWS = VertexOut.PositionWS;
// 	float3 RayDir = normalize(_Forward.xyz);
//
// 	for(int i = 0; i < _ThicknessSphereCount; ++i)
// 	{
// 		float3 Center = _SphereBuffer[i * 2].xyz;
// 		float Radius = _SphereBuffer[i * 2].w;
// 		float3 Scale = _SphereBuffer[i * 2 + 1].xyz;
// 		// float3 ScaledRayDir = normalize(RayDir / Scale);
// 		float R2 = Radius * Radius;
// 		
// 		if(dot((PositionWS - Center), (PositionWS - Center)) >= R2)
// 		{
// 			continue;
// 		}
//
// 		float OC = Center - PositionWS;
// 		float B = dot(OC, RayDir);
// 		float C = dot(OC, OC) - R2;
// 		float Delta = B * B - C;
// 		Thickness = -B + sqrt(Delta);
// 		// Thickness = length(Thickness * ScaledRayDir * Scale);
// 		break;
// 	}
//
// 	return float4(Thickness, 0.0, 0.0, 0.0);
// }


