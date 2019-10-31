// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'
// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'

Shader "Custom/InteractionShader"
{
   Properties{
       _CenterColor("CenterColor", Color) = (1,1,0,1)
       _RimColor("RimColor", Color) = (1,1,1,1)
       _pow("range",float) = 2
       _NoiseTexture("No",2D) ="white"{}
   }
   SubShader{
        tags{"Queue"="Transparent" "RenderType"="Transparent"}
       pass{
          
           Blend srcAlpha oneminusSrcalpha
           CGPROGRAM


           #pragma vertex vert
           #pragma fragment frag
           #include "unitycg.cginc"

           sampler2D _CameraDepthTexture;  //_CameraDepthTexture
           sampler2D _GrabText;
           sampler2D _NoiseTexture;
           struct a2v{
               float4 vertex:POSITION;
               float4 normal:NORMAL;
               float4 texcoord:TEXCOORD;
           };


           struct v2f{
               float4 pos:SV_POSITION;
               float4 screenUV:TEXCOORD0;
               float3 worldNormalDir:TEXCOORD1;
               float3 worldViewDir:TEXCOORD2;
               float4 screenPos:TEXCOORD3;
               float2 uv :TEXCOORD4;
           };

           v2f vert(a2v v){
               v2f o;
               o.pos = UnityObjectToClipPos(v.vertex);

              o.worldNormalDir = mul(v.normal, unity_WorldToObject).xyz;
              float3 worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
              o.worldViewDir = (_WorldSpaceCameraPos.xyz - worldPos).xyz;

              o.screenPos=ComputeScreenPos(o.pos);//获取投影点对应的屏幕坐标点
              COMPUTE_EYEDEPTH(o.screenPos.z);


              o.screenUV.xy = (float2(o.pos.xy) + o.pos.w)*0.5;
              o.screenUV.zw = o.pos.zw;
              COMPUTE_EYEDEPTH(o.screenUV.z);

              o.uv = v.texcoord.xy;
              return o;
           }

           fixed4 _CenterColor;
           fixed4 _RimColor;
           float _pow;

           fixed4 frag(v2f i):SV_Target{
               i.worldNormalDir = normalize(i.worldNormalDir);
               i.worldViewDir = normalize(i.worldViewDir);

               float dotNV =clamp(dot(i.worldNormalDir, i.worldViewDir) *_pow, 0, 1);
               fixed4 col = fixed4(1,1,1,1);

               float2 vd = i.screenPos.xy / i.screenPos.w;
               i.uv.x +=sin(_Time.x*8+i.uv.y);
               i.uv.y +=cos(_Time.x*9+i.uv.x);
               float4 nt = tex2D(_NoiseTexture, i.uv);
               
               float d_z=LinearEyeDepth(SAMPLE_DEPTH_TEXTURE_PROJ(_CameraDepthTexture,i.screenPos));

              float d2 = i.screenPos.z;

              float d3 = abs(d2 - d_z);
              d3 = max(dotNV, d3);

              float d3Max = 1.0 - min(1, d3);

              vd.x += nt.x * nt.y * d3Max * nt.y *0.08;
              vd.y += nt.y * nt.y * d3Max * nt.x *0.08;
              fixed4 sc = tex2D(_GrabText, vd);
              col = _RimColor * (1 - dotNV) + sc * dotNV;
           
            

               return col;
           }

           ENDCG
       }
   }
}
