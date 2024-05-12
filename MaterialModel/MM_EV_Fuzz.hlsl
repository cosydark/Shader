#ifdef MM_HEADER
#attribute Material.Author = "QP4B"
#attribute Material.Name = "EV_Fuzz"
#attribute Material.ShadingModel = "Fabric"

#stylesheet
# Surface Layer
- _BaseMap
- _BaseColor
- _NormalMap @TryInline(1)
- _NormalScale
- _MaskMap @TryInline(0)
- _EmissiveMap @TryInline(1)
- _EmissiveColor

# Fuzz Layer
- _FuzzColorMap @TryInline(1)
- _FuzzColor
- _FuzzMask @TryInline(1)
- _FuzzAmount
- _FuzzRoughness

#endstylesheet




#properties
// Base Layer
_BaseMap ("Base Map", 2D) = "white" {}
[HDR] _BaseColor ("Base Color", Color) = (1, 1, 1, 1)
[NoScaleOffset] [Normal] _NormalMap ("Normal Map", 2D) = "bump" {}
_NormalScale ("Normal Scale", Range(0, 2)) = 1

// PBR Layer
[NoScaleOffset] _MaskMap ("Mask Map", 2D) = "white" {} // R Metallic, G Occlusion, B Heightmap, A Roughness
_EmissiveMap ("Emissive Map", 2D) = "white" {}
[HDR] _EmissiveColor ("Emissive Color", Color) = (0, 0, 0, 1)

// Cloth Layer
_FuzzColorMap ("Fuzz Color Map", 2D) = "white" {}
[HDR] _FuzzColor ("Fuzz Color", Color) = (1, 1, 1, 1)
[NoScaleOffset] _FuzzMask ("Fuzz Mask", 2D) = "white" {}
_FuzzAmount ("Fuzz Amount", Range(0, 1)) = 1
_FuzzRoughness ("Fuzz Roughness", Range(0, 1)) = 0.75


#endproperties

#materialoption.TangentSpaceNormalMap 	= Enable
#materialoption.AmbientOcclusion 		= Enable
#materialoption.Emissive 				= Enable
#materialoption.Fuzz  					= Enable
#materialoption.Height					= Enable
#materialoption.Detail					= Enable
#propertyoption.GenST 					= _BaseMap
#propertyoption.GenST 					= _FuzzColorMap
#materialoption.UseSlab 			    = Enable


#else
#include "./MM_EV_Fuzz.Header.hlsl"
#endif

#include "Packages/com.funplus.xrender/Shaders/Library/Common.hlsl"
#include "Packages/com.funplus.xrender/Shaders/Library/CommonHeader.hlsl"
#include "Packages/com.funplus.xrender/Shaders/Library/CommonSampler.hlsl"
#include "Packages/com.funplus.xrender/Shaders/Library/CommonMaterial.hlsl"


void PrepareMaterialInput_New(FPixelInput PixelIn, FSurfacePositionData PosData, inout MInputType MInput)
{
	float2 BaseMapUV = PixelIn.UV0;
	float4 BaseMap = SAMPLE_TEXTURE2D(_BaseMap, SamplerTriLinearRepeat, BaseMapUV);
	float4 MaskMap = SAMPLE_TEXTURE2D(_MaskMap, SamplerLinearRepeat, BaseMapUV);
	
	MInput.Base.Color = BaseMap.rgb * _BaseColor;
	MInput.Base.Opacity = BaseMap.a;
	MInput.Base.Metallic = GetMaterialMetallicFromMaskMap(MaskMap);
	MInput.Base.Roughness = GetPerceptualRoughnessFromMaskMap(MaskMap);
	MInput.AO.AmbientOcclusion = GetMaterialAOFromMaskMap(MaskMap);

	float4 NormalMap = SAMPLE_TEXTURE2D(_NormalMap, SamplerLinearRepeat, BaseMapUV);
	MInput.TangentSpaceNormal.NormalTS = GetNormalTSFromNormalTex(NormalMap, _NormalScale);
 
	MInput.Emission.Color = SAMPLE_TEXTURE2D(_EmissiveMap, SamplerLinearRepeat, BaseMapUV).rgb * _EmissiveColor.rgb;
	
	float2 FuzzUV = PixelIn.UV0 * _FuzzColorMap_ST.xy + _FuzzColorMap_ST.zw;
	MInput.Fuzz.Weight = SAMPLE_TEXTURE2D(_FuzzMask, SamplerLinearRepeat, BaseMapUV).r * _FuzzAmount;
	MInput.Fuzz.Color = SAMPLE_TEXTURE2D(_FuzzColorMap, SamplerLinearRepeat, FuzzUV).rgb * _FuzzColor.rgb;
	MInput.Fuzz.Roughness = GetPerceptualRoughnessFromMaskMap(MaskMap) * _FuzzRoughness;
	MInput.Detail.Height = GetHeightFromMaskMap(MaskMap);
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
	#materialoption.CustomNormal
	#materialoption.AmbientOcclusion
	#materialoption.Height
	#materialoption.Emissive
	#materialoption.Anisotropic
	#materialoption.Clearcoat
	#materialoption.SubsurfaceScattering
	#materialoption.Transmission
	#materialoption.ThinFilm
	#materialoption.Hair
	#materialoption.VertexAnimationObjectSpace
	#materialoption.VertexAmbientOcclusion
	#materialoption.UseUV1
	#materialoption.UseUV2
	#materialoption.UseUV3
*/
