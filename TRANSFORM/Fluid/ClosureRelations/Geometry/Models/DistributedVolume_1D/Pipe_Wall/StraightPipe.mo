within TRANSFORM.Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.Pipe_Wall;
model StraightPipe
  import TRANSFORM;
  import TRANSFORM.Math.fillArray_1D;
  extends
    TRANSFORM.Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.StraightPipe;
  extends PartialPipeWithWall(
    final nZ=nV,
    final ths_wall=fill(th_wall, nZ),
    final drs=transpose(fillArray_1D(dr, nZ)),
    final dzs=fillArray_1D(dlengths, nR));
  input SI.Length th_wall = 0.01 "Wall thickness or specify dr"
    annotation (Dialog(group="Inputs: Wall"));
  input SI.Length dr[nR](min=0) = fill(th_wall/nR,nR) "Wall unit volume lengths of r-dimension"
    annotation (Dialog(group="Inputs: Wall"));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end StraightPipe;
