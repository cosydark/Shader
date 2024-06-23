#ifdef MM_HEADER
#attribute Material.Author = "QP4B"
#attribute Material.Name = "EV_LayeredRock"
#attribute Material.ShadingModel = "DefaultLit"
#attribute Material.LODCrossFade = Enable

#stylesheet

# Material Setting
- _BlendMask @Hide(_CustomOption0 != 0)
- _UseAdditionalLayer @Drawer(Toggle)

# Base Layer @Hide(_CustomOption1 == 0)
- _BaseLayer_BaseMap @TryInline(0)
- _BaseLayer_NormalMap @TryInline(1)
- _BaseLayer_NormalScale
- _BaseLayer_MaskMap @TryInline(0)

# Tiling Layer
- _TilingLayer_BaseMap @TryInline(1)
- _TilingLayer_BaseColor
- _TilingLayer_NormalMap @TryInline(1)
- _TilingLayer_NormalScale
- _TilingLayer_MaskMap @TryInline(0)
- _TilingLayer_Reflectance
- _TilingLayer_HeightOffset
- _TilingLayer_PorosityFactor @Drawer(PorosityFactor)
### Tiling Setting
- _TilingLayer_Tiling
- _TilingLayer_Use2U @Drawer(Toggle)
- _TilingLayer_HexTiling @Drawer(Toggle)
- _TilingLayer_MatchScaling @Drawer(Toggle)

# Tiling Layer (R) @Hide(_CustomEnum < 1 || _CustomEnum == 3)
- _TilingLayer_R_BaseMap @TryInline(1)
- _TilingLayer_R_BaseColor
- _TilingLayer_R_NormalMap @TryInline(1)
- _TilingLayer_R_NormalScale
- _TilingLayer_R_MaskMap @TryInline(0)
- _TilingLayer_R_Reflectance
- _TilingLayer_R_HeightOffset
- _TilingLayer_R_PorosityFactor @Drawer(PorosityFactor)
### Tiling Setting
- _TilingLayer_R_Tiling
- _TilingLayer_R_Use2U @Drawer(Toggle)
- _TilingLayer_R_HexTiling @Drawer(Toggle)
- _TilingLayer_R_MatchScaling @Drawer(Toggle)
### Mask Setting
- _TilingLayer_R_MaskContrast
- _TilingLayer_R_MaskIntensity
### Blend Setting
- _TilingLayer_R_BlendMode  @Drawer(Enum, Height Max, Height Min)
- _TilingLayer_R_BlendRadius

# Tiling Layer (G) @Hide(_CustomEnum != 2)
- _TilingLayer_G_BaseMap @TryInline(1)
- _TilingLayer_G_BaseColor
- _TilingLayer_G_NormalMap @TryInline(1)
- _TilingLayer_G_NormalScale
- _TilingLayer_G_MaskMap @TryInline(0)
- _TilingLayer_G_Reflectance
- _TilingLayer_G_HeightOffset
- _TilingLayer_G_PorosityFactor @Drawer(PorosityFactor)
### Tiling Setting
- _TilingLayer_G_Tiling
- _TilingLayer_G_Use2U @Drawer(Toggle)
- _TilingLayer_G_HexTiling @Drawer(Toggle)
- _TilingLayer_G_MatchScaling @Drawer(Toggle)
### Mask Setting
- _TilingLayer_G_MaskContrast
- _TilingLayer_G_MaskIntensity
### Blend Setting
- _TilingLayer_G_BlendMode @Drawer(Enum, Height Max, Height Min)
- _TilingLayer_G_BlendRadius

# Additional Layer (B) @Hide(_UseAdditionalLayer == 0)
- _AdditionalLayer_BaseColor
- _AdditionalLayer_NormalScale
- _AdditionalLayer_AmbientOcclusion
- _AdditionalLayer_Height
- _AdditionalLayer_Roughness
- _AdditionalLayer_Reflectance
### Mask Setting
- _AdditionalLayer_MaskContrast
- _AdditionalLayer_MaskIntensity
### Blend Setting
- _AdditionalLayer_UseHeightLerp @Drawer(Toggle)
- _AdditionalLayer_BlendMode @Drawer(Enum, Height Max, Height Min) @Hide(_AdditionalLayer_UseHeightLerp == 0)
- _AdditionalLayer_BlendRadius @Hide(_AdditionalLayer_UseHeightLerp == 0)

