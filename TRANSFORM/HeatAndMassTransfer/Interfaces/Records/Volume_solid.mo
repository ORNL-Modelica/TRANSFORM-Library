within TRANSFORM.HeatAndMassTransfer.Interfaces.Records;
record Volume_solid

  replaceable package Material =
      TRANSFORM.Media.Solids.SS316                     constrainedby
    TRANSFORM.Media.Interfaces.Solids.PartialAlloy
    "Material in the component"
      annotation (choicesAllMatching = true);

  parameter SI.Temperature T_start = Material.T_reference "Temperature"
    annotation(Dialog(tab = "Initialization",group="Start Value: Temperature"));

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Volume_solid;
