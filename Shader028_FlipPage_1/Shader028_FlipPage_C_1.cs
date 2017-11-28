using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System.Collections.Generic;


//[ExecuteInEditMode]
public class Shader028_FlipPage_C_1 : MonoBehaviour
{


	public int X=10;
	public int Y = 10;
	public float scale=0.5f;
	public Vector3[] vertices;
	public Vector2[] uvs;
	public Vector3[] vertices_Raw;
	public int[] triangles;

	public Vector3 startPos;


	public Mesh myMesh;
	public MeshRenderer msr;
	public MeshFilter msf;
	public Material myMa;


	public Vector4[] fourCorner=new Vector4[4];
	void Start(){
		startPos = this.transform.position;
	}

	void OnGUI(){
		if (GUILayout.Button ("点击创建一个简单的书页（模拟），然后请用鼠标靠近角边缘实现拖拽翻页效果\r\n" +
			"使用点阵生成mesh,然后根据拖拽点进行改变点的布局，简单demo示例，进一步优化，日后改善")) 
		{
			setPanle ();
			Debug.Log ("生成mesh....");
		}
	}


	Vector3 screenPos;
	public Vector3 WorldPos;
	public Vector3 minDisDot;
	public bool isSlip=false;
	public float maxL=4;
	public int type=-1;
	public bool isShrink=false;
	void Update(){


		if (Input.GetMouseButtonDown (0))
		{

			isShrink = false;
			screenPos = Input.mousePosition;
			startPos = this.transform.position;
			WorldPos = Camera.main.ScreenToWorldPoint (new Vector3(screenPos.x,screenPos.y,Mathf.Abs(Camera.main.transform.position.z-fourCorner[0].z)));
			isSlip = false;
			if (WorldPos.x > fourCorner [0].x && WorldPos.x < fourCorner [3].x && WorldPos.y > fourCorner [0].y && WorldPos.y < fourCorner [1].y) {
				isSlip = true;

				type = -1;
				if (Vector2.Distance (WorldPos, fourCorner [0]) < maxL) {
					minDisDot = fourCorner [0];
					type = 0;
				} else if (Vector2.Distance (WorldPos, fourCorner [1]) < maxL) {
					minDisDot = fourCorner [1];
					type = 1;
				} else if (Vector2.Distance (WorldPos, fourCorner [2]) < maxL) {
					minDisDot = fourCorner [2];
					type = 2;
				} else if (Vector2.Distance (WorldPos, fourCorner [3]) < maxL) {
					minDisDot = fourCorner [3];
					type = 3;
				}

			}

		}
		else if (Input.GetMouseButton (0)) 
		{
			isShrink=false;
			screenPos = Input.mousePosition;
			WorldPos = Camera.main.ScreenToWorldPoint (new Vector3(screenPos.x,screenPos.y,Mathf.Abs(Camera.main.transform.position.z-startPos.z)));

			///minDisDot=fourCorner[1];
			MoveDrag();

		}
		else if (Input.GetMouseButtonUp(0)) 
		{
			
			isShrink=true;

		}
		if(isShrink){

			float _dis=Vector3.Distance(WorldPos,minDisDot);
			if(_dis>0.1f&&_dis<0.5f){
				isSlip=false;
				setPanle();
			}
			else
			{
				WorldPos = Vector3.Lerp (WorldPos,minDisDot,0.1f);
				MoveDrag();
			}

		}
	}


	private void MoveDrag(){

		if (isSlip&&type>=0)
		{
			Vector3 dragLine = WorldPos - minDisDot;

			Vector3 dragLineMiddle = (WorldPos + minDisDot) / 2;
			float dragLineVerticalLineSlope = -dragLine.x / dragLine.y;

			float verticalLine_B = dragLineMiddle.y - dragLineVerticalLineSlope * dragLineMiddle.x;

			float maxDis = Vector3.Magnitude (dragLine)/2;


		


			Vector3 v;
			float k = dragLineVerticalLineSlope;
			float _b = verticalLine_B;



			for (int i = 0; i < vertices.Length; i++)
			{
				v = vertices_Raw [i];
				if ((v.y > dragLineVerticalLineSlope * v.x + verticalLine_B&&(type==1||type==2))||
					(v.y < dragLineVerticalLineSlope * v.x + verticalLine_B&&(type==0||type==3))
				) 
				{
					
					float m = (k * v.x - v.y + _b) / (k * k + 1);

					//点到直线的距离
					float d_verticalLine=Mathf.Abs((k*v.x-v.y+_b)/Mathf.Sqrt(k*k+1));
					float d2 =Mathf.Sin((d_verticalLine / maxDis) * Mathf.PI/2);
					vertices [i] = new Vector3 (v.x - 2 * k * m, v.y + 2 * m,v.z+d2*0.01f);

				} 
				else 
				{
					vertices [i] = v;
				}
			}
			RestPanel ();
		}
	}



	private void setPanle()
	{
		vertices=new Vector3[X*Y];
		uvs=new Vector2[X*Y];
		vertices_Raw=new Vector3[X*Y];
		triangles=new int[X*Y*3-6];
		int _num = 0;
		Vector3 _pos;
		List<int> triList = new List<int> ();
		for (int i = 0; i < Y; i++) 
		{
			for (int j = 0; j < X; j++)
			{
				_num = i * X + j;

				//_pos = startPos + new Vector3 (j,i,0)*scale;
			    _pos =new Vector3 (j,i,0)*scale;
				vertices [_num] = _pos;
				vertices_Raw [_num] =_pos;
				uvs [_num] = new Vector2 ((float)j/X,(float)i/Y);
				if (i < Y - 1 && j < X - 1) {
					triList.Add (_num);
					triList.Add (_num+1);
					triList.Add (_num+1+Y);

					triList.Add (_num+1+Y);
					triList.Add (_num+Y);
					triList.Add (_num);
				}
			}

		}
		triangles = triList.ToArray ();


		if (this.gameObject.GetComponent<MeshRenderer> () == null) {
			msr=this.gameObject.AddComponent<MeshRenderer> ();
		}
		if (this.gameObject.GetComponent<MeshFilter> () == null) {
			msf = this.gameObject.AddComponent<MeshFilter> ();
		}


		if (myMesh == null) {
			myMesh = new Mesh ();
			myMesh.name = "myMesh";
		}


		myMesh.vertices = vertices;
		myMesh.triangles = triangles;
		myMesh.uv = uvs;
		myMesh.RecalculateNormals ();
		myMesh.RecalculateBounds ();
		msr.material = myMa;
		msf.mesh = myMesh;

		fourCorner[0]=vertices[0]+startPos;
		fourCorner[1]=vertices[(Y-1)*X]+startPos;
		fourCorner [2] = vertices [X * Y - 1]+startPos;
		fourCorner[3]=vertices[X-1]+startPos;
        

	}



	private void RestPanel(){
		if (myMesh == null)
			return;
		myMesh.vertices = vertices;
		myMesh.triangles = triangles;
		myMesh.RecalculateNormals ();
		myMesh.RecalculateBounds ();
	}
}
