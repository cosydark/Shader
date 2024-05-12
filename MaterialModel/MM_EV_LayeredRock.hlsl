#ifdef MM_HEADER
#attribute Material.Author = "QP4B"
#attribute Material.Name = "EV_LayeredRock"
#attribute Material.ShadingModel = "DefaultLit"

#stylesheet

# Mask Layer
- _BlendMask @TryInline(0)
- _UVIndex @Drawer(Enum, 0, 1)

#endstylesheet


#properties
_BlendMask ("Blend Mask", 2D) = "black" {}
_UVIndex ("UV Index", Int) = 0
#endproperties

#materialoption.TangentSpaceNormalMap = Enable
#materialoption.AmbientOcclusion = Enable
#materialoption.Reflectance = Enable
#materialoption.Detail = Enable
#materialoption.UseSlab = Enable
#materialoption.UseUV1 = Enable
#materialoption.PostProcessMaterialInput  = Enable
#materialoption.Emissive = Disable
// #materialoption.Deferred = Enable


#materialoption.CustomOption0.UseVertexColor = OptionEnable

#else
#include "./MM_EV_LayeredRock.Header.hlsl"
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
	float2 MaskCoordinate = PrepareTextureCoordinates(_UVIndex, PixelIn);
	// Scale
	float LocalScaleX = length(float3(GetObjectToWorldMatrix()[0].x, GetObjectToWorldMatrix()[1].x, GetObjectToWorldMatrix()[2].x));
	MInput.PluginChannelData.Data1.x = LocalScaleX;
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
