// ---- Created with 3Dmigoto v1.2.45 on Wed Nov 27 22:18:57 2024

cbuffer _Globals : register(b0)
{
  float fBloomWeight : packoffset(c0) = {0.5};
  float fStarWeight : packoffset(c0.y) = {0.800000012};
  float fLensFlareWeight : packoffset(c0.z) = {0.300000012};
  float2 SimulateHDRParams : packoffset(c1);
  float4 vLightShaftPower : packoffset(c2);
  float3 vColorScale : packoffset(c3) = {1,1,1};
  float3 vSaturationScale : packoffset(c4) = {1,1,1};
  float2 vScreenSize : packoffset(c5) = {1280,720};
  float4 vSpotParams : packoffset(c6) = {640,360,300,400};
  float fLimbDarkening : packoffset(c7) = {755364.125};
  float fLimbDarkeningWeight : packoffset(c7.y) = {0};
  float fGamma : packoffset(c7.z) = {1};
}

SamplerState smplScene : register(s0);
SamplerState smplAdaptedLumCur : register(s1);
SamplerState smplBloom : register(s2);
SamplerState smplStar : register(s3);
SamplerState smplFlare : register(s4);
SamplerState smplLightShaftLinWork2 : register(s5);
Texture2D<float4> smplScene_Tex : register(t0);
Texture2D<float4> smplAdaptedLumCur_Tex : register(t1);
Texture2D<float4> smplBloom_Tex : register(t2);
Texture2D<float4> smplStar_Tex : register(t3);
Texture2D<float4> smplFlare_Tex : register(t4);
Texture2D<float4> smplLightShaftLinWork2_Tex : register(t5);


// 3Dmigoto declarations
#define cmp -
Texture1D<float4> IniParams : register(t120);
Texture2D<float4> StereoParams : register(t125);


void main( 
  float4 v0 : SV_Position0,
  float4 v1 : TEXCOORD0,
  float4 v2 : TEXCOORD1,
  float4 v3 : TEXCOORD2,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyz = smplBloom_Tex.Sample(smplBloom, v1.xy).xyz;
  r0.xyz = fBloomWeight * r0.xyz;
  r0.w = smplAdaptedLumCur_Tex.Sample(smplAdaptedLumCur, float2(0.25,0.5)).x;
  r1.xyzw = smplScene_Tex.Sample(smplScene, v1.xy).xyzw;
  r0.xyz = r1.xyz * r0.www + r0.xyz;
  //o0.w = r1.w;
  r1.xyz = smplStar_Tex.Sample(smplStar, v1.xy).xyz;
  r0.xyz = r1.xyz * fStarWeight + r0.xyz;
  r1.xyz = smplFlare_Tex.Sample(smplFlare, v1.xy).xyz;
  r0.xyz = r1.xyz * fLensFlareWeight + r0.xyz;
  r1.xyz = smplLightShaftLinWork2_Tex.Sample(smplLightShaftLinWork2, v1.xy).xyz;
  r0.xyz = r1.xyz * vLightShaftPower.xyz + r0.xyz;
  r1.xyz = vColorScale.xyz * r0.xyz;
  r0.w = dot(r1.xyz, float3(0.298909992,0.586610019,0.114480004));
  r0.xyz = r0.xyz * vColorScale.xyz + -r0.www;
  r0.xyz = vSaturationScale.xyz * r0.xyz + r0.www;
  r1.xy = v1.xy * vScreenSize.xy + -vSpotParams.xy;
  r0.w = dot(r1.xy, r1.xy);
  r1.x = fLimbDarkening + r0.w;
  r0.w = sqrt(r0.w);
  r0.w = -vSpotParams.z + r0.w;
  r1.x = fLimbDarkening / r1.x;
  r1.x = r1.x * r1.x;
  r1.xyz = r1.xxx * r0.xyz;
  r1.w = cmp(0 >= r0.w);
  r0.w = saturate(vSpotParams.w / r0.w);
  r0.w = r1.w ? 1 : r0.w;
  r1.xyz = r1.xyz * r0.www;
  r1.xyz = fLimbDarkeningWeight * r1.xyz;
  r0.w = 1 + -fLimbDarkeningWeight;
  r0.xyz = r0.xyz * r0.www + r1.xyz;
  r1.xyz = r0.xyz * float3(0.219999999,0.219999999,0.219999999) + float3(0.0299999993,0.0299999993,0.0299999993);
  r1.xyz = r0.xyz * r1.xyz + float3(0.00200000009,0.00200000009,0.00200000009);
  r2.xyz = r0.xyz * float3(0.219999999,0.219999999,0.219999999) + float3(0.300000012,0.300000012,0.300000012);
  r0.xyz = r0.xyz * r2.xyz + float3(0.0599999987,0.0599999987,0.0599999987);
  r0.xyz = r1.xyz / r0.xyz;
  r0.xyz = float3(-0.0333000012,-0.0333000012,-0.0333000012) + r0.xyz;
  r0.xyz = SimulateHDRParams.xxx * r0.xyz;
  r0.xyz = log2(r0.xyz);
  r0.xyz = fGamma * r0.xyz;
  o0.xyz = exp2(r0.xyz);
  o0.w = dot(o0.xyz, float3(0.298909992,0.586610019,0.114480004));
  return;
}