# Detail Layer @Hide(_CustomOption2 == 0)
- _Detail_BaseMap @TryInline(0)
- _Detail_NormalMap @TryInline(1)
- _Detail_NormalScale
- _Detail_MaskMap @TryInline(0)
- _Detail_AmbientOcclusion
- _Detail_AlbedoGrayValue
### Tiling Setting
- _Detail_Tiling
- _Detail_MatchScaling @Drawer(Toggle)

# Topping Layer @Hide(_CustomEnum < 3)
- _ToppingLayer_BaseMap @TryInline(1)
- _ToppingLayer_BaseColor
- _ToppingLayer_NormalMap @TryInline(1)
- _ToppingLayer_NormalScale
- _ToppingLayer_MaskMap @TryInline(0)
- _ToppingLayer_Reflectance
- _ToppingLayer_HeightOffset @Hide(_ToppingLayer_UseHeightLerp == 0)
- _ToppingLayer_PorosityFactor @Drawer(PorosityFactor)
### Topping Setting
- _ToppingLayer_NormalIntensity @Hide(_CustomOption1 == 0)
- _ToppingLayer_Coverage
- _ToppingLayer_Spread
### Tiling Setting
- _ToppingLayer_Tiling
- _ToppingLayer_Use2U @Drawer(Toggle)
- _ToppingLayer_HexTiling @Drawer(Toggle)
- _ToppingLayer_MatchScaling @Drawer(Toggle)
### Blend Setting
- _ToppingLayer_UseHeightLerp @Drawer(Toggle)
- _ToppingLayer_BlendMode @Drawer(Enum, Height Max, Height Min) @Hide(_ToppingLayer_UseHeightLerp == 0)
- _ToppingLayer_BlendRadius @Hide(_ToppingLayer_UseHeightLerp == 0)

#endstylesheet


