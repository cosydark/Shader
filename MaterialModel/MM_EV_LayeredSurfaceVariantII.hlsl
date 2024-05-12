#ifdef MM_HEADER
#attribute Material.Author = "QP4B"
#attribute Material.Name = "LayeredSurfaceVariantII"
#attribute Material.ShadingModel = "DefaultLit"

#stylesheet

# Base Layer @Hide(_CustomOption0 > 0)
- _LayoutNormal @TryInline(1)
- _LayoutNormalScale
- _BlendMask @TryInline(0)
- _UVIndex_Mask @Drawer(Enum, 0, 1)

# Tiling Layer
- _BaseMap_0 @TryInline(1)
- _BaseColor_0
- _NormalMap_0 @TryInline(1)
- _NormalScale
- _MaskMap_0 @TryInline(0)
- _Reflectance_0
- _HeightOffset_0
###
### Tiling Option
- _Tiling_0
- _MatchScaling_0 @Drawer(Toggle)
- _UVIndex_0 @Drawer(Enum, 0, 1)

# Tilling Layer (R) @Hide(_CustomOption1 == 0)
- _BaseMap_1 @TryInline(1)
- _BaseColor_1
- _NormalMap_1 @TryInline(1)
- _NormalScale_1
- _MaskMap_1 @TryInline(0)
- _Reflectance_1
- _HeightOffset_1
###
### Tiling Option
- _Tiling_1
- _MatchScaling_1 @Drawer(Toggle)
- _UVIndex_1 @Drawer(Enum, 0, 1)
###
### Mask Filter R
- _MaskContrast_R
- _MaskIntensity_R
###
### Blend Option
- _BlendMode_1  @Drawer(Enum, Lerp, Height Max, Height Min)
- _BlendRadius_1

# Tilling Layer (G) @Hide(_CustomOption2 == 0)
- _BaseMap_2 @TryInline(1)
- _BaseColor_2
- _NormalMap_2 @TryInline(1)
- _NormalScale_2
- _MaskMap_2 @TryInline(0)
- _Reflectance_2
- _HeightOffset_2
###
### Tiling Option
- _Tiling_2
- _MatchScaling_2 @Drawer(Toggle)
- _UVIndex_2 @Drawer(Enum, 0, 1)
###
### Mask Filter G
- _MaskContrast_G
- _MaskIntensity_G
###
### Blend Option
- _BlendMode_2  @Drawer(Enum, Lerp, Height Max, Height Min)
- _BlendRadius_2

# Detail (A) @Hide(_CustomOption3 == 0)
- _DetailMap @TryInline(1)
- _DetailIntensity
- _DetailNormalScale
###
### Tiling Option
- _Tiling_Detail
- _MatchScaling_Detail @Drawer(Toggle)
- _UVIndex_Detail @Drawer(Enum, 0, 1)
- _HexTilingInfo
###
### Mask Filter
- _MaskContrast_Detail
- _MaskIntensity_Detail


#endstylesheet


#properties
// Mask
_BlendMask ("BlendMask", 2D) = "black" {}
_LayoutNormal ("Expanded Normal", 2D) = "bump" {}
_LayoutNormalScale ("Layout Normal Scale", Range(0, 2)) = 1
_UVIndex_Mask ("UV Index", Int) = 0

