#ifdef MM_HEADER
#attribute Material.Author = "QP4B"
#attribute Material.Name = "EV_LayeredArchitecture"
#attribute Material.ShadingModel = "DefaultLit"
#attribute Material.LODCrossFade = Enable

#stylesheet

# Material Setting (1U) @Hide(_CustomOption0 != 0)
- _BlendMask @TryInline(0)

# Base Layer @Hide(_CustomOption2 == 0)
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
- _TilingLayer_HeightScale
- _TilingLayer_HeightOffset
- _TilingLayer_PorosityFactor @Drawer(PorosityFactor)
### Tiling Setting
- _TilingLayer_Tiling
- _TilingLayer_Use2U @Drawer(Toggle)
- _TilingLayer_HexTiling @Drawer(Toggle)
- _TilingLayer_MatchScaling @Drawer(Toggle)
### Blend Setting
- _TilingLayer_BlendHeightScale
- _TilingLayer_BlendHeightShift

# Tiling Layer (R) @Hide(_CustomEnum < 1)
- _TilingLayer_R_BaseMap @TryInline(1)
- _TilingLayer_R_BaseColor
- _TilingLayer_R_NormalMap @TryInline(1)
- _TilingLayer_R_NormalScale
- _TilingLayer_R_MaskMap @TryInline(0)
- _TilingLayer_R_Reflectance
- _TilingLayer_R_HeightScale
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
- _TilingLayer_R_BlendHeightScale
- _TilingLayer_R_BlendHeightShift
- _TilingLayer_R_BlendRadius

# Tiling Layer (G) @Hide(_CustomEnum < 2)
- _TilingLayer_G_BaseMap @TryInline(1)
- _TilingLayer_G_BaseColor
- _TilingLayer_G_NormalMap @TryInline(1)
- _TilingLayer_G_NormalScale
- _TilingLayer_G_MaskMap @TryInline(0)
- _TilingLayer_G_Reflectance
- _TilingLayer_G_HeightScale
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
- _TilingLayer_G_BlendHeightScale
- _TilingLayer_G_BlendHeightShift
- _TilingLayer_G_BlendRadius
#endstylesheet