#properties
[NoScaleOffset] _BlendMask ("Blend Mask", 2D) = "black" {}
_UseAdditionalLayer ("Use Additional Layer", Int) = 0
// Base Layer
_BaseLayer_BaseMap ("Base Map", 2D) = "linearGrey" {}
[Normal] _BaseLayer_NormalMap ("Normal Map", 2D) = "bump" {}
_BaseLayer_NormalScale ("Normal Scale", Range(0, 2)) = 1
_BaseLayer_MaskMap ("Mask Map (MOHR)", 2D) = "linearGrey" {}
// Tiling Layer
_TilingLayer_BaseMap ("Base Map", 2D) = "white" {}
_TilingLayer_BaseColor ("Base Color", Color) = (1, 1, 1, 1)
[Normal] _TilingLayer_NormalMap ("Normal Map", 2D) = "bump" {}
_TilingLayer_NormalScale ("Normal Scale", Range(0, 2)) = 1
_TilingLayer_MaskMap ("Mask Map (MOHR)", 2D) = "linearGrey" {}
_TilingLayer_Reflectance ("Reflectance", Range(0, 1)) = 0.5
_TilingLayer_HeightOffset ("Height Offset", Range(-1, 1)) = 0
_TilingLayer_PorosityFactor ("Porosity Factor", Vector) = (0, 0, 0, 1)
_TilingLayer_Tiling ("Tiling", Float) = 1
_TilingLayer_Use2U ("Use 2U", Int) = 1
_TilingLayer_HexTiling ("Hex Tiling", Int) = 0
_TilingLayer_MatchScaling ("Match Scaling", Int) = 0
// Tiling Layer R
_TilingLayer_R_BaseMap ("Base Map", 2D) = "white" {}
_TilingLayer_R_BaseColor ("Base Color", Color) = (1, 1, 1, 1)
[Normal] _TilingLayer_R_NormalMap ("Normal Map", 2D) = "bump" {}
_TilingLayer_R_NormalScale ("Normal Scale", Range(0, 2)) = 1
_TilingLayer_R_MaskMap ("Mask Map (MOHR)", 2D) = "linearGrey" {}
_TilingLayer_R_Reflectance ("Reflectance", Range(0, 1)) = 0.5
_TilingLayer_R_HeightOffset ("Height Offset", Range(-1, 1)) = 0
_TilingLayer_R_PorosityFactor ("Porosity Factor", Vector) = (0, 0, 0, 1)
_TilingLayer_R_Tiling ("Tiling", Float) = 1
_TilingLayer_R_Use2U ("Use 2U", Int) = 1
_TilingLayer_R_HexTiling ("Hex Tiling", Int) = 0
_TilingLayer_R_MatchScaling ("Match Scaling", Int) = 0
_TilingLayer_R_BlendMode ("Blend Mode", Float) = 1
_TilingLayer_R_BlendRadius ("Blend Radius", Range(0.001, 0.5)) = 0.1
_TilingLayer_R_MaskContrast ("Mask Contrast R", Float) = 1
_TilingLayer_R_MaskIntensity ("Mask Intensity R", Float) = 1
// Tiling Layer G
_TilingLayer_G_BaseMap ("Base Map", 2D) = "white" {}
_TilingLayer_G_BaseColor ("Base Color", Color) = (1, 1, 1, 1)
[Normal] _TilingLayer_G_NormalMap ("Normal Map", 2D) = "bump" {}
_TilingLayer_G_NormalScale ("Normal Scale", Range(0, 2)) = 1
_TilingLayer_G_MaskMap ("Mask Map (MOHR)", 2D) = "linearGrey" {}
_TilingLayer_G_Reflectance ("Reflectance", Range(0, 1)) = 0.5
_TilingLayer_G_HeightOffset ("Height Offset", Range(-1, 1)) = 0
_TilingLayer_G_PorosityFactor ("Porosity Factor", Vector) = (0, 0, 0, 1)
_TilingLayer_G_Tiling ("Tiling", Float) = 1
_TilingLayer_G_Use2U ("Use 2U", Int) = 1
_TilingLayer_G_HexTiling ("Hex Tiling", Int) = 0
_TilingLayer_G_MatchScaling ("Match Scaling", Int) = 0
_TilingLayer_G_BlendMode ("Blend Mode", Float) = 1
_TilingLayer_G_BlendRadius ("Blend Radius", Range(0.001, 0.5)) = 0.1
_TilingLayer_G_MaskContrast ("Mask Contrast R", Float) = 1
_TilingLayer_G_MaskIntensity ("Mask Intensity R", Float) = 1
// Additional Layer B
[HDR] _AdditionalLayer_BaseColor ("Base Color", Color) = (1, 1, 1, 1)
_AdditionalLayer_NormalScale ("Normal Scale", Range(0, 1)) = 0.5
_AdditionalLayer_Height ("Height", Range(0, 1)) = 0.5
_AdditionalLayer_Roughness ("Roughness", Range(0, 1)) = 0.5
_AdditionalLayer_Reflectance ("Reflectance", Range(0, 1)) = 0.5
_AdditionalLayer_UseHeightLerp ("Use Height Lerp", Int) = 0
_AdditionalLayer_BlendMode ("Blend Mode", Float) = 1
_AdditionalLayer_BlendRadius ("Blend Radius", Range(0.001, 0.5)) = 0.1
_AdditionalLayer_MaskContrast ("Mask Contrast R", Float) = 1
_AdditionalLayer_MaskIntensity ("Mask Intensity R", Float) = 1
// Detail Layer
_Detail_BaseMap ("Base Map", 2D) = "white" {}
[Normal] _Detail_NormalMap ("Normal Map", 2D) = "bump" {}
_Detail_NormalScale ("Normal Scale", Range(0, 2)) = 1
_Detail_MaskMap ("Mask Map (MOHR)", 2D) = "linearGrey" {}
_Detail_AmbientOcclusion ("AmbientOcclusion", Range(0, 1)) = 1
_Detail_AlbedoGrayValue ("Albedo GrayValue", Range(0, 1)) = 1
_Detail_Tiling ("Tiling", Float) = 1
_Detail_MatchScaling ("Match Scaling", Int) = 0
// Topping Layer
_ToppingLayer_BaseMap ("Base Map", 2D) = "white" {}
_ToppingLayer_BaseColor ("Base Color", Color) = (1, 1, 1, 1)
[Normal] _ToppingLayer_NormalMap ("Normal Map", 2D) = "bump" {}
_ToppingLayer_NormalScale ("Normal Scale", Range(0, 2)) = 1
_ToppingLayer_MaskMap ("Mask Map (MOHR)", 2D) = "linearGrey" {}
_ToppingLayer_Reflectance ("Reflectance", Range(0, 1)) = 0.5
_ToppingLayer_HeightOffset ("Height Offset", Range(-1, 1)) = 0
_ToppingLayer_PorosityFactor ("Porosity Factor", Vector) = (0, 0, 0, 1)
_ToppingLayer_NormalIntensity ("Normal Intensity", Range(0, 1)) = 0.5
_ToppingLayer_Coverage ("Coverage", Range(0, 1)) = 0.5
_ToppingLayer_Spread ("Spread", Range(0, 1)) = 0.5
_ToppingLayer_Tiling ("Tiling", Float) = 1
_ToppingLayer_Use2U ("Use 2U", Int) = 1
_ToppingLayer_HexTiling ("Hex Tiling", Int) = 0
_ToppingLayer_MatchScaling ("Match Scaling", Int) = 0
_ToppingLayer_UseHeightLerp ("Use Height Lerp", Int) = 1
_ToppingLayer_BlendMode ("Blend Mode", Float) = 1
_ToppingLayer_BlendRadius ("Blend Radius", Range(0.001, 0.5)) = 0.1

