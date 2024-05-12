#ifdef MM_HEADER
#attribute Material.Author = "QP4B"
#attribute Material.Name = "LayeredSurface"
#attribute Material.ShadingModel = "DefaultLit"

#stylesheet

# Texture Mask @Hide(_CustomOption0 > 0)
- _BlendMask @TryInline(0)

# Mask Adjustment
- _MaskContrast_R
- _MaskIntensity_R
- _MaskContrast_G
- _MaskIntensity_G
- _MaskContrast_B
- _MaskIntensity_B

# Base Layer
- _BaseMap @TryInline(1)
- _BaseColor
- _NormalMap @TryInline(1)
- _NormalScale
- _MaskMap @TryInline(0)
- _Reflectance
- _HeightOffset
### Tiling Option
- _Tiling
- _MatchScaling @Drawer(Toggle)

# R Channel @Hide(_CustomOption1 == 0)
- _BaseMap_R @TryInline(1)
- _BaseColor_R
- _NormalMap_R @TryInline(1)
- _NormalScale_R
- _MaskMap_R @TryInline(0)
- _Reflectance_R
- _HeightOffset_R
### Tiling Option
- _Tiling_R
- _MatchScaling_R @Drawer(Toggle)
### Blend Option
- _BlendMode_R  @Drawer(Enum, Lerp, Height Blend)
- _BlendRadius_R

# G Channel @Hide(_CustomOption2 == 0)
- _BaseMap_G @TryInline(1)
- _BaseColor_G
- _NormalMap_G @TryInline(1)
- _NormalScale_G
- _MaskMap_G @TryInline(0)
- _Reflectance_G
- _HeightOffset_G
### Tiling Option
- _Tiling_G
- _MatchScaling_G @Drawer(Toggle)
### Blend Option
- _BlendMode_G  @Drawer(Enum, Lerp, Height Blend)
- _BlendRadius_G

# B Channel @Hide(_CustomOption3 == 0)
- _BaseMap_B @TryInline(1)
- _BaseColor_B
- _NormalMap_B @TryInline(1)
- _NormalScale_B
- _MaskMap_B @TryInline(0)
- _Reflectance_B
- _HeightOffset_B
### Tiling Option
- _Tiling_B
- _MatchScaling_B @Drawer(Toggle)
### Blend Option
- _BlendMode_B @Drawer(Enum, Lerp, Height Blend)
- _BlendRadius_B

# Detail
- _UseDetailMap @Drawer(Toggle)
- _DetailMap @TryInline(1)
- _DetailIntensity
- _DetailNormalScale
### Tiling Option
- _Tiling_Detail
- _MatchScaling_Detail @Drawer(Toggle)

#endstylesheet


