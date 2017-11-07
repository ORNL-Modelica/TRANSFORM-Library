within TRANSFORM.Fluid.Volumes.ClosureModels.MassTransfer.Condensation;
partial model PartialBulkCondensation

  // Parameters
  replaceable package Medium =
    Modelica.Media.Water.StandardWater
    constrainedby Modelica.Media.Interfaces.PartialTwoPhaseMedium
    "Medium in the component"
    annotation(Dialog(tab="Internal Interface"));

  // Inputs provided to heat transfer model
  input Medium.ThermodynamicState state
    "Thermodynamic state" annotation(Dialog(tab="Internal Interface"));

  Media.BaseProperties2Phase medium2(redeclare package Medium = Medium, state=
        state)
    annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));

  SI.MassFlowRate m_flow "Mass flow rate of vapor bubbles";

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
end PartialBulkCondensation;
