Shader "Custom/SphereShadow_1_T" {
	properties{
	  _Extrusion ("Extrusion", Range(0,30)) = 5.0
	  _MainColor("MainColor",Color)=(1,1,1,1)
	}
	SubShader{
	   tags{"Queue"="Transparent" "RenderType"="Transparent"}
	   Pass{

	      Blend srcAlpha oneminusSrcAlpha
	      CGPROGRAM
	      #pragma vertex vert
	      #pragma fragment frag
	      #include "unitycg.cginc"

	      float _Extrusion;
	      struct a2v{
	         float4 vertex:POSITION;
	         float3 normal:NORMAL;
	      };


	      fixed4 _MainColor;
	      struct v2f{
	         float4 pos:SV_POSITION;
	      };


	      v2f vert(a2v v){
	        v2f o;
	       float4 worldLightPos=_WorldSpaceLightPos0;
	       //float4 worldLightPos=UnityWorldSpaceLightPos();
	        float4 objLightPos = mul(_World2Object,worldLightPos);
	        float3 toLight = normalize(objLightPos.xyz - v.vertex.xyz * objLightPos.w);
	         float backFactor = dot( toLight, v.normal );
	         float extrude = (backFactor < 0.0) ? 1.0 : 0.0;
	         v.vertex.xyz -= toLight * (_Extrusion*extrude);
	         o.pos=mul( UNITY_MATRIX_MVP, v.vertex );
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
}
