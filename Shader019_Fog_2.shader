Shader "Custom/MyFog_1" {
   properties{
      _Color("Main Color",Color)=(1,1,1,1)
      _Specular("Specular color",Color)=(1,1,1,1)
      _Gloss("Gloss",Range(2,64))=5
      _Selector("change factor",Range(0,1))=0.1

   }
   Subshader{

        pass{
            tags{"LightMode"="ForwardBase"}
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile_fwdbase
            #pragma multi_compile_fog
            #include "unitycg.cginc"

            fixed4 _Color;
            float _Selector;

            float _Gloss;
            fixed4 _Specular;


            struct a2v{
               float4 vertex:POSITION;
               float3 normal:NORMAL;
            };

            struct v2f{
               float4 pos:SV_POSITION;
               float3 worldPos:TEXCOORD0;
               float3 worldNormal:TEXCOORD1;
               float3 worldLitDir:TEXCOORD2;

               float3 worldViewDir:TEXCOORD3;
        
            };


            v2f vert(a2v v){
              v2f o;
              o.pos=mul(UNITY_MATRIX_MVP,v.vertex);
              o.worldPos=mul(_Object2World,v.vertex).xyz;
              o.worldNormal=mul(v.normal,(float3x3)_World2Object);

              o.worldViewDir=(_WorldSpaceCameraPos.xyz-o.worldPos.xyz);
              o.worldLitDir=(_WorldSpaceLightPos0.xyz);
              return o;
            }

            fixed4 frag(v2f i):SV_Target{
               fixed4 col;
               fixed4 c1=unity_FogColor;
               float viewDis=length( _WorldSpaceCameraPos-i.worldPos);
               UNITY_CALC_FOG_FACTOR(viewDis);


               //漫反射
               float3 worldNormal=normalize(i.worldNormal);
               float3 worldLitDir=normalize(i.worldLitDir);
               float diffuse_value=dot(worldNormal,worldLitDir)*0.5+0.5; //half lambert

               _Color.rgb=_Color.rgb*diffuse_value;


               //高光反射
               float3 r=reflect(-worldLitDir,worldNormal);


               float sp_value=  pow( max(0,dot(r,normalize(i.worldViewDir))),_Gloss);


               _Color.rgb+=_Specular.rgb*sp_value;
               if(_Selector>0.2){
                 col=_Color;
               }
               else{
                 col=lerp(unity_FogColor,_Color,unityFogFactor);
               }

               return col;
            }

            ENDCG
        }
   }
}
