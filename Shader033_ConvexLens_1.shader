Shader "Custom/ConvexLens" {
    Properties{
       _MainTex("MainTex",2D)="white"{}
       _Center("Center Point",Vector)=(1,1,1,1)
    }

    SubShader{
       CGINCLUDE
       #include "unitycg.cginc"

       struct a2v{
         float4 vertex:POSITION;
         float4 texcoord:TEXCOORD;
       };

       struct v2f{
          float4 pos:SV_POSITION;
          float2 uv:TEXCOORD1;
       };

       sampler2D _MainTex;
       float4 _MainTex_ST;
       float4 _MainTex_TexelSize;
       float4 _Center;
       v2f vert(a2v v){
         v2f o;
         o.pos=mul(UNITY_MATRIX_MVP,v.vertex);
         o.uv=_MainTex_ST.xy*v.texcoord.xy+_MainTex_ST.zw;
         return o;
       }

       fixed4 frag(v2f i):SV_Target{
          fixed4 col=fixed4(1,1,1,1);


          float2 c=float2(_Center.x,_Center.y);

          float dis=distance(c,i.uv);

          float2 uv2=i.uv;
          float R1=0.4;
           if(dis<R1){
             uv2.x=c.x+(i.uv.x-c.x)*dis/R1;
             uv2.y=c.y+(i.uv.y-c.y)*dis/R1  ;
           }

          col=tex2D(_MainTex,uv2);
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
