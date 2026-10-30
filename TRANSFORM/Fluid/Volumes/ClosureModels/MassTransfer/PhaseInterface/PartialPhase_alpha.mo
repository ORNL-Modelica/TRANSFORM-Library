within TRANSFORM.Fluid.Volumes.ClosureModels.MassTransfer.PhaseInterface;
partial model PartialPhase_alpha
  "heat transfer coefficient at the phase interface"
  // Parameters
  replaceable package Medium =
    Modelica.Media.Water.StandardWater
    constrainedby Modelica.Media.Interfaces.PartialTwoPhaseMedium
    "Medium in the component"
    annotation(Dialog(tab="Internal Interface"));
  // Inputs provided to heat transfer model
  input Medium.ThermodynamicState state_liquid
    "Thermodynamic state" annotation(Dialog(tab="Internal Interface"));
  input Medium.ThermodynamicState state_vapor
    "Thermodynamic state" annotation(Dialog(tab="Internal Interface"));
  input SI.Area surfaceArea "Mass transfer surface area"  annotation(Dialog(tab="Internal Interface"));
  Media.BaseProperties2Phase medium2_liquid(redeclare package Medium = Medium,
      state=state_liquid)
    annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));
  Media.BaseProperties2Phase medium2_vapor(redeclare package Medium = Medium,
      state=state_vapor)
    annotation (Placement(transformation(extent={{-80,-100},{-60,-80}})));
  SI.CoefficientOfHeatTransfer alpha
    "Heat transfer coefficient at vapor-liquid surface.";
  SI.HeatFlowRate Q_flow "Heat flow rate. Positive is into the liquid.";
  annotation (Icon(graphics={Ellipse(
          extent={{100,100},{-100,-100}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid), Text(
          extent={{-64,12},{64,-14}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="%name")}));
end PartialPhase_alpha;
