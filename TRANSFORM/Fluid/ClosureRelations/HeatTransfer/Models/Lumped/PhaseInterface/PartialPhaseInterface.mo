within TRANSFORM.Fluid.ClosureRelations.HeatTransfer.Models.Lumped.PhaseInterface;
partial model PartialPhaseInterface
  extends TRANSFORM.Fluid.Interfaces.Records.Medium_fluidInternal(
      redeclare replaceable package Medium =
                       Modelica.Media.Water.StandardWater constrainedby
      Modelica.Media.Interfaces.PartialTwoPhaseMedium);
  // Inputs provided to heat transfer model
  input Medium.ThermodynamicState state_liquid "Thermodynamic state"
    annotation (Dialog(tab="Internal Interface", group="Inputs"));
  input Medium.ThermodynamicState state_vapor "Thermodynamic state"
    annotation (Dialog(tab="Internal Interface", group="Inputs"));
  input SI.Area surfaceArea "Mass transfer surface area"
    annotation (Dialog(tab="Internal Interface", group="Inputs"));
  Media.BaseProperties2Phase medium_liquid(redeclare package Medium = Medium,
      state=state_liquid)
    annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));
  Media.BaseProperties2Phase medium_vapor(redeclare package Medium = Medium,
      state=state_vapor)
    annotation (Placement(transformation(extent={{-80,-100},{-60,-80}})));
  SI.CoefficientOfHeatTransfer alpha
    "Heat transfer coefficient at vapor-liquid surface.";
  SI.HeatFlowRate Q_flow=port_liquid.Q_flow "Heat flow rate.";
  HeatAndMassTransfer.Interfaces.HeatPort_Flow port_liquid annotation (
      Placement(transformation(extent={{-110,-10},{-90,10}}),
        iconTransformation(extent={{-110,-10},{-90,10}})));
  HeatAndMassTransfer.Interfaces.HeatPort_Flow port_vapor annotation (Placement(
        transformation(extent={{90,-10},{110,10}}), iconTransformation(extent={{
            90,-10},{110,10}})));
equation
  port_liquid.Q_flow + port_vapor.Q_flow = 0;
  Q_flow = alpha .* surfaceArea .* (port_liquid.T - port_vapor.T);
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end PartialPhaseInterface;
