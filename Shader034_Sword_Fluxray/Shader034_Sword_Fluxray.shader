Shader "Custom/Shader034_Sword_Fluxray" {

     properties{
        _MainTex("MainTex",2D)="white"{}
        _Ramp("Ramp",2D)="white"{}
        _Mask("Mask",2D)="white"{}
        _Bump("Bump",2D)="Bump"{}
     }
     Subshader{
         Tags {
			"Queue"="Transparent" 
			"IgnoreProjector"="True" 
			"RenderType"="Transparent"
			}
           Pass{

                  Blend SrcAlpha OneMinusSrcAlpha
                 CGPROGRAM
                 #pragma vertex vert
                 #pragma fragment frag
                 #include "unitycg.cginc"

                 sampler2D _MainTex;
                 sampler2D _Mask;
                 sampler2D _Ramp;
                 sampler2D _Bump;
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
                    o.pos=UnityObjectToClipPos(v.vertex);
                    o.uv=v.texcoord.xy;
                    return o;
                  
                 }

                 fixed4 frag(v2f i):SV_Target{
                     fixed4 col=fixed4(1,1,1,1);
                     col=tex2D(_MainTex,i.uv);
                     fixed4 col2=tex2D(_Mask,i.uv);

                     float2 u1=col2.rg;

                     float4 noise=tex2D(_Bump,i.uv);

                     float2 u2=u1+float2(-0.2,0)*_Time.y+noise.rg*0.04;
                     fixed4 col3=tex2D(_Ramp,u2);
                     return col*(1-col2.a)+col3*col2.a;

                 }

                 ENDCG
           }
     }
}
