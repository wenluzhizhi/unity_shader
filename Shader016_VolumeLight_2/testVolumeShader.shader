Shader "Custom/testVolumeShader" {
   properties{
     _Extrusion("",Range(0,30))=2
   }
   SubShader{


      tags{"Queue"="Transparent" "RenderType"="Transparent"}

      pass{

         Tags{"LightMode"="ForwardBase"}

         Material{Diffuse(1,1,1,1)}
         Lighting On
      }




      pass{
          Blend srcAlpha oneMinusSrcAlpha
          CGPROGRAM
          #pragma vertex vert
          #pragma fragment frag
          #include "unitycg.cginc"


          uniform float4 _LightPosition;
          float _Extrusion;
          struct a2v{
             float4 vertex:POSITION;
             float3 normal:NORMAL;
          };


          struct v2f{
             float4 pos:SV_POSITION;
          };


          v2f vert(a2v v){
             v2f o;

             float4 objLightPos=(_World2Object,_LightPosition);

             float3 toLight=normalize(objLightPos.xyz-v.vertex.xyz*objLightPos.w);

             float backFactor=dot(toLight,v.normal);

             float extrude=(backFactor<0.0)?1.0:0.0;

             v.vertex.xyz+=toLight*(extrude*_Extrusion);


             o.pos=mul(UNITY_MATRIX_MVP,v.vertex);
             return o;             
          }

          fixed4 frag(v2f i):SV_Target{
             fixed4 col;
             col=fixed4(1,1,1,0.5);
             return col;
          }

          ENDCG
      }
   }
}
