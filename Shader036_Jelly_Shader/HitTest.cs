using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class HitTest : MonoBehaviour
{
    public MeshRenderer mesh_render_;
    public RaycastHit hit;

    public Ray ClickRay;

    float controlTime;
    void Start(){
        mesh_render_ = this.gameObject.GetComponent<MeshRenderer>();
    }


    void Update() {
       controlTime += Time.deltaTime;
       if(Input.GetMouseButtonDown(0)){
           controlTime = 0;
           ClickRay = Camera.main.ScreenPointToRay(Input.mousePosition);
           if(Physics.Raycast(ClickRay, out hit)){
               Debug.Log(hit.collider.name);


               mesh_render_.material.SetVector("_ModelOrigin",transform.position);
               mesh_render_.material.SetVector("_ImpactOrigin",hit.point);
           }
       }
       mesh_render_.material.SetFloat("_ControlTime", controlTime);   
    }
}
