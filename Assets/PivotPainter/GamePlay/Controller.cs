using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Controller : MonoBehaviour
{
    new public Transform camera;
    public Transform character;
    public Transform cameraSocket;
    public Transform cameraLookAt;
    float cameraHDist = 10;
    float cameraHeight = 1;

    float cameraRotate = 0;
    
    public float moveForce = 4;
    // Start is called before the first frame update
    void Start()
    {

    }

    void OnDestroy()
    {
                Cursor.visible = true;
        Cursor.lockState = CursorLockMode.None;
    }
    float CameraHeightFromHDistance(float hdist)
    {   
        float a = (hdist-5.5f)/(40-5.5f);
        return Mathf.Lerp(8,35,a*a);
    }
    // Update is called once per frame
    void Update()
    {
        Cursor.visible = false;
        Cursor.lockState = CursorLockMode.Locked;
        float mx = Input.GetAxis("Mouse X");
        float mw = Input.GetAxis("Mouse ScrollWheel");
        float x = Input.GetAxis("Horizontal");
        float y = Input.GetAxis("Vertical");

        // Cursor.visible = false;
        Vector3 camTargetPos;
        cameraHDist += mw*-10;
        cameraHDist = Mathf.Clamp(cameraHDist,5.5f,40.0f);
        cameraHeight = CameraHeightFromHDistance(cameraHDist);        
        
        //rotate character using mouse x axis
        Quaternion charRotate = Quaternion.AngleAxis( 4*mx, Vector3.up);
        character.rotation = charRotate * character.rotation;
        Vector3 characterLookDir = character.TransformDirection(Vector3.forward);
        Vector3 forwardDir = character.TransformDirection(Vector3.forward);
        Vector3 leftDir = character.TransformDirection(Vector3.left);
        forwardDir.y = 0;        
        leftDir.y = 0;
        forwardDir = forwardDir.normalized;
        leftDir = leftDir.normalized;
        Vector3 v = forwardDir*y+leftDir*-x;;
        v = v.normalized;
        GetComponent<Rigidbody>().AddRelativeForce(v *moveForce, ForceMode.Acceleration);
        if ( y ==0 && x ==0 &&   GetComponentInChildren<Rigidbody>().velocity.magnitude > 0.1)
        {
            GetComponent<Rigidbody>().AddRelativeForce(-v *moveForce, ForceMode.Acceleration);
        }


        Vector3 camOffset = new Vector3( 0, cameraHeight, -cameraHDist);
        camTargetPos =  character.TransformPoint(camOffset);
        camera.position = Vector3.Lerp( camera.position,camTargetPos,1);
        camera.rotation = Quaternion.LookRotation((cameraLookAt.position - camera.position).normalized, Vector3.up);
        
    }
}
