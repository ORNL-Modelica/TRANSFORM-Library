within TRANSFORM.Fluid.ClosureRelations.Geometry.Models.TwoVolume_withLevel.withInternals;
partial model PartialWithInternals

  input SI.Area surfaceAreaInt_WInt=0
    "Inner transfer area of internal component (Internal wall to internal)" annotation(Dialog(group="Input Variables: Internal Structure"));
  input SI.Area surfaceAreaInt_WExt=0
    "Outer transfer area of internal component (External wall to volume)" annotation(Dialog(group="Input Variables: Internal Structure"));

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end PartialWithInternals;
