within TRANSFORM.Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.Pipe_Wall;
model StandardPipe "StandardPipe | Uses NPS schedules"
  import TRANSFORM;
  import TRANSFORM.Math.fillArray_1D;
  extends TRANSFORM.Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.StandardPipe;

  extends PartialPipeWithWall(
    final nZ=nV,
    r_inner = surfaceArea[1]/(length*2*Modelica.Constants.pi),
    final ths_wall=fill(nps.th_wall, nZ),
    final drs=transpose(fillArray_1D(dr, nZ)),
    final dzs=fillArray_1D(dlengths, nR));
    extends Icons.UnderConstruction;
  input SI.Length dr[nR](min=0) = fill(nps.th_wall/nR,nR) "Wall unit volume lengths of r-dimension"
    annotation (Dialog(group="Inputs: Wall"));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end StandardPipe;