#properties
_BlendMask ("Blend Mask", 2D) = "black" {}
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
_TilingLayer_HeightScale ("Height Scale", Range(0, 1)) = 1
_TilingLayer_HeightOffset ("Height Offset", Range(-1, 1)) = 0
_TilingLayer_PorosityFactor ("Porosity Factor", Vector) = (0, 0, 0, 1)
_TilingLayer_Tiling ("Tiling", Float) = 1
_TilingLayer_Use2U ("Use 2U", Int) = 0
_TilingLayer_HexTiling ("Hex Tiling", Int) = 0
_TilingLayer_MatchScaling ("Match Scaling", Int) = 1
_TilingLayer_BlendHeightScale ("Blend Height Scale", Range(0, 1)) = 0.3333
_TilingLayer_BlendHeightShift ("Blend Height Shift", Range(-0.5, 0.5)) = -0.1666
// Tiling Layer R
_TilingLayer_R_BaseMap ("Base Map", 2D) = "white" {}
_TilingLayer_R_BaseColor ("Base Color", Color) = (1, 1, 1, 1)
[Normal] _TilingLayer_R_NormalMap ("Normal Map", 2D) = "bump" {}
_TilingLayer_R_NormalScale ("Normal Scale", Range(0, 2)) = 1
_TilingLayer_R_MaskMap ("Mask Map (MOHR)", 2D) = "linearGrey" {}
_TilingLayer_R_Reflectance ("Reflectance", Range(0, 1)) = 0.5
_TilingLayer_R_HeightScale ("Height Scale", Range(0, 1)) = 1
_TilingLayer_R_HeightOffset ("Height Offset", Range(-1, 1)) = 0
_TilingLayer_R_PorosityFactor ("Porosity Factor", Vector) = (0, 0, 0, 1)
_TilingLayer_R_Tiling ("Tiling", Float) = 1
_TilingLayer_R_Use2U ("Use 2U", Int) = 0
_TilingLayer_R_HexTiling ("Hex Tiling", Int) = 0
_TilingLayer_R_MatchScaling ("Match Scaling", Int) = 1
_TilingLayer_R_BlendMode ("Blend Mode", Float) = 0
_TilingLayer_R_BlendRadius ("Blend Radius", Range(0.001, 0.5)) = 0.1
_TilingLayer_R_MaskContrast ("Mask Contrast R", Float) = 1
_TilingLayer_R_MaskIntensity ("Mask Intensity R", Float) = 1
_TilingLayer_R_BlendHeightScale ("Blend Height Scale", Range(0, 1)) = 1
_TilingLayer_R_BlendHeightShift ("Blend Height Shift", Range(-0.5, 0.5)) = 0
// Tiling Layer G
_TilingLayer_G_BaseMap ("Base Map", 2D) = "white" {}
_TilingLayer_G_BaseColor ("Base Color", Color) = (1, 1, 1, 1)
[Normal] _TilingLayer_G_NormalMap ("Normal Map", 2D) = "bump" {}
_TilingLayer_G_NormalScale ("Normal Scale", Range(0, 2)) = 1
_TilingLayer_G_MaskMap ("Mask Map (MOHR)", 2D) = "linearGrey" {}
_TilingLayer_G_Reflectance ("Reflectance", Range(0, 1)) = 0.5
_TilingLayer_G_HeightScale ("Height Scale", Range(0, 1)) = 1
_TilingLayer_G_HeightOffset ("Height Offset", Range(-1, 1)) = 0
_TilingLayer_G_PorosityFactor ("Porosity Factor", Vector) = (0, 0, 0, 1)
_TilingLayer_G_Tiling ("Tiling", Float) = 1
_TilingLayer_G_Use2U ("Use 2U", Int) = 0
_TilingLayer_G_HexTiling ("Hex Tiling", Int) = 0
_TilingLayer_G_MatchScaling ("Match Scaling", Int) = 1
_TilingLayer_G_BlendMode ("Blend Mode", Float) = 0
_TilingLayer_G_BlendRadius ("Blend Radius", Range(0.001, 0.5)) = 0.1
_TilingLayer_G_MaskContrast ("Mask Contrast R", Float) = 1
_TilingLayer_G_MaskIntensity ("Mask Intensity R", Float) = 1
_TilingLayer_G_BlendHeightScale ("Blend Height Scale", Range(0, 1)) = 0.3333
_TilingLayer_G_BlendHeightShift ("Blend Height Shift", Range(-0.5, 0.5)) = 0.1666

#endproperties

// #materialoption.TangentSpaceNormalMap = Enable
#materialoption.AmbientOcclusion = Enable
#materialoption.Reflectance = Enable
#materialoption.Detail = Enable
#materialoption.UseSlab = Enable
#materialoption.UseUV1 = Enable
#materialoption.PostProcessMaterialInput  = Enable
#materialoption.Emissive = Disable
#materialoption.CustomNormal = Enable

#materialoption.CustomEnum.LayerCount = (Tiling, TilingR, TilingRG)
#materialoption.CustomOption0.UseVertexColor = OptionEnable
#materialoption.CustomOption2.UseBaseLayer = OptionEnable

#else
#include "./MM_EV_LayeredArchitecture.Header.hlsl"
#endif

#include "Packages/com.funplus.xrender/Shaders/Library/Common.hlsl"
#include "Packages/com.funplus.xrender/Shaders/Library/CommonHeader.hlsl"
#include "Packages/com.funplus.xrender/Shaders/Library/CommonSampler.hlsl"
#include "Packages/com.funplus.xrender/Shaders/Library/CommonMaterial.hlsl"
#include "Packages/com.funplus.xrender/Shaders/Library/CommonAntiTilling.hlsl"
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
	CustomMInput CMInput;
	MaterialLayer MLayer;
	SetupMaterialLayer(	_TilingLayer_BaseMap,
						_TilingLayer_BaseColor,
						_TilingLayer_NormalMap,
						_TilingLayer_NormalScale,
						_TilingLayer_MaskMap,
						_TilingLayer_Reflectance,
						float2(_TilingLayer_HeightScale, _TilingLayer_HeightOffset),
						float2(_TilingLayer_BlendHeightScale, _TilingLayer_BlendHeightShift),
						MLayer
						);
	if(_TilingLayer_HexTiling > FLT_EPS)
	{
		InitializeTilingLayer_Hex(MLayer, TilingLayer_Coordinate, CMInput);
	}
	else
	{
		InitializeTilingLayer(MLayer, TilingLayer_Coordinate, CMInput);
	}
	// Tiling Layer R
