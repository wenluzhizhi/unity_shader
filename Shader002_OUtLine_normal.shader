// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'

Shader "Custom/OUtLine_normal" {
	Properties{

	 _Range("Rim Range",Range(0,1))=0.1
	 _DiffuseColor("Diffuse Color",Color)=(1,1,1,1)
	 _RimColor("rim color",Color)=(1,1,1,1)


	}
	subShader
	{
	   pass
	   {
	       cull front
	       CGPROGRAM
	       #pragma vertex vert
	       #pragma fragment frag
	       #include "unitycg.cginc"


	       float _Range;
	       fixed4 _RimColor;
	      
	       struct a2v{
	         float4 vertex:POSITION;
	         float4 normal:NORMAL;
	       };

	       struct v2f{
	          float4 Pos:SV_POSITION;
	          float3 normal:TEXCOORD0;
	       };

	       v2f vert(a2v v){
	          v2f o;

	          float4 V_POS=mul(UNITY_MATRIX_MV,v.vertex);
	          o.normal=mul(UNITY_MATRIX_IT_MV,v.normal).xyz;

	          V_POS.xyz+=normalize(o.normal)*_Range;

	          o.Pos=mul(UNITY_MATRIX_P,V_POS);
	          return o;

	       }

	       fixed4 frag(v2f i):SV_Target{
	          return _RimColor;
	       }
	       ENDCG

	       }




	    pass
	    {



	       cull Back
	     
	       CGPROGRAM
	       #pragma vertex vert
	       #pragma fragment frag
	       #include "unitycg.cginc"


	       float _Range;
	       fixed4 _DiffuseColor;
	       struct a2v{
	         float4 vertex:POSITION;
	         float4 normal:NORMAL;
	       };

	       struct v2f{
	          float4 Pos:SV_POSITION;
	          float3 normal:TEXCOORD0;
	          float3 worldLightDir:TEXCOORD1;
	          float3 worldViewDir:TEXCOORD2;
	       };

	       v2f vert(a2v v){
	          v2f o;
	          o.worldViewDir=(_WorldSpaceCameraPos- v.vertex).xyz;
	          o.worldLightDir=(_WorldSpaceLightPos0.xyz);
	          float4 V_POS=mul(UNITY_MATRIX_MV,v.vertex);
	          o.Pos=mul(UNITY_MATRIX_P,V_POS);
	          o.normal=mul(v.normal,_World2Object).xyz;
	         
	          return o;

	       }

	       fixed4 frag(v2f i):SV_Target
	       {

	          float3 viewDir=normalize(i.worldViewDir);
	          float3 lightDir=normalize(i.worldLightDir);
	          fixed3 col=_DiffuseColor.rgb*(dot(i.worldLightDir,i.normal)*0.5+0.5);
	          fixed3 c1=UNITY_LIGHTMODEL_AMBIENT.xyz;
	          return fixed4(col+c1,1);
	       }
	       ENDCG

	        
	   }
	














	        
	   }


}
