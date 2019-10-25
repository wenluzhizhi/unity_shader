Shader "Custom/RippleWater"
{
    Properties{
      _Scale("Scale",float)=0.01
    }
    SubShader{
        pass{


            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frg
            #include "unitycg.cginc"


            sampler2D _GrabTex1;
            sampler2D _BumpMap;
            float _Scale;
            struct a2v{
               float4 vertex:POSITION;
               float4 texcoord:TEXCOORD;
            };


            struct v2f{
               float4 position:SV_POSITION;
               float2 uv:TEXCOORD0;
               float4 grabUV:TEXCOORD1;
            };

            v2f vert(a2v v){
               v2f o;
               o.position = UnityObjectToClipPos(v.vertex);
               o.grabUV.xy = (float2(o.position.x, o.position.y) + o.position.w) * 0.5;
               o.grabUV.zw = o.position.zw;
               o.uv = v.texcoord.xy;
               return o;
            }

            fixed4 frg(v2f i):SV_Target{
                fixed4 col = fixed4(1, 0, 0, 1);
                i.grabUV.xy = i.grabUV.xy / i.grabUV.w;
                float a = tex2D(_BumpMap, i.uv).r;

                i.grabUV.xy += a * _Scale;

                col = tex2D(_GrabTex1, i.grabUV.xy);
                return col;
            }



            ENDCG
        }
    }
}