#endproperties

// #materialoption.TangentSpaceNormalMap = Enable
#materialoption.AmbientOcclusion = Enable
#materialoption.Reflectance = Enable
#materialoption.Detail = Enable
#materialoption.UseSlab = Enable
#materialoption.UseUV1 = Enable
#materialoption.PostProcessMaterialInput  = Enable
#materialoption.Emissive = Disable
#materialoption.Height = Enable
#materialoption.CustomNormal = Enable
// #materialoption.Deferred = OptionEnable

#materialoption.CustomEnum.LayerCount = (Tiling, TilingR, TilingRG, Tiling_WithTopping, TilingR_WithTopping)
#materialoption.CustomOption0.UseVertexColor = OptionEnable
#materialoption.CustomOption1.UseBaseLayer = OptionEnable
#materialoption.CustomOption2.UseDetailLayer = OptionDisable


#else
#include "./MM_EV_LayeredRock.Header.hlsl"
#endif

#include "Packages/com.funplus.xrender/Shaders/Library/Common.hlsl"
#include "Packages/com.funplus.xrender/Shaders/Library/CommonHeader.hlsl"
#include "Packages/com.funplus.xrender/Shaders/Library/CommonSampler.hlsl"
#include "Packages/com.funplus.xrender/Shaders/Library/CommonMaterial.hlsl"
#include "Assets/Res/Shader/Includes/LayeredSurface.hlsl"

