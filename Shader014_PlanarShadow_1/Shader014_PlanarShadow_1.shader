Shader "Custom/PlanarShadow_1_T" {


   Properties{
       
   }
   SubShader{
     pass{
        Tags{"LightMode"="ForwardBase"}
        Material{Diffuse(1,1,1,1)}
        Lighting on
     }



     pass{
         Tags{"LightMode"="ForwardBase"}
         Blend DstColor SrcColor
         offset -1,-1


         CGPROGRAM
         #pragma vertex vert
         #pragma fragment frag
         #include "unitycg.cginc"

         float4x4 _World2Ground;
         float4x4 _Ground2World;


         struct a2v{
           float4 vertex:POSITION;
         };

        struct v2f{
          float4 pos:SV_POSITION;
        };


        v2f vert(a2v v){
          v2f o;
          float3 litDir;
          litDir=WorldSpaceLightDir(v.vertex);
          litDir=normalize(mul(_World2Ground,float4(litDir,0)).xyz);

          float4 vt;

          vt=mul(_Object2World,v.vertex);
          vt=mul(_World2Ground,vt);

          vt.xz=vt.xz-(vt.y/litDir.y)*litDir.xz;
		
		vt.y=0;
		vt=mul(_Ground2World,vt);
		vt=mul(_World2Object,vt);
		o.pos= mul(UNITY_MATRIX_MVP, vt);

          return o;
        }

        float4 frag(v2f i):SV_Target
		{
			return float4(0.3,0.3,0.3,1);
		}

         ENDCG

     }
   }
}