#properties
// Mask
_BlendMask ("BlendMask", 2D) = "black" {}
_MaskContrast_R ("Mask Contrast R", Float) = 1
_MaskIntensity_R ("Mask Intensity R", Float) = 1
_MaskContrast_G ("Mask Contrast G", Float) = 1
_MaskIntensity_G ("Mask Intensity G", Float) = 1
_MaskContrast_B ("Mask Contrast B", Float) = 1
_MaskIntensity_B ("Mask Intensity B", Float) = 1
// Base Layer
_BaseMap ("Base Map", 2D) = "white" {}
_BaseColor ("Base Color", Color) = (1, 1, 1, 1)
[Normal] _NormalMap ("Normal Map", 2D) = "bump" {}
_NormalScale ("Normal Scale", Range(0, 2)) = 1
_MaskMap ("Mask Map (MOHR)", 2D) = "white" {}
_Reflectance ("Reflectance", Range(0, 1)) = 0.5
_HeightOffset ("Height Offset", Range(-1, 1)) = 0
_Tiling ("Tiling", Float) = 1
_MatchScaling ("Match Scaling", Int) = 0
// R Channel
_BaseMap_R ("BaseMap R", 2D) = "white" {}
_BaseColor_R ("Base Color R", Color) = (1, 1, 1, 1)
_NormalMap_R ("NormalMap R", 2D) = "bump" {}
_NormalScale_R ("Normal Scale R", Range(0, 2)) = 1
_MaskMap_R ("MaskMap R", 2D) = "black" {}
_Reflectance_R ("Reflectance R", Range(0, 1)) = 0.5
_HeightOffset_R ("Height Offset R", Range(-1, 1)) = 0
_Tiling_R ("Tiling R", Float) = 1
_MatchScaling_R ("Match Scaling R", Int) = 0
_BlendMode_R ("Blend Mode R", Float) = 1
_BlendRadius_R ("Blend Radius R", Range(0.01, 0.5)) = 0.1
// G Channel
_BaseMap_G ("BaseMap G", 2D) = "white" {}
_BaseColor_G ("Base Color G", Color) = (1, 1, 1, 1)
_NormalMap_G ("NormalMap G", 2D) = "bump" {}
_NormalScale_G ("Normal Scale G", Range(0, 2)) = 1
_MaskMap_G ("MaskMap G", 2D) = "black" {}
_Reflectance_G ("Reflectance G", Range(0, 1)) = 0.5
_HeightOffset_G ("Height Offset G", Range(-1, 1)) = 0
_Tiling_G ("Tiling G", Float) = 1
_MatchScaling_G ("Match Scaling G", Int) = 0
_BlendMode_G ("Blend Mode G", Float) = 1
_BlendRadius_G ("Blend Radius G", Range(0.01, 0.5)) = 0.1
// B Channel
_BaseMap_B ("BaseMap B", 2D) = "white" {}
_BaseColor_B ("Base Color B", Color) = (1, 1, 1, 1)
_NormalMap_B ("NormalMap B", 2D) = "bump" {}
_NormalScale_B ("Normal Scale B", Range(0, 2)) = 1
_MaskMap_B ("MaskMap B", 2D) = "black" {}
_Reflectance_B ("Reflectance B", Range(0, 1)) = 0.5
_HeightOffset_B ("Height Offset B", Range(-1, 1)) = 0
_Tiling_B ("Tiling B", Float) = 1
_MatchScaling_B ("Match Scaling B", Int) = 0
_BlendMode_B ("Blend Mode B", Float) = 1
_BlendRadius_B ("Blend Radius B", Range(0.01, 0.5)) = 0.1
// Detail
_UseDetailMap ("Use Detail Map", Int) = 0
_DetailIntensity ("Detail Intensity", Range(0, 1)) = 1
_DetailMap ("Detail Map", 2D) = "bump" {}
_DetailNormalScale ("Detail Normal Scale", Range(0, 2)) = 1
_Tiling_Detail ("Tiling Detail", Float) = 1
_MatchScaling_Detail ("Match Scaling Detail", Int) = 0

#endproperties

#materialoption.TangentSpaceNormalMap 	= Enable
#materialoption.AmbientOcclusion 		= Enable
#materialoption.Reflectance 			= Enable
#materialoption.Detail 					= Enable
#materialoption.UseSlab 			    = Enable
#materialoption.Emissive 				= Disable

#materialoption.CustomOption0.UseVertexColor = OptionEnable
#materialoption.CustomOption1.EnableChannelR = OptionDisable
#materialoption.CustomOption2.EnableChannelG = OptionDisable
#materialoption.CustomOption3.EnableChannelB = OptionDisable

#else
#include "./MM_EV_LayeredSurface.Header.hlsl"
#endif

#include "Packages/com.funplus.xrender/Shaders/Library/Common.hlsl"
#include "Packages/com.funplus.xrender/Shaders/Library/CommonHeader.hlsl"
#include "Packages/com.funplus.xrender/Shaders/Library/CommonSampler.hlsl"
#include "Packages/com.funplus.xrender/Shaders/Library/CommonMaterial.hlsl"

float3 BlendAngelCorrectedNormals(float3 BaseNormal, float3 AdditionalNormal)
{
	float3 Temp_0 = float3(BaseNormal.xy, BaseNormal.z + 1);
	float3 Temp_1 = float3(-AdditionalNormal.xy, AdditionalNormal.z);
	float3 Temp_2 = dot(Temp_0, Temp_1);
	return normalize(Temp_0 * Temp_2 - Temp_1 * Temp_2);
}
float HeightBlend(float WeightA, float HeightA, float HeightB, float Radius)
{
	float MaxHeight = max(WeightA + HeightA, 1 + HeightB) - Radius;
	float A = max(WeightA + HeightA - MaxHeight, 0);
	float B = max(1 + HeightB - MaxHeight, 0);
	return A / (A + B);
}
float ModifyHeight(float Height, float Offset)
{
	return saturate(Height + Offset * 0.5);
}

