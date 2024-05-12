#ifdef MM_HEADER
#attribute Material.Author = "QP4B"
#attribute Material.Name = "CharacterEye"

#stylesheet

# Base Layer
- _BaseMap
- _BaseColor
- _NormalMap
- _NormalScale

# PBR Layer
- _MaskMap @Tooltip(R: Specular Cookie, G: Occlusion, B: Iris Height, A: Pupil Mask)
- _Roughness
- _Reflectance
- _IrisDistanceValue
- _UVCenterOffset @Drawer(Vector2)
- _CookieColor
- _CookieOffset @Drawer(Vector2)

# Emissive Layer
- _EmissiveMap
- _EmissiveColor


# Matcap Layer
- _Matcap
- _MatcapColor

#endstylesheet




#properties
// Base Layer
[NoScaleOffset] _BaseMap ("Base Map", 2D) = "white" {}
[HDR] _BaseColor ("Base Color", Color) = (1, 1, 1, 1)
[NoScaleOffset] [Normal] _NormalMap ("Normal Map", 2D) = "bump" {} // Tangent Space NormalMap
_NormalScale ("Normal Scale", Range(0, 2)) = 1

// PBR Layer
[NoScaleOffset] _MaskMap ("Mask Map (Spec, AO, Height, Pupil)", 2D) = "white" {}    // Specular Cookie, Occlusion, Iris Distance, Roughness
_Roughness ("Roughness", Range(0, 1)) = 0.1
_Reflectance ("Reflectance", Range(0, 1)) = 0.39
_IrisDistanceValue ("Iris Distance Value", Range(0, 0.1)) = 0.05
_UVCenterOffset ("UV Center Offset", Vector) = (0, 0, 0, 0)

[NoScaleOffset] _EmissiveMap ("Emissive Map", 2D) = "white" {}
[HDR] _EmissiveColor ("Emissive Color", Color) = (0, 0, 0, 1)
[HDR] _CookieColor ("Specular Color", Color) = (1, 1, 1, 1)
_CookieOffset ("Specular Offset", Vector) = (0, 0, 0, 0)

// Matcap Layer
[NoScaleOffset] _Matcap ("Matcap", 2D) = "black" {}
[HDR] _MatcapColor ("Matcap Color", Color) = (1, 1, 1)

#endproperties
#materialoption.AmbientOcclusion    = Enable
#materialoption.Emissive            = Enable
#materialoption.Reflectance         = Enable
#materialoption.CustomData          = Enable
#materialoption.CustomTBN           = Enable

#else
#include "./MM_CH_CharacterEye.Header.hlsl"
#endif

#include "Packages/com.funplus.xrender/Shaders/Library/Common.hlsl"
#include "Packages/com.funplus.xrender/Shaders/Library/CommonHeader.hlsl"
#include "Packages/com.funplus.xrender/Shaders/Library/CommonSampler.hlsl"
#include "Packages/com.funplus.xrender/Shaders/Library/CommonMaterial.hlsl"


