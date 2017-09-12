using UnityEngine;
using System.Collections;

public class TestRe : MonoBehaviour {

	public Transform receiver;

	public Matrix4x4 worldToLocal;
	public Matrix4x4 localToWorld;

	public Material ma;
	void Start () {
	
	}

	void Update () {
	
	}


	void OnGUI(){

		if (GUILayout.Button ("Test")) {
			worldToLocal = receiver.worldToLocalMatrix;
			localToWorld = receiver.localToWorldMatrix;


			ma.SetMatrix ("_World2Ground",worldToLocal);
			ma.SetMatrix ("_Ground2World",localToWorld);
		}
	}
}
