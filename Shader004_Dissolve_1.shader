Shader "Custom/Shader004_Dissolve_1" {
	properties{

	   _MainTex("MainTex",2D)="white"{}
	   _DissolveTex("DissolveTex",2D)="white"{}
	   _DissolveRange("dissolve Range",Range(0,1))=0.1
	}
	subShader{
     	//Tags { "RenderType"="Opaque" "Queue"="Geometry"}

	   pass{
	    //Tags { "LightMode"="ForwardBase" }

			Cull Off
         CGPROGRAM
          #pragma vertex vert
          #pragma fragment frag
          #include "unitycg.cginc"


          sampler2D _MainTex;
          sampler2D _DissolveTex;

          float4 _MainTex_ST;
          float4 _DissolveTex_ST;

          float _DissolveRange;

          struct a2v{
             float4 vertex:POSITION;
             float4 texcoord:TEXCOORD;
          };

          struct v2f{
              float4 pos:SV_POSITION;
              float2 uv_main:TEXCOORD0;
              float2 uv_burn:TEXCOORD1;
          };

          v2f vert(a2v v){
              v2f o;
              o.pos=mul(UNITY_MATRIX_MVP,v.vertex);
              o.uv_main=v.texcoord.xy*_MainTex_ST.xy+_MainTex_ST.zw;
              o.uv_burn=v.texcoord.xy*_DissolveTex_ST.xy+_DissolveTex_ST.zw;
              return o;
          }


          fixed4 frag(v2f i):SV_Target{

              fixed4 MainColor;
              fixed4 BurnColor;

              fixed4 col=fixed4(1,1,0,1);

              MainColor=tex2D(_MainTex,i.uv_main);
              BurnColor=tex2D(_DissolveTex,i.uv_burn);
             
              float x1= BurnColor.r-_DissolveRange;
              clip(x1);
              if(x1<0.1){

                   if(x1<0.03){
                     return MainColor*fixed4(0,0,0,1);
                   }
                   return MainColor*fixed4(1,0,0,1);
              }
              return MainColor;
               
          }

          ENDCG

	   }
	}
}
