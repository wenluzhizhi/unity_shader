Shader "Custom/myShader_1" {
	properties{
	  _Tess("Tessellation",Range(1,32))=4
	  _MainTex("MainTex",2D)="white"{}
	  _DispTex("Disp texture",2D)="gray"{}
	  _NormalMap("Normal Map",2D)="bump"{}
	  _Color("Color",Color)=(1,1,1,1)
	  _SpecColor("Specular color",Color)=(1,1,1,1)
	  _disR("disR",Range(0,8))=1
	}
	Subshader{
	   tags{"RenderType"="Opaque"}
	   LOD 300
	   CGPROGRAM
	   #pragma surface surf BlinnPhong vertex:disp tessellate:tessFixed


	   #pragma target 5.0

	   struct appdata{
	      float4 vertex:POSITION;
	      float4 tangent:TANGENT;
	      float3 normal:NORMAL;
	      float2 texcoord:TEXCOORD0;
	   };
	   sampler2D _MainTex;
	   sampler2D _NormalMap;
	   struct Input{
	      float2 uv_MainTex;
	   };

	   float _Tess;
	   float4 tessFixed(){
	      return _Tess;
	   }

	   float _disR;
	   void disp(inout appdata v){

	      v.vertex.y+=sin(v.vertex.x*_Time.x);
	      v.vertex.xyz+=v.normal*_disR;
	   }

	   void surf(Input IN,inout SurfaceOutput o){
	       
	      half4 c=tex2D(_MainTex,IN.uv_MainTex);
	      o.Albedo=c.rgb;
	      o.Specular=0.2;
	      o.Gloss=1.0;
	      o.Normal=UnpackNormal(tex2D(_NormalMap,IN.uv_MainTex));
	   }



	   ENDCG

	}
}
