Shader "Custom/Cartoon_test_1" {
    properties{

        _OuterColor("Outer color",Color)=(1,1,1,1)
        _Diffuse("Diffuse Color",Color)=(1,1,1,1)
        _OuterLength("Outer length",Range(0,2))=0.5
        _SpecularColor("Specular Color",Color)=(1,1,1,1)
        _Gloss("Specular GLoss",Range(0,128))=4
        _Ramp("Ramp Texture",2D)="white"{}
    }
    SubShader{

        pass{

           Cull front
           CGPROGRAM
           #pragma vertex vert
           #pragma fragment frag
           #include "unitycg.cginc"

           fixed4 _OuterColor;
           float _OuterLength;
           struct a2v{
             float4 vertex:POSITION;
             float3 normal:NORMAL;
           };

           struct v2f{
             float4 pos:SV_POSITION;

           };

           v2f vert(a2v v){
             v2f o;
             o.pos=mul(UNITY_MATRIX_MV,v.vertex);
             //在视空间沿着法线方向延伸顶点：
             //将模型的法线从模型空间转换到视角空间
             float3 viewNormal=mul((float3x3)UNITY_MATRIX_IT_MV,v.normal);
             o.pos=o.pos+ normalize(float4(viewNormal,0))*_OuterLength;
             o.pos=mul(UNITY_MATRIX_P,o.pos);
             return o;
           }

           fixed4 frag(v2f i):SV_Target{
              fixed4 col;
              col=_OuterColor;
              return col;
           }


           ENDCG
        }


         pass{

           
           CGPROGRAM
           #pragma vertex vert
           #pragma fragment frag
           #include "unitycg.cginc"

           fixed4 _Diffuse;
           fixed4 _SpecularColor;
           float _Gloss;
           sampler2D _Ramp;
           struct a2v{
             float4 vertex:POSITION;
             float3 normal:Normal;
           };

           struct v2f{
             float4 pos:SV_POSITION;
             float3 worldNormal:TEXCOORD0;
             float3 worldLightDir:TEXCOORD1;
             float3 worldViewDir:TEXCOORD2;
           };

           v2f vert(a2v v){
             v2f o;
             o.pos=mul(UNITY_MATRIX_MVP,v.vertex);
             o.worldNormal=mul(v.normal,(float3x3)_World2Object);
             float3 worldPos=mul(_Object2World,v.vertex).xyz;
             o.worldLightDir=normalize(UnityWorldSpaceLightDir(worldPos));
             o.worldViewDir=normalize(UnityWorldSpaceViewDir(worldPos));
             return o;
           }

           fixed4 frag(v2f i):SV_Target{
              fixed4 col;
              float diffuse_value=dot(i.worldNormal,i.worldLightDir)*0.5+0.5;

              //使用bllinng-phong 计算高光发射
              fixed3 worldHalfDir=normalize(i.worldViewDir+i.worldLightDir);

              float specular_value=max(0,dot(i.worldNormal,worldHalfDir));

              specular_value=fwidth(specular_value)*2.0;

              specular_value=pow(specular_value,_Gloss);


              fixed3 ambient=UNITY_LIGHTMODEL_AMBIENT.xyz;

              fixed4 Ramp_t=tex2D(_Ramp,float2(diffuse_value,diffuse_value));
              _Diffuse.rgb=Ramp_t.rgb*_Diffuse.rgb;
              col=_Diffuse+_SpecularColor*specular_value;
              return col;
           }


           ENDCG
        }
    }
}
