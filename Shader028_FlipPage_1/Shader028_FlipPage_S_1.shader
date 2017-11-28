Shader "Custom/Shader028_FlipPage_S_1" {
	properties{
	  _MainColor("MainColor",Color)=(1,1,1,1)
	  _MainTex("Main Tex",2D)="white"{}
	  _MainTex2("Main Tex",2D)="white"{}
	}

	subShader{

	     pass{

	          CGPROGRAM
	          #pragma vertex vert
	          #pragma fragment frag
	          #include "unitycg.cginc"


	          sampler2D _MainTex;
	          float4 _MainTex_ST;
	          fixed4 _MainColor;
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
	               col=tex2D(_MainTex,i.uv);
	               return col;
	          }


	          ENDCG
	     }


	      pass{


	          cull front
	          CGPROGRAM
	          #pragma vertex vert
	          #pragma fragment frag
	          #include "unitycg.cginc"


	          sampler2D _MainTex2;
	          float4 _MainTex2_ST;
	          fixed4 _MainColor;
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
	              o.uv=v.texcoord.xy*_MainTex2_ST.xy+_MainTex2_ST.zw;
	              return o;
	          }


	          fixed4 frag(v2f i):SV_Target{
	               fixed4 col;
	               col=tex2D(_MainTex2,i.uv);
	               return col;
	          }


	          ENDCG
	     }

	}
	FallBack "Diffuse"
}
