Shader "Custom/ParallaxShader01" {
	properties{
	  _MainColor("MainColor",Color)=(1,1,1,1)

	  _MainTex("Main Tex",2D)="white"{}
	  _BumpMap("Bump map",2D)="Bump"{}

	  _ParallaxMap("",2D)="white"{}
	  _Amount("Amount",Range(0,1))=0.1
	  _Parallax("d",float)=1.0
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
	          sampler2D _BumpMap;
	          float _Parallax;
	          sampler2D _ParallaxMap;

	          float _Amount;
	          struct a2v{
	             float4 vertex:POSITION;
	             float4 texcoord:TEXCOORD;
	             float3 normal:NORMAL;
	             float4 tangent:TANGENT;
	          };

	          struct v2f{
	              float4 pos:SV_POSITION;
	              float2 uv:TEXCOORD1;
	              float3 tangentLitDir:TEXCOORD2;

	              float3 tangentViewDir:TEXCOORD3;

	          };


	          v2f vert(a2v v){
	              v2f o;
	              o.pos=mul(UNITY_MATRIX_MVP,v.vertex);
	              o.uv=v.texcoord.xy*_MainTex_ST.xy+_MainTex_ST.zw;


	              TANGENT_SPACE_ROTATION;
	              float4 worldLitDir=_WorldSpaceLightPos0;
	              float3 objLitDir=(_World2Object,worldLitDir);

	              float3 objViewDir=ObjSpaceViewDir(v.vertex);


	              o.tangentLitDir=mul(rotation,objLitDir);


	              o.tangentViewDir=mul(rotation,objViewDir);

	              return o;
	          }


	          fixed4 frag(v2f i):SV_Target{
	               fixed4 col;


	               float p=tex2D(_ParallaxMap,i.uv).a;

	                float2 offset=ParallaxOffset(p,_Parallax,i.tangentViewDir);

	                i.uv+=offset;

	               float3 N=UnpackNormal(tex2D(_BumpMap,i.uv));
	               float diff=dot(N,i.tangentLitDir)*0.5+0.5;
	                col=tex2D(_MainTex,i.uv);






	               if(_Amount>0.5){
	                 col=col*diff;
	               }
	               else{

	               }

	               return col;
	          }


	          ENDCG
	     }
	}
	FallBack "Diffuse"
}
