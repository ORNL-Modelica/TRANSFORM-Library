within TRANSFORM.Fluid.Interfaces.Records;
record Medium_fluidInternal
  replaceable package Medium = Modelica.Media.Interfaces.PartialMedium
    "Medium in the component" annotation (choicesAllMatching=true,Dialog(tab="Internal Interface"));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Medium_fluidInternal;
