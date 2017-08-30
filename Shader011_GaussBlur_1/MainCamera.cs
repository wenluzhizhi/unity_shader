using UnityEngine;
using System.Collections;

public class MainCamera : MonoBehaviour {

	public Material ma;
	void Start () {
	
	}
	

	void Update () {
	
	}

	void OnRenderImage(RenderTexture src,RenderTexture dest){
		Graphics.Blit (src, dest, ma);
	}
}
