using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Rendering;

public class RippleWater : MonoBehaviour {

    public CommandBuffer comBuf;
    public Camera mainCamera;

    public Color[] normalColorBuf;
    public float[] lateRippleBuf;
    public float[] currentRippleBuf;

    public Texture2D normalTex;

    public int width = 0;
    public int height = 0;

    public Material ma;

    public int size = 10;
    public int weight = 60;

    void Start() {

        width = Screen.width / 10;
        height = Screen.height / 10;
        //normalColorBuf = new Color[width * height];
        normalTex = new Texture2D(width, height, TextureFormat.R8, false);
        normalColorBuf = normalTex.GetPixels();


        comBuf = new CommandBuffer();
        comBuf.name = "myCommandBuffer";
        int screenCopyID = Shader.PropertyToID("_ScreenCopyTexture");
        comBuf.GetTemporaryRT(screenCopyID, -1, -1, 0, FilterMode.Bilinear);
        comBuf.Blit(BuiltinRenderTextureType.CurrentActive, screenCopyID);
        comBuf.SetGlobalTexture("_GrabTex1", screenCopyID);

        mainCamera.AddCommandBuffer(CameraEvent.AfterSkybox, comBuf);

        lateRippleBuf = new float[width * height];
        currentRippleBuf = new float[width * height];

        ma.SetTexture("_BumpMap", normalTex);

    }

    void FixedUpdate() {
        RippleSpread();
        BufToColor();
        AplyNormalTex();
        if (Input.GetMouseButton(0)) {
            Vector3 pos = Input.mousePosition;
            AddRipplePoint((int) pos.x, (int) pos.y, size, weight);
        }
    }

    public void AddRipplePoint(int x, int y, int size, int weight) {
        int x1 = x / 10;
        int y1 = y / 10;

        if (width * y1 + x1 > currentRippleBuf.Length)
            return;
        for (int posx = x1 - size; posx < x1 + size; posx++) {
            for (int posy = y1 - size; posy < y1 + size && posy < height; posy++) {
                int sd = width * posy + posx;
                if (posx < 0 || posx >= width || posy < 0 || posy >= height)
                    continue;
                if ((posx - x1) * (posx - x1) + (posy - y1) * (posy - y1) < size * size) {
                    lateRippleBuf[sd] = weight;
                }

            }
        }

    }

    void RippleSpread() {
        float leftPoint, rightPoint, bottomPoint, topPoint;
        for (int i = 0; i < lateRippleBuf.Length; i++) {
            if (i % width - 1 >= 0) {
                leftPoint = lateRippleBuf[i - 1];
            } else {
                leftPoint = lateRippleBuf[i + 1];
            }

            if (i % width + 1 < width) {
                rightPoint = lateRippleBuf[i + 1];
            } else {
                rightPoint = lateRippleBuf[i - 1];
            }

            if (i - width >= 0) {
                bottomPoint = lateRippleBuf[i - width];
            } else {
                bottomPoint = lateRippleBuf[i + width];
            }

            if (i + width < lateRippleBuf.Length) {
                topPoint = lateRippleBuf[i + width];
            } else {
                topPoint = lateRippleBuf[i - width];
            }

            currentRippleBuf[i] = (leftPoint + rightPoint + bottomPoint + topPoint) / 2f - currentRippleBuf[i];
            currentRippleBuf[i] -= currentRippleBuf[i] / 32f;
            if (currentRippleBuf[i] < 1) {
                currentRippleBuf[i] = 0;
            }

        }

        float[] trans = lateRippleBuf;
        lateRippleBuf = currentRippleBuf;
        currentRippleBuf = trans;
    }

    void AplyNormalTex() {
        normalTex.SetPixels(normalColorBuf);
        normalTex.Apply();
    }

    void BufToColor() {
        for (int i = 0; i < lateRippleBuf.Length; i++) {
            normalColorBuf[i].r = (byte) ( lateRippleBuf[i]);
        }
    }

    void OnDestroy() {

    }
}