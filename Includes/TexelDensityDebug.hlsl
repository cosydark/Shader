// Author: QP4B

#ifndef XRENDER_RES_TEXEL_DENSITY_DEBUG_HLSL_INCLUDED
#define XRENDER_RES_TEXEL_DENSITY_DEBUG_HLSL_INCLUDED

#define TEXEL_DENSITY_DEBUG_GRID_SIZE 128

#include "Packages/com.funplus.xrender/Shaders/SlabDebug/SlabDebugCommon.hlsl"

float2 GetTextureResolution(Texture2D BaseMap)
{
    float2 Resolution;
    BaseMap.GetDimensions(Resolution.x, Resolution.y);
    return Resolution;
}

float GetProceduralGridsByMapResolution(Texture2D Map, float2 UV, float GridSize)
{
    float2 Resolution = GetTextureResolution(Map) / GridSize;
    float2 Checker = saturate(floor(fmod(UV * Resolution, 2)));
    return lerp(Checker.x, 1 - Checker.x, Checker.y > FLT_EPS);
}

void ApplyTexelDensityDebug(inout float3 BaseColor, Texture2D BaseMap, float2 Coordinate)
{
#if defined(USE_DEBUG_MODE)
    if(IsSlabDebuggingShaderType(DEBUGID_MATERIAL_TEXEL_DENSITY))
    {
        BaseColor = GetProceduralGridsByMapResolution(BaseMap, Coordinate, TEXEL_DENSITY_DEBUG_GRID_SIZE);
    }
#endif
}

#endif