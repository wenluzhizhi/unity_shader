Shader "Custom/Shadere030_fluxay" {
	properties{
	  _MainColor("MainColor",Color)=(1,1,1,1)

	  _MainTex("Main Tex",2D)="white"{}
	   _MainTex2("Main Tex",2D)="white"{}
	  _Bump("Bump",2D)="Bump"{}
	}

	subShader{
		 tags{"queue"="transparent" "rendereType"="transparent"}
	     pass{
	          cull off
		      //Blend srcalpha oneminusSrcalpha 
	          CGPROGRAM
	          #pragma vertex vert
	          #pragma fragment frag
	          #include "unitycg.cginc"


	          sampler2D _MainTex;
	          sampler2D _MainTex2;
	          float4 _MainTex_ST;
	          fixed4 _MainColor;
	          sampler2D _Bump;
	          struct a2v{
	             float4 vertex:POSITION;
	             float4 texcoord:TEXCOORD;
	          };

	          struct v2f{
	              float4 pos:SV_POSITION;
	              float2 uv:TEXCOORD1;
	          };


	          v2f vert(a2v v){
	              v2f o;
	              o.pos=mul(UNITY_MATRIX_MVP,v.vertex);
	              o.uv=v.texcoord.xy*_MainTex_ST.xy+_MainTex_ST.zw;
	              return o;
	          }


	          fixed4 frag(v2f i):SV_Target{
	               fixed4 col;

	                float2 uv2=i.uv;
	                float2 uv3=i.uv;
	                  float2 uv4=i.uv;
	                uv2.y+=_Time.x*2;
	                uv3.y+=_Time.x*5;
	                   uv4.y+=_Time.x*6;
	                   uv4.x+=_Time.x;
	               float4 f1=tex2D(_MainTex2,uv2);
	               float4 f2=tex2D(_MainTex2,uv3);
	               float4 f3=tex2D(_MainTex2,uv4);

	               col=tex2D(_MainTex,i.uv)+f1+f2+f3;
	               //col.a=col.r;
	               return col;
	          }


	          ENDCG
	     }
	}
	FallBack "Diffuse"
}
