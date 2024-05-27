// Author: QP4B

#ifndef XRENDER_RES_LAYERED_SURFACE_HLSL_INCLUDED
#define XRENDER_RES_LAYERED_SURFACE_HLSL_INCLUDED

#include "Packages/com.funplus.xrender/Shaders/Library/Common.hlsl"
#include "Packages/com.funplus.xrender/Shaders/Library/CommonSampler.hlsl"
#include "Packages/com.funplus.xrender/Shaders/Library/CommonMaterial.hlsl"
#include "Packages/com.funplus.xrender/Shaders/Library/CommonAntiTilling.hlsl"

float2 HeightBlend(float WeightA, float HeightA, float WeightB, float HeightB, float Radius)
{
    float MaxHeight = max(WeightA + HeightA, WeightB + HeightB) - Radius;
    float A = max(WeightA + HeightA - MaxHeight, 0);
    float B = max(WeightB + HeightB - MaxHeight, 0);
    return float2(A, B) / (A + B);
}
float3 BlendAngelCorrectedNormals(float3 BaseNormal, float3 AdditionalNormal)
{
    float3 Temp_0 = float3(BaseNormal.xy, BaseNormal.z + 1);
    float3 Temp_1 = float3(-AdditionalNormal.xy, AdditionalNormal.z);
    float3 Temp_2 = dot(Temp_0, Temp_1);
    return normalize(Temp_0 * Temp_2 - Temp_1 * Temp_2);
}
float ModifyHeight(float Height, float Offset)
{
    return saturate(Height + Offset * 0.5);
}
float2 PrepareTextureCoordinates(float Handle, FPixelInput PixelInput)
{
    return Handle < FLT_EPS ? saturate(PixelInput.UV0) : saturate(PixelInput.UV1);
}
// Long Functions
void BlendWithHeight(	Texture2D<float4> BaseMap,
                        float4 BaseColor,
                        Texture2D<float4> NormalMap,
                        float NormalScale,
                        Texture2D<float4> MaskMap,
                        float Reflectance_Attribute,
                        float2 Coordinate,
                        float IntensityMask,
                        float BlendRadius,
                        float HeightOffset,
                        float BlendMode,
                        inout float3 Color,
                        inout float3 NormalTS,
                        inout float Metallic,
                        inout float AmbientOcclusion,
                        inout float Height,
                        inout float Roughness,
                        inout float Reflectance						
                    )
{
    float4 BaseMapBlend = SAMPLE_TEXTURE2D(BaseMap, SamplerTriLinearRepeat, Coordinate) * BaseColor;
    float4 NormalMapBlend = SAMPLE_TEXTURE2D(NormalMap, SamplerLinearRepeat, Coordinate);
    float3 NormalBlend = GetNormalTSFromNormalTex(NormalMapBlend, NormalScale);
    float4 MaskMapBlend = SAMPLE_TEXTURE2D(MaskMap, SamplerLinearRepeat, Coordinate);
	
    float HeightBlendMask;
    // TODO(QP4B) A Better Height Blend Function ?
    BRANCH
    switch (BlendMode)
    {
    case 1:
        HeightBlendMask = HeightBlend(IntensityMask, saturate(ModifyHeight(MaskMapBlend.z, HeightOffset)), 1, Height, BlendRadius).x;
        break;
    case 2:
        HeightBlendMask = HeightBlend(1, saturate(ModifyHeight(MaskMapBlend.z, HeightOffset)), IntensityMask, Height, BlendRadius).y;
        break;
    default:
        HeightBlendMask = IntensityMask;
        break;
    }
    // Color = HeightBlendMask;
    Color = lerp(Color, BaseMapBlend, HeightBlendMask);
    NormalTS = lerp(NormalTS, NormalBlend, HeightBlendMask);
    Reflectance = lerp(Reflectance, Reflectance_Attribute, HeightBlendMask);
    Metallic = lerp(Metallic, GetMaterialMetallicFromMaskMap(MaskMapBlend), HeightBlendMask);
    AmbientOcclusion = lerp(AmbientOcclusion, GetMaterialAOFromMaskMap(MaskMapBlend), HeightBlendMask);
    Height = lerp(Height, GetHeightFromMaskMap(MaskMapBlend), HeightBlendMask);
    Roughness = lerp(Roughness, GetPerceptualRoughnessFromMaskMap(MaskMapBlend), HeightBlendMask);
}
void BlendWithHeight(	Texture2D<float4> BaseMap,
                        float4 BaseColor,
                        Texture2D<float4> NormalMap,
                        float NormalScale,
                        Texture2D<float4> MaskMap,
                        float Reflectance_Attribute,
                        float2 Coordinate,
                        float IntensityMask,
                        float BlendRadius,
                        float HeightOffset,
                        float BlendMode,
                        inout float3 Color,
                        inout float3 NormalTS,
                        inout float Metallic,
                        inout float AmbientOcclusion,
                        inout float Height,
                        inout float Roughness,
                        inout float Reflectance,
                        inout float HeightMask
                    )
{
    float4 BaseMapBlend = SAMPLE_TEXTURE2D(BaseMap, SamplerTriLinearRepeat, Coordinate) * BaseColor;
    float4 NormalMapBlend = SAMPLE_TEXTURE2D(NormalMap, SamplerLinearRepeat, Coordinate);
    float3 NormalBlend = GetNormalTSFromNormalTex(NormalMapBlend, NormalScale);
    float4 MaskMapBlend = SAMPLE_TEXTURE2D(MaskMap, SamplerLinearRepeat, Coordinate);
	
    float HeightBlendMask;
    // TODO(QP4B) A Better Height Blend Function ?
    BRANCH
    switch (BlendMode)
    {
    case 1:
        HeightBlendMask = HeightBlend(IntensityMask, saturate(ModifyHeight(MaskMapBlend.z, HeightOffset)), 1, Height, BlendRadius).x;
        break;
    case 2:
        HeightBlendMask = HeightBlend(1, saturate(ModifyHeight(MaskMapBlend.z, HeightOffset)), IntensityMask, Height, BlendRadius).y;
        break;
    default:
        HeightBlendMask = IntensityMask;
        break;
    }
    // Color = HeightBlendMask;
    Color = lerp(Color, BaseMapBlend, HeightBlendMask);
    NormalTS = lerp(NormalTS, NormalBlend, HeightBlendMask);
    Reflectance = lerp(Reflectance, Reflectance_Attribute, HeightBlendMask);
    Metallic = lerp(Metallic, GetMaterialMetallicFromMaskMap(MaskMapBlend), HeightBlendMask);
    AmbientOcclusion = lerp(AmbientOcclusion, GetMaterialAOFromMaskMap(MaskMapBlend), HeightBlendMask);
    Height = lerp(Height, GetHeightFromMaskMap(MaskMapBlend), HeightBlendMask);
    Roughness = lerp(Roughness, GetPerceptualRoughnessFromMaskMap(MaskMapBlend), HeightBlendMask);
    HeightMask = HeightBlendMask;
}
void BlendWithHeightNoTexture(	float4 Color_Attribute,
                                float NormalScale_Attribute,
                                float Metallic_Attribute,
                                float AmbientOcclusion_Attribute,
                                float Height_Attribute,
                                float Roughness_Attribute,
                                float Reflectance_Attribute,
                                float IntensityMask,
                                float BlendRadius,
                                float BlendMode,
                                inout float3 Color,
                                inout float3 NormalTS,
                                inout float Metallic,
                                inout float AmbientOcclusion,
                                inout float Height,
                                inout float Roughness,
                                inout float Reflectance						
                             )
{
    float4 BaseMapBlend = Color_Attribute;
    float3 NormalBlend = lerp(float3(0, 0, 1), NormalTS, NormalScale_Attribute);
    float4 MaskMapBlend = float4(Metallic_Attribute, AmbientOcclusion_Attribute, Height_Attribute, Roughness_Attribute);
	
    float HeightBlendMask;
    // TODO(QP4B) A Better Height Blend Function ?
    BRANCH
    switch (BlendMode)
    {
    case 1:
        HeightBlendMask = HeightBlend(IntensityMask, saturate(Height_Attribute), 1, Height, BlendRadius).x;
        break;
    case 2:
        HeightBlendMask = HeightBlend(1, saturate(Height_Attribute), IntensityMask, Height, BlendRadius).y;
        break;
    default:
        HeightBlendMask = IntensityMask;
        break;
    }
    // Color = lerp(Color, BaseMapBlend, HeightBlendMask);
    // NormalTS = lerp(NormalTS, NormalBlend, HeightBlendMask);
    // Reflectance = lerp(Reflectance, Reflectance_Attribute, HeightBlendMask);
    // Metallic = lerp(Metallic, GetMaterialMetallicFromMaskMap(MaskMapBlend), HeightBlendMask);
    // AmbientOcclusion = lerp(AmbientOcclusion, GetMaterialAOFromMaskMap(MaskMapBlend), HeightBlendMask);
    // Height = lerp(Height, GetHeightFromMaskMap(MaskMapBlend), HeightBlendMask);
    // Roughness = lerp(Roughness, GetPerceptualRoughnessFromMaskMap(MaskMapBlend), HeightBlendMask);
    
    Color = lerp(Color, Color * BaseMapBlend, HeightBlendMask);
    NormalTS = lerp(NormalTS, NormalBlend, HeightBlendMask);
    Reflectance = lerp(Reflectance, Reflectance_Attribute, HeightBlendMask);
    Metallic = lerp(Metallic, GetMaterialMetallicFromMaskMap(MaskMapBlend), HeightBlendMask);
    AmbientOcclusion = lerp(AmbientOcclusion, GetMaterialAOFromMaskMap(MaskMapBlend), HeightBlendMask);
    Height = lerp(Height, GetHeightFromMaskMap(MaskMapBlend), HeightBlendMask);
    Roughness = lerp(Roughness, GetPerceptualRoughnessFromMaskMap(MaskMapBlend), HeightBlendMask);
}
// Needs Anti Tiling
void ApplyDetailMap(    Texture2D<float4> DetailMap,
                        float DetailIntensity,
                        float DetailNormalScale,
                        float2 Coordinate,
                        float IntensityMask,
                        inout float Roughness,
                        inout float3 NormalTS,
                        inout float AmbientOcclusion
                    )
{
    DetailIntensity = DetailIntensity * IntensityMask;
    float4 Detail = SAMPLE_TEXTURE2D(DetailMap, SamplerLinearRepeat, Coordinate);
    float3 DetailNormalTS = GetNormalTSFromDetailMap(Detail, DetailNormalScale * DetailIntensity);
    // Apply Detail Map
    NormalTS = BlendAngelCorrectedNormals(NormalTS, DetailNormalTS);
    AmbientOcclusion = min(AmbientOcclusion, lerp(1, GetAOFromDetailMap(Detail), DetailIntensity));
    Roughness *= lerp(1, Detail.r, DetailIntensity);
}
void ApplyDetailMapHex(     Texture2D<float4> DetailMap,
                            float DetailIntensity,
                            float DetailNormalScale,
                            float2 Coordinate,
                            float IntensityMask,
                            inout float Roughness,
                            inout float3 NormalTS,
                            inout float AmbientOcclusion,
                            float4 HexInfo
                       )
{
    DetailIntensity = DetailIntensity * IntensityMask;
    float4 Detail = SampleTexture2DHex(     DetailMap,
                                            SamplerLinearRepeat,
                                            Coordinate,
                                            HexInfo.x,
                                            HexInfo.y,
                                            HexInfo.z,
                                            HexInfo.w
                                       );
    float3 DetailNormalTS = GetNormalTSFromDetailMap(Detail, DetailNormalScale * DetailIntensity);
    // Apply Detail Map
    NormalTS = BlendAngelCorrectedNormals(NormalTS, DetailNormalTS);
    AmbientOcclusion = min(AmbientOcclusion, lerp(1, GetAOFromDetailMap(Detail), DetailIntensity));
    Roughness *= lerp(1, Detail.r, DetailIntensity);
}
void SetupTilingLayer(    Texture2D<float4> BaseMap,
                        float3 BaseColor,
                        Texture2D<float4> NormalMap,
                        float NormalScale,
                        Texture2D<float4> MaskMap,
                        float Reflectance_Attribute,
                        float HeightOffset_Attribute,
                        float2 Coordinate,
                        inout float3 Color,
                        inout float3 NormalTS,
                        inout float Metallic,
                        inout float AmbientOcclusion,
                        inout float Height,
                        inout float Roughness,
                        inout float Reflectance
                    )
{
    Color = SAMPLE_TEXTURE2D(BaseMap, SamplerTriLinearRepeat, Coordinate).rgb * BaseColor;
    NormalTS = GetNormalTSFromNormalTex(SAMPLE_TEXTURE2D(NormalMap, SamplerLinearRepeat, Coordinate), NormalScale);
    float4 Mask = SAMPLE_TEXTURE2D(MaskMap, SamplerLinearRepeat, Coordinate);
    Mask.z = saturate(ModifyHeight(Mask.z, HeightOffset_Attribute));
    Metallic = GetMaterialMetallicFromMaskMap(Mask);
    AmbientOcclusion = GetMaterialAOFromMaskMap(Mask);
    Height = GetHeightFromMaskMap(Mask);
    Roughness = GetPerceptualRoughnessFromMaskMap(Mask);
    Reflectance = Reflectance_Attribute;
}
void SetupTilingLayer(  Texture2D<float4> BaseMap,
                        float3 BaseColor,
                        Texture2D<float4> NormalMap,
                        float NormalScale,
                        Texture2D<float4> MaskMap,
                        float Reflectance,
                        float HeightOffset,
                        float2 Coordinate,
                        inout MInputType MInput
                    )
{
    // Modify Height
    float4 Mask = SAMPLE_TEXTURE2D(MaskMap, SamplerLinearRepeat, Coordinate);
    Mask.z = saturate(ModifyHeight(Mask.z, HeightOffset));
    // Fill
    MInput.Base.Color = SAMPLE_TEXTURE2D(BaseMap, SamplerTriLinearRepeat, Coordinate).rgb * BaseColor.rgb;
    MInput.TangentSpaceNormal.NormalTS = GetNormalTSFromNormalTex(SAMPLE_TEXTURE2D(NormalMap, SamplerLinearRepeat, Coordinate), NormalScale);
    MInput.Base.Metallic = GetMaterialMetallicFromMaskMap(Mask);
    MInput.AO.AmbientOcclusion = GetMaterialAOFromMaskMap(Mask);
    MInput.Detail.Height = GetHeightFromMaskMap(Mask);
    MInput.Base.Roughness = GetPerceptualRoughnessFromMaskMap(Mask);
    MInput.Specular.Reflectance = Reflectance;
}
#endif