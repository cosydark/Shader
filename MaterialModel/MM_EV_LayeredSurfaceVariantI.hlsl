#ifdef MM_HEADER
#attribute Material.Author = "QP4B"
#attribute Material.Name = "LayeredSurfaceVariantI"
#attribute Material.ShadingModel = "DefaultLit"

#stylesheet

# Texture Mask @Hide(_CustomOption0 > 0)
- _BlendMask @TryInline(0)
- _UVIndex_Mask @Drawer(Enum, 0, 1)

# Base Layer
- _BaseMap @TryInline(1)
- _BaseColor
- _NormalMap @TryInline(1)
- _NormalScale
- _MaskMap @TryInline(0)
- _Reflectance
- _HeightOffset
###
### Tiling Option
- _Tiling
- _MatchScaling @Drawer(Toggle)
- _UVIndex @Drawer(Enum, 0, 1)

# Blend Layer (R) @Hide(_CustomOption1 == 0)
- _BaseMap_Blende @TryInline(1)
- _BaseColor_Blend
- _NormalMap_Blend @TryInline(1)
- _NormalScale_Blend
- _MaskMap_Blend @TryInline(0)
- _Reflectance_Blend
- _HeightOffset_Blend
###
### Tiling Option
- _Tiling_Blend
- _MatchScaling_Blend @Drawer(Toggle)
- _UVIndex_Blend @Drawer(Enum, 0, 1)
###
### Mask Filter
- _MaskContrast_Blend
- _MaskIntensity_Blend

###
### Blend Option
- _BlendMode_Blend  @Drawer(Enum, Lerp, Height Max, Height Min)
- _BlendRadius_Blend

# Detail (A) @Hide(_CustomOption2 == 0)
- _DetailMap @TryInline(1)
- _DetailIntensity
- _DetailNormalScale
###
### Tiling Option
- _Tiling_Detail
- _MatchScaling_Detail @Drawer(Toggle)
- _UVIndex_Detail @Drawer(Enum, 0, 1)
###
### Mask Filter
- _MaskContrast_Detail
- _MaskIntensity_Detail

# Topping @Hide(_CustomOption3 == 0)
- _BaseMap_Topping @TryInline(1)
- _BaseColor_Topping
- _NormalMap_Topping @TryInline(1)
- _NormalScale_Topping
- _MaskMap_Topping @TryInline(0)
- _Reflectance_Topping
###
### Toppping Option
- _Coverage
- _Spread
###
### Tiling Option
- _Tiling_Topping
- _MatchScaling_Topping @Drawer(Toggle)
- _UVIndex_Topping @Drawer(Enum, 0, 1)

#endstylesheet


#properties
// Mask
_BlendMask ("BlendMask", 2D) = "black" {}
_UVIndex_Mask ("UV Index", Int) = 0

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
_UVIndex ("UV Index", Int) = 0
// Blend Layer
_BaseMap_Blende ("BaseMap", 2D) = "white" {}
_BaseColor_Blend ("Base Color", Color) = (1, 1, 1, 1)
_NormalMap_Blend ("NormalMap", 2D) = "bump" {}
_NormalScale_Blend ("Normal Scale", Range(0, 2)) = 1
_MaskMap_Blend ("MaskMap", 2D) = "black" {}
_Reflectance_Blend ("Reflectance", Range(0, 1)) = 0.5
_HeightOffset_Blend ("Height Offset", Range(-1, 1)) = 0
_Tiling_Blend ("Tiling", Float) = 1
_MatchScaling_Blend ("Match Scaling", Int) = 0
_UVIndex_Blend ("UV Index", Int) = 0
_BlendMode_Blend ("Blend Mode", Float) = 1
_BlendRadius_Blend ("Blend Radius", Range(0.01, 0.5)) = 0.1
_MaskContrast_Blend ("Mask Contrast R", Float) = 1
_MaskIntensity_Blend ("Mask Intensity R", Float) = 1
// Detail
_DetailIntensity ("Detail Intensity", Range(0, 1)) = 1
_DetailMap ("Detail Map", 2D) = "bump" {}
_DetailNormalScale ("Detail Normal Scale", Range(0, 2)) = 1
_Tiling_Detail ("Tiling Detail", Float) = 1
_MatchScaling_Detail ("Match Scaling Detail", Int) = 0
_UVIndex_Detail ("UV Index", Int) = 0
_MaskContrast_Detail ("Mask Contrast R", Float) = 1
_MaskIntensity_Detail ("Mask Intensity R", Float) = 1
// Topping
_BaseMap_Topping ("BaseMap", 2D) = "white" {}
_BaseColor_Topping ("Base Color", Color) = (1, 1, 1, 1)
_NormalMap_Topping ("NormalMap", 2D) = "bump" {}
_NormalScale_Topping ("Normal Scale", Range(0, 2)) = 1
_MaskMap_Topping ("MaskMap", 2D) = "black" {}
_Reflectance_Topping ("Reflectance", Range(0, 1)) = 0.5
_Coverage ("Coverage", Range(0, 1)) = 0.5
_Spread ("Spread", Range(0, 1)) = 0.5
_Tiling_Topping ("Tiling", Float) = 1
_MatchScaling_Topping ("Match Scaling", Int) = 0
_UVIndex_Topping ("UV Index", Int) = 0

