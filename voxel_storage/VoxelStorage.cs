using Godot;
using System;

[GlobalClass]
public abstract partial class VoxelStorage : Resource{
    public enum Voxel{SAND, GRASS, MOUNTAIN, SNOW, AIR};

    int elements = 0;

    public abstract void AddVoxel(int x, int y, int z, Voxel voxel);
    public abstract void RemoveVoxel(int x, int y, int z);
    public abstract Voxel GetVoxel(int x, int y, int z);
    public int GetSize(){
        return elements;
    }
}