within TRANSFORM.HeatAndMassTransfer.Resistances.Heat;
model ConvectionMediaSimple
  "Convective heat transfer model without a correlation"

  replaceable package Medium = Modelica.Media.Air.MoistAir constrainedby Modelica.Media.Interfaces.PartialMedium
                                            "Medium in the component"
    annotation (choicesAllMatching=true);
  input SI.Pressure p = 1e5 "Fluid pressure, if state is not given" annotation (Dialog(group="Inputs"));
  input Medium.ThermodynamicState state=
      Medium.setState_pTX(p, port_b.T)
    "Fluid state at port_b" annotation (Dialog(group="Inputs"));
  input SI.Velocity v "Flow velocity"
    annotation (Dialog(group="Inputs"));
  input SI.Diameter dimension
    "Characteristic dimension (e.g. hydraulic diameter)"
    annotation (Dialog(group="Inputs"));
  input SI.Area surfaceArea "Heat transfer surface area"
    annotation (Dialog(group="Inputs"));

  input SI.CoefficientOfHeatTransfer alpha "Convection heat transfer coefficient" annotation(Dialog(group="Inputs"));
  SI.HeatFlowRate Q_flow "Heat flow rate from surface to fluid";
  SI.TemperatureDifference dT "Surface minus fluid temperature";
  SI.ThermalResistance R "Surface to fluid thermal resistance";
  Interfaces.HeatPort_Flow port_a "Heat port at the surface" annotation (Placement(transformation(extent={{
            -80,-10},{-60,10}}), iconTransformation(extent={{-80,-10},{-60,10}})));
  Interfaces.HeatPort_Flow port_b "Heat port at the fluid" annotation (Placement(transformation(extent={{
            60,-10},{80,10}}), iconTransformation(extent={{60,-10},{80,10}})));
equation

  port_a.Q_flow = Q_flow;
  port_b.Q_flow = -Q_flow;
  dT = port_a.T - port_b.T;
  Q_flow = alpha*surfaceArea*dT;
  R = 1/max(Modelica.Constants.eps, alpha*surfaceArea);

  annotation (
    defaultComponentName="convection",
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,100}}),
        graphics={
        Rectangle(
          extent={{-30,60},{70,-60}},
          lineColor={255,255,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(points={{100,0},{100,0}}, color={0,127,255}),
        Line(points={{-30,20},{44,20}}, color={191,0,0}),
        Line(points={{-30,-20},{44,-20}}, color={191,0,0}),
        Line(points={{-16,60},{-16,-60}}, color={0,127,255}),
        Line(points={{14,60},{14,-60}}, color={0,127,255}),
        Line(points={{44,60},{44,-60}}, color={0,127,255}),
        Line(points={{-16,-60},{-26,-40}}, color={0,127,255}),
        Line(points={{-16,-60},{-6,-40}}, color={0,127,255}),
        Line(points={{14,-60},{4,-40}}, color={0,127,255}),
        Line(points={{14,-60},{24,-40}}, color={0,127,255}),
        Line(points={{44,-60},{34,-40}}, color={0,127,255}),
        Line(points={{44,-60},{54,-40}}, color={0,127,255}),
        Line(points={{24,-30},{44,-20}}, color={191,0,0}),
        Line(points={{24,-10},{44,-20}}, color={191,0,0}),
        Line(points={{24,10},{44,20}}, color={191,0,0}),
        Line(points={{24,30},{44,20}}, color={191,0,0}),
        Rectangle(
          extent={{-30,60},{-70,-60}},
          lineColor={0,0,0},
          fillColor={175,175,175},
          fillPattern=FillPattern.Forward),
        Text(
          extent={{-150,104},{150,64}},
          textString="%name",
          textColor={0,0,255})}),
    Documentation(info="<html>
<p>Convection resistance between a surface and a fluid, for a user specified heat transfer coefficient <code>alpha</code>, as in <code>Convection</code>.</p>
<ul>
<li>Only <code>alpha</code> and <code>surfaceArea</code> set the heat flow rate: the medium, <code>p</code>, <code>state</code>, <code>v</code> and <code>dimension</code> do not enter it.</li>
</ul>
</html>"),
    Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}}), graphics={
        Line(points={{100,0},{100,0}}, color={0,127,255}),
        Line(points={{100,0},{100,0}}, color={0,127,255}),
        Line(points={{100,0},{100,0}}, color={0,127,255})}));
end ConvectionMediaSimple;