#if defined(MATERIAL_ENUM_LAYERCOUNT_TILINGR) | defined(MATERIAL_ENUM_LAYERCOUNT_TILINGRG)
	BlendMask.r = saturate(pow(BlendMask.r, _TilingLayer_R_MaskContrast) * _TilingLayer_R_MaskIntensity);
	float2 TilingLayer_R_Coordinate = lerp(PixelIn.UV0, PixelIn.UV1, _TilingLayer_R_Use2U) * _TilingLayer_R_Tiling * lerp(1, LocalScaleX, _TilingLayer_R_MatchScaling);
	MaterialLayer MLayer_R;
	SetupMaterialLayer(	_TilingLayer_R_BaseMap,
						_TilingLayer_R_BaseColor,
						_TilingLayer_R_NormalMap,
						_TilingLayer_R_NormalScale,
						_TilingLayer_R_MaskMap,
						_TilingLayer_R_Reflectance,
						float2(_TilingLayer_R_HeightScale, _TilingLayer_R_HeightOffset),
						float2(_TilingLayer_R_BlendHeightScale, _TilingLayer_R_BlendHeightShift),
						MLayer_R
						);
	if(_TilingLayer_R_HexTiling > FLT_EPS)
	{
		BlendWithHeight_Hex(MLayer_R, TilingLayer_R_Coordinate, BlendMask.r, _TilingLayer_R_BlendRadius, _TilingLayer_R_BlendMode, CMInput);
	}
	else
	{
		BlendWithHeight(MLayer_R, TilingLayer_R_Coordinate, BlendMask.r, _TilingLayer_R_BlendRadius, _TilingLayer_R_BlendMode, CMInput);
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
						float2(_TilingLayer_G_HeightScale, _TilingLayer_G_HeightOffset),
						float2(_TilingLayer_G_BlendHeightScale, _TilingLayer_G_BlendHeightShift),
						MLayer_G
						);
	if(_TilingLayer_G_HexTiling > FLT_EPS)
	{
		BlendWithHeight_Hex(MLayer_G, TilingLayer_G_Coordinate, BlendMask.g, _TilingLayer_G_BlendRadius, _TilingLayer_G_BlendMode, CMInput);
	}
	else
	{
		BlendWithHeight(MLayer_G, TilingLayer_G_Coordinate, BlendMask.g, _TilingLayer_G_BlendRadius, _TilingLayer_G_BlendMode, CMInput);
	}
#endif

	// CMInput -> MInput
	MInput.Base.Color = CMInput.Color;
	MInput.TangentSpaceNormal.NormalTS = CMInput.NormalTS;
	MInput.Specular.Reflectance = CMInput.Reflectance;
	MInput.Base.Metallic = CMInput.Metallic;
	MInput.AO.AmbientOcclusion = CMInput.AmbientOcclusion;
	MInput.Detail.Height = CMInput.MaterialHeight;
	MInput.Base.Roughness = CMInput.Roughness;
	// Base Layer
#if defined(MATERIAL_USE_USEBASELAYER)
	float2 BaseCoordinate = PixelIn.UV0;
	float4 MaskMap = SAMPLE_TEXTURE2D(_BaseLayer_MaskMap, SamplerLinearRepeat, BaseCoordinate);
	float4 NormalMap = SAMPLE_TEXTURE2D(_BaseLayer_NormalMap, SamplerLinearRepeat, BaseCoordinate);
	float3 NormalTS = GetNormalTSFromNormalTex(NormalMap, _BaseLayer_NormalScale);
	MInput.TangentSpaceNormal.NormalTS = BlendAngelCorrectedNormals(NormalTS, MInput.TangentSpaceNormal.NormalTS);
	MInput.AO.AmbientOcclusion *= GetMaterialAOFromMaskMap(MaskMap);
#else
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
