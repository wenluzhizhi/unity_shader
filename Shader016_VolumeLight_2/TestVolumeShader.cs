using UnityEngine;
using System.Collections;

public class TestVolumeShader : MonoBehaviour {



	public Light shadowLight;
	public Material ma;
	void Start () {
	
	}
	

	void OnPostRender(){

		if (!enabled)
			return;

		Vector4 lightPos;


		if (shadowLight.type == LightType.Directional) 
		{


			Vector3 pos = shadowLight.transform.forward;
			lightPos = new Vector4 (pos.x,pos.y,pos.z,0.0f);


		} else 
		{
			Vector3 pos = shadowLight.transform.position;
			lightPos = new Vector4 (pos.x,pos.y,pos.z,1.0f);
		}
		ma.SetVector("_LightPosition",lightPos);
	}
}
