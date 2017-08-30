Shader "Custom/VF_Shader_3" {

//http://www.cnblogs.com/j349900963/p/4543837.html
	properties{
	  _MainColor("MainColor",Color)=(1,1,1,1)
	  _MainTex("Main Tex",2D)="white"{}
	}

	subShader{

	     pass{

	          CGPROGRAM
	          #pragma vertex vert
	          #pragma fragment frag
	          #include "unitycg.cginc"


	          sampler2D _MainTex;
	          float4 _MainTex_ST;
	          fixed4 _MainColor;
	          struct a2v{
	             float4 vertex:POSITION;
	             float4 texcoord:TEXCOORD;
	          };

	          struct v2f{
	              float4 pos:SV_POSITION;
	              float2 uv:TEXCOORD1;
	          };


	          v2f vert(a2v v){
	              v2f o;
	              //o.pos=mul(UNITY_MATRIX_MVP,v.vertex);
	              o.uv=v.texcoord.xy*_MainTex_ST.xy+_MainTex_ST.zw;

	              float4 ori=mul(UNITY_MATRIX_MV,float4(0,0,0,1));
	              float4 vt=v.vertex;
	              vt.z=0;
	              vt.xyz+=ori.xyz;
	              o.pos=mul(UNITY_MATRIX_P,vt);
	              return o;
	          }


	          fixed4 frag(v2f i):SV_Target{
	               fixed4 col;
	               col=tex2D(_MainTex,i.uv);
	               return col;
	          }


	          ENDCG
	     }
	}
	FallBack "Diffuse"
}
