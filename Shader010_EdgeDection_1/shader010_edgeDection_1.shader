Shader "Custom/shader010_edgeDection_1" {
	Properties{
	   _MainTex("Main Tex",2D)="whiet"{}
	   _EdgeOnly("Edge Only",Range(0,1))=1.0
	   _EdgeColor("Edge Color",Color)=(1,1,1,1)
	  
	}
	SubShader{
	    pass{
	        CGPROGRAM
	        #pragma vertex vert
	        #pragma fragment frag
	        #include "unitycg.cginc"

	        sampler2D _MainTex;
	        uniform half4 _MainTex_TexelSize;
	        half4 _EdgeColor;
	        float _EdgeOnly;
	        struct a2v{
	          float4 vertex:POSITION;
	          float4 texcoord:TEXCOORD0;
	        };

	        struct v2f{
	           float4 pos:SV_POSITION;
	           float2 UV[9]:TEXCOORD0;
	            
	        };


	        v2f vert(a2v v){
	           v2f o;
	           o.pos=mul(UNITY_MATRIX_MVP,v.vertex);
	           half2 uv2=v.texcoord.xy;
	           o.UV[0]=uv2+_MainTex_TexelSize.xy*half2(-1,1);
	           o.UV[1]=uv2+_MainTex_TexelSize.xy*half2(0,1);
	           o.UV[2]=uv2+_MainTex_TexelSize.xy*half2(1,1);

	           o.UV[3]=uv2+_MainTex_TexelSize.xy*half2(-1,0);
	           o.UV[4]=uv2+_MainTex_TexelSize.xy*half2(0,0);
	           o.UV[5]=uv2+_MainTex_TexelSize.xy*half2(1,0);


	           o.UV[6]=uv2+_MainTex_TexelSize.xy*half2(-1,1);
	           o.UV[7]=uv2+_MainTex_TexelSize.xy*half2(0,1);
	           o.UV[8]=uv2+_MainTex_TexelSize.xy*half2(1,1);


	           return o;
	        }

	        fixed4 lunminance(fixed4 c){ //计算颜色的亮度：
	           return 0.2125*c.r+0.7154*c.g+0.0721*c.b;
	        }

	        fixed4 frag(v2f i):SV_Target{
	           fixed4 col=tex2D(_MainTex,i.UV[4]);
	           col=fixed4(1,1,1,1);


	           const half Gx[9]={-1,0,1,
	                            -2,0,2,
	                            -1,0,1};

	           const half Gy[9]={-1,-2,-1,
	                             0,0,0,
	                             1,2,1};


	               
	           half texColor;
	           half edgeX=0;
	           half edgeY=0;
	
	           for(int it=0;it<9;it++)
	           {
	              
	              texColor=lunminance(tex2D(_MainTex,i.UV[it]));
	              edgeX+=texColor*Gx[it];
	              edgeY+=texColor*Gy[it];
	             
	           }

	           float edge=1-abs(edgeX)-abs(edgeY);
	           fixed4 screenTex=tex2D(_MainTex,i.UV[4]);
	           fixed4 withEdgeColor=lerp(_EdgeColor,screenTex,edge);
	           if(edge>_EdgeOnly){
	             return screenTex;
	           }
	           else{
	             return _EdgeColor;
	           }

	        }


	        ENDCG
	    }
	}
}
