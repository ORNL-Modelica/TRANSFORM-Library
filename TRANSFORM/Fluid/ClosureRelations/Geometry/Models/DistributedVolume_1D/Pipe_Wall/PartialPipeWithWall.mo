within TRANSFORM.Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.Pipe_Wall;
partial model PartialPipeWithWall
  parameter Integer nR(min=1) = 1 "Number of nodes in wall r-direction";
  parameter Integer nZ(min=1) = 1 "Number of nodes in z-direction";
  input SI.Length r_inner "Wall inner radius"
    annotation (Dialog(group="Inputs: Wall"));
  input SI.Length ths_wall[nZ] "Specify wall thickness or drs"
    annotation (Dialog(group="Inputs: Wall"));
  input SI.Length drs[nR,nZ](each min=0) "Wall unit volume lengths of r-dimension"
    annotation (Dialog(group="Inputs: Wall"));
  input SI.Length dzs[nR,nZ](each min=0) "Wall unit volume lengths of z-dimension"
    annotation (Dialog(group="Inputs: Wall"));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end PartialPipeWithWall;
