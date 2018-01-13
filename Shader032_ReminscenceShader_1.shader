Shader "Custom/Remini" {
	properties{
	   _MainTex("MainTex",2D)="white"{}
	   _Range("Reminscence",Range(0,1))=0.5
	}
	Subshader{

	   CGINCLUDE
	   #include"unitycg.cginc"


	   sampler2D _MainTex;
	   float4 _MainTex_ST;
	   float _Range;
	   struct a2v{
	     float4 vertex:POSITION;
	     float4 texcoord:TEXCOORD;
	   };

	   struct v2f{
	      float4 pos:SV_POSITION;
	      float2 uv:TEXCOORD0;
	   };

	   v2f vert(a2v v){
	     v2f o;
	     o.pos=mul(UNITY_MATRIX_MVP,v.vertex);
	     o.uv=v.texcoord.xy;
	     return o;
	   }

	   fixed4 frag(v2f i):SV_Target{
	      fixed4 col=fixed4(1,1,1,1);

	      col=tex2D(_MainTex,i.uv);


	      fixed4 c1;
	      c1.r=0.393*col.r+0.769*col.g+0.189*col.b;
	      c1.g=0.349*col.r+0.686*col.g+0.168*col.b;
	      c1.b=0.272*col.r+0.534*col.g+0.131*col.b;

	      c1.w=1;
	      if(i.uv.x>_Range){
	        return col;
	      }
	      return c1;

	   }

	   ENDCG

	   pass{
		   CGPROGRAM
		   #pragma vertex vert
		   #pragma fragment frag
		   ENDCG
	   }
	}
}