// Tiling Layer
_BaseMap_0 ("Base Map", 2D) = "white" {}
_BaseColor_0 ("Base Color", Color) = (1, 1, 1, 1)
[Normal] _NormalMap_0 ("Normal Map", 2D) = "bump" {}
_NormalScale ("Normal Scale", Range(0, 2)) = 1
_MaskMap_0 ("Mask Map (MOHR)", 2D) = "white" {}
_Reflectance_0 ("Reflectance", Range(0, 1)) = 0.5
_HeightOffset_0 ("Height Offset", Range(-1, 1)) = 0
_Tiling_0 ("Tiling", Float) = 1
_MatchScaling_0 ("Match Scaling", Int) = 0
_UVIndex_0 ("UV Index", Int) = 0
// Tiling Layer R
_BaseMap_1 ("BaseMap", 2D) = "white" {}
_BaseColor_1 ("Base Color", Color) = (1, 1, 1, 1)
_NormalMap_1 ("NormalMap", 2D) = "bump" {}
_NormalScale_1 ("Normal Scale", Range(0, 2)) = 1
_MaskMap_1 ("MaskMap", 2D) = "black" {}
_Reflectance_1 ("Reflectance", Range(0, 1)) = 0.5
_HeightOffset_1 ("Height Offset", Range(-1, 1)) = 0
_Tiling_1 ("Tiling", Float) = 1
_MatchScaling_1 ("Match Scaling", Int) = 0
_UVIndex_1 ("UV Index", Int) = 0
_BlendMode_1 ("Blend Mode", Float) = 1
_BlendRadius_1 ("Blend Radius", Range(0.01, 0.5)) = 0.1
_MaskContrast_R ("Mask Contrast R", Float) = 1
_MaskIntensity_R ("Mask Intensity R", Float) = 1
// Tiling Layer G
_BaseMap_2 ("BaseMap", 2D) = "white" {}
_BaseColor_2 ("Base Color", Color) = (1, 1, 1, 1)
_NormalMap_2 ("NormalMap", 2D) = "bump" {}
_NormalScale_2 ("Normal Scale", Range(0, 2)) = 1
_MaskMap_2 ("MaskMap", 2D) = "black" {}
_Reflectance_2 ("Reflectance", Range(0, 1)) = 0.5
_HeightOffset_2 ("Height Offset", Range(-1, 1)) = 0
_Tiling_2 ("Tiling", Float) = 1
_MatchScaling_2 ("Match Scaling", Int) = 0
_UVIndex_2 ("UV Index", Int) = 0
_BlendMode_2 ("Blend Mode", Float) = 1
_BlendRadius_2 ("Blend Radius", Range(0.01, 0.5)) = 0.1
_MaskContrast_G ("Mask Contrast R", Float) = 1
_MaskIntensity_G ("Mask Intensity R", Float) = 1
// Detail
_DetailIntensity ("Detail Intensity", Range(0, 1)) = 1
_DetailMap ("Detail Map", 2D) = "bump" {}
_DetailNormalScale ("Detail Normal Scale", Range(0, 2)) = 1
_Tiling_Detail ("Tiling Detail", Float) = 1
_MatchScaling_Detail ("Match Scaling Detail", Int) = 0
_UVIndex_Detail ("UV Index", Int) = 0
_MaskContrast_Detail ("Mask Contrast R", Float) = 1
_MaskIntensity_Detail ("Mask Intensity R", Float) = 1
_HexTilingInfo ("Hex Tiling Info", Vector) = (-0.5, 0.456, 10, 0.2)

#endproperties

#materialoption.TangentSpaceNormalMap = Enable
#materialoption.AmbientOcclusion = Enable
#materialoption.Reflectance = Enable
#materialoption.Detail = Enable
#materialoption.UseSlab = Enable
#materialoption.UseUV1 = Enable
#materialoption.PostProcessMaterialInput  = Enable
#materialoption.Emissive = Disable
#materialoption.Deferred = Enable

#materialoption.CustomOption0.UseVertexColor = OptionEnable
#materialoption.CustomOption1.TilingLayerR = OptionDisable
#materialoption.CustomOption2.TilingLayerG = OptionDisable
#materialoption.CustomOption3.DetailLayer = OptionDisable

#else
#include "./MM_EV_LayeredSurfaceVariantII.Header.hlsl"
#endif

#include "Packages/com.funplus.xrender/Shaders/Library/Common.hlsl"
#include "Packages/com.funplus.xrender/Shaders/Library/CommonHeader.hlsl"
#include "Packages/com.funplus.xrender/Shaders/Library/CommonSampler.hlsl"
#include "Packages/com.funplus.xrender/Shaders/Library/CommonMaterial.hlsl"
#include "Packages/com.funplus.xrender/Shaders/Library/CommonAntiTilling.hlsl"
#include "Assets/Res/Shader/Includes/LayeredSurface.hlsl"

