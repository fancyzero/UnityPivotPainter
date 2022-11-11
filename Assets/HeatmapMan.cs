using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Rendering;
#if UNITY_EDITOR
using UnityEditor;
#endif
[ExecuteAlways]
public class HeatmapMan : MonoBehaviour
{
    public float maxSenseDistance;
    public float excitationIncreaceSpeed = 1;
    public float excitationDecaySpeed = 0.3f;
    public GameObject strangeGrassRoot;
    public GameObject target;
    public int mapResolution = 1024;
    public ComputeShader computeShader;
    public CommandBuffer command;
    public Vector4 mapToWorld = new Vector4(0, 0, 10, 10);
    public RenderTexture heatMap;


    private  void OnScene(SceneView sceneview)
    {
        Handles.BeginGUI();

GUI.DrawTexture(new Rect(0, 0, 256, 256), heatMap, ScaleMode.ScaleToFit,false);
        Handles.EndGUI();
    }

    void OnEnable()
    {
        SceneView.duringSceneGui += OnScene;
        heatMap = new RenderTexture(mapResolution, mapResolution, 0, RenderTextureFormat.ARGBHalf, RenderTextureReadWrite.Linear);
        heatMap.enableRandomWrite = true;

        heatMap.Create();
        command = new CommandBuffer();
        command.name = "Update heat map";
        Camera.main.AddCommandBuffer(CameraEvent.BeforeGBuffer, command);

        foreach (var rdr in strangeGrassRoot.GetComponentsInChildren<Renderer>())
        {
            rdr.sharedMaterial.SetTexture("_HeatMap", heatMap);
            rdr.sharedMaterial.SetFloat("_MaxSenseDistance", maxSenseDistance);

        }
    }
    void OnDisable()
    {
        heatMap.Release();
        heatMap = null;
        command.Release();
        command = null;
        SceneView.duringSceneGui -= OnScene;
    }

    // Start is called before the first frame update
    void Start()
    {


    }
    // Update is called once per frame
    void Update()
    {
        command.Clear();
        command.SetComputeTextureParam(computeShader, 0, "_Map", heatMap);
        command.SetComputeFloatParam(computeShader, "_ExcitationIncreaceSpeed", excitationIncreaceSpeed);
        command.SetComputeFloatParam(computeShader, "_ExcitationDecaySpeed", excitationDecaySpeed);
        command.SetComputeFloatParam(computeShader, "_MaxSenseDistance", maxSenseDistance);
        command.SetComputeFloatParam(computeShader, "_DeltaTime", Time.deltaTime);
        command.SetComputeVectorParam(computeShader, "_MapToWorldST", mapToWorld);
        if (target != null)
            command.SetComputeVectorParam(computeShader, "_TargetPos", target.transform.position);
        command.DispatchCompute(computeShader, 0, mapResolution / 8, mapResolution / 8, 1);

    }
}
