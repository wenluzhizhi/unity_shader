Shader "Custom/TestShader0913_1" {
	properties{

	   _RimStrenth("Rim Strenth",Range(0,1))=0.1
	}
	SubShader{


	      CGINCLUDE
	      #include "unitycg.cginc"


	      struct a2v{

	         float4 vertex:POSITION;
	          float3 normal:NORMAL;
	      };

	      struct v2f{
	         float4 pos:SV_POSITION;
	        
	      };

	      v2f vert_p1(a2v v){
	         v2f o;
	         o.pos=mul(UNITY_MATRIX_MVP,v.vertex);
	         return o;
	      }


	     float _RimStrenth;
	      v2f vert_p2(a2v v){
	        v2f o;

	        o.pos=mul(UNITY_MATRIX_MV,v.vertex);

	        float3 viewNormal=mul((float3x3)UNITY_MATRIX_IT_MV,v.vertex.xyz);

	         o.pos.xyz+=viewNormal*_RimStrenth;
	         o.pos=mul(UNITY_MATRIX_P,o.pos);
	        return o;
	      }

	    
	      fixed4 frag(v2f i):SV_Target{
	         fixed4 col;
	         col=fixed4(0,1,1,1);
	         return col;
	      }

	       fixed4 frag_P2(v2f i):SV_Target{
	         fixed4 col;
	         col=fixed4(1,0,0,1);
	         return col;
	      }

	      ENDCG

	       pass{

	          cull front
	          CGPROGRAM
              #pragma vertex vert_p2
              #pragma fragment frag_P2
              ENDCG
	      }


	      pass{

	          
	          CGPROGRAM
              #pragma vertex vert_p1
              #pragma fragment frag
              ENDCG
	      }
	}
}
