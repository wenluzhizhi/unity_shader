Shader "Custom/Shader007_DynamicWater" {
	properties{
	  _MainColor("MainColor",Color)=(1,1,1,1)
	  _MainTex("Main Tex",2D)="white"{}
	  _BumpTex("Bump Map",2D)="Bump"{}
	 _WaveStenth("wave strenth",Range(0,0.5))=0.1
	}

	subShader{

	     tags{"Queue"="Transparent" "RenderType"="Transparent"}
	     GrabPass{"_GrabTex"}
	     pass{

	          //Blend srcAlpha OneMinusSrcAlpha
	          CGPROGRAM
	          #pragma vertex vert
	          #pragma fragment frag
	          #include "unitycg.cginc"
	          float _WaveStenth;
	          sampler2D _GrabTex;
	          sampler2D _MainTex;
	          float4 _MainTex_ST;
	          fixed4 _MainColor;
	          sampler2D _BumpTex;
	          float4 _BumpTex_ST;
	          struct a2v{
	             float4 vertex:POSITION;
	             float4 texcoord:TEXCOORD;
	          };

	          struct v2f{
	              float4 pos:SV_POSITION;
	              float2 uv:TEXCOORD1;
	              float4 screenPos:TEXCOORD2;
	              float2 bumpTex_uv:TEXCOORD3;
	          };


	          v2f vert(a2v v){
	              v2f o;
	              o.pos=mul(UNITY_MATRIX_MVP,v.vertex);
	              o.uv=v.texcoord.xy*_MainTex_ST.xy+_MainTex_ST.zw;
	              o.screenPos=ComputeGrabScreenPos(o.pos);
	              o.bumpTex_uv=_BumpTex_ST.xy*v.texcoord.xy+_BumpTex_ST;
	              return o;
	          }


	          fixed4 frag(v2f i):SV_Target
	          {
	               fixed4 col;
	               fixed4 bump=tex2D(_BumpTex,i.bumpTex_uv+_Time.xx);
	               i.screenPos.xy+=bump.xy;
	               fixed4 prt=tex2Dproj(_GrabTex,i.screenPos);
	               col=prt+_MainColor;
	               return col;
	          }


	          ENDCG
	     }
	}
}
