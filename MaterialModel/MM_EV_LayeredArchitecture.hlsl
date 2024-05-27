#ifdef MM_HEADER
#attribute Material.Author = "QP4B"
#attribute Material.Name = "EV_LayeredArchitecture"
#attribute Material.ShadingModel = "DefaultLit"

#stylesheet

# Material Setting (1U)
- _BlendMask @TryInline(0)
# Base Layer (1U)
- _BaseLayer_BaseMap @TryInline(0)
- _BaseLayer_NormalMap @TryInline(1)
- _BaseLayer_NormalScale
- _BaseLayer_MaskMap @TryInline(0)
# Tiling Layer (2U)
- _TilingLayer_BaseMap @TryInline(1)
- _TilingLayer_BaseColor
- _TilingLayer_NormalMap @TryInline(1)
- _TilingLayer_NormalScale
- _TilingLayer_MaskMap @TryInline(0)
- _TilingLayer_Reflectance
- _TilingLayer_HeightOffset
###
### Tiling Option
- _TilingLayer_Tiling
- _TilingLayer_MatchScaling @Drawer(Toggle)

#endstylesheet


#properties
_BlendMask ("Blend Mask", 2D) = "black" {}
// Base Layer
_BaseLayer_BaseMap ("Base Map", 2D) = "linearGrey" {}
_BaseLayer_NormalMap ("Normal Map", 2D) = "bump" {}
_BaseLayer_NormalScale ("Normal Scale", Range(0, 1)) = 1
_BaseLayer_MaskMap ("Mask Map (MOHR)", 2D) = "linearGrey" {}
// Tiling Layer
_TilingLayer_BaseMap ("Base Map", 2D) = "white" {}
_TilingLayer_BaseColor ("Base Color", Color) = (1, 1, 1, 1)
[Normal] _TilingLayer_NormalMap ("Normal Map", 2D) = "bump" {}
_TilingLayer_NormalScale ("Normal Scale", Range(0, 2)) = 1
_TilingLayer_MaskMap ("Mask Map (MOHR)", 2D) = "linearGrey" {}
_TilingLayer_Reflectance ("Reflectance", Range(0, 1)) = 0.5
_TilingLayer_HeightOffset ("Height Offset", Range(-1, 1)) = 0
_TilingLayer_Tiling ("Tiling", Float) = 1
_TilingLayer_MatchScaling ("Match Scaling", Int) = 0
#endproperties

#materialoption.TangentSpaceNormalMap = Enable
#materialoption.AmbientOcclusion = Enable
#materialoption.Reflectance = Enable
#materialoption.Detail = Enable
#materialoption.UseSlab = Enable
#materialoption.UseUV1 = Enable
#materialoption.PostProcessMaterialInput  = Enable
#materialoption.Emissive = Disable

#materialoption.CustomEnum.LayerCount = (1 Layer, 2 Layer, 3 Layer)
#materialoption.CustomOption0.UseVertexColor = OptionEnable

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
	MInput.PluginChannelData.Data0 = BlendMask;
	// Setup Values
	float3 Color = float3(0, 0, 0);
	float4 Mask = float4(0, 1, 0.5, 0.4);
	float Reflectance = 0.5;
	// Fill
	MInput.Base.Color = Color;
	MInput.Base.Opacity = 1;
	MInput.Base.Metallic = 0;
	MInput.AO.AmbientOcclusion = GetMaterialAOFromMaskMap(Mask);
	MInput.Detail.Height = GetHeightFromMaskMap(Mask);
	MInput.Base.Roughness = GetPerceptualRoughnessFromMaskMap(Mask);
	MInput.Specular.Reflectance = Reflectance;
	// Tiling Layer
	float2 TilingLayer_2_Coordinate = PixelIn.UV1 * _TilingLayer_Tiling * (_TilingLayer_MatchScaling > FLT_EPS ? LocalScaleX : 1);
	SetupTilingLayer(	_TilingLayer_BaseMap,
						_TilingLayer_BaseColor.rgb,
						_TilingLayer_NormalMap,
						_TilingLayer_NormalScale,
						_TilingLayer_MaskMap,
						_TilingLayer_Reflectance,
						_TilingLayer_HeightOffset,
						TilingLayer_2_Coordinate,
						MInput.Base.Color,
						MInput.TangentSpaceNormal.NormalTS,
						MInput.Base.Metallic,
						MInput.AO.AmbientOcclusion,
						MInput.Detail.Height,
						MInput.Base.Roughness,
						MInput.Specular.Reflectance
					);
	// Base Layer
	float2 BaseCoordinate = PixelIn.UV0;
	float4 MaskMap = SAMPLE_TEXTURE2D(_BaseLayer_MaskMap, SamplerLinearRepeat, BaseCoordinate);
	float4 NormalMap = SAMPLE_TEXTURE2D(_BaseLayer_NormalMap, SamplerLinearRepeat, BaseCoordinate);
	float3 NormalTS = GetNormalTSFromNormalTex(NormalMap, _BaseLayer_NormalScale);
    
	MInput.TangentSpaceNormal.NormalTS = BlendAngelCorrectedNormals(NormalTS, MInput.TangentSpaceNormal.NormalTS);
	MInput.AO.AmbientOcclusion *= GetMaterialAOFromMaskMap(MaskMap);
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