void PrepareMaterialInput_New(FPixelInput PixelIn, FSurfacePositionData PosData, inout MInputType MInput)
{
	// Prepare Base UV
	float2 MaskCoordinate = PrepareTextureCoordinates(_UVIndex_Mask, PixelIn);
	float2 TilingLayer_0_Coordinate = PrepareTextureCoordinates(_UVIndex_0, PixelIn);
	float2 TilingLayer_1_Coordinate = PrepareTextureCoordinates(_UVIndex_1, PixelIn);
	float2 TilingLayer_2_Coordinate = PrepareTextureCoordinates(_UVIndex_2, PixelIn);
	float2 DetailCoordinate = PrepareTextureCoordinates(_UVIndex_Detail, PixelIn);
	// Scale1
	float LocalScaleX = length(float3(GetObjectToWorldMatrix()[0].x, GetObjectToWorldMatrix()[1].x, GetObjectToWorldMatrix()[2].x));
	// Sample Mask For Bend
	float4 BlendMask = 0;
	// Mask
	#if defined(MATERIAL_USE_USEVERTEXCOLOR)
	BlendMask = PixelIn.VertexColor;
	#else
	BlendMask = SAMPLE_TEXTURE2D(_BlendMask, SamplerTriLinearRepeat, MaskCoordinate);
	#endif
	// Modify Mask
	BlendMask.r = saturate(pow(BlendMask.r, _MaskContrast_R) * _MaskIntensity_R);
	BlendMask.a = saturate(pow(BlendMask.a, _MaskContrast_Detail) * _MaskIntensity_Detail);
	// Setup Values
	float3 Color = float3(0, 0, 0);
	float3 NormalTS = float3(0, 0, 1);
	float3 TilingNormalTS = float3(0, 0, 1);
	float4 Mask = float4(0, 1, 0.5, 0.4);
	float Reflectance = 0.5;
	// Base Layer
	NormalTS = GetNormalTSFromNormalTex(SAMPLE_TEXTURE2D(_LayoutNormal, SamplerLinearRepeat, MaskCoordinate), _LayoutNormalScale);
	// Base Layer
	TilingLayer_0_Coordinate = TilingLayer_0_Coordinate * _Tiling_0 * (_MatchScaling_0 > FLT_EPS ? LocalScaleX : 1);
	SetupTilingLayer(	_BaseMap_0,
						_BaseColor_0.rgb,
						_NormalMap_0,
						_NormalScale,
						_MaskMap_0,
						_Reflectance_0,
						_HeightOffset_0,
						TilingLayer_0_Coordinate,
						Color,
						TilingNormalTS,
						Mask.r,
						Mask.g,
						Mask.b,
						Mask.a,
						Reflectance
					);
	
#if defined(MATERIAL_USE_TILINGLAYERR)
	BlendWithHeight(	_BaseMap_1,
						_BaseColor_1,
						_NormalMap_1,
						_NormalScale_1,
						_MaskMap_1,
						_Reflectance_1,
						TilingLayer_1_Coordinate * _Tiling_1 * (_MatchScaling_1 > FLT_EPS ? LocalScaleX : 1),
						BlendMask.r,
						_BlendRadius_1,
						_HeightOffset_1,
						_BlendMode_1,
						Color.rgb,
						TilingNormalTS,
						Mask.r,
						Mask.g,
						Mask.b,
						Mask.a,
						Reflectance
					);
#endif
#if defined(MATERIAL_USE_TILINGLAYERG)
	BlendWithHeight(	_BaseMap_2,
						_BaseColor_2,
						_NormalMap_2,
						_NormalScale_2,
						_MaskMap_2,
						_Reflectance_2,
						TilingLayer_2_Coordinate * _Tiling_2 * (_MatchScaling_2 > FLT_EPS ? LocalScaleX : 1),
						BlendMask.g,
						_BlendRadius_2,
						_HeightOffset_2,
						_BlendMode_2,
						Color.rgb,
						TilingNormalTS,
						Mask.r,
						Mask.g,
						Mask.b,
						Mask.a,
						Reflectance
					);
#endif
#if defined(MATERIAL_USE_DETAILLAYER)
	DetailCoordinate = DetailCoordinate * _Tiling_Detail * (_MatchScaling_Detail > FLT_EPS ? LocalScaleX : 1);
	ApplyDetailMapHex(		_DetailMap,
						DetailCoordinate,
						_DetailIntensity * BlendMask.a,
						Color.rgb,
						TilingNormalTS,
						Mask.g,
						_HexTilingInfo
					);
#endif
	
	MInput.Base.Color = Color;
	MInput.Base.Opacity = 1;
	MInput.Base.Metallic = GetMaterialMetallicFromMaskMap(Mask);
	MInput.AO.AmbientOcclusion = GetMaterialAOFromMaskMap(Mask);
	MInput.Detail.Height = GetHeightFromMaskMap(Mask);
	MInput.Base.Roughness = GetPerceptualRoughnessFromMaskMap(Mask);
	MInput.Specular.Reflectance = Reflectance;
	MInput.TangentSpaceNormal.NormalTS = BlendAngelCorrectedNormals(NormalTS, TilingNormalTS);
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
