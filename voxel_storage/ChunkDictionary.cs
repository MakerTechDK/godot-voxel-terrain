using Godot;
using System;

[GlobalClass]
public partial class ChunkDictionary : VoxelStorage
{
    public override void AddVoxel(int x, int y, int z, Voxel voxel)
    {}

    public override void RemoveVoxel(int x, int y, int z)
    {}

    public override Voxel GetVoxel(int x, int y, int z)
    {
        return Voxel.AIR;
    }
}
