Shader "Unlit/WaterReferaction"
{
	Properties
	{
		_WaveTex("Wave ", 2D) = "white" {}
	}
	SubShader
	{
		Tags{ "Queue" = "Transparent" "RenderType" = "Opaque" }

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			// make fog work
			#pragma multi_compile_fog

			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float4 vertex : POSITION;
				float4 uvgrab : TEXCOORD1;
				float2 uvmain : TEXCOORD2;
			};

			sampler2D _WaveTex;
			sampler2D _GrabTex;
			float4 _WaveTex_ST;
			float4 _GrabTex_TexelSize;

			v2f vert(appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				#if UNITY_UV_STARTS_AT_TOP
								float scale = -1.0;
				#else
								float scale = 1.0;
				#endif
				o.uvgrab.xy = (float2(o.vertex.x, o.vertex.y*scale) + o.vertex.w) * 0.5;
				o.uvgrab.zw = o.vertex.zw;
				o.uvmain = TRANSFORM_TEX(v.uv, _WaveTex);
				UNITY_TRANSFER_FOG(o,o.vertex);
				return o;
			}

			fixed4 frag(v2f i) : SV_Target
			{
				// sample the texture
				fixed2 offset = tex2D(_WaveTex, i.uvmain + _Time.x);
			offset.xy = offset.xx;
				offset += _GrabTex_TexelSize.xy;
				i.uvgrab.xy = offset*i.uvgrab.z + i.uvgrab.xy;
				i.uvgrab.xy = i.uvgrab.xy/i.uvgrab.w;
				half4 col = tex2D(_GrabTex, i.uvgrab)
				// apply fog
				UNITY_APPLY_FOG(i.fogCoord, col);
				//col.r = 1.0;
				return col;
			}
			ENDCG
		}
	}
}
