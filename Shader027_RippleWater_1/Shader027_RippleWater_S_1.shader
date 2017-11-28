Shader "Custom/Shader027_RippleWater_S_1" {



   
	properties{
	   _MainTex("RefractionTex",2D)="bump"{}
	   _BumpMap("NormalMap",2D)="white"{}
	   _Scale("Scale",Range(0,100))=1
	   _uv1("Rd",Range(0,1))=0.5
	}
	Subshader{
	    pass{
	        CGPROGRAM
	        #pragma vertex vert
	        #pragma fragment frag
	        #include "unitycg.cginc"


	        sampler2D _MainTex;
	        float4 _MainTex_ST;
	        float4 _MainTex_TexelSize;
	        sampler2D _BumpMap;
	        float4 _BumpMap_ST;
	        float _Scale;


	        struct a2v{
	           float4 vertex:POSITION;
	           float4 texcoord:TEXCOORD;
	        };

	        struct v2f{
	           float4 pos:SV_POSITION;
	           float2 uv:TEXCOORD1;
	           float2 buv:TEXCOORD2;
	        };



	        v2f vert(a2v v){
	            v2f o;
	            o.pos=mul(UNITY_MATRIX_MVP,v.vertex);
	            o.uv=_MainTex_ST.xy*v.texcoord.xy+_MainTex_ST.zw;
	            o.buv=_BumpMap_ST.xy*v.texcoord.xy+_BumpMap_ST.zw;
	            return o;
	        }

	        float _uv1;
	        fixed4 frag(v2f i):SV_Target
	        {
	            fixed4 col=fixed4(1,1,1,1);

	            float2 offset=float2(0,0);
	            float2 uv2=i.uv;
	            uv2.y=1-uv2.y;
	            float b=tex2D(_BumpMap, uv2).g;
	            offset=_MainTex_TexelSize.xy*b*_Scale;
	            
	             
	            col=tex2D(_MainTex,i.uv+offset)+fixed4(1,0,0,0)*b;
	           // col=fixed4(bump,1);
	            return col;
	        }


	        ENDCG
	    }
	}
}
