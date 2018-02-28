Shader "Custom/Shader035_waver_fire2" 
{
	properties{
	    _MainTex("Main Texture",2D)="white"{}
	    _Tex("Noise texture",2D)="white"{}
	    _SmokeTex("Smoke texture",2D)="white"{}
	    _Dot("Dot",2D)="white"{}
	}
	Subshader{
	    tags{"Queue"="Transparent"}
	    pass{

	       Blend srcAlpha oneminusSrcalpha
	       CGPROGRAM
	       #pragma vertex vert
	       #pragma fragment frag
	       #include "unitycg.cginc"

	       struct a2v{
	         float4 vertex:POSITION;
	         float4 texcoord:TEXCOORD;
	       };

	       sampler2D _MainTex;
	       float4 _MainTex_ST;
	       sampler2D _SmokeTex;
	       sampler2D _Tex;
	       sampler2D _Dot;
	       struct v2f{
	           float4 pos:SV_POSITION;
	           float2 uv:TEXCOORD0;
	       };


	       v2f vert(a2v v){
	          v2f o;
	          o.pos=UnityObjectToClipPos(v.vertex);

	          o.uv=v.texcoord.xy*_MainTex_ST.xy+_MainTex_ST.zw;
	          return o;
	       }

	       fixed4 frag(v2f i):SV_Target{
	          fixed4 result=fixed4(0,0,0,0);

	          float2 smokeUV=i.uv;
			  smokeUV.y-=_Time.y;
	          fixed4 smokeT=tex2D(_SmokeTex, smokeUV);

	          float2 mainUV=i.uv;
			  mainUV.xy += smokeT.rg*0.1;
	          fixed4 mainT=tex2D(_MainTex, mainUV);
			  mainT = mainT*mainT;

			  result = mainT + smokeT*mainT.a;

			  clip(result.a-0.3);
	          return  result;
	       }



	       ENDCG
	    }
	}
}
