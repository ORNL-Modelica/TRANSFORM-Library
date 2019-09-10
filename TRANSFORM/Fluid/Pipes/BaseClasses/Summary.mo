within TRANSFORM.Fluid.Pipes.BaseClasses;
record Summary
  extends Icons.Record;
  input SI.Temperature T_effective "Unit cell mass averaged temperature"
    annotation (Dialog(group="Inputs"));
  input SI.Temperature T_max "Maximum temperature" annotation (Dialog(group="Inputs"));
  input Real xpos[:] "x-position for physical location reference" annotation (Dialog(group="Inputs"));
  input Real xpos_norm[size(xpos,1)] "x-position for physical location reference normalized by total length" annotation (Dialog(group="Inputs"));
  annotation (
    defaultComponentName="summary",
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)));
end Summary;
