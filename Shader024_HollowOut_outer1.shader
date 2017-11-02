Shader "Custom/Shader024_HollowOut_Outer_1" {
	
	Properties
	{
	   _MainColor("MainColor",Color)=(1,1,1,1)
	   _SpeColor("Specular Color",Color)=(1,1,1,1)
	   _SpeGloss("Gloss",Range(2,32))=8
	}
	Subshader{
	 tags{"RenderType"="Transparent" "Queue"="Transparent+8"}
	 pass
	 {

	  
	     stencil
         {
	        Ref 1
	        comp greater
	        pass replace
	     }


	      //cull off
	      Zwrite off
	      Blend srcAlpha oneminussrcalpha
	      CGPROGRAM
	      #pragma vertex vert
	      #pragma fragment frag
	      #include "unitycg.cginc"
	      #include "Lighting.cginc"
	      //#pragma multi_compile_fwdbase

	      struct a2v{
	         float4 vertex:POSITION;
	         float3 normal:NORMAL;
	      };


	      struct v2f{
	          float4 pos:SV_POSITION;
	          float3 worldNormal:TEXCOORD0;
	          float3 worldLitDir:TEXCOORD1;
	          float3 worldViewDir:TEXCOORD2;
	      };


	      v2f vert(a2v v){
	        v2f o;
	        o.pos=mul(UNITY_MATRIX_MVP,v.vertex);
	        o.worldNormal=normalize(mul(v.normal,(float3x3)_World2Object));
	        o.worldLitDir=normalize(_WorldSpaceLightPos0.xyz);
	        o.worldViewDir=normalize(_WorldSpaceCameraPos.xyz);
	        return o;
	      }
	      float _SpeGloss;
	      float4 _SpeColor;
	      fixed4 frag(v2f i):SV_Target{
	         fixed4 col=fixed4(1,1,1,1);
	         col.rgb*=_LightColor0.rgb;
	         float diffuse_value=dot(i.worldNormal,i.worldLitDir)*0.5+0.5;
	         float3 h=normalize(i.worldViewDir+i.worldLitDir);

	         float spe_value=pow(max(0,dot(h,i.worldNormal)),_SpeGloss);
	         float3 ambient=UNITY_LIGHTMODEL_AMBIENT.rgb;
	         col.rgb=col.rgb*diffuse_value+_SpeColor.rgb*spe_value+ambient;
	        
	         return col;
	      }


	      ENDCG
	   }

//	   pass
//	   {
//
//	     
//
//
//
//
//	     stencil
//         {
//	        Ref 2
//	        comp greater
//	        pass replace
//	     }
//
//
//	      //cull off
//	      Zwrite off
//	      Blend srcAlpha oneminussrcalpha
//	      CGPROGRAM
//	      #pragma vertex vert
//	      #pragma fragment frag
//	      #include "unitycg.cginc"
//	      #include "Lighting.cginc"
//	      //#pragma multi_compile_fwdbase
//
//	      struct a2v{
//	         float4 vertex:POSITION;
//	         float3 normal:NORMAL;
//	      };
//
//
//	      struct v2f{
//	          float4 pos:SV_POSITION;
//	          float3 worldNormal:TEXCOORD0;
//	          float3 worldLitDir:TEXCOORD1;
//	          float3 worldViewDir:TEXCOORD2;
//	      };
//
//
//	      v2f vert(a2v v){
//	        v2f o;
//	        o.pos=mul(UNITY_MATRIX_MVP,v.vertex);
//	        o.worldNormal=normalize(mul(v.normal,(float3x3)_World2Object));
//	        o.worldLitDir=normalize(_WorldSpaceLightPos0.xyz);
//	        o.worldViewDir=normalize(_WorldSpaceCameraPos.xyz);
//	        return o;
//	      }
//	      float _SpeGloss;
//	      float4 _SpeColor;
//	      fixed4 frag(v2f i):SV_Target{
//	         fixed4 col=fixed4(1,1,1,1);
//	         col.rgb*=_LightColor0.rgb;
//	         float diffuse_value=dot(i.worldNormal,i.worldLitDir)*0.5+0.5;
//	         float3 h=normalize(i.worldViewDir+i.worldLitDir);
//
//	         float spe_value=pow(max(0,dot(h,i.worldNormal)),_SpeGloss);
//	         float3 ambient=UNITY_LIGHTMODEL_AMBIENT.rgb;
//	         col.rgb=col.rgb*diffuse_value+_SpeColor.rgb*spe_value+ambient;
//	         return col;
//	      }
//
//
//	      ENDCG
//	   }


//	    pass
//	    {
//
//
//	      tags{"RenderType"="Opaque" "Queue"="Geometry"  "LightMode"="ForwardAdd"}
//	      CGPROGRAM
//	      #pragma vertex vert
//	      #pragma fragment frag
//	      #include "unitycg.cginc"
//	       #include "Lighting.cginc"
//	      #pragma multi_compile_fwdadd
//
//	      struct a2v{
//	         float4 vertex:POSITION;
//	         float3 normal:NORMAL;
//	      };
//
//
//	      struct v2f{
//	          float4 pos:SV_POSITION;
//	          float3 worldNormal:TEXCOORD0;
//	          float3 worldLitDir:TEXCOORD1;
//	          float3 worldViewDir:TEXCOORD2;
//	      };
//
//
//	      v2f vert(a2v v){
//	        v2f o;
//	        o.pos=mul(UNITY_MATRIX_MVP,v.vertex);
//	        o.worldNormal=normalize(mul(v.normal,(float3x3)_World2Object));
//	        o.worldLitDir=normalize(_WorldSpaceLightPos0.xyz);
//	        o.worldViewDir=normalize(_WorldSpaceCameraPos.xyz);
//	        return o;
//	      }
//	      float _SpeGloss;
//	      float4 _SpeColor;
//	      fixed4 frag(v2f i):SV_Target{
//	         fixed4 col=fixed4(1,1,1,1);
//	         col.rgb*=_LightColor0.rgb;
//	         float diffuse_value=dot(i.worldNormal,i.worldLitDir)*0.5+0.5;
//	         float3 h=normalize(i.worldViewDir+i.worldLitDir);
//
//	         float spe_value=pow(max(0,dot(h,i.worldNormal)),_SpeGloss);
//
//	         col.rgb=col.rgb*diffuse_value+_SpeColor.rgb*spe_value;
//	         return col;
//	      }
//
//
//	      ENDCG
//	   }
	}
}
