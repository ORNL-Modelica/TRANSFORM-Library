within TRANSFORM.Fluid.ClosureRelations.Geometry.Models.TwoVolume_withLevel.withInternals;
model Cylinder_wInternalPipe

  extends
    TRANSFORM.Fluid.ClosureRelations.Geometry.Models.TwoVolume_withLevel.Cylinder;

  parameter Real nTubes=1 "Total number of parallel tubes"
     annotation(Dialog(group="Parameters: Internal Structure"));

  parameter SI.Length length_tube=length "Effective tubelength (single tube)"
     annotation(Dialog(group="Parameters: Internal Structure"));
  parameter SI.Length r_tube_inner=0.01 "Inner radius of internal tube"
     annotation(Dialog(group="Parameters: Internal Structure"));

  parameter SI.Length th_tube=0.001 "Internal tube wall thickness"
     annotation(Dialog(group="Parameters: Internal Structure"));

  extends PartialWithInternals(
  surfaceAreaInt_WInt=nTubes*2*pi*r_tube_inner*length_tube,
  surfaceAreaInt_WExt=nTubes*2*pi*r_tube_outer*length_tube);

  final parameter SI.Length r_tube_outer=r_tube_inner+th_tube "Outer radius of internal tube";
  SI.Volume VInt "Total volume of internal structure";

equation
  assert(V-VInt > 0, "Internal structure volume is greater than the component volume");

  VInt = nTubes*pi*r_tube_outer^2*length_tube;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Cylinder_wInternalPipe;
