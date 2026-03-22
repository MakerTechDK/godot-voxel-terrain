using Godot;
using System;

[GlobalClass]
public partial class GreedyMeshing : MeshingAlgorithm
{    
    public GreedyMeshing(){
        Name = "GreedyMeshing";
    }
    public override void GenerateMesh(ChunkData chunkData, MeshData meshData){
        if(chunkData.IsEmpty()) return;

        int chunkSize = chunkData.GetSize();

	    for(int b = 0; b < 2; ++b){
		    for(int d = 0; d < 3; ++d){
		    	int width = 0;
			    int height = 0;
			    int u = (d + 1) % 3;
			    int v = (d + 2) % 3;
			    Vector3 pos = Vector3.Zero;
			    Vector3 q = Vector3.Zero;
			
			    ChunkData.Voxel[] mask = new ChunkData.Voxel[chunkSize * chunkSize];
			    q[d] = 1;
    
			    Face face = Face.BACK;
			    if(d == 0) face = (b == 0) ? Face.LEFT : Face.RIGHT;
			    if(d == 1) face = (b == 0) ? Face.BOTTOM : Face.TOP;
			    if(d == 2) face = (b == 0) ? Face.BACK : Face.FRONT;
			
			    pos[d] = -1;
			    while(pos[d] < chunkSize){
				    int mask_index = 0;
				    pos[v] = 0;
				    while(pos[v] < chunkSize){
					    pos[u] = 0;
					    while(pos[u] < chunkSize){
						    ChunkData.Voxel current;
						    ChunkData.Voxel compare;
						
						    if(pos[d] >= 0) current = chunkData.GetVoxel((int)pos[0], (int)pos[1], (int)pos[2]);
						    else current = ChunkData.Voxel.AIR;

						    if(pos[d] < chunkSize - 1) compare = chunkData.GetVoxel((int)(pos[0] + q[0]), (int)(pos[1] + q[1]), (int)(pos[2] + q[2]));
						    else compare = ChunkData.Voxel.AIR;
						
						    if(b == 0){
							    if(current == ChunkData.Voxel.AIR && compare != ChunkData.Voxel.AIR) mask[mask_index] = compare;
							    else mask[mask_index] = ChunkData.Voxel.AIR;
                            } 
						    else{
							    if(current != ChunkData.Voxel.AIR && compare == ChunkData.Voxel.AIR) mask[mask_index] = current;
							    else mask[mask_index] = ChunkData.Voxel.AIR;
                            }
							
						    mask_index++;
						    pos[u]++;
                        }
					    pos[v]++;
                    }
				
				    pos[d]++;
				    mask_index = 0;
				
				    for(int j = 0; j < chunkSize; ++j){
					    for(int i = 0; i < chunkSize;){
						    ChunkData.Voxel voxel = mask[mask_index];
						
						    if(voxel == ChunkData.Voxel.AIR){
							    mask_index++;
							    i++;
							    continue;
                            }
							
						    width = 1;
						    while(i + width < chunkSize && voxel == mask[mask_index + width]) width++;
							
						    bool done = false;
                            height = 1;
						    while(height + j < chunkSize){
							    for(int k = 0; k < width; ++k){
								    if(voxel != mask[mask_index + k + height * chunkSize]){
									    done = true;
									    break;
                                    }
                                }
									
							    if(done) break;
							    height += 1;
                            }
							
						    Vector3 deltau = Vector3.Zero;
						    Vector3 deltav = Vector3.Zero;
						    deltau[u] = width;
						    deltav[v] = height;
						    pos[u] = i;
						    pos[v] = j;
						
						    addFace(pos, deltau, deltav, face, voxel, meshData);
						
						    for(int l = 0; l < height; ++l){
							    for(int k = 0; k < width; ++k){
								    mask[mask_index + k + l * chunkSize] = ChunkData.Voxel.AIR;
                                }
                            }
								
						    i += width;
						    mask_index += width;
                        }
                    }
                }
            }
        }
    }

    private void addFace(Vector3 pos, Vector3 deltau, Vector3 deltav, Face face, ChunkData.Voxel voxel, MeshData meshData){
	    Color color = Colors[voxel]	;
	    Vector3 sizeVector = deltau + deltav;			
	    var indices = faceIndices[face];
	    foreach(int[] triangle in indices) {
		    foreach(int index in triangle) {
			    Vector3 vertex = cubeVertices[index] * sizeVector;
			    meshData.AddData(vertex + pos, faceNormals[face], color);
            }
        }
    }
}