void PrepareMaterialInput_New(FPixelInput PixelIn, FSurfacePositionData PosData, inout MInputType MInput)
{
	// Prepare UV
	float2 MaskCoordinate = PixelIn.UV0;
	// Scale
	float LocalScaleX = length(float3(GetObjectToWorldMatrix()[0].x, GetObjectToWorldMatrix()[1].x, GetObjectToWorldMatrix()[2].x));
	// Mask For Bend
	float4 BlendMask = 0;
#if defined(MATERIAL_USE_USEVERTEXCOLOR)
	BlendMask = PixelIn.VertexColor;
#else
	BlendMask = SAMPLE_TEXTURE2D(_BlendMask, SamplerTriLinearRepeat, MaskCoordinate);
#endif
	
	// Setup MInput
	SetupMInput(MInput);
	// Tiling Layer
	float2 TilingLayer_Coordinate = lerp(PixelIn.UV0, PixelIn.UV1, _TilingLayer_Use2U) * _TilingLayer_Tiling * lerp(1, LocalScaleX, _TilingLayer_MatchScaling);
	MaterialLayer MLayer;
	SetupMaterialLayer(	_TilingLayer_BaseMap,
						_TilingLayer_BaseColor,
						_TilingLayer_NormalMap,
						_TilingLayer_NormalScale,
						_TilingLayer_MaskMap,
						_TilingLayer_Reflectance,
						_TilingLayer_HeightOffset,
						MLayer
						);
	if(_TilingLayer_HexTiling > FLT_EPS)
	{
		InitializeTilingLayer_Hex(MLayer, TilingLayer_Coordinate, MInput);
	}
	else
	{
		InitializeTilingLayer(MLayer, TilingLayer_Coordinate, MInput);
	}
	// Tiling Layer R
#if defined(MATERIAL_ENUM_LAYERCOUNT_TILINGR) | defined(MATERIAL_ENUM_LAYERCOUNT_TILINGRG) | defined(MATERIAL_ENUM_LAYERCOUNT_TILINGR_WITHTOPPING)
	BlendMask.r = saturate(pow(BlendMask.r, _TilingLayer_R_MaskContrast) * _TilingLayer_R_MaskIntensity);
	float2 TilingLayer_R_Coordinate = lerp(PixelIn.UV0, PixelIn.UV1, _TilingLayer_R_Use2U) * _TilingLayer_R_Tiling * lerp(1, LocalScaleX, _TilingLayer_R_MatchScaling);
	MaterialLayer MLayer_R;
	SetupMaterialLayer(	_TilingLayer_R_BaseMap,
						_TilingLayer_R_BaseColor,
						_TilingLayer_R_NormalMap,
						_TilingLayer_R_NormalScale,
						_TilingLayer_R_MaskMap,
						_TilingLayer_R_Reflectance,
						_TilingLayer_R_HeightOffset,
						MLayer_R
						);
	if(_TilingLayer_R_HexTiling > FLT_EPS)
	{
		BlendWithHeight_Hex(MLayer_R, TilingLayer_R_Coordinate, BlendMask.r, _TilingLayer_R_BlendRadius, _TilingLayer_R_BlendMode, MInput);
	}
	else
	{
		BlendWithHeight(MLayer_R, TilingLayer_R_Coordinate, BlendMask.r, _TilingLayer_R_BlendRadius, _TilingLayer_R_BlendMode, MInput);
	}
#endif
	// Tiling Layer G
#if defined(MATERIAL_ENUM_LAYERCOUNT_TILINGRG)
	BlendMask.g = saturate(pow(BlendMask.g, _TilingLayer_G_MaskContrast) * _TilingLayer_G_MaskIntensity);
	float2 TilingLayer_G_Coordinate = lerp(PixelIn.UV0, PixelIn.UV1, _TilingLayer_G_Use2U) * _TilingLayer_G_Tiling * lerp(1, LocalScaleX, _TilingLayer_G_MatchScaling);
	MaterialLayer MLayer_G;
	SetupMaterialLayer(	_TilingLayer_G_BaseMap,
						_TilingLayer_G_BaseColor,
						_TilingLayer_G_NormalMap,
						_TilingLayer_G_NormalScale,
						_TilingLayer_G_MaskMap,
						_TilingLayer_G_Reflectance,
						_TilingLayer_G_HeightOffset,
						MLayer_G
						);
	if(_TilingLayer_G_HexTiling > FLT_EPS)
	{
		BlendWithHeight_Hex(MLayer_G, TilingLayer_G_Coordinate, BlendMask.g, _TilingLayer_G_BlendRadius, _TilingLayer_G_BlendMode, MInput);
	}
	else
	{
		BlendWithHeight(MLayer_G, TilingLayer_G_Coordinate, BlendMask.g, _TilingLayer_G_BlendRadius, _TilingLayer_G_BlendMode, MInput);
	}
#endif
	// Additional Layer B
	BRANCH
	if(_UseAdditionalLayer > FLT_EPS)
	{
		BlendMask.b = saturate(pow(BlendMask.b, _AdditionalLayer_MaskContrast) * _AdditionalLayer_MaskIntensity);
		SimpleMaterialLayer SMLayer_B;
		SetupSMaterialLayer(	_AdditionalLayer_BaseColor,
								_AdditionalLayer_NormalScale,
								float4(0, 1, _AdditionalLayer_Height * 2, _AdditionalLayer_Roughness),
								_AdditionalLayer_Reflectance,
								SMLayer_B
							);
		if(_AdditionalLayer_UseHeightLerp > FLT_EPS)
		{
			BlendWithHeightNoTexture(SMLayer_B, BlendMask.b, _AdditionalLayer_BlendRadius, _AdditionalLayer_BlendMode, MInput);
		}
		else
		{
			BlendWithOutHeightNoTexture(SMLayer_B, BlendMask.b, MInput);
		}
	}
	// Detail Layer
#if defined(MATERIAL_USE_USEDETAILLAYER)
	DetailLayer DLayer;
	float2 DetailCoordinate = PixelIn.UV1 * _Detail_Tiling * lerp(1, LocalScaleX, _Detail_MatchScaling);
	SetupDetailLayer( _Detail_BaseMap,
					  _Detail_NormalMap,
					  _Detail_NormalScale,
					  _Detail_MaskMap,
					  _Detail_AmbientOcclusion,
					  _Detail_AlbedoGrayValue,
					  DLayer
					);
	BlendDetailLayer(DLayer, DetailCoordinate, MInput);
#endif
	// Base Layer
#if defined(MATERIAL_USE_USEBASELAYER)
	float2 BaseCoordinate = PixelIn.UV0;
	float4 MaskMap = SAMPLE_TEXTURE2D(_BaseLayer_MaskMap, SamplerLinearRepeat, BaseCoordinate);
	float4 NormalMap = SAMPLE_TEXTURE2D(_BaseLayer_NormalMap, SamplerLinearRepeat, BaseCoordinate);
	float3 NormalTS = GetNormalTSFromNormalTex(NormalMap, _BaseLayer_NormalScale);
#endif
	// Topping Layer
#if defined(MATERIAL_ENUM_LAYERCOUNT_TILING_WITHTOPPING) || defined(MATERIAL_ENUM_LAYERCOUNT_TILINGR_WITHTOPPING)
	float2 ToppingCoordinates = lerp(PixelIn.UV0, PixelIn.UV1, _ToppingLayer_Use2U) * _ToppingLayer_Tiling * lerp(1, LocalScaleX, _ToppingLayer_MatchScaling);
	float3 NormalWS;
#if defined(MATERIAL_USE_USEBASELAYER)
	NormalWS = TransformVectorTSToVectorWS_RowMajor(NormalTS, PixelIn.TangentToWorldMatrix, true);
	NormalWS = lerp(PixelIn.GeometricNormalWS, NormalWS, _ToppingLayer_NormalIntensity);
#else
	NormalWS = PixelIn.GeometricNormalWS;
#endif
	
	float3 NDotUp = dot(NormalWS, normalize(float3(0, 1, 0)));
	float Coverage = NDotUp - lerp(1, -1, _ToppingLayer_Coverage);
	Coverage = saturate(Coverage / _ToppingLayer_Spread);
	MaterialLayer MLayer_Detail;
	SetupMaterialLayer(	_ToppingLayer_BaseMap,
						_ToppingLayer_BaseColor,
						_ToppingLayer_NormalMap,
						_ToppingLayer_NormalScale,
						_ToppingLayer_MaskMap,
						_ToppingLayer_Reflectance,
						_ToppingLayer_HeightOffset,
						MLayer_Detail
						);
	BRANCH
	if(_ToppingLayer_HexTiling > FLT_EPS)
	{
		BRANCH
		if(_ToppingLayer_UseHeightLerp > FLT_EPS)
		{
			BlendWithHeight_Hex(MLayer_Detail, ToppingCoordinates, Coverage, _ToppingLayer_BlendRadius, _ToppingLayer_BlendMode, MInput);
		}
		else
		{
			BlendWithOutHeight_Hex(MLayer_Detail, ToppingCoordinates, Coverage, MInput);
		}
	}
	else
	{
		BRANCH
		if(_ToppingLayer_UseHeightLerp > FLT_EPS)
		{
			BlendWithHeight(MLayer_Detail, ToppingCoordinates, Coverage, _ToppingLayer_BlendRadius, _ToppingLayer_BlendMode, MInput);
		}
		else
		{
			BlendWithOutHeight(MLayer_Detail, ToppingCoordinates, Coverage, MInput);
		}
	}
#endif
	
#if defined(MATERIAL_USE_USEBASELAYER)
	MInput.TangentSpaceNormal.NormalTS = BlendAngelCorrectedNormals(NormalTS, MInput.TangentSpaceNormal.NormalTS);
	MInput.AO.AmbientOcclusion *= GetMaterialAOFromMaskMap(MaskMap);
	// MInput.Base.Roughness *= GetPerceptualRoughnessFromMaskMap(MaskMap);
#endif
	// To World Normal
	MInput.Geometry.NormalWS = TransformVectorTSToVectorWS_RowMajor(MInput.TangentSpaceNormal.NormalTS, PixelIn.TangentToWorldMatrix);
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
