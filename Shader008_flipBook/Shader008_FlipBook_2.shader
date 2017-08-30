Shader "Custom/VF_Shader_1" {

     Properties
     {
       _MainTex("MainTex",2D)="white"{}
       _BackTex("BackTex",2D)="white"{}
       _CurPageAngle("CurpageAngle",Range(0,1))=0
     }
     SubShader{


            Tags{"RenderType"="Opaque"}

            CGINCLUDE
            #include "unitycg.cginc"

            #define pi 3.1415



            sampler2D _MainTex;
            float4 _MainTex_ST;

            sampler2D _BackTex;
            float4 _BackTex_ST;

            float _CurPageAngle;


            struct a2v{
               float4 vertex:POSITION;
               float4 texcoord:TEXCOORD;
            };

            struct v2f{
                float4 pos:SV_POSITION;
                float2 mainUV:TEXCOORD0;
                float2 backUV:TEXCOORD1;
            };

            float4 flip_book(float4 vertex){
              float theta=_CurPageAngle*pi;
              float4 temp=vertex;

              float flipCurve = exp(-0.1 * pow(vertex.x - 0.5, 2)) * _CurPageAngle;

			  theta += flipCurve;


             temp.x = vertex.x * cos(clamp(theta, 0, pi));
			 temp.y = vertex.x * sin(clamp(theta, 0, pi));
              return temp;
            }

            v2f vert(a2v v){
               v2f o;
               o.mainUV=v.texcoord.xy*_MainTex_ST.xy+_MainTex_ST.zw;
               o.backUV=v.texcoord.xy*_BackTex_ST.xy+_BackTex_ST.zw;
               v.vertex=o.mainUV.x<0.5?flip_book(v.vertex):v.vertex;
               o.pos=mul(UNITY_MATRIX_MVP,v.vertex);
              
               return o;
            }

            v2f vert2(a2v v){
               v2f o;
               
               o.backUV=v.texcoord.xy*_BackTex_ST.xy+_BackTex_ST.zw;
               o.pos=mul(UNITY_MATRIX_MVP,v.vertex);
              
               return o;
            }


            fixed4 frag(v2f i):SV_Target{
               fixed4 col;
               i.mainUV.x=1-i.mainUV.x;
               i.mainUV.y=1-i.mainUV.y;
               col=tex2D(_MainTex,i.mainUV);
               return col;
            }

             fixed4 frag2(v2f i):SV_Target{
               fixed4 col;
               //i.backUV.x=1-i.backUV.x;
               i.backUV.y=1-i.backUV.y;
               col=tex2D(_BackTex,i.backUV);
               return col;
            }

            fixed4 frag3(v2f i):SV_Target{
               fixed4 col;
                i.backUV.x=1-i.backUV.x;
                i.backUV.y=1-i.backUV.y;
               col=tex2D(_BackTex,i.backUV);
               return col;
            }
         
            ENDCG

            pass
            {
               
               CGPROGRAM
               #pragma vertex vert
               #pragma fragment frag
               ENDCG
            }



            pass
            {
                Offset -1, -1
               cull front
               CGPROGRAM
               #pragma vertex vert
               #pragma fragment frag2
               ENDCG
            }

            pass
            {


               Offset 1,1
               CGPROGRAM
               #pragma vertex vert2
               #pragma fragment frag3
               ENDCG
            }
     }
}
