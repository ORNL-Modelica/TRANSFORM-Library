within TRANSFORM.Fluid.Interfaces.Records;
record Visualization_showName
  parameter Boolean showName = true annotation(Dialog(tab="Visualization"));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Visualization_showName;
