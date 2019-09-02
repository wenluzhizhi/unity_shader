Shader "Custom/Shader039_MoveRing"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Glossiness ("Smoothness", Range(0,1)) = 0.5
        _Metallic ("Metallic", Range(0,1)) = 0.0
        _RingTex("Ring Texture", 2D) = "white" {}
        _RingColor("Ring Color", Color) = (1,1,1,1)
         _Width("RangeWidth",float) = 0.3
        _Pos("Pos",float) = 2
        _MaxSize("MaxSize",float) = 20
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Standard fullforwardshadows

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

        sampler2D _MainTex;
        half tes;

        struct Input
        {
            float2 uv_MainTex;
            float3 worldPos;
        };

        half _Glossiness;
        half _Metallic;
        fixed4 _Color;
        half4 _hitPts;
        sampler2D _RingTex;
        half posInRing;
        half _RingIntensityScale;
        half4 _RingColor;
    


       
            float _Width;
            float _Pos;
            
            float _MaxSize;

      
        UNITY_INSTANCING_BUFFER_START(Props)
            // put more per-instance properties here
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf (Input IN, inout SurfaceOutputStandard o)
        {


            fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
            



           
            _Pos = abs(_SinTime.z) * _MaxSize;
            float dis = length(IN.worldPos);
            if(dis>_Pos && dis<_Pos + _Width && dis < _MaxSize ){
                   
                   float d1 = (1.0 - abs(dis - (_Pos + _Width / 2.0)) / _Width) * (1.0 - dis/_MaxSize);
                   float angle = acos(dot(normalize(IN.worldPos), float3(1,0,0)));
                   IN.uv_MainTex.y = angle;
                   float4 cring = tex2D(_RingTex, IN.uv_MainTex) * _RingColor;
                   c = c *(1.0-d1) + cring * d1;
            }
          o.Albedo = c.rgb;
            // Albedo comes from a texture tinted by color
          
            // Metallic and smoothness come from slider variables
            o.Metallic = _Metallic;
            o.Smoothness = _Glossiness;
            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
