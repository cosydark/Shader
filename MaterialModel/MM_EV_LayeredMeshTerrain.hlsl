#ifdef MM_HEADER
#attribute Material.Author = "QP4B"
#attribute Material.Name = "EV_LayeredMeshTerrain"
#attribute Material.ShadingModel = "DefaultLit"

#stylesheet

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
- _TilingLayer_HexTiling @Drawer(Toggle)
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
- _TilingLayer_R_HexTiling @Drawer(Toggle)
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
- _TilingLayer_G_HexTiling @Drawer(Toggle)
### Blend Setting
- _TilingLayer_G_BlendMode @Drawer(Enum, Height Max, Height Min)
- _TilingLayer_G_BlendHeightScale
- _TilingLayer_G_BlendHeightShift
- _TilingLayer_G_BlendRadius

# Tiling Layer (B) @Hide(_CustomEnum < 3)
- _TilingLayer_B_BaseMap @TryInline(1)
- _TilingLayer_B_BaseColor
- _TilingLayer_B_NormalMap @TryInline(1)
- _TilingLayer_B_NormalScale
- _TilingLayer_B_MaskMap @TryInline(0)
- _TilingLayer_B_Reflectance
- _TilingLayer_B_HeightScale
- _TilingLayer_B_HeightOffset
- _TilingLayer_B_PorosityFactor @Drawer(PorosityFactor)
### Tiling Setting
- _TilingLayer_B_Tiling
- _TilingLayer_B_HexTiling @Drawer(Toggle)
### Blend Setting
- _TilingLayer_B_BlendMode @Drawer(Enum, Height Max, Height Min)
- _TilingLayer_B_BlendHeightScale
- _TilingLayer_B_BlendHeightShift
- _TilingLayer_B_BlendRadius

#endstylesheet


#properties
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
_TilingLayer_HexTiling ("Hex Tiling", Int) = 0
_TilingLayer_BlendHeightScale ("Blend Height Scale", Range(0, 1)) = 0.25
_TilingLayer_BlendHeightShift ("Blend Height Shift", Range(-0.5, 0.5)) = -0.375
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
_TilingLayer_R_HexTiling ("Hex Tiling", Int) = 0
_TilingLayer_R_BlendMode ("Blend Mode", Float) = 0
_TilingLayer_R_BlendRadius ("Blend Radius", Range(0.001, 0.5)) = 0.1
_TilingLayer_R_BlendHeightScale ("Blend Height Scale", Range(0, 1)) = 0.25
_TilingLayer_R_BlendHeightShift ("Blend Height Shift", Range(-0.5, 0.5)) = -0.125
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
_TilingLayer_G_HexTiling ("Hex Tiling", Int) = 0
_TilingLayer_G_BlendMode ("Blend Mode", Float) = 0
_TilingLayer_G_BlendRadius ("Blend Radius", Range(0.001, 0.5)) = 0.1
_TilingLayer_G_BlendHeightScale ("Blend Height Scale", Range(0, 1)) = 0.25
_TilingLayer_G_BlendHeightShift ("Blend Height Shift", Range(-0.5, 0.5)) = 0.125
// Tiling Layer B
_TilingLayer_B_BaseMap ("Base Map", 2D) = "white" {}
_TilingLayer_B_BaseColor ("Base Color", Color) = (1, 1, 1, 1)
[Normal] _TilingLayer_B_NormalMap ("Normal Map", 2D) = "bump" {}
_TilingLayer_B_NormalScale ("Normal Scale", Range(0, 2)) = 1
_TilingLayer_B_MaskMap ("Mask Map (MOHR)", 2D) = "linearGrey" {}
_TilingLayer_B_Reflectance ("Reflectance", Range(0, 1)) = 0.5
_TilingLayer_B_HeightScale ("Height Scale", Range(0, 1)) = 1
_TilingLayer_B_HeightOffset ("Height Offset", Range(-1, 1)) = 0
_TilingLayer_B_PorosityFactor ("Porosity Factor", Vector) = (0, 0, 0, 1)
_TilingLayer_B_Tiling ("Tiling", Float) = 1
_TilingLayer_B_HexTiling ("Hex Tiling", Int) = 0
_TilingLayer_B_BlendMode ("Blend Mode", Float) = 0
_TilingLayer_B_BlendRadius ("Blend Radius", Range(0.001, 0.5)) = 0.1
_TilingLayer_B_BlendHeightScale ("Blend Height Scale", Range(0, 1)) = 0.25
_TilingLayer_B_BlendHeightShift ("Blend Height Shift", Range(-0.5, 0.5)) = 0.375

#endproperties

#materialoption.TangentSpaceNormalMap = Enable
#materialoption.AmbientOcclusion = Enable
#materialoption.Reflectance = Enable
#materialoption.Detail = Enable
#materialoption.UseSlab = Enable
#materialoption.UseUV1 = Enable
#materialoption.Emissive = Disable

#materialoption.CustomEnum.LayerCount = (Tiling, TilingR, TilingRG, TilingRGB)

#else
#include "./MM_EV_LayeredMeshTerrain.Header.hlsl"
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
	// Mask For Bend
	float4 BlendMask = PixelIn.VertexColor;
	
	// Setup MInput
	SetupMInput(MInput);
	// Tiling Layer
	float2 TilingLayer_Coordinate = PixelIn.UV0 * _TilingLayer_Tiling;
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
#if defined(MATERIAL_ENUM_LAYERCOUNT_TILINGR) | defined(MATERIAL_ENUM_LAYERCOUNT_TILINGRG) | defined(MATERIAL_ENUM_LAYERCOUNT_TILINGRGB)
	float2 TilingLayer_R_Coordinate = PixelIn.UV0 * _TilingLayer_R_Tiling;
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
#if defined(MATERIAL_ENUM_LAYERCOUNT_TILINGRG) | defined(MATERIAL_ENUM_LAYERCOUNT_TILINGRGB)
	float2 TilingLayer_G_Coordinate = PixelIn.UV0 * _TilingLayer_G_Tiling;
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

	// Tiling Layer B
#if defined(MATERIAL_ENUM_LAYERCOUNT_TILINGRGB)
	float2 TilingLayer_B_Coordinate = PixelIn.UV0 * _TilingLayer_B_Tiling;
	MaterialLayer MLayer_B;
	SetupMaterialLayer(	_TilingLayer_B_BaseMap,
						_TilingLayer_B_BaseColor,
						_TilingLayer_B_NormalMap,
						_TilingLayer_B_NormalScale,
						_TilingLayer_B_MaskMap,
						_TilingLayer_B_Reflectance,
						float2(_TilingLayer_B_HeightScale, _TilingLayer_B_HeightOffset),
						float2(_TilingLayer_B_BlendHeightScale, _TilingLayer_B_BlendHeightShift),
						MLayer_B
						);
	if(_TilingLayer_B_HexTiling > FLT_EPS)
	{
		BlendWithHeight_Hex(MLayer_B, TilingLayer_B_Coordinate, BlendMask.b, _TilingLayer_B_BlendRadius, _TilingLayer_B_BlendMode, CMInput);
	}
	else
	{
		BlendWithHeight(MLayer_B, TilingLayer_B_Coordinate, BlendMask.b, _TilingLayer_B_BlendRadius, _TilingLayer_B_BlendMode, CMInput);
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
