Shader "Custom/Shader045_PointShape_1"
{
    properties {
        _MainTex("Main Texuture", 2D) = "white" {}
    }
    Subshader {
        pass {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma geometry geom
            #include "UnityCG.cginc"
            
            sampler2D _MainTex;
            float4 _MainTex_ST;
            struct a2v {
                float4 pos:POSITION;
                float2 uv:TEXCOORD0;
            };

            struct v2f {
                float4 pos:SV_POSITION;
                float2 uv:TEXCOORD0;
            };


            v2f vert(a2v v) {
                v2f o;
                o.pos = UnityObjectToClipPos(v.pos);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            [maxvertexcount(1)]
            void geom(triangle v2f IN[3], inout PointStream<v2f> pointStream) {
                v2f o;
                
                for(uint i = 0; i < 3; i++) {
                    o.pos = IN[i].pos;
                    o.uv = IN[i].uv;
                    pointStream.Append(o);
                } 
                
            }

            fixed4 frag(v2f i) :SV_Target {
                fixed4 col = fixed4(1.0, 1.0, 1.0, 1.0);
                col = tex2D(_MainTex, i.uv);
                return col;
            }
            ENDCG
        }
    }
}
