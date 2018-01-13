Shader "Custom/ReliefShader01" {
	properties{
	    _MainTex("MainTex",2D)="white"{}
	}
	Subshader{
	    CGINCLUDE
	    #include "unitycg.cginc"

	    struct a2v{
	      float4 vertex:POSITION;
	      float4 texcoord:TEXCOORD;
	    };

	    sampler2D _MainTex;
	    float4 _MainTex_ST;
	    float4 _MainTex_TexelSize;
	    struct v2f{
	       float4 pos:SV_POSITION;
	       float2 uv:TEXCOORD0;
	    };


	    v2f vert(a2v v){
	       v2f o;
	       o.pos=mul(UNITY_MATRIX_MVP,v.vertex);
	       o.uv=v.texcoord.xy*_MainTex_ST.xy+_MainTex_ST.zw;
	       return o;
	    }


	    fixed4 frag(v2f i):SV_Target{
	       fixed4 col=fixed4(1,1,1,1);
	       col=tex2D(_MainTex,i.uv);

	       float2 upLeft=i.uv+float2(-_MainTex_TexelSize.x,_MainTex_TexelSize.y);
	        float2 rightBottom=i.uv+float2(_MainTex_TexelSize.x,-_MainTex_TexelSize.y);

	        col=tex2D(_MainTex,upLeft)-tex2D(_MainTex,rightBottom)+0.5;      
	       return col;
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
