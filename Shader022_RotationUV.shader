Shader "Custom/RotationUV_1" {
	Properties{
	   _MainTex("Base(2D)",2D)="white"{}
	   _RotationSpeed("Rotation Speed",float)=2.0
	}
	Subshader{
	  Tags{"RenderType"="Opaque"}
	  LOD 200

	  CGPROGRAM
	  #pragma surface surf Lambert vertex:vert

	  sampler2D _MainTex;
	  struct Input{
	     float2 uv_MainTex;
	  };


	  float _RotationSpeed;


	  void vert(inout appdata_full v){
	     float sinX=sin(_RotationSpeed*_Time);
	     float cosX=cos(_RotationSpeed*_Time);
	     float sinY=sin(_RotationSpeed*_Time);

	     float2x2 roM=float2x2(cosX,-sinX,sinY,cosX);


	     v.texcoord.xy=mul(v.texcoord.xy,roM);
	  }


	  void surf(Input IN,inout SurfaceOutput o){
	      half4 c=tex2D(_MainTex,IN.uv_MainTex);
	      o.Albedo=c.rgb;
	      o.Alpha=c.a;
	  }
	  ENDCG
	}
}
