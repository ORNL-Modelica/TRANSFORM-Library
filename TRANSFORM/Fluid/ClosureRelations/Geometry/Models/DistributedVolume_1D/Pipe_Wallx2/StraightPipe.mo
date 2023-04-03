within TRANSFORM.Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.Pipe_Wallx2;
model StraightPipe
  import TRANSFORM;
  import TRANSFORM.Math.fillArray_1D;
  extends TRANSFORM.Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.StraightPipe;
  extends PartialPipeWithWall(
    final nZ=nV,
    r_inner = surfaceArea[1]/(length*2*Modelica.Constants.pi),
    final ths_wall=fill(th_wall, nZ),
    final ths_wall_2=fill(th_wall_2, nZ),
    final drs=transpose(fillArray_1D(dr, nZ)),
    final drs_2=transpose(fillArray_1D(dr_2, nZ)),
    final dzs=fillArray_1D(dlengths, nR),
    final dzs_2=fillArray_1D(dlengths, nR_2));
  input SI.Length th_wall = 0.01 "Wall thickness or specify dr"
    annotation (Dialog(group="Inputs: Wall"));
  input SI.Length th_wall_2 = th_wall "Wall thickness or specify dr"
    annotation (Dialog(group="Inputs: Wall"));
  input SI.Length dr[nR](min=0) = fill(th_wall/nR,nR) "Wall unit volume lengths of r-dimension"
    annotation (Dialog(group="Inputs: Wall"));
  input SI.Length dr_2[nR_2](min=0) = fill(th_wall_2/nR_2,nR_2) "Wall unit volume lengths of r-dimension"
    annotation (Dialog(group="Inputs: Wall"));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end StraightPipe;