void UnpackDetailMap(	Texture2D<float4> DetailMapTex,
						float NormalScale,
						float2 Coordinate,
						inout float3 NormalTS,
						inout float AmbientOcclusion,
						inout float Height
					)
{
	float4 DetailMap = SAMPLE_TEXTURE2D(DetailMapTex, SamplerLinearRepeat, Coordinate);
	// Normal
	NormalTS.xy	= DetailMap.rg * 2.0 - 1.0;
	NormalTS.xy	*= NormalScale;
	NormalTS.z	= sqrt(1.0 - saturate(dot(NormalTS.xy, NormalTS.xy)));
	//
	AmbientOcclusion = DetailMap.a;
	Height = DetailMap.b;
}
void BlendWithHeight(	Texture2D<float4> BaseMap,
						float4 BaseColor,
						Texture2D<float4> NormalMap,
						float NormalScale,
						Texture2D<float4> MaskMap,
						float ReflectanceBlend,
						float2 Coordinate,
						inout float4 Color,
						inout float3 NormalTS,
						inout float4 Mask,
						inout float Reflectance,
						float BlendMask,
						float BlendContrast,
						float HeightOffset,
						float BlendMode
					)
{
	float4 BaseMapBlend = SAMPLE_TEXTURE2D(BaseMap, SamplerTriLinearRepeat, Coordinate) * BaseColor;
	float4 NormalMapBlend = SAMPLE_TEXTURE2D(NormalMap, SamplerLinearRepeat, Coordinate);
	float3 NormalBlend = GetNormalTSFromNormalTex(NormalMapBlend, NormalScale);
	float4 MaskMapBlend = SAMPLE_TEXTURE2D(MaskMap, SamplerLinearRepeat, Coordinate);
	
	float HeightBlendMask;
	// TODO(QP4B) A Better Height Blend Function ?
	BRANCH
	switch (BlendMode)
	{
		case 1:
			HeightBlendMask = HeightBlend(BlendMask, saturate(ModifyHeight(MaskMapBlend.z, HeightOffset)), Mask.z, BlendContrast);
			break;
		default:
			HeightBlendMask = BlendMask;
			break;
	}
	// Color = HeightBlendMask;
	Color = lerp(Color, BaseMapBlend, HeightBlendMask);
	NormalTS = lerp(NormalTS, NormalBlend, HeightBlendMask);
	Mask = lerp(Mask, MaskMapBlend, HeightBlendMask);
	Reflectance = lerp(Reflectance, ReflectanceBlend, HeightBlendMask);
}

