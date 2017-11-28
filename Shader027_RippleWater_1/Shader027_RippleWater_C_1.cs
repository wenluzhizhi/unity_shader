using UnityEngine;
using System.Collections;

public class Shader027_RippleWater_C_1 : MonoBehaviour {

	public Material ma;
	public Texture2D normalTex;
	public int rippleSize = 100;
	public int rippleWeight = 128;


	public Color32[] normalColorBuf;
	public float[] lateRippleBuf;
	public float[] currentRippleBuf;

	private int screenWidth;
	private int screenHeight;
	private float Times;

	public Color32 c1;
	void Test(){
	 
		float s1 = 0.0f;
		c1.r=(byte)(s1-10f);
	}


	void OnGUI(){
		GUILayout.Label ("鼠标拖动，水波效果",sy);
	}

	GUIStyle sy=new GUIStyle();

	void Start () {

		//Test ();
		sy.fontSize=40;
		sy.normal.textColor = Color.white;

		screenWidth = Screen.width / 10;
		screenHeight = Screen.height / 10;
		normalTex = new Texture2D (screenWidth,screenHeight,TextureFormat.ARGB32,false);
		ma.SetTexture ("_BumpMap",normalTex);
		normalColorBuf=new Color32[screenWidth*screenHeight];

		lateRippleBuf=new float[screenWidth*screenHeight];
	    currentRippleBuf=new float[screenWidth*screenHeight];
	}
	

	void Update () {
	    
	}


	void FixedUpdate(){

		RippleSpread ();
		BufToColor();
		AplyNormalTex();
		if (Input.GetMouseButton (0)) {
			OnClickScreen ();
		}
	}
		


public void AplyNormalTex()
{
		
	normalTex.SetPixels32(normalColorBuf);

	normalTex.Apply();

}

	/// <summary>
	/// 将波幅度转换成图片颜色
	/// </summary>
	public void BufToColor()
	{
		for (int i = 0; i < lateRippleBuf.Length; i++)
		{

			normalColorBuf[i].g = (byte)(lateRippleBuf[i]);
			normalColorBuf[i].a = (byte)(lateRippleBuf[i]);
			//normalColorBuf[i].g = (byte)(-128);
			//normalColorBuf[i].a = (byte)(255);
			//ALLColor[i].r = (byte)(buf1[i] + 128f);
			//ALLColor[i].b = (byte)(buf1[i] + 128f);

		}


	}



	public void RippleSpread()
	{
		///任意时刻根据某一个点周围前、 后、左、右四个点以及该点自身的振幅来推算出下一时刻该点的振幅
		float leftpoint;
		float rightpoint;
		float bottompoint;
		float toppoint;

		for (int i = 0; i < lateRippleBuf.Length-1; i++)
		{        //波能扩散 


			//水波边界反弹
			if ((i % screenWidth -1) >= 0)
			{
				leftpoint = lateRippleBuf[i - 1];
			}
			else {
				leftpoint = lateRippleBuf[i + 1];
			}

			if ((i% screenWidth + 1) < screenWidth)
			{
				rightpoint = lateRippleBuf[i + 1];
			}
			else {
				rightpoint = lateRippleBuf[i - 1];
			}
			if ((i - screenWidth) >= 0)
			{
				bottompoint =lateRippleBuf[i - screenWidth];
			}
			else {
				bottompoint = lateRippleBuf[i + screenWidth];
			}
			if ((i + screenWidth) < lateRippleBuf.Length)
			{
				toppoint = lateRippleBuf[i + screenWidth];
			}
			else {
				toppoint = lateRippleBuf[i - screenWidth];
			}

			//扩散推导公式X0'=a（left+right+bottom+top）+bX0 找出一个最简解：a = 1/2、b = -1

			//波能扩散
			currentRippleBuf[i] = (leftpoint + rightpoint + bottompoint + toppoint) / 2f - currentRippleBuf[i];
			//波能衰减 水在实际中是存在阻尼的，
			// 否则，用上面这个公式，一旦你在水中增加一个波源，
			//水面将永不停止的震荡下去。所以，还需要对波幅数据进行衰减处理，
			// 让每一个点在经过一次计算后，波幅都比理想值按一定的比例降低。这个衰减率经过测试，用1/32比较合适，也就是1/2^5
			currentRippleBuf[i] -= currentRippleBuf[i] / 128f;
			if (currentRippleBuf[i] < 1) {
				currentRippleBuf[i] = 0;
			}
		}

		//交换波能数据缓冲区 
		float[] buf3 = lateRippleBuf;

		lateRippleBuf = currentRippleBuf;
		currentRippleBuf= buf3;
	}


















	void OnClickScreen(){
		Vector3 v3 = Input.mousePosition;
		AddRipplePoint ((int)v3.x,(int)v3.y,rippleSize,rippleWeight);

	}

	public void AddRipplePoint(int x,int y,int size,int weight){

		int X1 = x / 10;
		int Y1 = y / 10;

		if (screenWidth * Y1 + X1 >= lateRippleBuf.Length)
			return;
		for (int posx = X1 - rippleSize; posx < X1 + rippleSize; posx++)
		{
			for (int posy = X1 - rippleSize; posy < X1 + rippleSize; posy++)
			{
				if ((posx - X1) * (posx - X1) + (posy - Y1) * (posy - Y1) < rippleSize * rippleSize)
				{
					lateRippleBuf[screenWidth * Y1 + X1] = weight;
				}
			}
		}
		
	}



	void OnRenderImage(RenderTexture src,RenderTexture dest){
		if (ma != null) {
			ma.SetTexture ("_RefractionTex",src);
			Graphics.Blit (src, dest, ma);
			
		} else {
			Graphics.Blit (src,dest);
		}
	}
}
