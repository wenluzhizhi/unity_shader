using UnityEngine;
using System.Collections;

public class VF_PageMain : MonoBehaviour {

	public Material ma;


	public Texture[] pages;
	public int currentPage=0;
	public int lastPage=1;
	void Start () 
	{
		if (ma == null) {
		}
		SetTexture ();
	}

	private void SetTexture(){

		if (currentPage < pages.Length) {
			ma.SetTexture ("_MainTex",pages[currentPage]);
		}
		if (lastPage < pages.Length) {
			ma.SetTexture ("_BackTex",pages[lastPage]);
		}
		ma.SetFloat ("_CurPageAngle",0);
	}
	

	void Update () {
	
	}


	void OnGUI()
	{
		if (GUILayout.Button ("Flip book")) {
			StartCoroutine (starFlipBook());
		}
	}


	IEnumerator starFlipBook()
	{
		float _temp = 0.00f;
		for (int i = 0; i < 99; i++)
		{
			ma.SetFloat ("_CurPageAngle",_temp);
			_temp += 0.01f;
			yield return new WaitForSeconds (0.02f);
		}
		if (currentPage + 1 < pages.Length) {
			currentPage += 1;
		} else {
			currentPage = 0;
		}

		if (lastPage + 1 < pages.Length) {
			lastPage += 1;
		} else {
			lastPage = 0;
		}
		SetTexture ();

	
	}
}
