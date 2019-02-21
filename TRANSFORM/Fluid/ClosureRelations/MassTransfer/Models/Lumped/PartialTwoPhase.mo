within TRANSFORM.Fluid.ClosureRelations.MassTransfer.Models.Lumped;
partial model PartialTwoPhase
  extends PartialMassTransfer(
     final flagIdeal=0, replaceable package Medium =
        Modelica.Media.Water.StandardWater constrainedby
      Modelica.Media.Interfaces.PartialTwoPhaseMedium);
  TRANSFORM.Media.BaseProperties2Phase medium(redeclare package Medium =
        Medium, state=state) "Bulk fluid properties"
    annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end PartialTwoPhase;
