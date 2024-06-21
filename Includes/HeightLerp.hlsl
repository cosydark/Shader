// Author: QP4B

#ifndef XRENDER_RES_HEIGHT_LERP_HLSL_INCLUDED
#define XRENDER_RES_HEIGHT_LERP_HLSL_INCLUDED

// TODO(QP4B) A Better Height Blend Function ?
float ModifyHeight(float Height, float Offset)
{
    return saturate(Height + Offset * 0.5);
}
float2 HeightBlend(float WeightA, float HeightA, float WeightB, float HeightB, float Radius)
{
    float MaxHeight = max(WeightA + HeightA, WeightB + HeightB) - Radius;
    float A = max(WeightA + HeightA - MaxHeight, 0);
    float B = max(WeightB + HeightB - MaxHeight, 0);
    return float2(A, B) / (A + B);
}
float ComputeHeightBlendMask(float HeightA, float HeightB, float IntensityMask, float BlendRadius, float BlendMode)
{
    float2 Weights = lerp(float2(IntensityMask, 1), float2(1, IntensityMask), BlendMode);
    float2 BlendResult = HeightBlend(Weights.x, HeightA, Weights.y, HeightB, BlendRadius);
    return  lerp(BlendResult.x, BlendResult.y, BlendMode);
}

#endif