#endproperties

#materialoption.TangentSpaceNormalMap 	= Enable
#materialoption.AmbientOcclusion 		= Enable
#materialoption.Reflectance 			= Enable
#materialoption.Detail 					= Enable
#materialoption.UseSlab 			    = Enable
#materialoption.UseUV1					= Enable
#materialoption.Emissive 				= Disable

#materialoption.CustomOption0.UseVertexColor = OptionEnable
#materialoption.CustomOption1.BlendLayer = OptionDisable
#materialoption.CustomOption2.DetailLayer = OptionDisable
#materialoption.CustomOption3.ToppingLayer = OptionDisable

#else
#include "./MM_EV_LayeredSurfaceVariantI.Header.hlsl"
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
float2 HeightBlend(float WeightA, float HeightA, float WeightB, float HeightB, float Radius)
{
	float MaxHeight = max(WeightA + HeightA, WeightB + HeightB) - Radius;
	float A = max(WeightA + HeightA - MaxHeight, 0);
	float B = max(WeightB + HeightB - MaxHeight, 0);
	return float2(A, B) / (A + B);
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
			HeightBlendMask = HeightBlend(BlendMask, saturate(ModifyHeight(MaskMapBlend.z, HeightOffset)), 1, Mask.z, BlendContrast).x;
			break;
		case 2:
			HeightBlendMask = HeightBlend(1, saturate(ModifyHeight(MaskMapBlend.z, HeightOffset)), BlendMask, Mask.z, BlendContrast).y;
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

float2 PrepareTextureCoordinates(float Handle, FPixelInput PixelInput)
{
	if(Handle < FLT_EPS)
	{
		return 	PixelInput.UV0;
	}
	return PixelInput.UV1;
}

void PrepareMaterialInput_New(FPixelInput PixelIn, FSurfacePositionData PosData, inout MInputType MInput)
{
	// Prepare UV
	float2 MaskCoordinates = PrepareTextureCoordinates(_UVIndex_Mask, PixelIn);
	float2 BaseLayerCoordinates = PrepareTextureCoordinates(_UVIndex, PixelIn);
	float2 BlendLayerCoordinates = PrepareTextureCoordinates(_UVIndex_Blend, PixelIn);
	float2 DetailCoordinates = PrepareTextureCoordinates(_UVIndex_Detail, PixelIn);
	float2 ToppingCoordinates = PrepareTextureCoordinates(_UVIndex_Topping, PixelIn);
	// Scale
	float LocalScaleX = length(float3(GetObjectToWorldMatrix()[0].x, GetObjectToWorldMatrix()[1].x, GetObjectToWorldMatrix()[2].x));
	// Sample Mask For Bend
	float4 BlendMask = 0;
	// Mask
	#if defined(MATERIAL_USE_USEVERTEXCOLOR)
	BlendMask = PixelIn.VertexColor;
	#else
	BlendMask = SAMPLE_TEXTURE2D(_BlendMask, SamplerTriLinearRepeat, MaskCoordinates);
	#endif
	
	BlendMask.r = saturate(pow(BlendMask.r, _MaskContrast_Blend) * _MaskIntensity_Blend);
	BlendMask.a = saturate(pow(BlendMask.a, _MaskContrast_Detail) * _MaskIntensity_Detail);
	
	// Sample BaseLayer
	BaseLayerCoordinates = BaseLayerCoordinates * _Tiling * (_MatchScaling > FLT_EPS ? LocalScaleX : 1);
	float4 BaseMap = SAMPLE_TEXTURE2D(_BaseMap, SamplerTriLinearRepeat, BaseLayerCoordinates);
	float4 Color = BaseMap * _BaseColor;
	float4 NormalMap = SAMPLE_TEXTURE2D(_NormalMap, SamplerLinearRepeat, BaseLayerCoordinates);
	float3 NormalTS = GetNormalTSFromNormalTex(NormalMap, _NormalScale);
	float4 Mask = SAMPLE_TEXTURE2D(_MaskMap, SamplerLinearRepeat, BaseLayerCoordinates);
	Mask.z = ModifyHeight(Mask.z, _HeightOffset);
	Mask = saturate(Mask);
	float Reflectance = _Reflectance;

#if defined(MATERIAL_USE_BLENDLAYER)
	BlendWithHeight(_BaseMap_Blende,
					_BaseColor_Blend,
					_NormalMap_Blend,
					_NormalScale_Blend,
					_MaskMap_Blend,
					_Reflectance_Blend,
					BlendLayerCoordinates * _Tiling_Blend * (_MatchScaling_Blend > FLT_EPS ? LocalScaleX : 1),
					Color,
					NormalTS,
					Mask,
					Reflectance,
					BlendMask.r,
					_BlendRadius_Blend,
					_HeightOffset_Blend,
					_BlendMode_Blend
					);
#endif

#if defined(MATERIAL_USE_DETAILLAYER)
	// Needs Anti Tiling
	float DetailIntensity = _DetailIntensity * BlendMask.a;
	DetailCoordinates = DetailCoordinates * _Tiling_Detail * (_MatchScaling_Detail > FLT_EPS ? LocalScaleX : 1);
	float4 DetailMap = SAMPLE_TEXTURE2D(_DetailMap, SamplerLinearRepeat, DetailCoordinates);
	float3 DetailNormalTS = GetNormalTSFromDetailMap(DetailMap, _DetailNormalScale * DetailIntensity);
	// Apply Detail Map
	NormalTS = BlendAngelCorrectedNormals(NormalTS, DetailNormalTS);
	Mask.g = min(Mask.g, lerp(1, GetAOFromDetailMap(DetailMap), DetailIntensity));
	Color *= lerp(1, GetAlbedoGrayScaleFromDetailMap(DetailMap), DetailIntensity);
#endif
	
#if defined(MATERIAL_USE_TOPPINGLAYER)
	ToppingCoordinates = ToppingCoordinates * _Tiling_Topping * (_MatchScaling_Topping > FLT_EPS ? LocalScaleX : 1);
	float4 BaseMapTopping = SAMPLE_TEXTURE2D(_BaseMap_Topping, SamplerTriLinearRepeat, ToppingCoordinates) * _BaseColor_Topping;
	float4 NormalMapTopping = SAMPLE_TEXTURE2D(_NormalMap_Topping, SamplerLinearRepeat, ToppingCoordinates);
	float3 NormalTopping = GetNormalTSFromNormalTex(NormalMapTopping, _NormalScale_Topping);
	float4 MaskTopping = SAMPLE_TEXTURE2D(_MaskMap_Topping, SamplerLinearRepeat, ToppingCoordinates);
	// Compute N Dot Up
	float3 NormalWS = TransformVectorTSToVectorWS_RowMajor(NormalTS, PixelIn.TangentToWorldMatrix, true);
	float3 NdotUp = dot(NormalWS, normalize(float3(0, 1, 0)));
	float Coverage = NdotUp - lerp(1, -1, _Coverage);
	Coverage = saturate(Coverage / _Spread);
	float HeightCoverage = saturate((1 - Mask.b) - lerp(1, -1, Coverage));
	// Apply Topping Layer
	Color = lerp(Color, BaseMapTopping, HeightCoverage);
	Mask = lerp(Mask, MaskTopping, HeightCoverage);
	NormalTS = lerp(NormalTS, NormalTopping, HeightCoverage);

#endif
	
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
