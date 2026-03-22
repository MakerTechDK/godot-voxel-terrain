using Godot;
using System;
using System.Collections.Generic;


[GlobalClass]
public abstract partial class MeshingAlgorithm: Resource
{
    public enum Face{BOTTOM, FRONT, RIGHT, TOP, LEFT, BACK}

    public String Name = "noName";

    protected Godot.Collections.Dictionary<ChunkData.Voxel, Color> Colors;
    
    protected Vector3[] cubeVertices = [
	    new Vector3(0, 0, 1),
	    new Vector3(1, 0, 1),
 	    new Vector3(1, 0, 0),
 	    new Vector3(0, 0, 0),
	    new Vector3(0, 1, 1),
	    new Vector3(1, 1, 1),
 	    new Vector3(1, 1, 0),
 	    new Vector3(0, 1, 0)
    ];

    protected Dictionary<Face, int[][]>  faceIndices = new Dictionary<Face, int[][]>{
        {Face.FRONT, [[0, 4, 5],[0, 5, 1]]},
        {Face.BACK, [[2, 7, 3],[2, 6, 7]]},
        {Face.LEFT, [[3, 7, 4],[3, 4, 0]]},
        {Face.RIGHT, [[1, 5, 6],[1, 6, 2]]},
        {Face.BOTTOM, [[0, 1, 2],[0, 2, 3]]},
        {Face.TOP, [[4, 7, 6],[4, 6, 5]]}
    };

    protected Dictionary<Face, Vector3> faceNormals = new Dictionary<Face, Vector3> {
        {Face.FRONT, new Vector3(0, 0, 1)},
        {Face.BACK, new Vector3(0, 0, -1)},
        {Face.LEFT, new Vector3(-1, 0, 0)},
        {Face.RIGHT, new Vector3(1, 0, 0)},
        {Face.BOTTOM, new Vector3(0, -1, 0)},
        {Face.TOP, new Vector3(0, 1, 0)}
    };

    public void SetColors(Godot.Collections.Dictionary<ChunkData.Voxel, Color> c){
        Colors = c;
    }

    public abstract void GenerateMesh(ChunkData chunkData, MeshData mesh_data);

}