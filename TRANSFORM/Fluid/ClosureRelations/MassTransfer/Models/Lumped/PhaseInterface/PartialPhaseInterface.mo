within TRANSFORM.Fluid.ClosureRelations.MassTransfer.Models.Lumped.PhaseInterface;
partial model PartialPhaseInterface
  "Mass flow rate at the vapor-liquid interface. Positive is into the liquid."
  extends PartialMassTransfer(
     final flagIdeal=0, redeclare replaceable package Medium =
        Modelica.Media.Water.StandardWater constrainedby Modelica.Media.Interfaces.PartialTwoPhaseMedium,
      final state=state_liquid);
  // Inputs provided to heat transfer model
  input Medium.ThermodynamicState state_liquid
    "Thermodynamic state" annotation(Dialog(tab="Internal Interface",group="Inputs"));
  input Medium.ThermodynamicState state_vapor
    "Thermodynamic state" annotation(Dialog(tab="Internal Interface",group="Inputs"));
  input SI.Area surfaceArea "Mass transfer surface area"  annotation(Dialog(tab="Internal Interface",group="Inputs"));
  Media.BaseProperties2Phase medium_liquid(redeclare package Medium = Medium,
      state=state_liquid)
    annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));
  Media.BaseProperties2Phase medium_vapor(redeclare package Medium = Medium,
      state=state_vapor)
    annotation (Placement(transformation(extent={{-80,-100},{-60,-80}})));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end PartialPhaseInterface;
