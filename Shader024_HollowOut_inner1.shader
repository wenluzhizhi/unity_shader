Shader "Custom/Shader024_HollowOut_inner1" {
	properties{
	  _MainColor("MainColor",Color)=(1,1,1,1)
	  _MainTex("Main Tex",2D)="white"{}
	}

	subShader{
	     tags{"RenderType"="Transparent" "Queue"="Transparent-5"}
	      stencil
         {
	        Ref 2
	        comp greater
	        pass replace
	     }
	     pass{
	          
	          Zwrite off
	          Blend SrcAlpha  oneminusSrcalpha
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
	               col=_MainColor;
	               return col;
	          }


	          ENDCG
	     }
	}
	FallBack "Diffuse"
}
