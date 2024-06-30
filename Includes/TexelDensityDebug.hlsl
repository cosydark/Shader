// Author: QP4B

#ifndef XRENDER_RES_TEXEL_DENSITY_DEBUG_HLSL_INCLUDED
#define XRENDER_RES_TEXEL_DENSITY_DEBUG_HLSL_INCLUDED

#include "Packages/com.funplus.xrender/Shaders/Library/CommonSampler.hlsl"

float2 GetTextureResolution(Texture2D BaseMap)
{
    float2 Resolution;
    BaseMap.GetDimensions(Resolution.x, Resolution.y);
    return Resolution;
}

float GetProceduralGridsByMapResolution(Texture2D Map, float2 UV, float GridSize)
{
    float ProceduralGridsGrayScale;
    float2 Resolution = GetTextureResolution(Map) / GridSize;
    float2 Checker = saturate(floor(fmod(UV * Resolution, 2)));
    if(Checker.y > FLT_EPS)
    {
        ProceduralGridsGrayScale = min(Checker.x, Checker.y);
    }
    else
    {
        ProceduralGridsGrayScale = 1 - Checker.x;
    }
    return ProceduralGridsGrayScale;
}

#endif