within TRANSFORM.HeatAndMassTransfer.Interfaces.Records;
record nodes
  parameter Integer n(min=1)=1 "Number of nodes"
    annotation(Dialog,  Evaluate=true);
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end nodes;
