#ifdef MM_HEADER
#attribute Material.Author = "QP4B"
#attribute Material.Name = "QuadLayerMaterial"
#attribute Material.ShadingModel = "DefaultLit"

#stylesheet
# Mask
- _LayerMaskMap @TryInline(0)

# Base
- _NormalMap @TryInline(1)
- _NormalScale
- _DetailNormal @Drawer(Toggle)
- _DetailNormalMap @TryInline(1)
- _DetailNormalScale

# R Channel

- _BaseMap_R @TryInline(1)
- _BaseColor_R
- _NormalMap_R @TryInline(1)
- _NormalScale_R
- _MaskMap_R @TryInline(0)
- _Reflectance_R

# G Channel

- _BaseMap_G @TryInline(1)
- _BaseColor_G
- _NormalMap_G @TryInline(1)
- _NormalScale_G
- _MaskMap_G @TryInline(0)
- _Reflectance_G

# B Channel

- _BaseMap_B @TryInline(1)
- _BaseColor_B
- _MaskMap_B @TryInline(0)
- _Reflectance_B

#endstylesheet


#properties
// Mask
_LayerMaskMap ("Layer Mask Map", 2D) = "black" {}
// Base Layer
[NoScaleOffset] [Normal] _NormalMap ("Normal Map", 2D) = "bump" {}
_NormalScale ("Normal Scale", Range(0, 2)) = 1
_DetailNormal ("Detail Normal", Int) = 0
[NoScaleOffset] [Normal] _DetailNormalMap ("Detail Normal Map", 2D) = "bump" {}
_DetailNormalScale ("Detail Normal Scale", Range(0, 2)) = 1

// R Channel
_BaseMap_R ("Base Map R", 2D) = "white" {}
_BaseColor_R ("Base Color R", Color) = (1, 1, 1, 1)
[NoScaleOffset] [Normal] _NormalMap_R ("Normal Map R", 2D) = "bump" {}
_NormalScale_R ("Normal Scale R", Range(0, 2)) = 1
[NoScaleOffset] _MaskMap_R ("Mask Map R (MOHR)", 2D) = "white" {}
_Reflectance_R ("Reflectance R", Range(0, 1)) = 0.5

// G Channel
_BaseMap_G ("Base Map G", 2D) = "white" {}
_BaseColor_G ("Base Color G", Color) = (1, 1, 1, 1)
[NoScaleOffset] [Normal] _NormalMap_G ("Normal Map G", 2D) = "bump" {}
_NormalScale_G ("Normal Scale G", Range(0, 2)) = 1
[NoScaleOffset] _MaskMap_G ("Mask Map G (MOHR)", 2D) = "white" {}
_Reflectance_G ("Reflectance G", Range(0, 1)) = 0.5

// B Channel
_BaseMap_B ("Base Map B", 2D) = "white" {}
_BaseColor_B ("Base Color B", Color) = (1, 1, 1, 1)
[NoScaleOffset] _MaskMap_B ("Mask Map B (MOHR)", 2D) = "white" {}
_Reflectance_B ("Reflectance B", Range(0, 1)) = 0.5

#endproperties

#materialoption.TangentSpaceNormalMap 	= Enable
#materialoption.AmbientOcclusion 		= Enable
#materialoption.Emissive 				= Enable
#materialoption.Detail 					= Enable
#materialoption.UseSlab 			    = Enable

#else
#include "./MM_EV_QuadLayerMaterial.Header.hlsl"
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

