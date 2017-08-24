// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'

// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/myShader" {
	 Properties{
        _Color("Main Color",Color)=(1,1,1,1)
       _RimColor("RimColor",Color)=(1,1,1,1)
       _RimLength("length",Range(0,1))=0.2
       _Gloss("Gloss",Range(0,32))=2
       _SpecularColor("Specular Color",Color)=(1,0,0,1)
    }
    SubShader{

        pass{

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "unitycg.cginc"

            struct a2v{

                float4 vertex:POSITION;
                float4 normal:NORMAL;
            };

            fixed4 _Color;
            fixed4 _RimColor;
            float _RimLength;
            fixed3 _SpecularColor;
            float _Gloss;
            struct v2f{

                 float4 pos:SV_POSITION;
                 float3 worldNormal:TEXCOORD0;
                 float3 worldViewDir:TEXCOORD1;
                 float3 worldLightDir:TEXCOORD2;
                 float3 worldRelectorDir:TEXCOORD3;

            };


            v2f vert(a2v v){
                v2f o;
                o.pos=mul(UNITY_MATRIX_MVP,v.vertex);
                float3 worldPos=mul(_Object2World,v.vertex).xyz;
                o.worldViewDir=normalize(_WorldSpaceCameraPos.xyz-worldPos);
                o.worldNormal=normalize(mul(v.normal,_World2Object).xyz);
                o.worldLightDir=normalize(_WorldSpaceLightPos0.xyz);  //平行光可以这样使用

                o.worldRelectorDir=reflect(-o.worldLightDir,o.worldNormal);
                return o;
            }


            fixed4 frag(v2f i):SV_Target{
                fixed4 col;
                float dot_value=dot(i.worldNormal,i.worldViewDir);

                //漫反射
                float diffuse_value=dot(i.worldLightDir,i.worldNormal);

                //高光反射
                float3 sp=_SpecularColor.rgb* pow( max(0,dot(i.worldViewDir,i.worldRelectorDir)),_Gloss);


                //环境光：
                fixed3 ambient=UNITY_LIGHTMODEL_AMBIENT.xyz;


                if(dot_value<_RimLength)
                {
                   return _RimColor;
                }
                return _Color*(diffuse_value*0.5+0.5)+fixed4(sp+ambient,1);
            }


            ENDCG
        }
    }
}
