// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'

// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/myShader" {
	Properties{
	   _Range("Rim Range",Range(0,1))=0.1
	   _RimColor("rim color",Color)=(1,1,1,1)
	   _DiffuseColor("DiffuseColor",Color)=(1,1,1,1)
	}
	SubShader{

	     pass{

	         CGPROGRAM

	         #pragma vertex vert
	         #pragma fragment frag

	         #include "unitycg.cginc"

	         float _Range;
	         fixed4 _RimColor;
	         fixed4 _DiffuseColor;
	         struct a2v{
	           float4 vertex:POSITION;
	           float4 normal:NORMAL;
	         };


	         struct v2f{

                  float4 Pos:SV_POSITION;
                  float3 normal:NORMAL;
                  float3 worldViewDir:TEXCOORD0;
                  float3 worldLightDir:TEXCOORD1;
	         };

	         v2f vert(a2v v)
	         {
	             v2f o;
	            
	             o.Pos=mul(UNITY_MATRIX_MVP,v.vertex);
	             o.worldViewDir=normalize(_WorldSpaceCameraPos.xyz-v.vertex.xyz);
	             o.normal=normalize(mul(v.normal,_World2Object).xyz);
	             o.worldLightDir=normalize(_WorldSpaceLightPos0.xyz);
	             return o;
	           
	         }

	         fixed4 frag(v2f i):SV_Target{

                 fixed4 col;
                 col=fixed4(1,1,0,1);
                 float dot_value=dot(i.normal,i.worldViewDir);
                 col.rgb=_DiffuseColor.rgb*(dot(i.normal,i.worldLightDir)*0.5 +0.5);
                 if(dot_value<_Range)
                 {
                    col=_RimColor;
                 }
                 return col;
	         }


	         ENDCG
	     }
	}
}
