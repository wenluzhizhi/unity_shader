using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Rendering;

[RequireComponent(typeof(Camera))]
public class CommandBufffer : MonoBehaviour
{



    public Camera mainCamera;
    public CommandBuffer buffer;

    void Start()
    {
        mainCamera.depthTextureMode = DepthTextureMode.Depth;


        buffer = new CommandBuffer();
        int screenID = Shader.PropertyToID("wusuowei");
        buffer.GetTemporaryRT(screenID, -1, -1, 0, FilterMode.Bilinear);
        buffer.Blit(BuiltinRenderTextureType.CurrentActive, screenID);

        buffer.SetGlobalTexture("_GrabText", screenID);
         mainCamera.AddCommandBuffer(CameraEvent.AfterSkybox, buffer);
    }
}