void PrepareMaterialInput_New(FPixelInput PixelIn, FSurfacePositionData PosData, inout MInputType MInput)
{
	// Prepare
	float LocalScaleX = length(float3(GetObjectToWorldMatrix()[0].x, GetObjectToWorldMatrix()[1].x, GetObjectToWorldMatrix()[2].x));
	
	float R_UV_Scale = 8;// TODO Covert To Param
	float2 R_UV = (R_UV_Scale * LocalScaleX) * float2(PixelIn.UV0.x, PixelIn.UV0.y);
	float G_UV_Scale = 8;// TODO Covert To Param
	float2 G_UV = (G_UV_Scale * LocalScaleX) * float2(PixelIn.UV0.x, PixelIn.UV0.y);
	float B_UV_Scale = 5;// TODO Covert To Param
	float2 B_UV = (B_UV_Scale * LocalScaleX) * float2(PixelIn.UV0.x, PixelIn.UV0.y);
	float Detail_UV_Scale = 10;// TODO Covert To Param
	float2 Detail_UV = (Detail_UV_Scale * LocalScaleX) * float2(PixelIn.UV0.x, 1 - PixelIn.UV0.y);
	// Sample Base Map
	float4 BaseMap_R = SAMPLE_TEXTURE2D(_BaseMap_R, SamplerTriLinearRepeat, R_UV) * _BaseColor_R;
	float4 BaseMap_G = SAMPLE_TEXTURE2D(_BaseMap_G, SamplerTriLinearRepeat, G_UV) * _BaseColor_G;
	float4 BaseMap_B = SAMPLE_TEXTURE2D(_BaseMap_B, SamplerTriLinearRepeat, B_UV) * _BaseColor_B;
	// Sample Normal Map
	float4 NormalMap_R = SAMPLE_TEXTURE2D(_NormalMap_R, SamplerLinearRepeat, R_UV);
	float3 NormalTS_R = GetNormalTSFromNormalTex(NormalMap_R, _NormalScale_R);
	float4 NormalMap_G = SAMPLE_TEXTURE2D(_NormalMap_G, SamplerLinearRepeat, G_UV);
	float3 NormalTS_G = GetNormalTSFromNormalTex(NormalMap_G, _NormalScale_G);
	float4 NormalMap_Detail = SAMPLE_TEXTURE2D(_DetailNormalMap, SamplerLinearRepeat, Detail_UV);
	float3 NormalTS_Detail = GetNormalTSFromNormalTex(NormalMap_Detail, _DetailNormalScale);
	float4 NormalMap = SAMPLE_TEXTURE2D(_NormalMap, SamplerLinearRepeat, PixelIn.UV0);
	float3 Normal_Object = GetNormalTSFromNormalTex(NormalMap, _NormalScale);
	// Sample Mask
	float4 MaskMap_R = SAMPLE_TEXTURE2D(_MaskMap_R, SamplerLinearRepeat, R_UV);
	float4 MaskMap_G = SAMPLE_TEXTURE2D(_MaskMap_G, SamplerLinearRepeat, G_UV);
	float4 MaskMap_B = SAMPLE_TEXTURE2D(_MaskMap_B, SamplerLinearRepeat, G_UV);
	// LayerMask
	float2 LayerMaskMapUV = PixelIn.UV0;
	float3 LayerMaskMap = SAMPLE_TEXTURE2D(_LayerMaskMap, SamplerTriLinearCLamp, LayerMaskMapUV);
	// Blend
	float G_Mask_Contrast = 1; float G_Mask_Intensity = 1;// TODO Covert To Param
	float B_Mask_Contrast = 1; float B_Mask_Intensity = 1;// TODO Covert To Param
	float LayerMaskMap_G = LayerMaskMap.g;float LayerMaskMap_B = LayerMaskMap.b;
	LayerMaskMap_G = saturate(pow(LayerMaskMap_G, G_Mask_Contrast) * G_Mask_Intensity);
	LayerMaskMap_B = saturate(pow(LayerMaskMap_B, B_Mask_Contrast) * B_Mask_Intensity);
	// Blend Normal
	int BlendDetailNormal = _DetailNormal;
	float3 BlendNormal_RG = lerp(NormalTS_R, NormalTS_G, LayerMaskMap_G);
	BlendNormal_RG = (BlendDetailNormal < FLT_EPS) ? BlendNormal_RG : BlendAngelCorrectedNormals(BlendNormal_RG, NormalTS_Detail);
	float3 FinalNormalTS = BlendAngelCorrectedNormals(Normal_Object, BlendNormal_RG);
	// Blend Color
	float3 BaseMap_RG = lerp(BaseMap_R, BaseMap_G, LayerMaskMap_G);
	float3 BaseMap_RGB = lerp(BaseMap_RG, BaseMap_B, LayerMaskMap_B);
	float3 FinalBaseColor = BaseMap_RGB;
	// Blend Mask
	float4 MaskMap_RG = lerp(MaskMap_R, MaskMap_G, LayerMaskMap.g);
	float4 MaskMap_RGB = lerp(MaskMap_RG, MaskMap_B, LayerMaskMap.b);
	float4 FinalMask = MaskMap_RGB;

	// Export	
	MInput.Base.Color = FinalBaseColor;
	MInput.Base.Opacity = 1;
	MInput.Base.Metallic = 0;
	MInput.Base.Roughness = GetPerceptualRoughnessFromMaskMap(FinalMask);
	MInput.Detail.Height = GetHeightFromMaskMap(FinalMask);
	MInput.AO.AmbientOcclusion = GetMaterialAOFromMaskMap(FinalMask);
	MInput.TangentSpaceNormal.NormalTS = FinalNormalTS;
	MInput.Emission.Color = 0;
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
