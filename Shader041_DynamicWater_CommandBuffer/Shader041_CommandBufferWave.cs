using System.Collections.Generic;
using UnityEngine.Rendering;
using UnityEngine;

[ExecuteInEditMode]
public class CommandBufferWave : MonoBehaviour {

    private Camera m_Cam;

    // We'll want to add a command buffer on any camera that renders us,
    // so have a dictionary of them.
    private Dictionary<Camera, CommandBuffer> m_Cameras = new Dictionary<Camera, CommandBuffer>();

    // Remove command buffers from all cameras we added into
    private void Cleanup()
    {
        foreach (var cam in m_Cameras)
        {
            if (cam.Key)
            {
                cam.Key.RemoveCommandBuffer(CameraEvent.AfterSkybox, cam.Value);
            }
        }
        m_Cameras.Clear();
    }

    public void OnEnable()
    {
        Cleanup();
    }

    public void OnDisable()
    {
        Cleanup();
    }

    // Whenever any camera will render us, add a command buffer to do the work on it
    public void OnWillRenderObject()
    {
        var act = gameObject.activeInHierarchy && enabled;
        if (!act)
        {
            Cleanup();
            return;
        }

        var cam = Camera.current;
        if (!cam)
            return;

        CommandBuffer buf = null;
        // Did we already add the command buffer on this camera? Nothing to do then.
        if (m_Cameras.ContainsKey(cam))
            return;
        buf = new CommandBuffer();
        buf.name = "Grab screen";
        m_Cameras[cam] = buf;

        // copy screen into temporary RT
        int screenCopyID = Shader.PropertyToID("_ScreenCopyTexture");
        buf.GetTemporaryRT(screenCopyID, -1, -1, 0, FilterMode.Bilinear);
        buf.Blit(BuiltinRenderTextureType.CurrentActive, screenCopyID);

        buf.SetGlobalTexture("_GrabTex", screenCopyID);
        cam.AddCommandBuffer(CameraEvent.AfterSkybox, buf);
    }
}
