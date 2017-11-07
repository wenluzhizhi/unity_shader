Shader "Custom/ShaderScanImage" {
   Properties{
      _MainTex("MainTex",2D)="white"{}
      _Gloss("Gloss",Range(0,360))=0
      _burnSize("BurnSize",Range(1,20))=1
   }
   Subshader{

       pass{
        
         

              CGPROGRAM
              #pragma vertex vert
              #pragma fragment frag
              #include "unitycg.cginc"


              struct a2v{
                 float4 vertex:POSITION;
                 float4 texcoord:TEXCOORD;
              };

              struct v2f{
                 float4 pos:SV_POSITION;
                 float2 uv:TEXCOORD0;
              };


              sampler2D _MainTex;
              float4 _MainTex_ST;
              half4 _MainTex_TexelSize;
              v2f vert(a2v v){
                 v2f o;
                 o.pos=mul(UNITY_MATRIX_MVP,v.vertex);
                 o.uv=v.texcoord.xy*_MainTex_ST.xy+_MainTex_ST.zw;
                 return o;
              }
             
              float _Gloss;
              float _burnSize;
              fixed4 frag(v2f i):SV_Target{
                  fixed4 col=fixed4(1,1,1,1);
                  col=tex2D(_MainTex,i.uv);

                  float _x;
                  float _y;
                  //float ra=radians(_Gloss);
                  float ra=radians(_Time.y*320);

                  _y=cos(ra);
                  _x=sin(ra);
                

                  _y=_y*0.5f;
                  _x=_x*0.5f;


                  float2 uv2=i.uv-0.5f;

                  float2 v1=float2(_x,_y);

                  float d1=dot(v1,uv2)/(length(v1)*length(uv2));


                  half2 u1=i.uv;

                



                   float weight[3]={0.4026,0.2442,0.0545};
                  if(d1<-0.95&&length(uv2)<0.5)
                  {



                  _burnSize=(-0.95-d1)/0.05*_burnSize;

                  half2 u_n_x_l2=i.uv-float2(_MainTex_TexelSize.x*2,0)*_burnSize;
                  half2 u_n_x_l1=i.uv-float2(_MainTex_TexelSize.x,0)*_burnSize;


                   half2 u_n_x_r2=i.uv+float2(_MainTex_TexelSize.x*2,0)*_burnSize;
                   half2 u_n_x_r1=i.uv+float2(_MainTex_TexelSize.x,0)*_burnSize;




                   half2 u_n_y_l2=i.uv-float2(0,_MainTex_TexelSize.x*2)*_burnSize;
                  half2 u_n_y_l1=i.uv-float2(0,_MainTex_TexelSize.x)*_burnSize;


                   half2 u_n_y_r2=i.uv+float2(0,_MainTex_TexelSize.x*2)*_burnSize;
                   half2 u_n_y_r1=i.uv+float2(0,_MainTex_TexelSize.x)*_burnSize;












                    col.rgb=col.rgb*weight[0]+(tex2D(_MainTex,u_n_x_l2)+tex2D(_MainTex,u_n_x_r2))*weight[2]+(tex2D(_MainTex,u_n_x_l1)+tex2D(_MainTex,u_n_x_r1))*weight[1];
                    //col.rgb=col.rgb*0.9;


                     col.rgb=col.rgb*weight[0]+(tex2D(_MainTex,u_n_y_l2)+tex2D(_MainTex,u_n_y_r2))*weight[2]+(tex2D(_MainTex,u_n_y_l1)+tex2D(_MainTex,u_n_y_r1))*weight[1];
                  }

                  return col;
              }

              ENDCG
          
       }
   }
}
