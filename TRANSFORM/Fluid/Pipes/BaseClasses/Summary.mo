within TRANSFORM.Fluid.Pipes.BaseClasses;
record Summary
  extends Icons.Record;
  SI.Temperature T_effective "Unit cell mass averaged temperature"
    annotation (Dialog(group="Inputs"));
  SI.Temperature T_max "Maximum temperature" annotation (Dialog(group="Inputs"));
  Real xpos[:] "x-position for physical location reference" annotation (Dialog(group="Inputs"));
  Real xpos_norm[size(xpos,1)] "x-position for physical location reference normalized by total length" annotation (Dialog(group="Inputs"));
  annotation (
    defaultComponentName="summary",
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)));
end Summary;
