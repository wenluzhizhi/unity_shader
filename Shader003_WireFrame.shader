Shader "Custom/Shader003_WireFrame" {
	Properties{
	   _lineWidth("LineWidth",Range(0,1))=0.1

	   _lineColor("lineColor",Color)=(1,1,1,1)
	   _innerColor("innerColor",Color)=(1,0,1,1)
	}
	SubShader{

	   pass{

            Tags{"RenderType"="Transparent"}
            Blend SrcAlpha OneMinusSrcAlpha 
            //AlphaTest Greater 0.5
            //cull off
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "unitycg.cginc"

            struct a2v{
              float4 vertex:POSITION;
              float4 texcoord:TEXCOORD;
            };

            float _lineWidth;
            fixed4 _innerColor;
            fixed4 _lineColor;
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

                float sx=step(_lineWidth,i.uv.x);
                float ex=step(i.uv.x,1-_lineWidth);
                float sy=step(_lineWidth,i.uv.y);
                float ey=step(i.uv.y,1-_lineWidth);
                fixed4 ree;
                ree=lerp(_lineColor,_innerColor,sx*ex*ey*sy);
                return ree;
            }
            ENDCG
	   }
	}
}
