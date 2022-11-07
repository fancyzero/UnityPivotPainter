using System.Collections;
using System.Collections.Generic;
using UnityEngine;
[ExecuteAlways]
public class StrangeGrassAttractor : MonoBehaviour
{
    public GameObject strangeGrass;
    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        foreach( var rd in strangeGrass.GetComponentsInChildren<Renderer>() )
        {
            rd.sharedMaterial.SetVector("_LookAt", transform.position);
        }
    }
}
