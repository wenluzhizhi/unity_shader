Shader "Custom/MianT1" {
	Properties {
		
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
	    _MaskColor("Mask Color",Color)=(1,1,1,1)
		
	}
	SubShader
	 {
	    pass{

	        ZTest Greater
	        CGPROGRAM

	        #pragma vertex vert
	        #pragma fragment frag

	        sampler2D _MainTex;
	        fixed4 _MaskColor;
	        struct a2v{
	           float4 vertex:POSITION;
	           float4 texcoord:TEXCOORD;
	        };


	        struct v2f{
	           float4 pos:SV_POSITION;
	           float2 uv:TEXCOORD1;
	        };

	        v2f vert(a2v v){
	           v2f o;
	           o.pos=mul(UNITY_MATRIX_MVP,v.vertex);
	           o.uv=v.texcoord.xy;
	           return o;
	        }

	        fixed4 frag(v2f i):SV_Target{

                fixed4 col;
                col=_MaskColor;
                return col;
	        }

	        ENDCG
	     }


	      
	     pass{

	       ZTest less
	        CGPROGRAM

	        #pragma vertex vert
	        #pragma fragment frag

	        sampler2D _MainTex;

	        struct a2v{
	           float4 vertex:POSITION;
	           float4 texcoord:TEXCOORD;
	        };


	        struct v2f{
	           float4 pos:SV_POSITION;
	           float2 uv:TEXCOORD1;
	        };

	        v2f vert(a2v v){
	           v2f o;
	           o.pos=mul(UNITY_MATRIX_MVP,v.vertex);
	           o.uv=v.texcoord.xy;
	           return o;
	        }

	        fixed4 frag(v2f i):SV_Target{

                fixed4 col;
                col=tex2D(_MainTex,i.uv);
                return col;
	        }

	        ENDCG
	     }

	 }
	
}
