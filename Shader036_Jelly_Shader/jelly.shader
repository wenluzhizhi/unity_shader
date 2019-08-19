Shader "Custom/jelly"
{
   properties{
         _Tess ("Tessellation", Range(1,32)) = 4
     _MainTex("main texture", 2D) = "white"{}
     _Color("Main Color", Color) = (1,1,1,1)
     _Glossiness ("Smoothness", Range(0,1)) = 0.5
		_Metallic ("Metallic", Range(0,1)) = 0.0

    _ControlTime ("Time", float) = 0
		_ModelOrigin ("Model Origin", Vector) = (0,0,0,0)
		_ImpactOrigin ("Impact Origin", Vector) = (-5,0,0,0)

    _Frequency ("Frequency", Range(0, 1000)) = 10
		_Amplitude ("Amplitude", Range(0, 5)) = 0.1
		_WaveFalloff ("Wave Falloff", Range(1, 8)) = 4
		_MaxWaveDistortion ("Max Wave Distortion", Range(0.1, 2.0)) = 1
		_ImpactSpeed ("Impact Speed", Range(0, 10)) = 0.5
		_WaveSpeed ("Wave Speed", Range(-10, 10)) = -5
  }
  subShader{
      Tags{"RenderType" = "Opaque"}
      LOD 200
      CGPROGRAM
      #pragma surface surf Standard fullforwardshadows addshadow vertex:vert tessellate:tessFixed

      sampler2D _MainTex;
      fixed4 _Color;
      half _Glossiness;
		  half _Metallic;

      float4 _ModelOrigin;
      float4 _ImpactOrigin;
      float _ControlTime;

      half _Frequency; //Base frequency for our waves.
		  half _Amplitude; //Base amplitude for our waves.
		  half _WaveFalloff; //How quickly our distortion should fall off given distance.
		  half _MaxWaveDistortion; //Smaller number here will lead to larger distortion as the vertex approaches origin.
		  half _ImpactSpeed; //How quickly our wave origin moves across the sphere.
		  half _WaveSpeed; //Oscillation speed of an individual wave.
float _Tess;
      struct Input{
        float2 uv_MainTex;
      };
      float4 tessFixed()
            {
                return _Tess;
            }

      void vert(inout appdata_base v){
         float4 world_space_vertex = mul(unity_ObjectToWorld, v.vertex);
         float4 direction = normalize(_ModelOrigin - _ImpactOrigin);
         float4 origin = _ImpactOrigin + _ControlTime * _ImpactSpeed * direction;
         float dist = distance(world_space_vertex, origin);

         dist = pow(dist, _WaveFalloff);
         dist = max(dist, _MaxWaveDistortion);


          
        float4 l_ImpactOrigin = mul(unity_WorldToObject, _ImpactOrigin);
			    float4 l_direction = mul(unity_WorldToObject, direction);
          float impactAxis = l_ImpactOrigin + dot((v.vertex - l_ImpactOrigin), l_direction);
          v.vertex.xyz += v.normal * sin(impactAxis * _Frequency + _ControlTime * _WaveSpeed) * _Amplitude * (1 / dist);
		      //v.vertex.xyz += v.normal * 0;
      }


      void surf(Input IN, inout SurfaceOutputStandard o){
        fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
			  o.Albedo = c.rgb;
			  // Metallic and smoothness come from slider variables
		   	o.Metallic = _Metallic;
		  	o.Smoothness = _Glossiness;
		  	o.Alpha = c.a;
      }
      ENDCG
  }
  FallBack "Diffuse"
}
