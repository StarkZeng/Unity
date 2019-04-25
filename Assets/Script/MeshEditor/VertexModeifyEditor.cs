using System.Collections;
using System.Collections.Generic;
using UnityEngine;

using UnityEditor;
[CustomEditor(typeof(VertexModeify))]
[ExecuteInEditMode]
public class VertexModeifyEditor : Editor
{

    VertexModeify vm;

   

    void OnEnable()
    {
    }

   

    public override void OnInspectorGUI()
    {
        base.OnInspectorGUI();

        vm = (VertexModeify)target;
        

        EditorGUILayout.BeginHorizontal();
        EditorGUILayout.LabelField("控制点大小");
        vm.ConrolPointSize = EditorGUILayout.Slider(vm.ConrolPointSize, 0, 10);
        EditorGUILayout.EndHorizontal();

        if (GUI.changed)
        {
            vm.UpdateControlPointSize();
        }

        if (GUILayout.Button("Create Control Point"))
        {
            vm.CreateControlPoints();
        }

        if (GUILayout.Button("Delete Control Point"))
        {
            vm.DeleteControl();
        }

        if (GUILayout.Button("Revert All Change"))
        {
            vm.RevertChange();
        }


        if (GUILayout.Button("Apply"))
        {
           
        }

    }
}
