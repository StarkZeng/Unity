using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class ContorlPoint : MonoBehaviour {

    // Use this for initialization
    public delegate void OnConrolPointMoveDelegate(string id, Vector3 pos);
    public OnConrolPointMoveDelegate OnConrolPointMove = null;
    Vector3 lastPosition;
	void Start () {
        lastPosition = transform.localPosition;
    }
	
	// Update is called once per frame
	void Update () {
		if(lastPosition != transform.localPosition)
        {
            if(OnConrolPointMove != null)
            {
                OnConrolPointMove(name, transform.localPosition);
            }
            
            lastPosition = transform.localPosition;
        }
	}
}
