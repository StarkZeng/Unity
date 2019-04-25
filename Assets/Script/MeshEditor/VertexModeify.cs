using System.Collections;
using System.Collections.Generic;
using UnityEngine;



public class VertexModeify : MonoBehaviour {

    // Use this for initialization
    [HideInInspector]
    public float ConrolPointSize;

    Vector3[] OriVecties;
    Vector3[] Vectices;
    GameObject[] PointObjects;

    void Start () {
       
    }

    public void DeleteControl()
    {
        Transform containerTrans = transform.Find("Contorls");
        if (containerTrans)
        {
            DestroyImmediate(containerTrans.gameObject);
        }
    }

    public void CreateControlPoints()
    {
        DeleteControl();
        GameObject container = new GameObject("Contorls");
        container.transform.parent = transform;
        container.transform.localPosition = Vector3.zero;
        container.transform.localScale = Vector3.one;

        OriVecties = GetComponent<MeshFilter>().sharedMesh.vertices;
        Vectices = GetComponent<MeshFilter>().sharedMesh.vertices;

        GameObject control = Resources.Load<GameObject>("MeshEditor/ContorlPoint");
        Vector3 size = new Vector3(ConrolPointSize, ConrolPointSize, ConrolPointSize);
        PointObjects = new GameObject[Vectices.Length];
        for (int i = 0; i < Vectices.Length; i++)
        {
            GameObject go = Instantiate(control);
            go.transform.parent = container.transform;
            go.transform.localScale = size;
            go.transform.localPosition = Vectices[i];
            go.name = i.ToString();
            go.GetComponent<ContorlPoint>().OnConrolPointMove = OnControlMove;

            PointObjects[i] = go;
        }
    }

    public void OnControlMove(string id,Vector3 pos)
    {
        Vectices[int.Parse(id)] = pos;
        Mesh mesh = GetComponent<MeshFilter>().sharedMesh;
        mesh.vertices = Vectices;
        mesh.RecalculateNormals();
    }

    public void UpdateControlPointSize()
    {
        Vector3 size = new Vector3(ConrolPointSize, ConrolPointSize, ConrolPointSize);
        for (int i = 0; i < PointObjects.Length; i++)
        {
            PointObjects[i].transform.localScale = size;
        }
    }

    public void RevertChange()
    {
        Mesh mesh = GetComponent<MeshFilter>().sharedMesh;
        mesh.vertices = OriVecties;
        mesh.RecalculateNormals();

        Vectices = mesh.vertices;

        for (int i = 0; i < Vectices.Length; i++)
        {
            PointObjects[i].transform.localPosition = Vectices[i];
        }
    }

}