void PrepareMaterialInput_New(FPixelInput PixelIn, FSurfacePositionData PosData, inout MInputType MInput)
{
	float LocalScaleX = length(float3(GetObjectToWorldMatrix()[0].x, GetObjectToWorldMatrix()[1].x, GetObjectToWorldMatrix()[2].x));
	float4 ScaleFilter = float4(_MatchScaling_R > FLT_EPS ? LocalScaleX : 1, _MatchScaling_G > FLT_EPS ? LocalScaleX : 1, _MatchScaling_B > FLT_EPS ? LocalScaleX : 1, 1);
	// Sample Mask For Bend
	float4 BlendMask = 0;
	//
	#if defined(MATERIAL_USE_USEVERTEXCOLOR)
	BlendMask = PixelIn.VertexColor;
	#else
	BlendMask = SAMPLE_TEXTURE2D(_BlendMask, SamplerTriLinearRepeat, PixelIn.UV0);
	#endif
	BlendMask.r = saturate(pow(BlendMask.r, _MaskContrast_R) * _MaskIntensity_R);
	BlendMask.g = saturate(pow(BlendMask.g, _MaskContrast_G) * _MaskIntensity_G);
	BlendMask.b = saturate(pow(BlendMask.b, _MaskContrast_B) * _MaskIntensity_B);
	
	// Sample BaseLayer
	float2 BaseMapUV = PixelIn.UV0 * _Tiling * (_MatchScaling > FLT_EPS ? LocalScaleX : 1);
	float4 BaseMap = SAMPLE_TEXTURE2D(_BaseMap, SamplerTriLinearRepeat, BaseMapUV);
	float4 Color = BaseMap * _BaseColor;
	float4 NormalMap = SAMPLE_TEXTURE2D(_NormalMap, SamplerLinearRepeat, BaseMapUV);
	float3 NormalTS = GetNormalTSFromNormalTex(NormalMap, _NormalScale);
	float4 Mask = SAMPLE_TEXTURE2D(_MaskMap, SamplerLinearRepeat, BaseMapUV);
	Mask.z = ModifyHeight(Mask.z, _HeightOffset);
	Mask = saturate(Mask);
	float Reflectance = _Reflectance;

	#if defined(MATERIAL_USE_ENABLECHANNELR)
	BlendWithHeight(_BaseMap_R,
					_BaseColor_R,
					_NormalMap_R,
					_NormalScale_R,
					_MaskMap_R,
					_Reflectance_R,
					PixelIn.UV0 * _Tiling_R * ScaleFilter.r,
					Color,
					NormalTS,
					Mask,
					Reflectance,
					BlendMask.r,
					_BlendRadius_R,
					_HeightOffset_R,
					_BlendMode_R
					);
	#endif
	#if defined(MATERIAL_USE_ENABLECHANNELG)
	BlendWithHeight(_BaseMap_G,
					_BaseColor_G,
					_NormalMap_G,
					_NormalScale_G,
					_MaskMap_G,
					_Reflectance_G,
					PixelIn.UV0 * _Tiling_G * ScaleFilter.g,
					Color,
					NormalTS,
					Mask,
					Reflectance,
					BlendMask.g,
					_BlendRadius_G,
					_HeightOffset_G,
					_BlendMode_G
					);
	#endif
	#if defined(MATERIAL_USE_ENABLECHANNELB)
	BlendWithHeight(_BaseMap_B,
					_BaseColor_B,
					_NormalMap_B,
					_NormalScale_B,
					_MaskMap_B,
					_Reflectance_B,
					PixelIn.UV0 * _Tiling_B * ScaleFilter.b,
					Color,
					NormalTS,
					Mask,
					Reflectance,
					BlendMask.b,
					_BlendRadius_B,
					_HeightOffset_B,
					_BlendMode_B);
	#endif

	BRANCH
	if(_UseDetailMap > FLT_EPS)
	{
		// Needs Anti Tiling
		float DetailIntensity = _DetailIntensity * BlendMask.a;
		float2 DetailBaseMapUV = PixelIn.UV0 * _Tiling_Detail * (_MatchScaling_Detail > FLT_EPS ? LocalScaleX : 1);
		float4 DetailMap = SAMPLE_TEXTURE2D(_DetailMap, SamplerLinearRepeat, DetailBaseMapUV);
		float3 DetailNormalTS = GetNormalTSFromDetailMap(DetailMap, _DetailNormalScale * DetailIntensity);
		NormalTS = BlendAngelCorrectedNormals(NormalTS, DetailNormalTS);
		Mask.g *= lerp(1, GetAOFromDetailMap(DetailMap), DetailIntensity);
		Mask.a *= lerp(1, GetAlbedoGrayScaleFromDetailMap(DetailMap), DetailIntensity);
	}
	
	MInput.Base.Color = Color;
	MInput.Base.Opacity = 1;
	MInput.Base.Metallic = GetMaterialMetallicFromMaskMap(Mask);
	MInput.Base.Roughness = GetPerceptualRoughnessFromMaskMap(Mask);
	MInput.Detail.Height = GetHeightFromMaskMap(Mask);
	MInput.AO.AmbientOcclusion = GetMaterialAOFromMaskMap(Mask);
	MInput.Specular.Reflectance = Reflectance;
	MInput.TangentSpaceNormal.NormalTS = NormalTS;
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
	#materialoption.CapsuleShadow
	#materialoption.ReceiveDecal
	#materialoption.SpecularOcclusion
	#materialoption.Haziness
	#materialoption.MeanFreePath
	#materialoption.MicroShadow
	
*/
