// ---- Created with 3Dmigoto v1.2.45 on Wed Nov 27 22:18:57 2024

cbuffer _Globals : register(b0)
{
  float4 vViewInfo : packoffset(c0);
  float fDistantBlurZThreshold : packoffset(c1);
  float fFar : packoffset(c1.y);
  float fDistantBlurIntensity : packoffset(c1.z);
  float fKIDSDOFType : packoffset(c1.w) = {0};
  float fBloomWeight : packoffset(c2) = {0.5};
  float fStarWeight : packoffset(c2.y) = {0.800000012};
  float fLensFlareWeight : packoffset(c2.z) = {0.300000012};
  float2 SimulateHDRParams : packoffset(c3);
  float4 vLightShaftPower : packoffset(c4);
  float3 vColorScale : packoffset(c5) = {1,1,1};
  float3 vSaturationScale : packoffset(c6) = {1,1,1};
  float2 vScreenSize : packoffset(c7) = {1280,720};
  float4 vSpotParams : packoffset(c8) = {640,360,300,400};
  float fLimbDarkening : packoffset(c9) = {755364.125};
  float fLimbDarkeningWeight : packoffset(c9.y) = {0};
  float fGamma : packoffset(c9.z) = {1};
}

SamplerState smplScene : register(s0);
SamplerState smplAdaptedLumCur : register(s1);
SamplerState smplZ : register(s2);
SamplerState smplBlurFront : register(s3);
SamplerState smplDOFMerge : register(s4);
SamplerState smplBlurBack : register(s5);
SamplerState smplBlurHexFront : register(s6);
SamplerState smplBlurHexBack : register(s7);
SamplerState smplBloom : register(s8);
SamplerState smplStar : register(s9);
SamplerState smplFlare : register(s10);
SamplerState smplLightShaftLinWork2 : register(s11);
Texture2D<float4> smplScene_Tex : register(t0);
Texture2D<float4> smplAdaptedLumCur_Tex : register(t1);
Texture2D<float4> smplZ_Tex : register(t2);
Texture2D<float4> smplBlurFront_Tex : register(t3);
Texture2D<float4> smplDOFMerge_Tex : register(t4);
Texture2D<float4> smplBlurBack_Tex : register(t5);
Texture2D<float4> smplBlurHexFront_Tex : register(t6);
Texture2D<float4> smplBlurHexBack_Tex : register(t7);
Texture2D<float4> smplBloom_Tex : register(t8);
Texture2D<float4> smplStar_Tex : register(t9);
Texture2D<float4> smplFlare_Tex : register(t10);
Texture2D<float4> smplLightShaftLinWork2_Tex : register(t11);


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
  float4 r0,r1,r2,r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = smplScene_Tex.Sample(smplScene, v1.xy).xyzw;
  r1.x = smplAdaptedLumCur_Tex.Sample(smplAdaptedLumCur, float2(0.25,0.5)).x;
  r1.yzw = r1.xxx * r0.xyz;
  r2.x = smplDOFMerge_Tex.Sample(smplDOFMerge, v1.xy).w;
  r2.y = cmp(fKIDSDOFType == 0.000000);
  if (r2.y != 0) {
    r2.y = cmp(r2.x < 0.5);
    if (r2.y == 0) {
      r2.yzw = smplBlurBack_Tex.Sample(smplBlurBack, v1.xy).xyz;
      r3.x = -0.5 + r2.x;
      r3.x = r3.x * -2 + 1;
      r3.x = max(0, r3.x);
      r3.x = 9.99999975e-06 + r3.x;
      r3.x = 1 / r3.x;
      r3.x = -1 + r3.x;
      r3.x = saturate(0.25 * r3.x);
      r2.yzw = -r0.xyz * r1.xxx + r2.yzw;
      r1.yzw = r3.xxx * r2.yzw + r1.yzw;
    }
    r3.xyzw = smplBlurFront_Tex.Sample(smplBlurFront, v1.xy).xyzw;
    r2.y = -0.5 + r3.w;
    r2.y = abs(r2.y) * -2 + 1;
    r2.y = max(0, r2.y);
    r2.y = 9.99999975e-06 + r2.y;
    r2.y = 1 / r2.y;
    r2.y = -1 + r2.y;
    r2.y = saturate(0.25 * r2.y);
    r3.xyz = r3.xyz + -r1.yzw;
    r2.yzw = r2.yyy * r3.xyz + r1.yzw;
  } else {
    r3.x = cmp(fKIDSDOFType == 1.000000);
    if (r3.x != 0) {
      r3.x = cmp(r2.x < 0.5);
      if (r3.x == 0) {
        r3.xyz = smplBlurHexBack_Tex.Sample(smplBlurHexBack, v1.xy).xyz;
        r2.x = -0.5 + r2.x;
        r2.x = r2.x * -2 + 1;
        r2.x = max(0, r2.x);
        r2.x = 9.99999975e-06 + r2.x;
        r2.x = 1 / r2.x;
        r2.x = -1 + r2.x;
        r2.x = saturate(0.25 * r2.x);
        r3.xyz = -r0.xyz * r1.xxx + r3.xyz;
        r1.yzw = r2.xxx * r3.xyz + r1.yzw;
      }
      r3.xyzw = smplBlurHexFront_Tex.Sample(smplBlurHexFront, v1.xy).xyzw;
      r2.x = -0.5 + r3.w;
      r2.x = abs(r2.x) * -2 + 1;
      r2.x = max(0, r2.x);
      r2.x = 9.99999975e-06 + r2.x;
      r2.x = 1 / r2.x;
      r2.x = -1 + r2.x;
      r2.x = saturate(0.25 * r2.x);
      r3.xyz = r3.xyz + -r1.yzw;
      r2.yzw = r2.xxx * r3.xyz + r1.yzw;
    } else {
      r2.x = smplZ_Tex.Sample(smplZ, v1.xy).x;
      r2.x = vViewInfo.z + r2.x;
      r2.x = -vViewInfo.w / r2.x;
      r2.x = -fDistantBlurZThreshold + r2.x;
      r3.x = fFar + -fDistantBlurZThreshold;
      r2.x = saturate(r2.x / r3.x);
      r2.x = saturate(fDistantBlurIntensity * r2.x);
      r2.x = sqrt(r2.x);
      r3.xyz = smplBlurFront_Tex.Sample(smplBlurFront, v1.xy).xyz;
      r0.xyz = -r0.xyz * r1.xxx + r3.xyz;
      r2.yzw = r2.xxx * r0.xyz + r1.yzw;
    }
  }
  r0.xyz = smplBloom_Tex.Sample(smplBloom, v1.xy).xyz;
  r0.xyz = r0.xyz * fBloomWeight + r2.yzw;
  r1.xyz = smplStar_Tex.Sample(smplStar, v1.xy).xyz;
  r0.xyz = r1.xyz * fStarWeight + r0.xyz;
  r1.xyz = smplFlare_Tex.Sample(smplFlare, v1.xy).xyz;
  r0.xyz = r1.xyz * fLensFlareWeight + r0.xyz;
  r1.xyz = smplLightShaftLinWork2_Tex.Sample(smplLightShaftLinWork2, v1.xy).xyz;
  r0.xyz = r1.xyz * vLightShaftPower.xyz + r0.xyz;
  r1.xyz = vColorScale.xyz * r0.xyz;
  r1.x = dot(r1.xyz, float3(0.298909992,0.586610019,0.114480004));
  r0.xyz = r0.xyz * vColorScale.xyz + -r1.xxx;
  r0.xyz = vSaturationScale.xyz * r0.xyz + r1.xxx;
  r1.xy = v1.xy * vScreenSize.xy + -vSpotParams.xy;
  r1.x = dot(r1.xy, r1.xy);
  r1.y = sqrt(r1.x);
  r1.y = -vSpotParams.z + r1.y;
  r1.z = cmp(0 >= r1.y);
  r1.y = saturate(vSpotParams.w / r1.y);
  r1.y = r1.z ? 1 : r1.y;
  r1.x = fLimbDarkening + r1.x;
  r1.x = fLimbDarkening / r1.x;
  r1.x = r1.x * r1.x;
  r1.xzw = r1.xxx * r0.xyz;
  r1.xyz = r1.xzw * r1.yyy;
  r1.w = 1 + -fLimbDarkeningWeight;
  r1.xyz = fLimbDarkeningWeight * r1.xyz;
  r0.xyz = r0.xyz * r1.www + r1.xyz;
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
  //o0.w = r0.w;
  o0.w = dot(o0.xyz, float3(0.298909992,0.586610019,0.114480004));
  return;
}