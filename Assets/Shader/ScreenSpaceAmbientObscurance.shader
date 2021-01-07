Shader "Hidden/ScreenSpaceAmbientObscurance" {
Properties {
 _MainTex ("Base (RGB)", 2D) = "white" { }
}
SubShader { 
 Pass {
  ZTest Always
  ZWrite Off
  Cull Off
  Fog { Mode Off }
  GpuProgramID 6335
Program "vp" {
SubProgram "opengl " {
"!!GLSL
#ifdef VERTEX

varying vec2 xlv_TEXCOORD0;
varying vec2 xlv_TEXCOORD1;
void main ()
{
  vec2 tmpvar_1;
  tmpvar_1 = gl_MultiTexCoord0.xy;
  gl_Position = (gl_ModelViewProjectionMatrix * gl_Vertex);
  xlv_TEXCOORD0 = tmpvar_1;
  xlv_TEXCOORD1 = tmpvar_1;
}


#endif
#ifdef FRAGMENT
uniform vec4 _ZBufferParams;
uniform float _Radius;
uniform float _Radius2;
uniform float _Intensity;
uniform vec4 _ProjInfo;
uniform sampler2D _CameraDepthTexture;
uniform sampler2D _Rand;
uniform vec4 _MainTex_TexelSize;
varying vec2 xlv_TEXCOORD0;
varying vec2 xlv_TEXCOORD1;
void main ()
{
  float sum_2;
  float ssDiskRadius_3;
  vec3 n_C_4;
  float randomPatternRotationAngle_5;
  vec3 C_6;
  vec2 ssC_7;
  vec4 fragment_8;
  fragment_8.xw = vec2(1.0, 1.0);
  ssC_7 = xlv_TEXCOORD1;
  vec3 P_9;
  P_9.z = texture2D (_CameraDepthTexture, xlv_TEXCOORD1).x;
  float tmpvar_10;
  tmpvar_10 = (1.0/(((_ZBufferParams.z * P_9.z) + _ZBufferParams.w)));
  vec3 tmpvar_11;
  tmpvar_11.xy = (((
    (xlv_TEXCOORD1 * _MainTex_TexelSize.zw)
   * _ProjInfo.xy) + _ProjInfo.zw) * tmpvar_10);
  tmpvar_11.z = tmpvar_10;
  P_9 = tmpvar_11;
  C_6 = tmpvar_11;
  float tmpvar_12;
  tmpvar_12 = clamp ((tmpvar_10 * 0.003333333), 0.0, 1.0);
  vec2 p_13;
  float tmpvar_14;
  tmpvar_14 = floor((tmpvar_12 * 256.0));
  p_13.x = (tmpvar_14 * 0.00390625);
  p_13.y = ((tmpvar_12 * 256.0) - tmpvar_14);
  fragment_8.yz = p_13;
  randomPatternRotationAngle_5 = (texture2D (_Rand, (xlv_TEXCOORD0 * 12.0)).x * 1000.0);
  vec3 tmpvar_15;
  tmpvar_15 = dFdy(tmpvar_11);
  vec3 tmpvar_16;
  tmpvar_16 = dFdx(tmpvar_11);
  n_C_4 = normalize(((tmpvar_15.yzx * tmpvar_16.zxy) - (tmpvar_15.zxy * tmpvar_16.yzx)));
  ssDiskRadius_3 = (-(_Radius) / tmpvar_10);
  sum_2 = 0.0;
  for (int l_1 = 0; l_1 < 11; l_1++) {
    float tmpvar_17;
    tmpvar_17 = ((float(l_1) + 0.5) * 0.09090909);
    float tmpvar_18;
    tmpvar_18 = ((tmpvar_17 * 43.96) + randomPatternRotationAngle_5);
    vec2 tmpvar_19;
    tmpvar_19.x = cos(tmpvar_18);
    tmpvar_19.y = sin(tmpvar_18);
    vec3 P_20;
    vec2 tmpvar_21;
    tmpvar_21 = clamp (((
      (tmpvar_17 * ssDiskRadius_3)
     * tmpvar_19) + ssC_7), 0.0, 1.0);
    P_20.z = texture2D (_CameraDepthTexture, tmpvar_21).x;
    float tmpvar_22;
    tmpvar_22 = (1.0/(((_ZBufferParams.z * P_20.z) + _ZBufferParams.w)));
    vec3 tmpvar_23;
    tmpvar_23.xy = (((
      (tmpvar_21 * _MainTex_TexelSize.zw)
     * _ProjInfo.xy) + _ProjInfo.zw) * tmpvar_22);
    tmpvar_23.z = tmpvar_22;
    P_20 = tmpvar_23;
    vec3 tmpvar_24;
    tmpvar_24 = (tmpvar_23 - C_6);
    float tmpvar_25;
    tmpvar_25 = dot (tmpvar_24, tmpvar_24);
    float tmpvar_26;
    tmpvar_26 = max ((_Radius2 - tmpvar_25), 0.0);
    sum_2 = (sum_2 + ((
      (tmpvar_26 * tmpvar_26)
     * tmpvar_26) * max (
      ((dot (tmpvar_24, n_C_4) - 0.01) / (0.01 + tmpvar_25))
    , 0.0)));
  };
  float tmpvar_27;
  tmpvar_27 = (_Radius2 * _Radius);
  float tmpvar_28;
  tmpvar_28 = (sum_2 / (tmpvar_27 * tmpvar_27));
  sum_2 = tmpvar_28;
  float tmpvar_29;
  tmpvar_29 = max (0.0, (1.0 - (
    (tmpvar_28 * _Intensity)
   * 0.4545455)));
  vec2 tmpvar_30;
  tmpvar_30.x = tmpvar_29;
  tmpvar_30.y = tmpvar_29;
  fragment_8.xw = tmpvar_30;
  gl_FragData[0] = fragment_8;
}


#endif
"
}
SubProgram "d3d9 " {
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 4 [_MainTex_TexelSize]
"vs_3_0
def c5, 0, -2, 1, 0
dcl_position v0
dcl_texcoord v1
dcl_position o0
dcl_texcoord o1.xy
dcl_texcoord1 o2.xy
dp4 o0.x, c0, v0
dp4 o0.y, c1, v0
dp4 o0.z, c2, v0
dp4 o0.w, c3, v0
mov r0.x, c5.x
slt r0.x, c4.y, r0.x
mad r0.y, v1.y, c5.y, c5.z
mad o2.y, r0.x, r0.y, v1.y
mov o1.xy, v1
mov o2.x, v1.x

"
}
SubProgram "d3d11 " {
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
ConstBuffer "$Globals" 224
Vector 192 [_MainTex_TexelSize]
ConstBuffer "UnityPerDraw" 336
Matrix 0 [glstate_matrix_mvp]
BindCB  "$Globals" 0
BindCB  "UnityPerDraw" 1
"vs_4_0
eefiecedmomhifcekjcppomhnkmljppeaamoobmlabaaaaaahmacaaaaadaaaaaa
cmaaaaaaiaaaaaaapaaaaaaaejfdeheoemaaaaaaacaaaaaaaiaaaaaadiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaaebaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaafaepfdejfeejepeoaafeeffiedepepfceeaaklkl
epfdeheogiaaaaaaadaaaaaaaiaaaaaafaaaaaaaaaaaaaaaabaaaaaaadaaaaaa
aaaaaaaaapaaaaaafmaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaa
fmaaaaaaabaaaaaaaaaaaaaaadaaaaaaabaaaaaaamadaaaafdfgfpfagphdgjhe
gjgpgoaafeeffiedepepfceeaaklklklfdeieefcieabaaaaeaaaabaagbaaaaaa
fjaaaaaeegiocaaaaaaaaaaaanaaaaaafjaaaaaeegiocaaaabaaaaaaaeaaaaaa
fpaaaaadpcbabaaaaaaaaaaafpaaaaaddcbabaaaabaaaaaaghaaaaaepccabaaa
aaaaaaaaabaaaaaagfaaaaaddccabaaaabaaaaaagfaaaaadmccabaaaabaaaaaa
giaaaaacabaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaa
abaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaabaaaaaaaaaaaaaa
agbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
abaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpccabaaa
aaaaaaaaegiocaaaabaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaa
dbaaaaaibcaabaaaaaaaaaaabkiacaaaaaaaaaaaamaaaaaaabeaaaaaaaaaaaaa
aaaaaaaiccaabaaaaaaaaaaabkbabaiaebaaaaaaabaaaaaaabeaaaaaaaaaiadp
dhaaaaajiccabaaaabaaaaaaakaabaaaaaaaaaaabkaabaaaaaaaaaaabkbabaaa
abaaaaaadgaaaaafhccabaaaabaaaaaaegbabaaaabaaaaaadoaaaaab"
}
}
Program "fp" {
SubProgram "opengl " {
"!!GLSL"
}
SubProgram "d3d9 " {
Float 3 [_Intensity]
Vector 5 [_MainTex_TexelSize]
Vector 4 [_ProjInfo]
Float 1 [_Radius]
Float 2 [_Radius2]
Vector 0 [_ZBufferParams]
SetTexture 0 [_CameraDepthTexture] 2D 0
SetTexture 1 [_Rand] 2D 1
"ps_3_0
def c6, 0.00333333341, 256, 0.00390625, 12
def c7, 1000, 0, 0, 3.99636364
def c8, 0.5, 1, 0.159154937, 0.0909090936
def c9, 6.28318548, -3.14159274, -0.00999999978, 0.00999999978
def c10, 0.454545468, 1, 0, 0
defi i0, 11, 0, 0, 0
dcl_texcoord v0.xy
dcl_texcoord1 v1.xy
dcl_2d s0
dcl_2d s1
texld r0, v1, s0
mad r0.x, c0.z, r0.x, c0.w
rcp r1.z, r0.x
mul r0.yz, c5.xzww, v1.xxyw
mad r0.yz, r0, c4.xxyw, c4.xzww
mul r1.xy, r1.z, r0.yzzw
mul_sat r0.y, r1.z, c6.x
mul r0.z, r0.y, c6.y
frc r0.w, r0.z
add r0.z, -r0.w, r0.z
mul oC0.y, r0.z, c6.z
mad oC0.z, r0.y, c6.y, -r0.z
mul r0.yz, c6.w, v0.xxyw
texld r2, r0.yzzw, s1
mul r0.y, r2.x, c7.x
dsy r2.xyz, r1.zxyw
dsx r3.xyz, r1.yzxw
mul r4.xyz, r2, r3
mad r2.xyz, r2.zxyw, r3.yzxw, -r4
nrm r3.xyz, r2
mul r0.x, r0.x, -c1.x
mov r2.xy, c7.z
rep i0
add r2.yz, r2.y, c8.xyxw
mul r0.z, r0.x, r2.z
mad r0.w, r2.z, c7.w, r0.y
mad r0.w, r0.w, c8.z, c8.x
frc r0.w, r0.w
mad r0.w, r0.w, c9.x, c9.y
sincos r4.xy, r0.w
mul r0.z, r0.z, c8.w
mad_sat r0.zw, r0.z, r4.xyxy, v1.xyxy
texld r4, r0.zwzw, s0
mad r1.w, c0.z, r4.x, c0.w
rcp r4.z, r1.w
mul r0.zw, r0, c5
mad r0.zw, r0, c4.xyxy, c4
mul r4.xy, r4.z, r0.zwzw
add r4.xyz, -r1, r4
dp3 r0.z, r4, r4
dp3 r0.w, r4, r3
add r1.w, -r0.z, c2.x
max r2.z, r1.w, c7.z
mul r1.w, r2.z, r2.z
mul r1.w, r2.z, r1.w
add r0.w, r0.w, c9.z
add r0.z, r0.z, c9.w
rcp r0.z, r0.z
mul r0.z, r0.z, r0.w
max r2.z, r0.z, c7.z
mad r2.x, r1.w, r2.z, r2.x
endrep
mov r0.x, c2.x
mul r0.x, r0.x, c1.x
mul r0.x, r0.x, r0.x
rcp r0.x, r0.x
mul r0.x, r0.x, r2.x
mul r0.x, r0.x, c3.x
mad r0.x, r0.x, -c10.x, c10.y
max oC0.xw, r0.x, c7.z

"
}
SubProgram "d3d11 " {
SetTexture 0 [_CameraDepthTexture] 2D 0
ConstBuffer "$Globals" 224
Float 96 [_Radius]
Float 100 [_Radius2]
Float 104 [_Intensity]
Vector 112 [_ProjInfo]
Vector 192 [_MainTex_TexelSize]
ConstBuffer "UnityPerCamera" 144
Vector 112 [_ZBufferParams]
BindCB  "$Globals" 0
BindCB  "UnityPerCamera" 1
"ps_4_0
eefiecedionnomhodffeaogddghdkmbhmikhbhdlabaaaaaajaaiaaaaadaaaaaa
cmaaaaaajmaaaaaanaaaaaaaejfdeheogiaaaaaaadaaaaaaaiaaaaaafaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaafmaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadaaaaaafmaaaaaaabaaaaaaaaaaaaaaadaaaaaaabaaaaaa
amamaaaafdfgfpfagphdgjhegjgpgoaafeeffiedepepfceeaaklklklepfdeheo
cmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaa
apaaaaaafdfgfpfegbhcghgfheaaklklfdeieefcliahaaaaeaaaaaaaooabaaaa
fjaaaaaeegiocaaaaaaaaaaaanaaaaaafjaaaaaeegiocaaaabaaaaaaaiaaaaaa
fkaaaaadaagabaaaaaaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaagcbaaaad
mcbabaaaabaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaacafaaaaaaefaaaaaj
pcaabaaaaaaaaaaaogbkbaaaabaaaaaaeghobaaaaaaaaaaaaagabaaaaaaaaaaa
dcaaaaalbcaabaaaaaaaaaaackiacaaaabaaaaaaahaaaaaaakaabaaaaaaaaaaa
dkiacaaaabaaaaaaahaaaaaaaoaaaaakecaabaaaaaaaaaaaaceaaaaaaaaaiadp
aaaaiadpaaaaiadpaaaaiadpakaabaaaaaaaaaaadiaaaaaidcaabaaaabaaaaaa
ogbkbaaaabaaaaaaogikcaaaaaaaaaaaamaaaaaadcaaaaalmcaabaaaabaaaaaa
agaebaaaabaaaaaaagiecaaaaaaaaaaaahaaaaaakgiocaaaaaaaaaaaahaaaaaa
diaaaaahdcaabaaaaaaaaaaakgakbaaaaaaaaaaaogakbaaaabaaaaaadicaaaah
icaabaaaaaaaaaaackaabaaaaaaaaaaaabeaaaaaaohefkdldiaaaaahecaabaaa
abaaaaaadkaabaaaaaaaaaaaabeaaaaaaaaaiaedebaaaaafecaabaaaabaaaaaa
ckaabaaaabaaaaaadiaaaaahcccabaaaaaaaaaaackaabaaaabaaaaaaabeaaaaa
aaaaiadldcaaaaakeccabaaaaaaaaaaadkaabaaaaaaaaaaaabeaaaaaaaaaiaed
ckaabaiaebaaaaaaabaaaaaablaaaaafdcaabaaaabaaaaaaegaabaaaabaaaaaa
cgaaaaaiaanaaaaaicaabaaaaaaaaaaaakaabaaaabaaaaaaabeaaaaaadaaaaaa
cdaaaaajbcaabaaaabaaaaaaakaabaaaabaaaaaabkaabaaaabaaaaaabkaabaaa
abaaaaaafhaaaaahicaabaaaaaaaaaaadkaabaaaaaaaaaaaakaabaaaabaaaaaa
cgaaaaaiaanaaaaaicaabaaaaaaaaaaadkaabaaaaaaaaaaaabeaaaaaakaaaaaa
claaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaaamaaaaafhcaabaaaabaaaaaa
cgajbaaaaaaaaaaaalaaaaafhcaabaaaacaaaaaajgaebaaaaaaaaaaadiaaaaah
hcaabaaaadaaaaaaegacbaaaabaaaaaaegacbaaaacaaaaaadcaaaaakhcaabaaa
abaaaaaacgajbaaaabaaaaaajgaebaaaacaaaaaaegacbaiaebaaaaaaadaaaaaa
baaaaaahicaabaaaabaaaaaaegacbaaaabaaaaaaegacbaaaabaaaaaaeeaaaaaf
icaabaaaabaaaaaadkaabaaaabaaaaaadiaaaaahhcaabaaaabaaaaaapgapbaaa
abaaaaaaegacbaaaabaaaaaaaoaaaaajicaabaaaabaaaaaaakiacaiaebaaaaaa
aaaaaaaaagaaaaaackaabaaaaaaaaaaadgaaaaaidcaabaaaacaaaaaaaceaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaadaaaaaabcbaaaaahecaabaaaacaaaaaa
bkaabaaaacaaaaaaabeaaaaaapaaaaaaadaaaeadckaabaaaacaaaaaaclaaaaaf
ecaabaaaacaaaaaabkaabaaaacaaaaaaaaaaaaahecaabaaaacaaaaaackaabaaa
acaaaaaaabeaaaaaaaaaaadpdiaaaaahicaabaaaacaaaaaadkaabaaaabaaaaaa
ckaabaaaacaaaaaadcaaaaajecaabaaaacaaaaaackaabaaaacaaaaaaabeaaaaa
aljadleadkaabaaaaaaaaaaaenaaaaahbcaabaaaadaaaaaabcaabaaaaeaaaaaa
ckaabaaaacaaaaaadiaaaaahecaabaaaacaaaaaadkaabaaaacaaaaaaabeaaaaa
ijiiiidndgaaaaafccaabaaaaeaaaaaaakaabaaaadaaaaaadccaaaajmcaabaaa
acaaaaaakgakbaaaacaaaaaaagaebaaaaeaaaaaakgbobaaaabaaaaaaefaaaaaj
pcaabaaaadaaaaaaogakbaaaacaaaaaaeghobaaaaaaaaaaaaagabaaaaaaaaaaa
dcaaaaalbcaabaaaadaaaaaackiacaaaabaaaaaaahaaaaaaakaabaaaadaaaaaa
dkiacaaaabaaaaaaahaaaaaaaoaaaaakecaabaaaadaaaaaaaceaaaaaaaaaiadp
aaaaiadpaaaaiadpaaaaiadpakaabaaaadaaaaaadiaaaaaimcaabaaaacaaaaaa
kgaobaaaacaaaaaakgiocaaaaaaaaaaaamaaaaaadcaaaaalmcaabaaaacaaaaaa
kgaobaaaacaaaaaaagiecaaaaaaaaaaaahaaaaaakgiocaaaaaaaaaaaahaaaaaa
diaaaaahdcaabaaaadaaaaaakgakbaaaadaaaaaaogakbaaaacaaaaaaaaaaaaai
hcaabaaaadaaaaaaegacbaiaebaaaaaaaaaaaaaaegacbaaaadaaaaaabaaaaaah
ecaabaaaacaaaaaaegacbaaaadaaaaaaegacbaaaadaaaaaabaaaaaahicaabaaa
acaaaaaaegacbaaaadaaaaaaegacbaaaabaaaaaaaaaaaaajbcaabaaaadaaaaaa
ckaabaiaebaaaaaaacaaaaaabkiacaaaaaaaaaaaagaaaaaadeaaaaahbcaabaaa
adaaaaaaakaabaaaadaaaaaaabeaaaaaaaaaaaaadiaaaaahccaabaaaadaaaaaa
akaabaaaadaaaaaaakaabaaaadaaaaaadiaaaaahbcaabaaaadaaaaaaakaabaaa
adaaaaaabkaabaaaadaaaaaaaaaaaaahicaabaaaacaaaaaadkaabaaaacaaaaaa
abeaaaaaaknhcdlmaaaaaaahecaabaaaacaaaaaackaabaaaacaaaaaaabeaaaaa
aknhcddmaoaaaaahecaabaaaacaaaaaadkaabaaaacaaaaaackaabaaaacaaaaaa
deaaaaahecaabaaaacaaaaaackaabaaaacaaaaaaabeaaaaaaaaaaaaadcaaaaaj
bcaabaaaacaaaaaaakaabaaaadaaaaaackaabaaaacaaaaaaakaabaaaacaaaaaa
boaaaaahccaabaaaacaaaaaabkaabaaaacaaaaaaabeaaaaaabaaaaaabgaaaaab
diaaaaajbcaabaaaaaaaaaaaakiacaaaaaaaaaaaagaaaaaabkiacaaaaaaaaaaa
agaaaaaadiaaaaahbcaabaaaaaaaaaaaakaabaaaaaaaaaaaakaabaaaaaaaaaaa
aoaaaaahbcaabaaaaaaaaaaaakaabaaaacaaaaaaakaabaaaaaaaaaaadiaaaaai
bcaabaaaaaaaaaaaakaabaaaaaaaaaaackiacaaaaaaaaaaaagaaaaaadcaaaaak
bcaabaaaaaaaaaaaakaabaiaebaaaaaaaaaaaaaaabeaaaaaklkkkkdoabeaaaaa
aaaaiadpdeaaaaakjccabaaaaaaaaaaaagaabaaaaaaaaaaaaceaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaadoaaaaab"
}
}
 }
 Pass {
  ZTest Always
  ZWrite Off
  Cull Off
  Fog { Mode Off }
  GpuProgramID 79310
Program "vp" {
SubProgram "opengl " {
"!!GLSL
#ifdef VERTEX

varying vec2 xlv_TEXCOORD0;
varying vec2 xlv_TEXCOORD1;
void main ()
{
  vec2 tmpvar_1;
  tmpvar_1 = gl_MultiTexCoord0.xy;
  gl_Position = (gl_ModelViewProjectionMatrix * gl_Vertex);
  xlv_TEXCOORD0 = tmpvar_1;
  xlv_TEXCOORD1 = tmpvar_1;
}


#endif
#ifdef FRAGMENT
#extension GL_ARB_shader_texture_lod : enable
uniform sampler2D _MainTex;
uniform vec4 _MainTex_TexelSize;
float gaussian[5];
uniform vec2 _Axis;
uniform float _BlurFilterDistance;
varying vec2 xlv_TEXCOORD0;
void main ()
{
  gaussian[0] = 0.15317;
  gaussian[1] = 0.144893;
  gaussian[2] = 0.122649;
  gaussian[3] = 0.092902;
  gaussian[4] = 0.06297;
  float totalWeight_2;
  float sum_3;
  float key_4;
  vec2 ssC_5;
  vec4 fragment_6;
  fragment_6 = vec4(1.0, 1.0, 1.0, 1.0);
  ssC_5 = xlv_TEXCOORD0;
  vec4 tmpvar_7;
  tmpvar_7 = texture2DLod (_MainTex, xlv_TEXCOORD0, 0.0);
  vec2 tmpvar_8;
  tmpvar_8 = tmpvar_7.yz;
  key_4 = ((tmpvar_7.y * 0.9961089) + (tmpvar_7.z * 0.003891051));
  float tmpvar_9;
  tmpvar_9 = (gaussian[0] * 0.5);
  totalWeight_2 = tmpvar_9;
  sum_3 = (tmpvar_7.x * tmpvar_9);
  for (int r_1 = -4; r_1 <= 4; r_1++) {
    if ((r_1 != 0)) {
      int index_10;
      vec4 tmpvar_11;
      tmpvar_11.zw = vec2(0.0, 0.0);
      tmpvar_11.xy = (ssC_5 + ((_Axis * _MainTex_TexelSize.xy) * (
        float(r_1)
       * _BlurFilterDistance)));
      vec4 tmpvar_12;
      tmpvar_12 = texture2DLod (_MainTex, tmpvar_11.xy, 0.0);
      float tmpvar_13;
      tmpvar_13 = ((tmpvar_12.y * 0.9961089) + (tmpvar_12.z * 0.003891051));
      index_10 = r_1;
      if ((r_1 < 0)) {
        index_10 = -(r_1);
      };
      float tmpvar_14;
      tmpvar_14 = ((0.3 + gaussian[index_10]) * max (0.0, (1.0 - 
        (2000.0 * abs((tmpvar_13 - key_4)))
      )));
      sum_3 = (sum_3 + (tmpvar_12.x * tmpvar_14));
      totalWeight_2 = (totalWeight_2 + tmpvar_14);
    };
  };
  fragment_6.xw = vec2((sum_3 / (totalWeight_2 + 0.0001)));
  fragment_6.yz = tmpvar_8;
  gl_FragData[0] = fragment_6;
}


#endif
"
}
SubProgram "d3d9 " {
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 4 [_MainTex_TexelSize]
"vs_3_0
def c5, 0, -2, 1, 0
dcl_position v0
dcl_texcoord v1
dcl_position o0
dcl_texcoord o1.xy
dcl_texcoord1 o2.xy
dp4 o0.x, c0, v0
dp4 o0.y, c1, v0
dp4 o0.z, c2, v0
dp4 o0.w, c3, v0
mov r0.x, c5.x
slt r0.x, c4.y, r0.x
mad r0.y, v1.y, c5.y, c5.z
mad o2.y, r0.x, r0.y, v1.y
mov o1.xy, v1
mov o2.x, v1.x

"
}
SubProgram "d3d11 " {
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
ConstBuffer "$Globals" 224
Vector 192 [_MainTex_TexelSize]
ConstBuffer "UnityPerDraw" 336
Matrix 0 [glstate_matrix_mvp]
BindCB  "$Globals" 0
BindCB  "UnityPerDraw" 1
"vs_4_0
eefiecedmomhifcekjcppomhnkmljppeaamoobmlabaaaaaahmacaaaaadaaaaaa
cmaaaaaaiaaaaaaapaaaaaaaejfdeheoemaaaaaaacaaaaaaaiaaaaaadiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaaebaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaafaepfdejfeejepeoaafeeffiedepepfceeaaklkl
epfdeheogiaaaaaaadaaaaaaaiaaaaaafaaaaaaaaaaaaaaaabaaaaaaadaaaaaa
aaaaaaaaapaaaaaafmaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaa
fmaaaaaaabaaaaaaaaaaaaaaadaaaaaaabaaaaaaamadaaaafdfgfpfagphdgjhe
gjgpgoaafeeffiedepepfceeaaklklklfdeieefcieabaaaaeaaaabaagbaaaaaa
fjaaaaaeegiocaaaaaaaaaaaanaaaaaafjaaaaaeegiocaaaabaaaaaaaeaaaaaa
fpaaaaadpcbabaaaaaaaaaaafpaaaaaddcbabaaaabaaaaaaghaaaaaepccabaaa
aaaaaaaaabaaaaaagfaaaaaddccabaaaabaaaaaagfaaaaadmccabaaaabaaaaaa
giaaaaacabaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaa
abaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaabaaaaaaaaaaaaaa
agbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
abaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpccabaaa
aaaaaaaaegiocaaaabaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaa
dbaaaaaibcaabaaaaaaaaaaabkiacaaaaaaaaaaaamaaaaaaabeaaaaaaaaaaaaa
aaaaaaaiccaabaaaaaaaaaaabkbabaiaebaaaaaaabaaaaaaabeaaaaaaaaaiadp
dhaaaaajiccabaaaabaaaaaaakaabaaaaaaaaaaabkaabaaaaaaaaaaabkbabaaa
abaaaaaadgaaaaafhccabaaaabaaaaaaegbabaaaabaaaaaadoaaaaab"
}
}
Program "fp" {
SubProgram "opengl " {
"!!GLSL"
}
SubProgram "d3d9 " {
Vector 1 [_Axis]
Float 2 [_BlurFilterDistance]
Vector 0 [_MainTex_TexelSize]
SetTexture 0 [_MainTex] 2D 0
"ps_3_0
def c3, 1, 0, 0.996108949, 0.00389105058
def c4, -0, -1, -2, -3
def c5, 0.362969995, 2000, 1, 9.99999975e-005
def c6, 0.0765850022, 0, -4, 0.444893003
def c7, 0.453170002, 0.300000012, 0.422649026, 0.392902017
defi i0, 9, 0, 0, 0
dcl_texcoord v0.xy
dcl_2d s0
mul r0, c3.xxyy, v0.xyxx
texldl r0, r0, s0
dp2add r0.w, r0.yzzw, c3.zwzw, c3.y
mul r0.x, r0.x, c6.x
mov r1.xy, c1
mul r1.xy, r1, c0
mov r2.zw, c3.y
mov r3.x, r0.x
mov r3.yz, c6.xxzw
rep i0
if_ne r3.z, -r3.z
mul r1.z, r3.z, c2.x
mad r2.xy, r1, r1.z, v0
texldl r4, r2, s0
add r5, r3_abs.z, c4
add r1.z, r3_abs.z, c6.z
cmp r1.w, -r5_abs.x, c7.x, c7.y
cmp r1.w, -r5_abs.y, c6.w, r1.w
cmp r1.w, -r5_abs.z, c7.z, r1.w
cmp r1.w, -r5_abs.w, c7.w, r1.w
cmp r1.z, r1.z, c5.x, r1.w
dp2add r1.w, r4.yzzw, c3.zwzw, -r0.w
mad r1.w, r1_abs.w, -c5.y, c5.z
mul r1.z, r1.w, r1.z
cmp r1.z, r1.w, r1.z, c3.y
mad r3.x, r4.x, r1.z, r3.x
add r3.y, r1.z, r3.y
endif
add r3.z, r3.z, c3.x
endrep
add r0.x, r3.y, c5.w
rcp r0.x, r0.x
mul oC0.xw, r0.x, r3.x
mov oC0.yz, r0

"
}
SubProgram "d3d11 " {
SetTexture 0 [_MainTex] 2D 0
ConstBuffer "$Globals" 224
Vector 192 [_MainTex_TexelSize]
Vector 208 [_Axis] 2
Float 216 [_BlurFilterDistance]
BindCB  "$Globals" 0
"ps_4_0
eefiecedbkemjekefkpplfoglnalbfjalhbdccglabaaaaaaoaaeaaaaadaaaaaa
cmaaaaaajmaaaaaanaaaaaaaejfdeheogiaaaaaaadaaaaaaaiaaaaaafaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaafmaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaafmaaaaaaabaaaaaaaaaaaaaaadaaaaaaabaaaaaa
amaaaaaafdfgfpfagphdgjhegjgpgoaafeeffiedepepfceeaaklklklepfdeheo
cmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaa
apaaaaaafdfgfpfegbhcghgfheaaklklfdeieefcaiaeaaaaeaaaaaaaacabaaaa
dfbiaaaabgaaaaaajjnibmdoaaaaaaaaaaaaaaaaaaaaaaaanffobedoaaaaaaaa
aaaaaaaaaaaaaaaaggcppldnaaaaaaaaaaaaaaaaaaaaaaaaghedlodnaaaaaaaa
aaaaaaaaaaaaaaaagkpgiadnaaaaaaaaaaaaaaaaaaaaaaaafjaaaaaeegiocaaa
aaaaaaaaaoaaaaaafkaaaaadaagabaaaaaaaaaaafibiaaaeaahabaaaaaaaaaaa
ffffaaaagcbaaaaddcbabaaaabaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaac
aeaaaaaaeiaaaaalpcaabaaaaaaaaaaaegbabaaaabaaaaaaeghobaaaaaaaaaaa
aagabaaaaaaaaaaaabeaaaaaaaaaaaaaapaaaaakicaabaaaaaaaaaaajgafbaaa
aaaaaaaaaceaaaaappaahpdpppaahpdlaaaaaaaaaaaaaaaadiaaaaahbcaabaaa
aaaaaaaaakaabaaaaaaaaaaaabeaaaaajjnijmdndiaaaaajdcaabaaaabaaaaaa
egiacaaaaaaaaaaaamaaaaaaegiacaaaaaaaaaaaanaaaaaadgaaaaafbcaabaaa
acaaaaaaakaabaaaaaaaaaaadgaaaaaigcaabaaaacaaaaaaaceaaaaaaaaaaaaa
jjnijmdnpmppppppaaaaaaaadaaaaaabccaaaaahecaabaaaabaaaaaaabeaaaaa
aeaaaaaackaabaaaacaaaaaaadaaaeadckaabaaaabaaaaaabpaaaeadckaabaaa
acaaaaaaclaaaaafecaabaaaabaaaaaackaabaaaacaaaaaadiaaaaaiecaabaaa
abaaaaaackaabaaaabaaaaaackiacaaaaaaaaaaaanaaaaaadcaaaaajmcaabaaa
abaaaaaaagaebaaaabaaaaaakgakbaaaabaaaaaaagbebaaaabaaaaaaeiaaaaal
pcaabaaaadaaaaaaogakbaaaabaaaaaaeghobaaaaaaaaaaaaagabaaaaaaaaaaa
abeaaaaaaaaaaaaaapaaaaakecaabaaaabaaaaaajgafbaaaadaaaaaaaceaaaaa
ppaahpdpppaahpdlaaaaaaaaaaaaaaaaccaaaaahicaabaaaabaaaaaackaabaaa
acaaaaaaabeaaaaaaaaaaaaaciaaaaaficaabaaaacaaaaaackaabaaaacaaaaaa
dhaaaaajicaabaaaabaaaaaadkaabaaaabaaaaaadkaabaaaacaaaaaackaabaaa
acaaaaaaaaaaaaaiicaabaaaabaaaaaaabeaaaaajkjjjjdoakjajaaadkaabaaa
abaaaaaaaaaaaaaiecaabaaaabaaaaaadkaabaiaebaaaaaaaaaaaaaackaabaaa
abaaaaaadcaaaaakecaabaaaabaaaaaackaabaiambaaaaaaabaaaaaaabeaaaaa
aaaapkeeabeaaaaaaaaaiadpdeaaaaahecaabaaaabaaaaaackaabaaaabaaaaaa
abeaaaaaaaaaaaaadiaaaaahicaabaaaacaaaaaackaabaaaabaaaaaadkaabaaa
abaaaaaadcaaaaajbcaabaaaacaaaaaaakaabaaaadaaaaaadkaabaaaacaaaaaa
akaabaaaacaaaaaadcaaaaajccaabaaaacaaaaaadkaabaaaabaaaaaackaabaaa
abaaaaaabkaabaaaacaaaaaabfaaaaabboaaaaahecaabaaaacaaaaaackaabaaa
acaaaaaaabeaaaaaabaaaaaabgaaaaabaaaaaaahbcaabaaaaaaaaaaabkaabaaa
acaaaaaaabeaaaaabhlhnbdiaoaaaaahjccabaaaaaaaaaaaagaabaaaacaaaaaa
agaabaaaaaaaaaaadgaaaaafgccabaaaaaaaaaaafgagbaaaaaaaaaaadoaaaaab
"
}
}
 }
 Pass {
  ZTest Always
  ZWrite Off
  Cull Off
  Fog { Mode Off }
  GpuProgramID 183583
Program "vp" {
SubProgram "opengl " {
"!!GLSL
#ifdef VERTEX

varying vec2 xlv_TEXCOORD0;
varying vec2 xlv_TEXCOORD1;
void main ()
{
  vec2 tmpvar_1;
  tmpvar_1 = gl_MultiTexCoord0.xy;
  gl_Position = (gl_ModelViewProjectionMatrix * gl_Vertex);
  xlv_TEXCOORD0 = tmpvar_1;
  xlv_TEXCOORD1 = tmpvar_1;
}


#endif
#ifdef FRAGMENT
uniform sampler2D _AOTex;
uniform sampler2D _MainTex;
varying vec2 xlv_TEXCOORD0;
varying vec2 xlv_TEXCOORD1;
void main ()
{
  gl_FragData[0] = (texture2D (_MainTex, xlv_TEXCOORD0) * texture2D (_AOTex, xlv_TEXCOORD1).xxxx);
}


#endif
"
}
SubProgram "d3d9 " {
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 4 [_MainTex_TexelSize]
"vs_3_0
def c5, 0, -2, 1, 0
dcl_position v0
dcl_texcoord v1
dcl_position o0
dcl_texcoord o1.xy
dcl_texcoord1 o2.xy
dp4 o0.x, c0, v0
dp4 o0.y, c1, v0
dp4 o0.z, c2, v0
dp4 o0.w, c3, v0
mov r0.x, c5.x
slt r0.x, c4.y, r0.x
mad r0.y, v1.y, c5.y, c5.z
mad o2.y, r0.x, r0.y, v1.y
mov o1.xy, v1
mov o2.x, v1.x

"
}
SubProgram "d3d11 " {
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
ConstBuffer "$Globals" 224
Vector 192 [_MainTex_TexelSize]
ConstBuffer "UnityPerDraw" 336
Matrix 0 [glstate_matrix_mvp]
BindCB  "$Globals" 0
BindCB  "UnityPerDraw" 1
"vs_4_0
eefiecedmomhifcekjcppomhnkmljppeaamoobmlabaaaaaahmacaaaaadaaaaaa
cmaaaaaaiaaaaaaapaaaaaaaejfdeheoemaaaaaaacaaaaaaaiaaaaaadiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaaebaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaafaepfdejfeejepeoaafeeffiedepepfceeaaklkl
epfdeheogiaaaaaaadaaaaaaaiaaaaaafaaaaaaaaaaaaaaaabaaaaaaadaaaaaa
aaaaaaaaapaaaaaafmaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaa
fmaaaaaaabaaaaaaaaaaaaaaadaaaaaaabaaaaaaamadaaaafdfgfpfagphdgjhe
gjgpgoaafeeffiedepepfceeaaklklklfdeieefcieabaaaaeaaaabaagbaaaaaa
fjaaaaaeegiocaaaaaaaaaaaanaaaaaafjaaaaaeegiocaaaabaaaaaaaeaaaaaa
fpaaaaadpcbabaaaaaaaaaaafpaaaaaddcbabaaaabaaaaaaghaaaaaepccabaaa
aaaaaaaaabaaaaaagfaaaaaddccabaaaabaaaaaagfaaaaadmccabaaaabaaaaaa
giaaaaacabaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaa
abaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaabaaaaaaaaaaaaaa
agbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
abaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpccabaaa
aaaaaaaaegiocaaaabaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaa
dbaaaaaibcaabaaaaaaaaaaabkiacaaaaaaaaaaaamaaaaaaabeaaaaaaaaaaaaa
aaaaaaaiccaabaaaaaaaaaaabkbabaiaebaaaaaaabaaaaaaabeaaaaaaaaaiadp
dhaaaaajiccabaaaabaaaaaaakaabaaaaaaaaaaabkaabaaaaaaaaaaabkbabaaa
abaaaaaadgaaaaafhccabaaaabaaaaaaegbabaaaabaaaaaadoaaaaab"
}
}
Program "fp" {
SubProgram "opengl " {
"!!GLSL"
}
SubProgram "d3d9 " {
SetTexture 0 [_AOTex] 2D 0
SetTexture 1 [_MainTex] 2D 1
"ps_3_0
dcl_texcoord v0.xy
dcl_texcoord1 v1.xy
dcl_2d s0
dcl_2d s1
texld r0, v1, s0
texld r1, v0, s1
mul oC0, r0.x, r1

"
}
SubProgram "d3d11 " {
SetTexture 0 [_AOTex] 2D 0
SetTexture 1 [_MainTex] 2D 1
"ps_4_0
eefiecedhonmmkhajogncnhbhnncghjepkpfkmgiabaaaaaakmabaaaaadaaaaaa
cmaaaaaajmaaaaaanaaaaaaaejfdeheogiaaaaaaadaaaaaaaiaaaaaafaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaafmaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaafmaaaaaaabaaaaaaaaaaaaaaadaaaaaaabaaaaaa
amamaaaafdfgfpfagphdgjhegjgpgoaafeeffiedepepfceeaaklklklepfdeheo
cmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaa
apaaaaaafdfgfpfegbhcghgfheaaklklfdeieefcneaaaaaaeaaaaaaadfaaaaaa
fkaaaaadaagabaaaaaaaaaaafkaaaaadaagabaaaabaaaaaafibiaaaeaahabaaa
aaaaaaaaffffaaaafibiaaaeaahabaaaabaaaaaaffffaaaagcbaaaaddcbabaaa
abaaaaaagcbaaaadmcbabaaaabaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaac
acaaaaaaefaaaaajpcaabaaaaaaaaaaaogbkbaaaabaaaaaaeghobaaaaaaaaaaa
aagabaaaaaaaaaaaefaaaaajpcaabaaaabaaaaaaegbabaaaabaaaaaaeghobaaa
abaaaaaaaagabaaaabaaaaaadiaaaaahpccabaaaaaaaaaaaagaabaaaaaaaaaaa
egaobaaaabaaaaaadoaaaaab"
}
}
 }
 Pass {
  ZTest Always
  ZWrite Off
  Cull Off
  Fog { Mode Off }
  GpuProgramID 209739
Program "vp" {
SubProgram "opengl " {
"!!GLSL
#ifdef VERTEX

varying vec2 xlv_TEXCOORD0;
varying vec2 xlv_TEXCOORD1;
void main ()
{
  vec2 tmpvar_1;
  tmpvar_1 = gl_MultiTexCoord0.xy;
  gl_Position = (gl_ModelViewProjectionMatrix * gl_Vertex);
  xlv_TEXCOORD0 = tmpvar_1;
  xlv_TEXCOORD1 = tmpvar_1;
}


#endif
#ifdef FRAGMENT
uniform sampler2D _AOTex;
uniform sampler2D _MainTex;
uniform vec4 _MainTex_TexelSize;
varying vec2 xlv_TEXCOORD0;
varying vec2 xlv_TEXCOORD1;
void main ()
{
  float tmpvar_1;
  vec2 cse_2;
  cse_2 = (_MainTex_TexelSize.xy * 0.75);
  vec2 cse_3;
  cse_3 = (_MainTex_TexelSize.xy * vec2(-0.75, 0.75));
  tmpvar_1 = (((
    (texture2D (_AOTex, xlv_TEXCOORD1).x + texture2D (_AOTex, (xlv_TEXCOORD1 + cse_2)).x)
   + texture2D (_AOTex, 
    (xlv_TEXCOORD1 - cse_2)
  ).x) + texture2D (_AOTex, (xlv_TEXCOORD1 + cse_3)).x) + texture2D (_AOTex, (xlv_TEXCOORD1 - cse_3)).x);
  vec4 tmpvar_4;
  tmpvar_4.w = 5.0;
  tmpvar_4.x = tmpvar_1;
  tmpvar_4.y = tmpvar_1;
  tmpvar_4.z = tmpvar_1;
  gl_FragData[0] = ((texture2D (_MainTex, xlv_TEXCOORD0) * tmpvar_4) / 5.0);
}


#endif
"
}
SubProgram "d3d9 " {
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 4 [_MainTex_TexelSize]
"vs_3_0
def c5, 0, -2, 1, 0
dcl_position v0
dcl_texcoord v1
dcl_position o0
dcl_texcoord o1.xy
dcl_texcoord1 o2.xy
dp4 o0.x, c0, v0
dp4 o0.y, c1, v0
dp4 o0.z, c2, v0
dp4 o0.w, c3, v0
mov r0.x, c5.x
slt r0.x, c4.y, r0.x
mad r0.y, v1.y, c5.y, c5.z
mad o2.y, r0.x, r0.y, v1.y
mov o1.xy, v1
mov o2.x, v1.x

"
}
SubProgram "d3d11 " {
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
ConstBuffer "$Globals" 224
Vector 192 [_MainTex_TexelSize]
ConstBuffer "UnityPerDraw" 336
Matrix 0 [glstate_matrix_mvp]
BindCB  "$Globals" 0
BindCB  "UnityPerDraw" 1
"vs_4_0
eefiecedmomhifcekjcppomhnkmljppeaamoobmlabaaaaaahmacaaaaadaaaaaa
cmaaaaaaiaaaaaaapaaaaaaaejfdeheoemaaaaaaacaaaaaaaiaaaaaadiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaaebaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaafaepfdejfeejepeoaafeeffiedepepfceeaaklkl
epfdeheogiaaaaaaadaaaaaaaiaaaaaafaaaaaaaaaaaaaaaabaaaaaaadaaaaaa
aaaaaaaaapaaaaaafmaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaa
fmaaaaaaabaaaaaaaaaaaaaaadaaaaaaabaaaaaaamadaaaafdfgfpfagphdgjhe
gjgpgoaafeeffiedepepfceeaaklklklfdeieefcieabaaaaeaaaabaagbaaaaaa
fjaaaaaeegiocaaaaaaaaaaaanaaaaaafjaaaaaeegiocaaaabaaaaaaaeaaaaaa
fpaaaaadpcbabaaaaaaaaaaafpaaaaaddcbabaaaabaaaaaaghaaaaaepccabaaa
aaaaaaaaabaaaaaagfaaaaaddccabaaaabaaaaaagfaaaaadmccabaaaabaaaaaa
giaaaaacabaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaa
abaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaabaaaaaaaaaaaaaa
agbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
abaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpccabaaa
aaaaaaaaegiocaaaabaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaa
dbaaaaaibcaabaaaaaaaaaaabkiacaaaaaaaaaaaamaaaaaaabeaaaaaaaaaaaaa
aaaaaaaiccaabaaaaaaaaaaabkbabaiaebaaaaaaabaaaaaaabeaaaaaaaaaiadp
dhaaaaajiccabaaaabaaaaaaakaabaaaaaaaaaaabkaabaaaaaaaaaaabkbabaaa
abaaaaaadgaaaaafhccabaaaabaaaaaaegbabaaaabaaaaaadoaaaaab"
}
}
Program "fp" {
SubProgram "opengl " {
"!!GLSL"
}
SubProgram "d3d9 " {
Vector 0 [_MainTex_TexelSize]
SetTexture 0 [_AOTex] 2D 0
SetTexture 1 [_MainTex] 2D 1
"ps_3_0
def c1, 0.75, -0.75, 0.200000003, 1
dcl_texcoord v0.xy
dcl_texcoord1 v1.xy
dcl_2d s0
dcl_2d s1
texld r0, v1, s0
mov r1.xy, c1
mad r2, c0.xyxy, r1.xxyx, v1.xyxy
texld r3, r2, s0
texld r2, r2.zwzw, s0
add r0.x, r0.x, r3.x
mad r1, c0.xyxy, -r1.xxyx, v1.xyxy
texld r3, r1, s0
texld r1, r1.zwzw, s0
add r0.x, r0.x, r3.x
add r0.x, r2.x, r0.x
add r0.x, r1.x, r0.x
texld r1, v0, s1
mul r1.xyz, r0.x, r1
mul oC0, r1, c1.zzzw

"
}
SubProgram "d3d11 " {
SetTexture 0 [_MainTex] 2D 1
SetTexture 1 [_AOTex] 2D 0
ConstBuffer "$Globals" 224
Vector 192 [_MainTex_TexelSize]
BindCB  "$Globals" 0
"ps_4_0
eefiecedcckmoaacelohdbfpfglengibjapjdpmpabaaaaaafaadaaaaadaaaaaa
cmaaaaaajmaaaaaanaaaaaaaejfdeheogiaaaaaaadaaaaaaaiaaaaaafaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaafmaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaafmaaaaaaabaaaaaaaaaaaaaaadaaaaaaabaaaaaa
amamaaaafdfgfpfagphdgjhegjgpgoaafeeffiedepepfceeaaklklklepfdeheo
cmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaa
apaaaaaafdfgfpfegbhcghgfheaaklklfdeieefchiacaaaaeaaaaaaajoaaaaaa
fjaaaaaeegiocaaaaaaaaaaaanaaaaaafkaaaaadaagabaaaaaaaaaaafkaaaaad
aagabaaaabaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaafibiaaaeaahabaaa
abaaaaaaffffaaaagcbaaaaddcbabaaaabaaaaaagcbaaaadmcbabaaaabaaaaaa
gfaaaaadpccabaaaaaaaaaaagiaaaaacaeaaaaaaefaaaaajpcaabaaaaaaaaaaa
ogbkbaaaabaaaaaaeghobaaaabaaaaaaaagabaaaaaaaaaaadcaaaaanpcaabaaa
abaaaaaaegiecaaaaaaaaaaaamaaaaaaaceaaaaaaaaaeadpaaaaeadpaaaaealp
aaaaeadpogbobaaaabaaaaaaefaaaaajpcaabaaaacaaaaaaegaabaaaabaaaaaa
eghobaaaabaaaaaaaagabaaaaaaaaaaaefaaaaajpcaabaaaabaaaaaaogakbaaa
abaaaaaaeghobaaaabaaaaaaaagabaaaaaaaaaaaaaaaaaahbcaabaaaaaaaaaaa
akaabaaaaaaaaaaaakaabaaaacaaaaaadcaaaaaopcaabaaaacaaaaaaegiecaia
ebaaaaaaaaaaaaaaamaaaaaaaceaaaaaaaaaeadpaaaaeadpaaaaealpaaaaeadp
ogbobaaaabaaaaaaefaaaaajpcaabaaaadaaaaaaegaabaaaacaaaaaaeghobaaa
abaaaaaaaagabaaaaaaaaaaaefaaaaajpcaabaaaacaaaaaaogakbaaaacaaaaaa
eghobaaaabaaaaaaaagabaaaaaaaaaaaaaaaaaahbcaabaaaaaaaaaaaakaabaaa
aaaaaaaaakaabaaaadaaaaaaaaaaaaahbcaabaaaaaaaaaaaakaabaaaabaaaaaa
akaabaaaaaaaaaaaaaaaaaahbcaabaaaaaaaaaaaakaabaaaacaaaaaaakaabaaa
aaaaaaaaefaaaaajpcaabaaaabaaaaaaegbabaaaabaaaaaaeghobaaaaaaaaaaa
aagabaaaabaaaaaadiaaaaahhcaabaaaabaaaaaaagaabaaaaaaaaaaaegacbaaa
abaaaaaadiaaaaakpccabaaaaaaaaaaaegaobaaaabaaaaaaaceaaaaamnmmemdo
mnmmemdomnmmemdoaaaaiadpdoaaaaab"
}
}
 }
 Pass {
  ZTest Always
  ZWrite Off
  Cull Off
  Fog { Mode Off }
  GpuProgramID 321471
Program "vp" {
SubProgram "opengl " {
"!!GLSL
#ifdef VERTEX

varying vec2 xlv_TEXCOORD0;
varying vec2 xlv_TEXCOORD1;
void main ()
{
  vec2 tmpvar_1;
  tmpvar_1 = gl_MultiTexCoord0.xy;
  gl_Position = (gl_ModelViewProjectionMatrix * gl_Vertex);
  xlv_TEXCOORD0 = tmpvar_1;
  xlv_TEXCOORD1 = tmpvar_1;
}


#endif
#ifdef FRAGMENT
uniform vec4 _ZBufferParams;
uniform vec4 _ProjInfo;
uniform sampler2D _CameraDepthTexture;
uniform sampler2D _MainTex;
uniform vec4 _MainTex_TexelSize;
varying vec2 xlv_TEXCOORD0;
void main ()
{
  vec4 fragment_1;
  vec3 P_2;
  P_2.z = texture2D (_CameraDepthTexture, xlv_TEXCOORD0).x;
  float tmpvar_3;
  tmpvar_3 = (1.0/(((_ZBufferParams.z * P_2.z) + _ZBufferParams.w)));
  vec3 tmpvar_4;
  tmpvar_4.xy = (((
    (xlv_TEXCOORD0 * _MainTex_TexelSize.zw)
   * _ProjInfo.xy) + _ProjInfo.zw) * tmpvar_3);
  tmpvar_4.z = tmpvar_3;
  P_2 = tmpvar_4;
  float tmpvar_5;
  tmpvar_5 = clamp ((tmpvar_3 * 0.003333333), 0.0, 1.0);
  vec2 p_6;
  float tmpvar_7;
  tmpvar_7 = floor((tmpvar_5 * 256.0));
  p_6.x = (tmpvar_7 * 0.00390625);
  p_6.y = ((tmpvar_5 * 256.0) - tmpvar_7);
  fragment_1.yz = p_6;
  fragment_1.xw = texture2D (_MainTex, xlv_TEXCOORD0).xw;
  gl_FragData[0] = fragment_1;
}


#endif
"
}
SubProgram "d3d9 " {
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 4 [_MainTex_TexelSize]
"vs_3_0
def c5, 0, -2, 1, 0
dcl_position v0
dcl_texcoord v1
dcl_position o0
dcl_texcoord o1.xy
dcl_texcoord1 o2.xy
dp4 o0.x, c0, v0
dp4 o0.y, c1, v0
dp4 o0.z, c2, v0
dp4 o0.w, c3, v0
mov r0.x, c5.x
slt r0.x, c4.y, r0.x
mad r0.y, v1.y, c5.y, c5.z
mad o2.y, r0.x, r0.y, v1.y
mov o1.xy, v1
mov o2.x, v1.x

"
}
SubProgram "d3d11 " {
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
ConstBuffer "$Globals" 224
Vector 192 [_MainTex_TexelSize]
ConstBuffer "UnityPerDraw" 336
Matrix 0 [glstate_matrix_mvp]
BindCB  "$Globals" 0
BindCB  "UnityPerDraw" 1
"vs_4_0
eefiecedmomhifcekjcppomhnkmljppeaamoobmlabaaaaaahmacaaaaadaaaaaa
cmaaaaaaiaaaaaaapaaaaaaaejfdeheoemaaaaaaacaaaaaaaiaaaaaadiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaaebaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaafaepfdejfeejepeoaafeeffiedepepfceeaaklkl
epfdeheogiaaaaaaadaaaaaaaiaaaaaafaaaaaaaaaaaaaaaabaaaaaaadaaaaaa
aaaaaaaaapaaaaaafmaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaa
fmaaaaaaabaaaaaaaaaaaaaaadaaaaaaabaaaaaaamadaaaafdfgfpfagphdgjhe
gjgpgoaafeeffiedepepfceeaaklklklfdeieefcieabaaaaeaaaabaagbaaaaaa
fjaaaaaeegiocaaaaaaaaaaaanaaaaaafjaaaaaeegiocaaaabaaaaaaaeaaaaaa
fpaaaaadpcbabaaaaaaaaaaafpaaaaaddcbabaaaabaaaaaaghaaaaaepccabaaa
aaaaaaaaabaaaaaagfaaaaaddccabaaaabaaaaaagfaaaaadmccabaaaabaaaaaa
giaaaaacabaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaa
abaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaabaaaaaaaaaaaaaa
agbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
abaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpccabaaa
aaaaaaaaegiocaaaabaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaa
dbaaaaaibcaabaaaaaaaaaaabkiacaaaaaaaaaaaamaaaaaaabeaaaaaaaaaaaaa
aaaaaaaiccaabaaaaaaaaaaabkbabaiaebaaaaaaabaaaaaaabeaaaaaaaaaiadp
dhaaaaajiccabaaaabaaaaaaakaabaaaaaaaaaaabkaabaaaaaaaaaaabkbabaaa
abaaaaaadgaaaaafhccabaaaabaaaaaaegbabaaaabaaaaaadoaaaaab"
}
}
Program "fp" {
SubProgram "opengl " {
"!!GLSL"
}
SubProgram "d3d9 " {
Vector 0 [_ZBufferParams]
SetTexture 0 [_CameraDepthTexture] 2D 0
SetTexture 1 [_MainTex] 2D 1
"ps_3_0
def c1, 0.00333333341, 256, 0.00390625, 0
dcl_texcoord v0.xy
dcl_2d s0
dcl_2d s1
texld r0, v0, s0
mad r0.x, c0.z, r0.x, c0.w
rcp r0.x, r0.x
mul_sat r0.x, r0.x, c1.x
mul r0.y, r0.x, c1.y
frc r0.z, r0.y
add r0.y, -r0.z, r0.y
mul oC0.y, r0.y, c1.z
mad oC0.z, r0.x, c1.y, -r0.y
texld r0, v0, s1
mov oC0.xw, r0

"
}
SubProgram "d3d11 " {
SetTexture 0 [_CameraDepthTexture] 2D 0
SetTexture 1 [_MainTex] 2D 1
ConstBuffer "UnityPerCamera" 144
Vector 112 [_ZBufferParams]
BindCB  "UnityPerCamera" 0
"ps_4_0
eefiecedijibedojkfamodpldjkldjnjlpkofjfhabaaaaaaimacaaaaadaaaaaa
cmaaaaaajmaaaaaanaaaaaaaejfdeheogiaaaaaaadaaaaaaaiaaaaaafaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaafmaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaafmaaaaaaabaaaaaaaaaaaaaaadaaaaaaabaaaaaa
amaaaaaafdfgfpfagphdgjhegjgpgoaafeeffiedepepfceeaaklklklepfdeheo
cmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaa
apaaaaaafdfgfpfegbhcghgfheaaklklfdeieefcleabaaaaeaaaaaaagnaaaaaa
fjaaaaaeegiocaaaaaaaaaaaaiaaaaaafkaaaaadaagabaaaaaaaaaaafkaaaaad
aagabaaaabaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaafibiaaaeaahabaaa
abaaaaaaffffaaaagcbaaaaddcbabaaaabaaaaaagfaaaaadpccabaaaaaaaaaaa
giaaaaacabaaaaaaefaaaaajpcaabaaaaaaaaaaaegbabaaaabaaaaaaeghobaaa
aaaaaaaaaagabaaaaaaaaaaadcaaaaalbcaabaaaaaaaaaaackiacaaaaaaaaaaa
ahaaaaaaakaabaaaaaaaaaaadkiacaaaaaaaaaaaahaaaaaaaoaaaaakbcaabaaa
aaaaaaaaaceaaaaaaaaaiadpaaaaiadpaaaaiadpaaaaiadpakaabaaaaaaaaaaa
dicaaaahbcaabaaaaaaaaaaaakaabaaaaaaaaaaaabeaaaaaaohefkdldiaaaaah
ccaabaaaaaaaaaaaakaabaaaaaaaaaaaabeaaaaaaaaaiaedebaaaaafccaabaaa
aaaaaaaabkaabaaaaaaaaaaadcaaaaakeccabaaaaaaaaaaaakaabaaaaaaaaaaa
abeaaaaaaaaaiaedbkaabaiaebaaaaaaaaaaaaaadiaaaaahcccabaaaaaaaaaaa
bkaabaaaaaaaaaaaabeaaaaaaaaaiadlefaaaaajpcaabaaaaaaaaaaaegbabaaa
abaaaaaaeghobaaaabaaaaaaaagabaaaabaaaaaadgaaaaafjccabaaaaaaaaaaa
agambaaaaaaaaaaadoaaaaab"
}
}
 }
}
Fallback Off
}