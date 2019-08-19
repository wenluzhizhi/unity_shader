Shader "Custom/MyTessellation"
{
    properties{
        _Tess ("Tessellation", Range(1,32)) = 4
      _MainTex("main texutre", 2D) = "white"{}
      _DispTex("Disp Texture", 2D) = "gray"{}
      _NormalMap("Normal Map", 2D) = "bump"{}
      _Displacement("Displacement Range", Range(0, 1.0)) = 0.3
      _Color("Main Color", Color) = (1,1,1,1)
      _SpecColor("Spec Color", Color) = (1,1,1,1)
    }
    Subshader{
       

       Tags{"RenderType" = "opaque"}
       LOD 300

       CGPROGRAM
       #pragma surface surf BlinnPhong addShadow fullforwardshadows vertex:disp tessellate:tessFixed
       #pragma target 4.6
float _Tess;
float4 tessFixed()
            {
                return _Tess;
            }

       struct appdata{
          float4 vertex:POSITION;
          float4 tangent:TANGENT;
          float4 texcoord:TEXCOORD0;
          float3 normal:Normal;
       };

       sampler2D _MainTex;
       sampler2D _NormalMap;
       sampler2D _DispTex;
       float _Displacement;


       void disp(inout appdata v){
           float d = tex2Dlod(_DispTex, float4(v.texcoord.xy, 0 ,0)).r * _Displacement;
           v.vertex.xyz += v.normal * d;
       }


      

       struct Input{
           float2 uv_MainTex;
       };

       void surf(Input In, inout SurfaceOutput o){
           half4 c = tex2D(_MainTex, In.uv_MainTex);
           o.Albedo = c.rgb;
           o.Specular = 0.8;
           o.Gloss = 32.0;
           o.Normal = UnpackNormal(tex2D(_NormalMap, In.uv_MainTex));
       }


       ENDCG
    }
}
