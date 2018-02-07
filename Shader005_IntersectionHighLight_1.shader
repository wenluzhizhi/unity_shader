//添加注释：
 //1，通过主相机可以获取相机的深度图，然后在一个物体A上添加着色器，该着色器通过UV 进行深度采样，此时可以获取在该物体的顶点，
  //，由其他物体带来的深度，即没有该物体时的深度
 //然后再通过该物体上的顶点，获取该物体处实际的顶点深度
 
 Shader "Custom/Shader005_IntersectionHighLight_1" {
	Properties{

	     _RimLength("RimLength",Range(0,3))=1
	     _InterSectionRange("InterSectionRange",Range(0,1))=0.2
	     _CilrcleColor("Circle Color",Color)=(1,1,1,1)
	     _NoiseTex("NoiseTex",2D)="white"{}
	     dd1("dd",Range(0,1))=0.1
	       dd2("dd",Range(0,1))=0.1
	}
	Subshader{
	    tags{"Queue"="Transparent" "RenderType"="Transparent"}
	    GrabPass{
	        "_GrabTempTex"
	    }
        pass{

           Zwrite off
           //cull off
           Blend srcAlpha oneMinusSrcAlpha
           CGPROGRAM
           #pragma vertex vert
           #pragma fragment frag
           #include "unitycg.cginc"

           float _RimLength;
           fixed4 _CilrcleColor;
           sampler2D _CameraDepthTexture;
           float _InterSectionRange;

           sampler2D _GrabTempTex;
           sampler2D _NoiseTex;
           float4 _NoiseTex_ST;
           float dd1;
           float dd2;
           struct a2v{
               float4 vertex:POSITION;
               float4 normal:NORMAL;

               float4 texcoord:TEXCOORD;
               
           };

           struct v2f{
               float4 pos:SV_POSITION;
               float3 worldViewDir:TEXCOORD0;
               float3 worldNormal:TEXCOORD1;
               float4 screenPos:TEXCOORD2;
               float4 grabPos:TEXCOORD3;
               float2 uv:TEXCOORD4;
           };


           v2f vert(a2v v){
              v2f o;
              o.pos=mul(UNITY_MATRIX_MVP,v.vertex);
              o.worldNormal=normalize(mul(v.normal,_World2Object).xyz);
              float3 worldVertexPos=mul(_Object2World,v.vertex);
              o.worldViewDir=(_WorldSpaceCameraPos.xyz-worldVertexPos);

              o.screenPos=ComputeScreenPos(o.pos);//获取投影点对应的屏幕坐标点
              COMPUTE_EYEDEPTH(o.screenPos.z);

              o.grabPos=ComputeGrabScreenPos(o.pos);

              o.uv=v.texcoord.xy*_NoiseTex_ST.xy+_NoiseTex_ST.zw;
              return o;
           }

           fixed4 frag(v2f i):SV_Target
           {
              fixed4 col;
              float dotV=(1-  abs(dot(i.worldViewDir,i.worldNormal)))*_RimLength;
             


              //从屏幕空间获得的屏幕深度：
              float screen_z=i.screenPos.z;


              //从深度图获取的深度值

              float d_z=LinearEyeDepth(SAMPLE_DEPTH_TEXTURE_PROJ(_CameraDepthTexture,UNITY_PROJ_COORD(i.screenPos)));

              float diff=(1-abs(screen_z-d_z))* _InterSectionRange;

              float d1=max(diff,dotV);


              float4 offset=tex2D(_NoiseTex,i.uv-_Time.xy*dd1);



              i.grabPos.xy-=offset.xy*dd2;

              fixed4 c1=tex2Dproj(_GrabTempTex,i.grabPos);


               col=_CilrcleColor*d1+c1;
              return col;
           }



           ENDCG
        }
	}
}
