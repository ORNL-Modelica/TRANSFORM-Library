within TRANSFORM.HeatAndMassTransfer.Interfaces.Records;
record Material_solid

  replaceable package Material =
      TRANSFORM.Media.Solids.SS316                     constrainedby
    TRANSFORM.Media.Interfaces.Solids.PartialAlloy
    "Material in the component"
      annotation (choicesAllMatching = true);

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Material_solid;
