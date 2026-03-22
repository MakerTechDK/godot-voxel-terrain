using Godot;
using System;

[GlobalClass]
public partial class ChunkData: Resource
{

    public enum Voxel{SAND, GRASS, MOUNTAIN, SNOW, AIR};

    private Voxel[] voxels;
    private int size = 32;
    private int numberOfVoxels = 0;


    public ChunkData(){
        SetSize(size);
    }

    public int GetSize() {
        return size;
    }

    public void SetSize(int newSize){
        size = newSize;
        
        voxels = new Voxel[size*size*size];
        for(int i = 0; i < size*size*size; ++i){
            voxels[i] = Voxel.AIR;
        }
        numberOfVoxels = 0;
    }

    public void AddVoxel(int x, int y, int z, Voxel voxel){
        if (x < 0 || y < 0 || z < 0 || x >= size || y >= size || z >= size) return;
        voxels[positionToIndex(x, y, z)] = voxel;
        if(voxel != Voxel.AIR) numberOfVoxels++;
    }

    public void RemoveVoxel(int x, int y, int z){
        var voxel = GetVoxel(x, y, z);
        if(voxel == Voxel.AIR) return;

        int index = positionToIndex(x, y, z);
        voxels[index] = Voxel.AIR;
        numberOfVoxels--;
    }

    public Voxel GetVoxel(int x, int y, int z){
        if(x < 0 || y < 0 || z < 0 || x >= size || y >= size || z >= size) return Voxel.AIR;
        return voxels[positionToIndex(x, y, z)];
    }

    public int NumberOfVoxels(){
        return numberOfVoxels;
    }

    public bool IsEmpty(){
        return numberOfVoxels <= 0;
    }

    private int positionToIndex(int x, int y, int z){
        return x + z * size + y * size * size;
    }

}
