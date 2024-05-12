#ifdef MM_HEADER
#attribute Material.Author = "QP4B"
#attribute Material.Name = "CH_Slime"
#stylesheet
# PBR
- _BaseMap
- _MaskMap
- _NormalMap
- _EmissionMap
# InnerLight
### Fresnel
- _OuterFresnelColor
- _InnerFresnelColor
- _OuterFresnelPower
- _InnerFresnelPower
### Pulse
- _PulseSpeed
- _PulseOffset
- _PulseStrength
### SphereMask
- _SphereMaskRadius
- _SphereMaskHardness
- _SphereMaskExp
### Matcap
- _MatcapNoise
- _MatcapTint
- _NoiseMap
- _NormalNoiseScale
### Polka
- _PolkaMap
- _PolkaTint
- _PolkaTiling
- _PolkaTurbance
#endstylesheet

#properties
[NoScaleOffset]_BaseMap("BaseMap", 2D) = "gray" {}
[NoScaleOffset]_MaskMap("MaskMap", 2D) = "white" {}
[NoScaleOffset]_NormalMap("NormalMap", 2D) = "white" {}
[NoScaleOffset]_EmissionMap("EmissionMap", 2D) = "black" {}
[HDR]_OuterFresnelColor("OuterFresnelColor", Color) = (0.6104957,0.2581829,1,1)
[HDR]_InnerFresnelColor("InnerFresnelColor", Color) = (0.1620294,0.2663557,1,1)
_OuterFresnelPower("OuterFresnelPower", Float) = 0
_InnerFresnelPower("InnerFresnelPower", Float) = 0.5
_PulseSpeed("PulseSpeed", Float) = 0
_PulseOffset("PulseOffset", Float) = 0
_PulseStrength("PulseStrength", Float) = 0
_SphereMaskRadius("SphereMaskRadius", Float) = 0.18
_SphereMaskHardness("SphereMaskHardness", Float) = 0.87
_SphereMaskExp("SphereMaskExp", Float) = 1.62
[NoScaleOffset]_MatcapNoise("MatcapNoise", 2D) = "black" {}
_MatcapTint("MatcapTint", Color) = (0.7529413,0.4901961,0.9019608,1)
[NoScaleOffset]_NoiseMap("NoiseMap", 2D) = "white" {}
_NormalNoiseScale("NormalNoiseScale", Float) = 1
[NoScaleOffset]_PolkaMap("PolkaMap", 2D) = "white" {}
_PolkaTint("PolkaTint", Color) = (1,1,1,0)
_PolkaTiling("PolkaTiling", Float) = 1
_PolkaTurbance("PolkaTurbance", Float) = 1
#endproperties

#materialoption.TangentSpaceNormalMap 	= Enable
#materialoption.AmbientOcclusion 		= Enable
#materialoption.Emissive 				= Enable
#materialoption.Reflectance 			= Enable
#materialoption.CustomNormal          = Enable

#else
#include "./MM_CH_Slime.Header.hlsl"
#endif
#include "Packages/com.funplus.xrender/Shaders/Library/Common.hlsl"
#include "Packages/com.funplus.xrender/Shaders/Library/CommonHeader.hlsl"
#include "Packages/com.funplus.xrender/Shaders/Library/CommonSampler.hlsl"
#include "Packages/com.funplus.xrender/Shaders/Library/CommonMaterial.hlsl"

