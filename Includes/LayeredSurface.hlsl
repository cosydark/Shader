// Author: QP4B

#ifndef XRENDER_RES_LAYERED_SURFACE_HLSL_INCLUDED
#define XRENDER_RES_LAYERED_SURFACE_HLSL_INCLUDED

#include "Packages/com.funplus.xrender/Shaders/Library/Common.hlsl"
#include "Packages/com.funplus.xrender/Shaders/Library/CommonSampler.hlsl"
#include "Packages/com.funplus.xrender/Shaders/Library/CommonMaterial.hlsl"
#include "Packages/com.funplus.xrender/Shaders/Library/CommonAntiTilling.hlsl"

struct MaterialLayer
{
    Texture2D<float4> BaseMap;
    float4 BaseColor;
    Texture2D<float4> NormalMap;
    float NormalScale;
    Texture2D<float4> MaskMap;
    float Reflectance;
    float HeightOffset;
};
struct SimpleMaterialLayer
{
    float4 BaseColor;
    float4 Mask;
    float NormalScale;
    float Reflectance;
};
struct DetailLayer
{
    Texture2D<float4> BaseMap;
    Texture2D<float4> NormalMap;
    float NormalScale;
    Texture2D<float4> MaskMap;
    float AmbientOcclusion;
    float AlbedoGrayValue;
};
float DetailLuminance(float3 LinearRgb)
{
    return dot(LinearRgb, float3(0.2126729, 0.7151522, 0.0721750));
}
// TODO(QP4B) A Better Height Blend Function ?
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
void BlendWithHeight(MaterialLayer MLayer, float2 Coordinate, float IntensityMask, float BlendRadius, float BlendMode, inout MInputType MInput )
{
    float4 BaseMapBlend = SAMPLE_TEXTURE2D(MLayer.BaseMap, SamplerTriLinearRepeat, Coordinate) * MLayer.BaseColor;
    float4 NormalMapBlend = SAMPLE_TEXTURE2D(MLayer.NormalMap, SamplerLinearRepeat, Coordinate);
    float3 NormalBlend = GetNormalTSFromNormalTex(NormalMapBlend, MLayer.NormalScale);
    float4 MaskMapBlend = SAMPLE_TEXTURE2D(MLayer.MaskMap, SamplerLinearRepeat, Coordinate);
    
    float2 Weights = lerp(float2(IntensityMask, 1), float2(1, IntensityMask), BlendMode);
    
    float2 BlendResult = HeightBlend(Weights.x, saturate(ModifyHeight(MaskMapBlend.z, MLayer.HeightOffset)), Weights.y, MInput.Detail.Height, BlendRadius);
    float HeightBlendMask = lerp(BlendResult.x, BlendResult.y, BlendMode);
    
    MInput.Base.Color = lerp(MInput.Base.Color, BaseMapBlend, HeightBlendMask);
    MInput.TangentSpaceNormal.NormalTS = lerp(MInput.TangentSpaceNormal.NormalTS, NormalBlend, HeightBlendMask);
    MInput.Specular.Reflectance = lerp(MInput.Specular.Reflectance, MLayer.Reflectance, HeightBlendMask);
    MInput.Base.Metallic = lerp(MInput.Base.Metallic, GetMaterialMetallicFromMaskMap(MaskMapBlend), HeightBlendMask);
    MInput.AO.AmbientOcclusion = lerp(MInput.AO.AmbientOcclusion, GetMaterialAOFromMaskMap(MaskMapBlend), HeightBlendMask);
    MInput.Detail.Height = lerp(MInput.Detail.Height, GetHeightFromMaskMap(MaskMapBlend), HeightBlendMask);
    MInput.Base.Roughness = lerp(MInput.Base.Roughness, GetPerceptualRoughnessFromMaskMap(MaskMapBlend), HeightBlendMask);
}
void BlendWithHeight_HexTilling(MaterialLayer MLayer, float2 Coordinate, float4 HexTilingInfo, float IntensityMask, float BlendRadius, float BlendMode, inout MInputType MInput )
{
    float4 BaseMapBlend = SampleTexture2DHex(MLayer.BaseMap, SamplerTriLinearRepeat, Coordinate, HexTilingInfo.x, HexTilingInfo.y, HexTilingInfo.z, HexTilingInfo.w) * MLayer.BaseColor;
    float4 NormalMapBlend = SampleTexture2DHex(MLayer.NormalMap, SamplerLinearRepeat, Coordinate, HexTilingInfo.x, HexTilingInfo.y, HexTilingInfo.z, HexTilingInfo.w);
    float3 NormalBlend = GetNormalTSFromNormalTex(NormalMapBlend, MLayer.NormalScale);
    float4 MaskMapBlend = SampleTexture2DHex(MLayer.MaskMap, SamplerLinearRepeat, Coordinate, HexTilingInfo.x, HexTilingInfo.y, HexTilingInfo.z, HexTilingInfo.w);
    
    float2 Weights = lerp(float2(IntensityMask, 1), float2(1, IntensityMask), BlendMode);
    
    float2 BlendResult = HeightBlend(Weights.x, saturate(ModifyHeight(MaskMapBlend.z, MLayer.HeightOffset)), Weights.y, MInput.Detail.Height, BlendRadius);
    float HeightBlendMask = lerp(BlendResult.x, BlendResult.y, BlendMode);
    
    MInput.Base.Color = lerp(MInput.Base.Color, BaseMapBlend, HeightBlendMask);
    MInput.TangentSpaceNormal.NormalTS = lerp(MInput.TangentSpaceNormal.NormalTS, NormalBlend, HeightBlendMask);
    MInput.Specular.Reflectance = lerp(MInput.Specular.Reflectance, MLayer.Reflectance, HeightBlendMask);
    MInput.Base.Metallic = lerp(MInput.Base.Metallic, GetMaterialMetallicFromMaskMap(MaskMapBlend), HeightBlendMask);
    MInput.AO.AmbientOcclusion = lerp(MInput.AO.AmbientOcclusion, GetMaterialAOFromMaskMap(MaskMapBlend), HeightBlendMask);
    MInput.Detail.Height = lerp(MInput.Detail.Height, GetHeightFromMaskMap(MaskMapBlend), HeightBlendMask);
    MInput.Base.Roughness = lerp(MInput.Base.Roughness, GetPerceptualRoughnessFromMaskMap(MaskMapBlend), HeightBlendMask);
}
void BlendWithOutHeight(MaterialLayer MLayer, float2 Coordinate, float IntensityMask, inout MInputType MInput)
{
    float4 BaseMapBlend = SAMPLE_TEXTURE2D(MLayer.BaseMap, SamplerTriLinearRepeat, Coordinate) * MLayer.BaseColor;
    float4 NormalMapBlend = SAMPLE_TEXTURE2D(MLayer.NormalMap, SamplerLinearRepeat, Coordinate);
    float3 NormalBlend = GetNormalTSFromNormalTex(NormalMapBlend, MLayer.NormalScale);
    float4 MaskMapBlend = SAMPLE_TEXTURE2D(MLayer.MaskMap, SamplerLinearRepeat, Coordinate);
    
    MInput.Base.Color = lerp(MInput.Base.Color, BaseMapBlend, IntensityMask);
    MInput.TangentSpaceNormal.NormalTS = lerp(MInput.TangentSpaceNormal.NormalTS, NormalBlend, IntensityMask);
    MInput.Specular.Reflectance = lerp(MInput.Specular.Reflectance, MLayer.Reflectance, IntensityMask);
    MInput.Base.Metallic = lerp(MInput.Base.Metallic, GetMaterialMetallicFromMaskMap(MaskMapBlend), IntensityMask);
    MInput.AO.AmbientOcclusion = lerp(MInput.AO.AmbientOcclusion, GetMaterialAOFromMaskMap(MaskMapBlend), IntensityMask);
    MInput.Detail.Height = lerp(MInput.Detail.Height, GetHeightFromMaskMap(MaskMapBlend), IntensityMask);
    MInput.Base.Roughness = lerp(MInput.Base.Roughness, GetPerceptualRoughnessFromMaskMap(MaskMapBlend), IntensityMask);
}
void BlendWithHeightNoTexture(SimpleMaterialLayer SMLayer, float IntensityMask, float BlendRadius, float BlendMode, inout MInputType MInput)
{
    float4 BaseColorBlend = SMLayer.BaseColor;
    float3 NormalBlend = lerp(float3(0, 0, 1), MInput.TangentSpaceNormal.NormalTS, SMLayer.NormalScale);
    float4 MaskMapBlend = SMLayer.Mask;
    
    float2 Weights = lerp(float2(IntensityMask, 1), float2(1, IntensityMask), BlendMode);
    float2 BlendResult = HeightBlend(Weights.x, GetHeightFromMaskMap(MaskMapBlend), Weights.y, MInput.Detail.Height, BlendRadius);
    float HeightBlendMask = lerp(BlendResult.x, BlendResult.y, BlendMode);

    BaseColorBlend = lerp(1, BaseColorBlend, HeightBlendMask);
    
    MInput.Base.Color = saturate(MInput.Base.Color * BaseColorBlend);// Make BaseColor Physical
    MInput.TangentSpaceNormal.NormalTS = lerp(MInput.TangentSpaceNormal.NormalTS, NormalBlend, HeightBlendMask);
    MInput.Specular.Reflectance = lerp(MInput.Specular.Reflectance, SMLayer.Reflectance, HeightBlendMask);
    // MInput.Base.Metallic = lerp(MInput.Base.Metallic, GetMaterialMetallicFromMaskMap(MaskMapBlend), HeightBlendMask);
    // MInput.AO.AmbientOcclusion = lerp(MInput.AO.AmbientOcclusion, GetMaterialAOFromMaskMap(MaskMapBlend), HeightBlendMask);
    // MInput.Detail.Height = lerp(MInput.Detail.Height, GetHeightFromMaskMap(MaskMapBlend), HeightBlendMask);
    MInput.Base.Roughness = lerp(MInput.Base.Roughness, GetPerceptualRoughnessFromMaskMap(MaskMapBlend), HeightBlendMask);
}
void BlendDetailLayer(DetailLayer DLayer, float2 Coordinate, inout MInputType MInput)
{
    float BaseMapAlbedoGrayValue = DetailLuminance(SAMPLE_TEXTURE2D(DLayer.BaseMap, SamplerTriLinearRepeat, Coordinate));
    float4 NormalMapBlend = SAMPLE_TEXTURE2D(DLayer.NormalMap, SamplerLinearRepeat, Coordinate);
    float3 NormalBlend = GetNormalTSFromNormalTex(NormalMapBlend, DLayer.NormalScale);
    float4 MaskMapBlend = SAMPLE_TEXTURE2D(DLayer.MaskMap, SamplerLinearRepeat, Coordinate);
    
    MInput.Base.Color *= lerp(1, BaseMapAlbedoGrayValue, DLayer.AlbedoGrayValue);
    MInput.TangentSpaceNormal.NormalTS = BlendAngelCorrectedNormals(MInput.TangentSpaceNormal.NormalTS, NormalBlend);
    MInput.AO.AmbientOcclusion = min(MInput.AO.AmbientOcclusion, lerp(1, GetMaterialAOFromMaskMap(MaskMapBlend), DLayer.AmbientOcclusion));
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
void SetupTilingLayer(MaterialLayer MLayer, float2 Coordinate, inout MInputType MInput)
{
    // Modify Height
    float4 Mask = SAMPLE_TEXTURE2D(MLayer.MaskMap, SamplerLinearRepeat, Coordinate);
    Mask.z = saturate(ModifyHeight(Mask.z, MLayer.HeightOffset));
    // Fill
    MInput.Base.Color = SAMPLE_TEXTURE2D(MLayer.BaseMap, SamplerTriLinearRepeat, Coordinate).rgb * MLayer.BaseColor.rgb;
    MInput.TangentSpaceNormal.NormalTS = GetNormalTSFromNormalTex(SAMPLE_TEXTURE2D(MLayer.NormalMap, SamplerLinearRepeat, Coordinate), MLayer.NormalScale);
    MInput.Base.Metallic = GetMaterialMetallicFromMaskMap(Mask);
    MInput.AO.AmbientOcclusion = GetMaterialAOFromMaskMap(Mask);
    MInput.Detail.Height = GetHeightFromMaskMap(Mask);
    MInput.Base.Roughness = GetPerceptualRoughnessFromMaskMap(Mask);
    MInput.Specular.Reflectance = MLayer.Reflectance;
}
void SetupMaterialLayer(    Texture2D<float4> BaseMap,
                            float4 BaseColor,
                            Texture2D<float4> NormalMap,
                            float NormalScale,
                            Texture2D<float4> MaskMap,
                            float Reflectance,
                            float HeightOffset,
                            inout MaterialLayer MLayer
                       )
{
    MLayer.BaseMap = BaseMap;
    MLayer.BaseColor = BaseColor;
    MLayer.NormalMap = NormalMap;
    MLayer.NormalScale = NormalScale;
    MLayer.MaskMap = MaskMap;
    MLayer.Reflectance = Reflectance;
    MLayer.HeightOffset = HeightOffset;
}
void SetupSMaterialLayer(   float4 BaseColor,
                            float NormalScale,
                            float4 Mask,
                            float Reflectance,
                            inout SimpleMaterialLayer SMLayer
                         )
{
    SMLayer.BaseColor = BaseColor;
    SMLayer.NormalScale = NormalScale;
    SMLayer.Mask = Mask;
    SMLayer.Reflectance = Reflectance;
}
void SetupDetailLayer(  Texture2D<float4> BaseMap,
                        Texture2D<float4> NormalMap,
                        float NormalScale,
                        Texture2D<float4> MaskMap,
                        float AmbientOcclusion,
                        float AlbedoGrayValue,
                        inout DetailLayer SMLayer
                     )
{
    SMLayer.BaseMap = BaseMap;
    SMLayer.NormalMap = NormalMap;
    SMLayer.NormalScale = NormalScale;
    SMLayer.MaskMap = MaskMap;
    SMLayer.AmbientOcclusion = AmbientOcclusion;
    SMLayer.AlbedoGrayValue = AlbedoGrayValue;
}
void SetupMInput(inout MInputType MInput)
{
    MInput.Base.Color = float3(0.5, 0.5, 0.5);
    MInput.Base.Opacity = 1;
    MInput.Base.Metallic = 0.5;
    MInput.AO.AmbientOcclusion = 0.5;
    MInput.Detail.Height = 0.5;
    MInput.Base.Roughness = 0.5;
    MInput.Specular.Reflectance = 0.5;
}
#endif