using UnityEngine;
using System.Collections;

public class FogCamera_1 : MonoBehaviour {


	public Material ma;


	void Start(){
		GetComponent<Camera>().depthTextureMode |= DepthTextureMode.Depth;
	}
   void	OnRenderImage (RenderTexture src, RenderTexture dest){
		if (ma != null) {
			Graphics.Blit (src,dest,ma);
		}
	}
}