float4 TriplanarProjection384( float3 PositionWS, Texture2D Tex, float Tiling, float3 Weight )
{
float3 PositionOS = PositionWS - TransformPositionOSToPositionWS(float3(0, 0, 0), GetObjectToWorldMatrix());
float4 Color0 = Weight.x > 0.0 ? SAMPLE_TEXTURE2D(Tex, SamplerLinearRepeat, PositionOS.yz * Tiling) : float4(0, 0, 0, 0);
float4 Color1 = Weight.y > 0.0 ? SAMPLE_TEXTURE2D(Tex, SamplerLinearRepeat, PositionOS.zx * Tiling) : float4(0, 0, 0, 0);
float4 Color2 = Weight.z > 0.0 ? SAMPLE_TEXTURE2D(Tex, SamplerLinearRepeat, PositionOS.xy * Tiling) : float4(0, 0, 0, 0);
float4 Color3 = float4(1, 1, 1, 0);
float4 Weight4 = (Weight.x + Weight.y + Weight.z) > 0.0 ? float4(Weight, 0) : float4(Weight, 1);
return (Color0 * Weight4.x + Color1 * Weight4.y + Color2 * Weight4.z + Color3 * Weight4.w) / (Weight4.x + Weight4.y + Weight4.z + Weight4.w);
}
float4 NormalizedOffsetNormal390( float3 NormalWS, float3 OffsetDirection )
{
return normalize(float4(NormalWS.x + OffsetDirection.x, NormalWS.y + OffsetDirection.y, NormalWS.z, 0));
}
float3 TriplanarProjection423( float3 PositionWS, float3 NormalWS, Texture2D Tex, float Tiling, float3 Weight )
{
Weight = Weight * abs(NormalWS);
float3 PositionOS = PositionWS - TransformPositionOSToPositionWS(float3(0, 0, 0), GetObjectToWorldMatrix());
float4 Color0 = Weight.x > 0.0 ? SAMPLE_TEXTURE2D(Tex, SamplerLinearRepeat, PositionOS.yz * Tiling) : float4(0, 0, 0, 0);
float4 Color1 = Weight.y > 0.0 ? SAMPLE_TEXTURE2D(Tex, SamplerLinearRepeat, PositionOS.zx * Tiling) : float4(0, 0, 0, 0);
float4 Color2 = Weight.z > 0.0 ? SAMPLE_TEXTURE2D(Tex, SamplerLinearRepeat, PositionOS.xy * Tiling) : float4(0, 0, 0, 0);
float4 Color3 = float4(1, 1, 1, 0);
float4 Weight4 = (Weight.x + Weight.y + Weight.z) > 0.0 ? float4(Weight, 0) : float4(Weight, 1);
return (Color0 * Weight4.x + Color1 * Weight4.y + Color2 * Weight4.z + Color3 * Weight4.w) / (Weight4.x + Weight4.y + Weight4.z + Weight4.w);
}
float CustomSphereMask( float2 Coords, float2 Center, float Radius, float Hardness )
{
return 1.0 - saturate((distance(Coords, Center) - Radius) / (1 - Hardness));
}
float3 MatcapSampler392( Texture2D Tex, float3 NormalWS )
{
float2 Coordinate = mul(GetWorldToViewMatrix(), NormalWS).xy * 0.5 + 0.5;
return SAMPLE_TEXTURE2D(Tex, SamplerLinearRepeat, Coordinate).xyz;
}
FMaterialInput PrepareMaterialInput(FPixelInput PixelIn, FSurfacePositionData PosData)
{
    ZERO_INITIALIZE(FMaterialInput, MInput);
    float3 Time3432 = ( _Time.y * float3(0,0.2,0.1) );
    float3 ase_worldPos = PixelIn.PositionWS;
    float3 PositionWS220 = ase_worldPos;
    float3 ase_worldNormal = GetNormalWSFromNormalTS( PixelIn, float3( 0, 0, 1 ) );
    float3 NormalWS171 = ase_worldNormal;
    float3 NormalWS390 = NormalWS171;
    float3 PositionWS384 = ( PositionWS220 + Time3432 );
    Texture2D Tex384 =(Texture2D)_NoiseMap;
    float Tiling384 = 1.0;
    float3 Weight384 = float3(1,1,1);
    float4 localTriplanarProjection384 = TriplanarProjection384( PositionWS384 , Tex384 , Tiling384 , Weight384 );
    float4 normalizeResult342 = normalize( localTriplanarProjection384 );
    float2 uv_BaseMap118 = PixelIn.UV0;
    float4 SAMPLE_TEXTURE2DNode118 = SAMPLE_TEXTURE2D(_BaseMap, SamplerLinearRepeat, uv_BaseMap118);
    float NoiseMask441 = SAMPLE_TEXTURE2DNode118.a;
    float3 OffsetDirection390 = ( normalizeResult342 * ( _NormalNoiseScale * NoiseMask441 ) ).xyz;
    float4 localNormalizedOffsetNormal390 = NormalizedOffsetNormal390( NormalWS390 , OffsetDirection390 );
    float4 OffsetedPosition445 = localNormalizedOffsetNormal390;
    float3 PositionWS423 = ( float4( Time3432 , 0.0 ) + float4( PositionWS220 , 0.0 ) + ( OffsetedPosition445 * _PolkaTurbance ) ).xyz;
    float3 NormalWS423 = NormalWS171;
    Texture2D Tex423 =(Texture2D)_PolkaMap;
    float Tiling423 = _PolkaTiling;
    float3 Weight423 = float3(1,1,0);
    float3 localTriplanarProjection423 = TriplanarProjection423( PositionWS423 , NormalWS423 , Tex423 , Tiling423 , Weight423 );
    float2 uv_EmissionMap169 = PixelIn.UV0;
    float4 SAMPLE_TEXTURE2DNode169 = SAMPLE_TEXTURE2D(_EmissionMap, SamplerLinearRepeat, uv_EmissionMap169);
    half EyeMask429 = SAMPLE_TEXTURE2DNode169.a;
    float4 PolkaColor419 = ( ( float4( localTriplanarProjection423 , 0.0 ) * _PolkaTint * EyeMask429 ) * _PolkaTint.a );
    MInput.BaseColor = max( PolkaColor419 , SAMPLE_TEXTURE2DNode118 ).rgb;
    MInput.Opacity = 1.0;
    float2 uv_MaskMap166 = PixelIn.UV0;
    float4 SAMPLE_TEXTURE2DNode166 = SAMPLE_TEXTURE2D(_MaskMap, SamplerLinearRepeat, uv_MaskMap166);
    MInput.Metallic = SAMPLE_TEXTURE2DNode166.r;
    float4 temp_cast_6 = (SAMPLE_TEXTURE2DNode166.a).xxxx;
    MInput.PerceptualRoughness = max( temp_cast_6 , PolkaColor419 ).r;
    float2 uv_NormalMap179 = PixelIn.UV0;
    float3 NormalTSResult178 = GetNormalTSFromNormalTex( SAMPLE_TEXTURE2D(_NormalMap, SamplerLinearRepeat, uv_NormalMap179) , 1.0 );
    MInput.NormalTS = NormalTSResult178;
    MInput.AmbientOcclusion = SAMPLE_TEXTURE2DNode166.g;
    float2 Coords248 = PositionWS220.xy;
    float3 objToWorld255 = Transform( GetObjectToWorldMatrix(), float4( float3( 0,0,0 ), 1 ) ).xyz;
    float2 Center248 = objToWorld255.xy;
    float Radius248 = _SphereMaskRadius;
    float Hardness248 = _SphereMaskHardness;
    float localCustomSphereMask248 = CustomSphereMask( Coords248 , Center248 , Radius248 , Hardness248 );
    float SphereMaskValue247 = pow( abs( localCustomSphereMask248 ) , _SphereMaskExp );
    float PulseTime240 = pow( abs( saturate( ( _PulseOffset + ( 0.5 * ( 1.0 + sin( ( _Time.y * 6.283185 * _PulseSpeed ) ) ) ) ) ) ) , 0.5 );
    float lerpResult260 = lerp( SphereMaskValue247 , ( SphereMaskValue247 * PulseTime240 ) , _PulseStrength);
    float PulseSphereMask265 = lerpResult260;
    float3 normalizeResult196 = normalize( NormalWS171 );
    float3 normalizeResult197 = normalize( ( _WorldSpaceCameraPos - PositionWS220 ) );
    float dotResult185 = dot( normalizeResult196 , normalizeResult197 );
    float EPS409 = FLT_EPS;
    float FresnelTerm192 = max( abs( ( 1.0 - max( dotResult185 , 0.0 ) ) ) , EPS409 );
    float InnerFresnel209 = pow( abs( ( 1.0 - pow( abs( pow( abs( FresnelTerm192 ) , _InnerFresnelPower ) ) , 0.25 ) ) ) , 1.25 );
    float OutFresnel204 = pow( abs( FresnelTerm192 ) , _OuterFresnelPower );
    float4 lerpResult275 = lerp( ( PulseSphereMask265 * InnerFresnel209 * _InnerFresnelColor ) , _OuterFresnelColor , OutFresnel204);
    float4 EmissionFromMap266 = ( SAMPLE_TEXTURE2DNode169 * float4(1,1,1,0) );
    float4 Light335 = ( lerpResult275 + EmissionFromMap266 );
    Texture2D Tex392 =(Texture2D)_MatcapNoise;
    float3 NormalWS392 = localNormalizedOffsetNormal390.xyz;
    float3 localMatcapSampler392 = MatcapSampler392( Tex392 , NormalWS392 );
    float4 MatcapColor395 = ( ( float4( localMatcapSampler392 , 0.0 ) * _MatcapTint * _MatcapTint.a ) * EyeMask429 );
    MInput.EmissiveColor = ( Light335 + MatcapColor395 ).rgb;
    return MInput;
}
float4 PrepareMaterialVertexCustomOutputData(in FVertexOutput VertexOut, in FVertexInput VertexIn, float3 OffsetOS, float3 OffsetWS)
{
    return float4(0.0, 0.0, 0.0, 0.0);
}
void PrepareMaterialVertexCustomOutput(inout FVertexOutput VertexOut, in FVertexInput VertexIn)
{
}
float3 CalculateVertexOffsetObjectSpace(in FVertexInput VertIn)
{
    return float3(0.0, 0.0, 0.0);
}
float3 CalculateVertexOffsetWorldSpace(in FVertexInput VertIn)
{
    return float3(0.0, 0.0, 0.0);
}
//ss:[[-509616416]]

