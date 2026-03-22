using Godot;
using System;
using System.Collections.Generic;

[GlobalClass]
public partial class MeshData: Resource
{
    private Godot.Collections.Array surfaceArray = [];
    private List<Vector3> vertices = new List<Vector3>();
    private List<Vector3> normals = new List<Vector3>();
    private List<Color> colors = new List<Color>();

    private int numberOfVertices = 0;


    public MeshData(){
        surfaceArray.Resize((int)Mesh.ArrayType.Max);
    }

    public void Commit(){
        surfaceArray[(int)Mesh.ArrayType.Vertex] = vertices.ToArray();
        surfaceArray[(int)Mesh.ArrayType.Normal] = normals.ToArray();
        surfaceArray[(int)Mesh.ArrayType.Color] = colors.ToArray();
    }

    public void AddData(Vector3 vertex, Vector3 normal, Color color){
        vertices.Add(vertex);
	    normals.Add(normal);
	    colors.Add(color);
        numberOfVertices++;
    }

    public bool IsEmpty(){
        return numberOfVertices <= 0;
    }

    public Godot.Collections.Array GetSurfaceArray(){
        return surfaceArray;
    }

    public int NumberOfVertices(){
        return numberOfVertices;
    }

    public void Reset(){
        surfaceArray.Clear();
        vertices.Clear();
        normals.Clear();
        colors.Clear();
        numberOfVertices = 0;
        surfaceArray.Resize((int)Mesh.ArrayType.Max);
    }
}
