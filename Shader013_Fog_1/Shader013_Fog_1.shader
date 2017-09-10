Shader "Custom/TestFog_1" {
	properties{
	   _MainTex("Main Texture",2D)="white"{}
	   _Gloss("Gloss",Range(0,1))=0.5
	   _FogColor("Fog Color",Color)=(1,1,1,1)
	   _Noise("Noise Texture",2D)="white"{}
	   _Speed("fog speed",Range(0,20))=5
	}
	SubShader{
	   pass{
	         //ColorMask B
	         CGPROGRAM
	         #pragma vertex vert
	         #pragma fragment frag
	         #include "unitycg.cginc"

	         uniform sampler2D _MainTex;
	         float4 _MainTex_ST;
	         uniform sampler2D _CameraDepthTexture;


	         uniform sampler2D _Noise;

	         float4 _Noise_ST;

	         fixed4 _FogColor;
	         float _Gloss;
	         float _Speed;
	         struct a2v{
	           float4 vertex:POSITION;
	           float4 texcoord:TEXCOORD;
	         };

	         struct v2f{
	           float4 pos:SV_POSITION;
	           float2 uv:TEXCOORD0;
	           float2 noiseUV:TEXCOORD1;
	         };

	         v2f vert(a2v v){
	            v2f o;
	            o.pos=mul(UNITY_MATRIX_MVP,v.vertex);
	            o.uv=v.texcoord.xy*_MainTex_ST.xy+_MainTex_ST.zw;
	            o.noiseUV=v.texcoord.xy*_Noise_ST.xy+_Noise_ST.zw;
	            return o;
	         }

	         fixed4 frag(v2f i):SV_Target{
	            fixed4 col;
	            col=tex2D(_MainTex,i.uv);
	            i.uv.y=1-i.uv.y;
	            float linearDepth=Linear01Depth(SAMPLE_DEPTH_TEXTURE(_CameraDepthTexture,i.uv));

	            i.noiseUV.x+=sin(_Time.x)*_Speed;
	            i.noiseUV.y-=cos(_Time.x)*_Speed;
	            float n=tex2D(_Noise,i.noiseUV);
	            col.rgb = lerp(col.rgb, _FogColor.rgb, linearDepth*n.r);
	            //col.r=1;
	            //col=fixed4(1,1,1,1);
	            return col;
	         }

	         ENDCG
	   }
	}
}
