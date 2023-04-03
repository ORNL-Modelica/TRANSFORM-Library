within TRANSFORM.Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.Pipe_Wall;
model GenericPipe
  import TRANSFORM;
  import TRANSFORM.Math.fillArray_1D;
  extends TRANSFORM.Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.GenericPipe;
  extends PartialPipeWithWall(
    final nZ=nV,
    r_inner=sum(surfaceAreas[1,:])/(sum(dlengths)/nZ*2*Modelica.Constants.pi),
    ths_wall=fill(0.01, nZ),
    drs=fillArray_1D(ths_wall/nR, nR),
    dzs=fillArray_1D(dlengths, nR));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end GenericPipe;