FMaterialInput PrepareMaterialInput(FPixelInput PixelIn, FSurfacePositionData PosData)
{

    // Pupil Mask & Iris Mask
    const float IrisSize = 0.2;
    // float2 EyeUV = PixelIn.UV0 * 2 - 1;
    // float PupilMask = dot(EyeUV, EyeUV);
    // PupilMask = 1 - smoothstep(0, _PupilSize, PupilMask);
    // float IrisMask = (1 - PupilMask) * (0.5 - IrisSize);

    float2 Texcoord = PixelIn.UV0;
    float4 MaskMap = SAMPLE_TEXTURE2D(_MaskMap, SamplerLinearRepeat, Texcoord);
    float PupilMask = MaskMap.a;
    float IrisMask = (1 - PupilMask) * (0.5 - IrisSize);


    // Reset uv
    float4 Height = MaskMap.b * 2;  // Mul by 2 as fake HDR image.
    float Amplitude = _IrisDistanceValue;

    // Do parallax First
    float3 ViewDirTS = mul(PixelIn.TangentToWorldMatrix, PosData.CameraVectorWS);
    Texcoord += ParallaxOffset1Step(Height, -Amplitude, ViewDirTS);

    // Sample textures after parallax
    float4 BaseMap = SAMPLE_TEXTURE2D(_BaseMap, SamplerLinearRepeat, Texcoord);

    // Fill in FMaterialInput
    ZERO_INITIALIZE(FMaterialInput, MInput);
    float4 BaseColor = BaseMap * _BaseColor;
    MInput.BaseColor = BaseColor.rgb;
    MInput.Opacity = BaseColor.a;
    MInput.PerceptualRoughness = _Roughness;

#if defined(MATERIAL_USE_AMBIENT_OCCLUSION)
    MInput.AmbientOcclusion = GetMaterialAOFromMaskMap(MaskMap);
#endif

#if defined(MATERIAL_USE_REFLECTANCE)
    MInput.DielectricReflectance = _Reflectance;
#endif


#if defined(MATERIAL_USE_CUSTOM_TBN)
    float4 NormalMap = SAMPLE_TEXTURE2D(_NormalMap, SamplerLinearRepeat, Texcoord);
    float3 NormalTS = GetNormalTSFromNormalTex(NormalMap, _NormalScale);

    MInput.CustomTBN[2] = GetNormalWSFromNormalTS(PixelIn, NormalTS);
    MInput.CustomTBN[0] = Orthonormalize(PixelIn.GeometricTangentWS, MInput.CustomTBN[2]);
    MInput.CustomTBN[1] = ComputeBinormal(MInput.CustomTBN[2], MInput.CustomTBN[0], PixelIn.BinormalSymmetry);
#endif


#if defined(MATERIAL_USE_EMISSIVE)
    MInput.EmissiveColor = SAMPLE_TEXTURE2D(_EmissiveMap, SamplerLinearRepeat, Texcoord).rgb * _EmissiveColor.rgb;

    // Add highlight cookie
    float ViewBias = Pow2(dot(MInput.CustomTBN[2], PosData.CameraVectorWS)) * 0.05;
    float3 Cookie = SAMPLE_TEXTURE2D(_MaskMap, SamplerLinearRepeat, lerp(PixelIn.UV0, Texcoord, 0.25) + _CookieOffset.xy + ViewBias).r * _CookieColor.rgb;
    MInput.EmissiveColor += Cookie;
#endif


#if defined(MATERIAL_USE_CUSTOM_DATA)
    // Matcap for eyes
    float NdotV = saturate(dot(MInput.CustomTBN[2], PosData.CameraVectorWS));
    float3 MatcapNormalWS = normalize(lerp(PixelIn.GeometricNormalWS, MInput.CustomTBN[2], NdotV));
    float2 MatcapUV = ComputeMatcapUV(PosData.PositionWS, MatcapNormalWS);
    MInput.CustomData0.xyz = SAMPLE_TEXTURE2D(_Matcap, SamplerLinearClamp, MatcapUV).rgb * _MatcapColor;
    MInput.MaterialFeature |= MATERIAL_FEATURE_MATCAP;

    // Eyes
    // const float IrisMask = IrisMask;
    const float IrisDistance = Height;

    // As the eye's texcoords are unwarapped to a normalized sphere, than tangent will be pointing to the center.
    // Or, we can calculate the vector by UV.
    float3 IrisNormal = float3(PixelIn.UV0 * 2 - 1 + _UVCenterOffset.xy, 0);
    IrisNormal = GetNormalWSFromNormalTS(PixelIn, normalize(IrisNormal));
    MInput.CustomData1 = float4(IrisNormal, IrisMask); // w: IrisMask
    // Blend in the negative intersection normal to create some concavity
    // Not great as it ties the concavity to the convexity of the cornea surface
    // No good justification for that. On the other hand, if we're just looking to
    // introduce some concavity, this does the job.
    float3 CausticNormal = normalize(lerp(IrisNormal, -MInput.CustomTBN[2], IrisMask * IrisDistance));
    MInput.CustomData2.rgb = CausticNormal;
#endif


#if defined(USE_DEBUG_MODE)
    MInput.MaterialDebugData0 = CausticNormal * 0.5 + 0.5;
    MInput.MaterialDebugData1 = IrisMask;
#endif

    return MInput;
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
*/
