using Godot;
using System;
using System.Runtime.CompilerServices;

[GlobalClass]
public partial class SkipHiddenFaces : MeshingAlgorithm
{
    public SkipHiddenFaces(){
        Name = "SkipHiddenFaces";
    }
    public override void GenerateMesh(ChunkData chunkData, MeshData meshData)
    {
        if(chunkData.IsEmpty()) return;

        int size = chunkData.GetSize();
        for(int x = 0; x < size; ++x){
            for(int y = 0; y < size; ++y){
                for(int z = 0; z < size; ++z){
                    ChunkData.Voxel voxel = chunkData.GetVoxel(x, y, z);
                    Vector3 position = new Vector3(x, y, z);
                    if(voxel == ChunkData.Voxel.AIR) continue;

                    if(!hasNeighbour(chunkData, Face.FRONT, position)) addFace(position, Face.FRONT, voxel, meshData);
                    if(!hasNeighbour(chunkData, Face.BACK, position)) addFace(position, Face.BACK, voxel, meshData);
                    if(!hasNeighbour(chunkData, Face.LEFT, position)) addFace(position, Face.LEFT, voxel, meshData);
                    if(!hasNeighbour(chunkData, Face.RIGHT, position)) addFace(position, Face.RIGHT, voxel, meshData);
                    if(!hasNeighbour(chunkData, Face.TOP, position)) addFace(position, Face.TOP, voxel, meshData);
                    if(!hasNeighbour(chunkData, Face.BOTTOM, position)) addFace(position, Face.BOTTOM, voxel, meshData);
                }
            }
        }
    }

private bool hasNeighbour(ChunkData data, Face face, Vector3 position){
	var neighbourPosition = position + faceNormals[face];
	if(data.GetVoxel((int)neighbourPosition.X, (int)neighbourPosition.Y, (int)neighbourPosition.Z) == ChunkData.Voxel.AIR) return false;
	return true;
}
	
	
private void addFace(Vector3 position, Face face, ChunkData.Voxel voxel, MeshData meshData){
	Color color = Colors[voxel];
	int[][] indices = faceIndices[face];
	foreach(int[] triangle in indices){
		foreach(int index in triangle){
			meshData.AddData(cubeVertices[index] + position, faceNormals[face], color);
        }
    }
}

}