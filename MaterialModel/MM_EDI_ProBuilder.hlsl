#ifdef MM_HEADER
#attribute Material.Author = "QP4B"
#attribute Material.Name = "ProBuilder"
#attribute Material.ShadingModel = "DefaultLit"

#stylesheet
# Base Layer
- _Metallic
- _Roughness
- _Reflectance

#endstylesheet


#properties
_Metallic ("Metallic", Range(0, 1)) = 0
_Roughness ("Roughness", Range(0, 1)) = 1
_Reflectance ("Reflectance", Range(0, 1)) = 0.5
#endproperties

#materialoption.TangentSpaceNormalMap = Enable
#materialoption.AmbientOcclusion = Enable
#materialoption.Emissive = Enable
#materialoption.Reflectance = Enable
#materialoption.Detail = Enable
#propertyoption.GenST = _BaseMap
#materialoption.UseSlab = Enable


#else
#include "./MM_EDI_ProBuilder.Header.hlsl"
#endif

#include "Packages/com.funplus.xrender/Shaders/Library/Common.hlsl"
#include "Packages/com.funplus.xrender/Shaders/Library/CommonHeader.hlsl"
#include "Packages/com.funplus.xrender/Shaders/Library/CommonSampler.hlsl"
#include "Packages/com.funplus.xrender/Shaders/Library/CommonMaterial.hlsl"
void PrepareMaterialInput_New(FPixelInput PixelIn, FSurfacePositionData PosData, inout MInputType MInput)
{
	MInput.Base.Color = PixelIn.VertexColor;
	MInput.Base.Opacity = 1;
	MInput.Base.Metallic = _Metallic;
	MInput.Base.Roughness = _Roughness;
	MInput.Detail.Height = 0.5;
	MInput.AO.AmbientOcclusion = 1;
	MInput.Specular.Reflectance = _Reflectance;
	MInput.Emission.Color = float3(0, 0, 0);
	MInput.TangentSpaceNormal.NormalTS = float3(0, 0, 1);
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