/*ASEBEGIN
Version=18935
2560;1;2560;1379;81.28772;883.2142;1;True;True
Node;AmplifyShaderEditor.CommentaryNode;280;-1558.294,-2738.578;Inherit;False;998.9222;1559.218;Bind;20;176;175;177;174;432;399;398;397;409;408;171;220;172;219;266;429;169;170;454;455;;1,1,1,1;0;0
Node;AmplifyShaderEditor.WorldPosInputsNode;219;-1021.86,-2167.721;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldNormalVector;172;-1024.44,-2000.104;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.CommentaryNode;222;-2125.926,-1148.692;Inherit;False;1569.203;726.7723;Fresnel;28;204;209;202;201;205;216;199;215;211;214;213;206;207;210;208;192;191;221;410;189;186;185;197;196;181;218;217;184;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;220;-825.7786,-2170.936;Float;False;PositionWS;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;171;-828.0761,-2006.399;Float;False;NormalWS;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;217;-1993.985,-875.9957;Inherit;False;220;PositionWS;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WorldSpaceCameraPos;184;-2049.483,-1014.636;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.GetLocalVarNode;181;-1842.685,-1098.692;Inherit;False;171;NormalWS;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;218;-1787.026,-986.442;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.NormalizeNode;196;-1646.177,-1086.509;Inherit;False;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.NormalizeNode;197;-1649.177,-987.5081;Inherit;False;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;241;-2363.162,-368.2417;Inherit;False;1809.182;366.876;Pulse;12;223;225;229;230;232;233;224;234;235;237;238;240;;1,1,1,1;0;0
Node;AmplifyShaderEditor.DotProductOpNode;185;-1458.385,-1037.757;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;186;-1324.917,-1036.757;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;223;-2313.162,-237.8194;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;224;-2301.318,-116.3657;Inherit;False;Property;_PulseSpeed;PulseSpeed;12;0;Create;True;0;0;0;True;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.NumericConstantsNode;408;-1091.424,-1646.708;Inherit;False;0;5;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;189;-1185.418,-1038.257;Inherit;False;2;0;FLOAT;1;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;225;-2102.242,-232.3876;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;6.283185;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;409;-824.0325,-1594.516;Float;False;EPS;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;229;-1940.662,-232.7881;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;398;-1248.918,-1366.58;Inherit;False;Constant;_Vector1;Vector 1;9;0;Create;True;0;0;0;False;0;False;0,0.2,0.1;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.AbsOpNode;221;-1049.806,-1034.471;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;397;-1255.349,-1449.567;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;410;-1100.735,-940.2217;Inherit;False;409;EPS;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;191;-911.9175,-1036.757;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0.0001;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;230;-1774.662,-231.7881;Inherit;False;2;2;0;FLOAT;1;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;399;-1068.796,-1436.524;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;401;-2758.205,1666.383;Inherit;False;2220.187;852.1461;Matcap;22;395;452;393;453;394;392;353;445;390;391;352;444;342;384;442;381;387;400;386;389;434;385;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;232;-1615.073,-235.2418;Inherit;False;2;2;0;FLOAT;0.5;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;192;-790.9003,-1036.217;Float;False;FresnelTerm;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;432;-813.3007,-1436.656;Inherit;False;Time3;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.TexturePropertyNode;165;716.8386,-813.3194;Inherit;True;Property;_BaseMap;BaseMap;1;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;None;None;False;gray;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.CommentaryNode;279;-1674.549,55.29738;Inherit;False;1116.443;811.0678;Sphere Mask;15;265;260;261;262;259;264;247;257;256;258;248;243;250;249;255;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;234;-1642.073,-318.2417;Inherit;False;Property;_PulseOffset;PulseOffset;13;0;Create;True;0;0;0;True;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;434;-2676.127,1917.538;Inherit;False;432;Time3;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;385;-2682.744,1733.763;Inherit;False;220;PositionWS;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;208;-2075.926,-616.8256;Inherit;False;192;FresnelTerm;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.TransformPositionNode;255;-1592.87,179.2144;Inherit;False;Object;World;False;Fast;True;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;250;-1611.371,396.6971;Inherit;False;Property;_SphereMaskHardness;SphereMaskHardness;17;0;Create;True;0;0;0;True;0;False;0.87;0.87;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;118;967.0365,-806.124;Inherit;True;Property;_TextureSample0;Texture Sample 0;5;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;249;-1570.37,105.2975;Inherit;False;220;PositionWS;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;243;-1591.776,323.4986;Inherit;False;Property;_SphereMaskRadius;SphereMaskRadius;16;0;Create;True;0;0;0;True;0;False;0.18;0.18;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;233;-1416.073,-237.2418;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;389;-2666.997,2349.771;Inherit;False;Constant;_T3Weight;T3Weight;18;0;Create;True;0;0;0;False;0;False;1,1,1;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.TexturePropertyNode;386;-2735.987,2083.666;Inherit;True;Property;_NoiseMap;NoiseMap;22;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;None;None;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SimpleAddOpNode;400;-2470.873,1859.884;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;387;-2648.997,2274.771;Inherit;False;Constant;_T3Tiling;T3Tiling;18;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CustomExpressionNode;248;-1323.897,170.3291;Inherit;False;return 1.0 - saturate((distance(Coords, Center) - Radius) / (1 - Hardness))@;1;Create;4;True;Coords;FLOAT2;0,0;In;;Float;False;True;Center;FLOAT2;0,0;In;;Float;False;True;Radius;FLOAT;0;In;;Float;False;True;Hardness;FLOAT;0;In;;Float;False;CustomSphereMask;False;False;0;b9ccff642fce8074d8eeb3a0e721e5c6;False;4;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;210;-1960.227,-534.1708;Inherit;False;Property;_InnerFresnelPower;InnerFresnelPower;10;0;Create;True;0;0;0;True;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;235;-1276.017,-235.6154;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.AbsOpNode;207;-1876.042,-615.1687;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;441;1293.962,-695.5461;Inherit;False;NoiseMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;442;-2225.753,2287.294;Inherit;False;441;NoiseMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.AbsOpNode;237;-1103.017,-233.6154;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;206;-1745.042,-614.1687;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;0.25;False;1;FLOAT;0
Node;AmplifyShaderEditor.CustomExpressionNode;384;-2270.035,1980.228;Inherit;False;    float3 PositionOS = PositionWS - TransformPositionOSToPositionWS(float3(0, 0, 0), GetObjectToWorldMatrix())@$    float4 Color0 = Weight.x > 0.0 ? SAMPLE_TEXTURE2D(Tex, SamplerLinearRepeat, PositionOS.yz * Tiling) : float4(0, 0, 0, 0)@$    float4 Color1 = Weight.y > 0.0 ? SAMPLE_TEXTURE2D(Tex, SamplerLinearRepeat, PositionOS.zx * Tiling) : float4(0, 0, 0, 0)@$    float4 Color2 = Weight.z > 0.0 ? SAMPLE_TEXTURE2D(Tex, SamplerLinearRepeat, PositionOS.xy * Tiling) : float4(0, 0, 0, 0)@$    float4 Color3 = float4(1, 1, 1, 0)@$    float4 Weight4 = (Weight.x + Weight.y + Weight.z) > 0.0 ? float4(Weight, 0) : float4(Weight, 1)@$    return (Color0 * Weight4.x + Color1 * Weight4.y + Color2 * Weight4.z + Color3 * Weight4.w) / (Weight4.x + Weight4.y + Weight4.z + Weight4.w)@;4;Create;4;True;PositionWS;FLOAT3;0,0,0;In;;Float;False;True;Tex;OBJECT;;In;Texture2D;Float;False;True;Tiling;FLOAT;0;In;;Float;False;True;Weight;FLOAT3;0,0,0;In;;Float;False;TriplanarProjection;True;False;0;;False;4;0;FLOAT3;0,0,0;False;1;OBJECT;;False;2;FLOAT;0;False;3;FLOAT3;0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;258;-1160.875,318.7512;Inherit;False;Property;_SphereMaskExp;SphereMaskExp;18;0;Create;True;0;0;0;True;0;False;1.62;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.AbsOpNode;256;-1110.35,170.0492;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;381;-2256.648,2128.842;Inherit;False;Property;_NormalNoiseScale;NormalNoiseScale;23;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;238;-957.9795,-233.7445;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.AbsOpNode;213;-1568.638,-609.4058;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;257;-954.6138,172.3756;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.NormalizeNode;342;-2042.414,1981.764;Inherit;False;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;444;-2033.672,2192.031;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;247;-808.9487,173.5677;Inherit;False;SphereMaskValue;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;391;-1927.683,1879.235;Inherit;False;171;NormalWS;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.PowerNode;214;-1430.914,-607.8583;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;0.25;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;352;-1887.566,1983.004;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;240;-781.9795,-233.7445;Inherit;False;PulseTime;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;264;-1494.834,651.4726;Inherit;False;240;PulseTime;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;211;-1260.147,-605.7634;Inherit;False;2;0;FLOAT;1;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;259;-1463.956,507.0378;Inherit;False;247;SphereMaskValue;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.CustomExpressionNode;390;-1678.233,1953.017;Float;False;return normalize(float4(NormalWS.x + OffsetDirection.x, NormalWS.y + OffsetDirection.y, NormalWS.z, 0))@;4;Create;2;True;NormalWS;FLOAT3;0,0,0;In;;Float;False;True;OffsetDirection;FLOAT3;0,0,0;In;;Float;False;NormalizedOffsetNormal;True;False;0;;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.AbsOpNode;215;-1111.364,-603.9896;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;199;-1296.155,-791.2891;Inherit;False;192;FresnelTerm;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;436;-2265.115,2551.482;Inherit;False;1724.412;1007.242;Polka;16;419;438;418;423;430;417;425;414;426;431;427;424;433;446;447;448;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;262;-1289.086,752.5981;Inherit;False;Property;_PulseStrength;PulseStrength;14;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;445;-1337.622,2222.684;Inherit;False;OffsetedPosition;-1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;261;-1250.086,637.5981;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;170;-1521.881,-2689.317;Inherit;True;Property;_EmissionMap;EmissionMap;4;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;None;None;False;black;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.GetLocalVarNode;446;-2078.54,2761.596;Inherit;False;445;OffsetedPosition;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;448;-2047.993,2843.359;Inherit;False;Property;_PolkaTurbance;PolkaTurbance;28;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;260;-1006.086,590.5981;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.AbsOpNode;201;-1096.273,-789.6322;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;216;-973.6403,-602.4421;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1.25;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;205;-1181.903,-709.7733;Inherit;False;Property;_OuterFresnelPower;OuterFresnelPower;9;0;Create;True;0;0;0;True;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;454;-1211.926,-2492.517;Inherit;False;Constant;_EmissionTint;EmissionTint;29;1;[HDR];Create;True;0;0;0;False;0;False;1,1,1,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;433;-1916.636,2594.517;Inherit;False;432;Time3;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;169;-1302.086,-2689.578;Inherit;True;Property;_TextureSample2;Texture Sample 2;2;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;447;-1827.993,2792.359;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;265;-802.3511,586.5729;Inherit;False;PulseSphereMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;202;-965.2727,-788.6322;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;0.25;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;209;-787.4717,-600.2391;Float;False;InnerFresnel;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;336;-1680.338,924.749;Inherit;False;1115.028;690.1495;ZZ;10;276;272;268;273;277;267;275;271;270;335;;1,1,1,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;424;-1918.167,2683.889;Inherit;False;220;PositionWS;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;431;-1675.044,2666.5;Inherit;False;3;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.GetLocalVarNode;268;-1600.904,1058.022;Inherit;False;209;InnerFresnel;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;204;-794.2728,-789.1797;Float;False;OutFresnel;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;429;-821.5521,-2546.451;Half;False;EyeMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;427;-1714.015,2977.962;Inherit;False;171;NormalWS;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ColorNode;270;-1620.904,1146.021;Inherit;False;Property;_InnerFresnelColor;InnerFresnelColor;8;1;[HDR];Create;True;0;0;0;False;0;False;0.1620294,0.2663557,1,1;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexturePropertyNode;353;-1661.157,1742.308;Inherit;True;Property;_MatcapNoise;MatcapNoise;20;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;None;None;False;black;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.TexturePropertyNode;414;-1978.392,3027.162;Inherit;True;Property;_PolkaMap;PolkaMap;25;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;None;None;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.GetLocalVarNode;267;-1630.338,979.2565;Inherit;False;265;PulseSphereMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;425;-1688.478,3165.643;Inherit;False;Property;_PolkaTiling;PolkaTiling;27;0;Create;True;1;ZHaoyuecheng;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;426;-1694.168,3247.394;Inherit;False;Constant;_PolkaWeight;PolkaWeight;27;0;Create;True;0;0;0;False;0;False;1,1,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;455;-975.9261,-2687.517;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CustomExpressionNode;423;-1354.569,3025.774;Inherit;False;	Weight = Weight * abs(NormalWS)@$	float3 PositionOS = PositionWS - TransformPositionOSToPositionWS(float3(0, 0, 0), GetObjectToWorldMatrix())@$	float4 Color0 = Weight.x > 0.0 ? SAMPLE_TEXTURE2D(Tex, SamplerLinearRepeat, PositionOS.yz * Tiling) : float4(0, 0, 0, 0)@$	float4 Color1 = Weight.y > 0.0 ? SAMPLE_TEXTURE2D(Tex, SamplerLinearRepeat, PositionOS.zx * Tiling) : float4(0, 0, 0, 0)@$	float4 Color2 = Weight.z > 0.0 ? SAMPLE_TEXTURE2D(Tex, SamplerLinearRepeat, PositionOS.xy * Tiling) : float4(0, 0, 0, 0)@$	float4 Color3 = float4(1, 1, 1, 0)@$	float4 Weight4 = (Weight.x + Weight.y + Weight.z) > 0.0 ? float4(Weight, 0) : float4(Weight, 1)@$	return (Color0 * Weight4.x + Color1 * Weight4.y + Color2 * Weight4.z + Color3 * Weight4.w) / (Weight4.x + Weight4.y + Weight4.z + Weight4.w)@;3;Create;5;False;PositionWS;FLOAT3;0,0,0;In;;Float;False;True;NormalWS;FLOAT3;0,0,0;In;;Float;False;False;Tex;OBJECT;;In;Texture2D;Float;False;False;Tiling;FLOAT;0;In;;Float;False;False;Weight;FLOAT3;0,0,0;In;;Float;False;TriplanarProjection;True;False;0;;False;5;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;OBJECT;;False;3;FLOAT;0;False;4;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;271;-1349.277,1053.407;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;430;-1318.684,3370.152;Inherit;False;429;EyeMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.CustomExpressionNode;392;-1342.714,1954.868;Float;False;    float2 Coordinate = mul(GetWorldToViewMatrix(), NormalWS).xy * 0.5 + 0.5@$    return SAMPLE_TEXTURE2D(Tex, SamplerLinearRepeat, Coordinate).xyz@;3;Create;2;True;Tex;OBJECT;0;In;Texture2D;Inherit;False;True;NormalWS;FLOAT3;0,0,0;In;;Float;False;MatcapSampler;True;False;0;;False;2;0;OBJECT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;272;-1593.279,1503.406;Inherit;False;204;OutFresnel;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;394;-1339.055,2050.832;Inherit;False;Property;_MatcapTint;MatcapTint;21;0;Create;True;0;0;0;False;0;False;0.7529413,0.4901961,0.9019608,1;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;273;-1621.279,1329.406;Inherit;False;Property;_OuterFresnelColor;OuterFresnelColor;7;1;[HDR];Create;True;0;0;0;False;0;False;0.6104957,0.2581829,1,1;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;417;-1343.204,3197.682;Inherit;False;Property;_PolkaTint;PolkaTint;26;0;Create;True;0;0;0;False;0;False;1,1,1,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;266;-822.3337,-2686.371;Float;False;EmissionFromMap;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;277;-1227.535,1405.402;Inherit;False;266;EmissionFromMap;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;275;-1154.279,1233.406;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;418;-1112.088,3051.048;Inherit;False;3;3;0;FLOAT3;0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;393;-1098.055,1951.832;Inherit;False;3;3;0;FLOAT3;0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;453;-1102.544,2093.429;Inherit;False;429;EyeMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;438;-947.8535,3049.07;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;276;-941.4548,1234.758;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;452;-935.6927,1950.63;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;395;-776.7752,1944.597;Inherit;False;MatcapColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;419;-783.9124,3048.469;Inherit;False;PolkaColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TexturePropertyNode;180;445.75,-49.12975;Inherit;True;Property;_NormalMap;NormalMap;3;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;None;None;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.RegisterLocalVarNode;335;-793.3094,1229.136;Inherit;False;Light;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TexturePropertyNode;167;718.1685,-581.9993;Inherit;True;Property;_MaskMap;MaskMap;2;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;None;None;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SamplerNode;166;972.8686,-584.2991;Inherit;True;Property;_TextureSample1;Texture Sample 1;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;337;867.8441,186.8546;Inherit;False;335;Light;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;411;-1821.639,-2549.983;Inherit;False;247.3334;665.1233;GT;7;405;404;402;407;406;403;437;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SamplerNode;179;690.054,-51.42957;Inherit;True;Property;_TextureSample3;Texture Sample 3;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;396;850.468,268.2431;Inherit;False;395;MatcapColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;450;1080.535,-320.1187;Inherit;False;419;PolkaColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;421;1086.293,-910.3811;Inherit;False;419;PolkaColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;449;1331.814,-353.3681;Inherit;False;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StyleLabelNode;404;-1770.639,-2350.859;Inherit;False;Property;T_Fresnel;Fresnel;6;0;Create;False;0;0;0;True;0;False;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;451;1336.659,-257.1039;Inherit;False;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StyleLabelNode;407;-1770.639,-2123.859;Inherit;False;Property;T_Matcap;Matcap;19;0;Create;False;0;0;0;True;0;False;0;1;FLOAT;0
Node;AmplifyShaderEditor.StyleGroupNode;402;-1770.213,-2499.983;Inherit;False;Property;G_PBR;PBR;0;0;Create;False;0;0;0;True;0;False;0;1;FLOAT;0
Node;AmplifyShaderEditor.StyleLabelNode;406;-1769.639,-2197.859;Inherit;False;Property;T_SphereMask;SphereMask;15;0;Create;False;0;0;0;True;0;False;0;1;FLOAT;0
Node;AmplifyShaderEditor.StyleLabelNode;405;-1771.639,-2275.859;Inherit;False;Property;T_Pulse;Pulse;11;0;Create;False;0;0;0;True;0;False;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;174;-997.19,-1831.024;Inherit;False;2;2;0;FLOAT3x3;0,0,0,1,1,1,1,0,1;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;177;-832.84,-1829.337;Float;False;NormalTS;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;176;-1215.037,-1751.75;Inherit;False;171;NormalWS;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;328;1145.038,193.2992;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StyleGroupNode;403;-1769.639,-2425.859;Inherit;False;Property;G_InnerLight;InnerLight;5;0;Create;False;0;0;0;True;0;False;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;422;1296.727,-817.6898;Inherit;False;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetNormalTSFromNormalTex;178;995.9208,-52.18694;Inherit;False;2;0;FLOAT4;1,1,1,1;False;1;FLOAT;1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StyleLabelNode;437;-1768.854,-2047.991;Inherit;False;Property;T_Polka;Polka;24;0;Create;False;0;0;0;True;0;False;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldToTangentMatrix;175;-1240.858,-1831.838;Inherit;False;0;1;FLOAT3x3;0
Node;AmplifyShaderEditor.RangedFloatNode;456;1465.712,-449.2142;Inherit;False;Constant;_Float0;Float 0;29;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.MaterialModelMasterNode;0;1677.783,-427.2903;Inherit;False;True;-1;2;ASEMaterialInspector;0;0;CH_Slime;QP4B;10;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT3;0,0,0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;9;FLOAT3;0,0,0;False;0
WireConnection;220;0;219;0
WireConnection;171;0;172;0
WireConnection;218;0;184;0
WireConnection;218;1;217;0
WireConnection;196;0;181;0
WireConnection;197;0;218;0
WireConnection;185;0;196;0
WireConnection;185;1;197;0
WireConnection;186;0;185;0
WireConnection;189;1;186;0
WireConnection;225;0;223;0
WireConnection;225;2;224;0
WireConnection;409;0;408;3
WireConnection;229;0;225;0
WireConnection;221;0;189;0
WireConnection;191;0;221;0
WireConnection;191;1;410;0
WireConnection;230;1;229;0
WireConnection;399;0;397;0
WireConnection;399;1;398;0
WireConnection;232;1;230;0
WireConnection;192;0;191;0
WireConnection;432;0;399;0
WireConnection;118;0;165;0
WireConnection;233;0;234;0
WireConnection;233;1;232;0
WireConnection;400;0;385;0
WireConnection;400;1;434;0
WireConnection;248;0;249;0
WireConnection;248;1;255;0
WireConnection;248;2;243;0
WireConnection;248;3;250;0
WireConnection;235;0;233;0
WireConnection;207;0;208;0
WireConnection;441;0;118;4
WireConnection;237;0;235;0
WireConnection;206;0;207;0
WireConnection;206;1;210;0
WireConnection;384;0;400;0
WireConnection;384;1;386;0
WireConnection;384;2;387;0
WireConnection;384;3;389;0
WireConnection;256;0;248;0
WireConnection;238;0;237;0
WireConnection;213;0;206;0
WireConnection;257;0;256;0
WireConnection;257;1;258;0
WireConnection;342;0;384;0
WireConnection;444;0;381;0
WireConnection;444;1;442;0
WireConnection;247;0;257;0
WireConnection;214;0;213;0
WireConnection;352;0;342;0
WireConnection;352;1;444;0
WireConnection;240;0;238;0
WireConnection;211;1;214;0
WireConnection;390;0;391;0
WireConnection;390;1;352;0
WireConnection;215;0;211;0
WireConnection;445;0;390;0
WireConnection;261;0;259;0
WireConnection;261;1;264;0
WireConnection;260;0;259;0
WireConnection;260;1;261;0
WireConnection;260;2;262;0
WireConnection;201;0;199;0
WireConnection;216;0;215;0
WireConnection;169;0;170;0
WireConnection;447;0;446;0
WireConnection;447;1;448;0
WireConnection;265;0;260;0
WireConnection;202;0;201;0
WireConnection;202;1;205;0
WireConnection;209;0;216;0
WireConnection;431;0;433;0
WireConnection;431;1;424;0
WireConnection;431;2;447;0
WireConnection;204;0;202;0
WireConnection;429;0;169;4
WireConnection;455;0;169;0
WireConnection;455;1;454;0
WireConnection;423;0;431;0
WireConnection;423;1;427;0
WireConnection;423;2;414;0
WireConnection;423;3;425;0
WireConnection;423;4;426;0
WireConnection;271;0;267;0
WireConnection;271;1;268;0
WireConnection;271;2;270;0
WireConnection;392;0;353;0
WireConnection;392;1;390;0
WireConnection;266;0;455;0
WireConnection;275;0;271;0
WireConnection;275;1;273;0
WireConnection;275;2;272;0
WireConnection;418;0;423;0
WireConnection;418;1;417;0
WireConnection;418;2;430;0
WireConnection;393;0;392;0
WireConnection;393;1;394;0
WireConnection;393;2;394;4
WireConnection;438;0;418;0
WireConnection;438;1;417;4
WireConnection;276;0;275;0
WireConnection;276;1;277;0
WireConnection;452;0;393;0
WireConnection;452;1;453;0
WireConnection;395;0;452;0
WireConnection;419;0;438;0
WireConnection;335;0;276;0
WireConnection;166;0;167;0
WireConnection;179;0;180;0
WireConnection;449;0;166;4
WireConnection;449;1;450;0
WireConnection;451;0;166;4
WireConnection;451;1;450;0
WireConnection;174;0;175;0
WireConnection;174;1;176;0
WireConnection;177;0;174;0
WireConnection;328;0;337;0
WireConnection;328;1;396;0
WireConnection;422;0;421;0
WireConnection;422;1;118;0
WireConnection;178;0;179;0
WireConnection;0;0;422;0
WireConnection;0;1;456;0
WireConnection;0;2;166;1
WireConnection;0;3;451;0
WireConnection;0;4;178;0
WireConnection;0;5;166;2
WireConnection;0;9;328;0
ASEEND*/
//CHKSM=4D340277EC2BE7331FCDD1087F882F14AC62B575