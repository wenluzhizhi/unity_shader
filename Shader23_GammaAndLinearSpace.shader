Shader "Custom/GammaAndLinearSpace_1" {
   properties{
       _MainTex("MianTex",2D)="green"{}
       _Test("test",float)=2.2
       _Color("Main Color",Color)=(1,1,1,1)

       _Ra("fd",Range(0,1))=0.5
   }
   Subshader{
      tags{"RenderType"="Opaque"}

      Pass{
         tags{"LightMode"="ForwardBase"}
         CGPROGRAM
         #pragma vertex vert
         #pragma fragment frag
         #include "Unitycg.cginc"
         #include "Lighting.cginc"


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
            o.pos=mul(UNITY_MATRIX_MVP,v.vertex);
            o.uv=v.texcoord.xy;
            return o;


         }
         float _Test;
          float4 Linear2Gamma(float4 c){
             return pow(c,1.0/_Test);
         }

         float4 Gamma2Linear(float4 c){
             return pow(c,_Test);
         }

         sampler2D _MainTex;
         float _Ra;
         fixed4 frag(v2f i):SV_Target
         {
            float4 c=tex2D(_MainTex,i.uv);
             if(_Ra<0.5){
                return Gamma2Linear(c);
             }
             else if(_Ra>0.8){
                return Linear2Gamma(c);
             } 
             else{
               return c;
             }
            
         }

        


         ENDCG
      }
   }
}
