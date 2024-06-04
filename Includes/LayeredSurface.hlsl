// Author: QP4B

#ifndef XRENDER_RES_LAYERED_SURFACE_HLSL_INCLUDED
#define XRENDER_RES_LAYERED_SURFACE_HLSL_INCLUDED

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
void BlendWithHeight_Hex(MaterialLayer MLayer, float2 Coordinate, float IntensityMask, float BlendRadius, float BlendMode, inout MInputType MInput )
{
    float4 BaseMapBlend = SAMPLE_TEXTURE2D_HEX(MLayer.BaseMap, SamplerTriLinearRepeat, Coordinate) * MLayer.BaseColor;
    float4 NormalMapBlend = SAMPLE_TEXTURE2D_HEX(MLayer.NormalMap, SamplerLinearRepeat, Coordinate);
    float3 NormalBlend = GetNormalTSFromNormalTex(NormalMapBlend, MLayer.NormalScale);
    float4 MaskMapBlend = SAMPLE_TEXTURE2D_HEX(MLayer.MaskMap, SamplerLinearRepeat, Coordinate);
    
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
void BlendWithOutHeight_Hex(MaterialLayer MLayer, float2 Coordinate, float IntensityMask, inout MInputType MInput)
{
    float4 BaseMapBlend = SAMPLE_TEXTURE2D_HEX(MLayer.BaseMap, SamplerTriLinearRepeat, Coordinate) * MLayer.BaseColor;
    float4 NormalMapBlend = SAMPLE_TEXTURE2D_HEX(MLayer.NormalMap, SamplerLinearRepeat, Coordinate);
    float3 NormalBlend = GetNormalTSFromNormalTex(NormalMapBlend, MLayer.NormalScale);
    float4 MaskMapBlend = SAMPLE_TEXTURE2D_HEX(MLayer.MaskMap, SamplerLinearRepeat, Coordinate);
    
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
void InitializeTilingLayer(MaterialLayer MLayer, float2 Coordinate, inout MInputType MInput)
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
void InitializeTilingLayer_Hex(MaterialLayer MLayer, float2 Coordinate, inout MInputType MInput)
{
    // Modify Height
    float4 Mask = SAMPLE_TEXTURE2D_HEX(MLayer.MaskMap, SamplerLinearRepeat, Coordinate);
    Mask.z = saturate(ModifyHeight(Mask.z, MLayer.HeightOffset));
    // Fill
    MInput.Base.Color = SAMPLE_TEXTURE2D_HEX(MLayer.BaseMap, SamplerTriLinearRepeat, Coordinate).rgb * MLayer.BaseColor.rgb;
    MInput.TangentSpaceNormal.NormalTS = GetNormalTSFromNormalTex(SAMPLE_TEXTURE2D_HEX(MLayer.NormalMap, SamplerLinearRepeat, Coordinate), MLayer.NormalScale);
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