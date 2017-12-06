Shader "Custom/point_obj" {
	properties{
	    _MainTex("Texture",2D)="white"{}
	    _Range("expRange",Range(0,1))=0
	}
    SubShader{

           pass{

                CGPROGRAM
                #pragma vertex vert
                #pragma fragment frag
                #pragma geometry geom
                #include "unitycg.cginc"

                sampler2D _MainTex;
                float4 _MainTex_ST;
                float _Range;
                struct a2v{
                  float4 vertex:POSITION;
                  float4 texcoord:TEXCOORD;
                  float3 normal:NORMAL;
                };


                 struct v2g{
                    float4 vertex:POSITION;
                    float4 uv:TEXCOORD;
                    float3 normal:NORMAL;
                 };

                struct g2f{
                   float4 pos:SV_POSITION;
                   float2 uv:TEXCOORD;

                };

                v2g vert(a2v v){
                  v2g o;
                  //o.pos=mul(UNITY_MATRIX_MVP,v.vertex);
                  //o.uv=v.texcoord.xy*_MainTex_ST.xy+_MainTex_ST.zw;
                  o.vertex=v.vertex;
                  o.uv=v.texcoord;
                  o.normal=v.normal;
                  return o;
                }

                [maxvertexcount(1)]
                void geom(triangle v2g IN[3],inout PointStream<g2f> pointStream){

                   for(int i=0;i<3;i++){
                      g2f o;

                      //float3 nor=mul(IN[i].normal,(float3x3)_World2Object);
                      //IN[i].vertex+=float4(nor*_Range,1);


                      IN[i].vertex+=float4(_Range*IN[i].normal,1);


                      o.pos=mul(UNITY_MATRIX_MVP,IN[i].vertex);
                      o.uv=IN[i].uv.xy;
                      pointStream.Append(o);
                   }
                  
                }




                fixed4 frag(g2f i):SV_Target{
                   fixed4 col=fixed4(1,1,1,1);
                   col=tex2D(_MainTex,i.uv);
                   return col;
                }

                ENDCG
           }
    }
}
