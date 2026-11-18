within TRANSFORM.HeatAndMassTransfer.Resistances.Heat;
model ConvectionMedia
  "Convective heat transfer resistance model with a correlation"
  import Modelica.Constants.pi;
  replaceable package Medium = Modelica.Media.Air.MoistAir constrainedby Modelica.Media.Interfaces.PartialMedium
                                            "Medium in the component"
    annotation (choicesAllMatching=true);
  parameter Integer n=1 "# of heat transfer segments";
  input Medium.ThermodynamicState[n] states=Medium.setState_pTX(fill(1e5, n),
      port_b.T) "Fluid state for properties and velocity"
    annotation (Dialog(group="Inputs"));
  input SI.MassFlowRate m_flows[n]=zeros(n) "Fluid mass flow rate"
    annotation (Dialog(group="Inputs"));
  input SI.Diameter dimensions[n]=fill(1, n)
    "Characteristic dimension (e.g. hydraulic diameter)"
    annotation (Dialog(group="Inputs"));
  input SI.Area crossAreas[n]=0.25*pi*dimensions.^2 "Cross sectional flow area"
    annotation (Dialog(group="Inputs"));
  input SI.Length dlengths[n]=fill(1, n)
    "Segment length along the flow"
    annotation (Dialog(group="Inputs"));
  input SI.Area surfaceAreas[n]=dimensions .* dlengths
    "Heat transfer surface area"
    annotation (Dialog(group="Inputs"));
  input SI.Height roughnesses[n]=fill(2.5e-5, n)
    "Average height of surface asperities"
    annotation (Dialog(group="Inputs"));
  replaceable model HeatTransferCoeff =
      TRANSFORM.HeatAndMassTransfer.ClosureRelations.HeatTransfer.Models.Ideal
    constrainedby TRANSFORM.HeatAndMassTransfer.ClosureRelations.HeatTransfer.Models.PartialHeatTransfer
    "Heat transfer coefficient model" annotation (Dialog(group="Closure Models"), choicesAllMatching=true);
  HeatTransferCoeff heatTransferCoeff(
    redeclare final package Medium = Medium,
    final nHT=n,
    final states=states,
    final Ts_wall=port_a.T,
    final Ts_fluid=port_b.T,
    final vs=m_flows ./ (Medium.density(states) .* crossAreas),
    final dimensions=dimensions,
    final crossAreas=crossAreas,
    final dlengths=dlengths,
    final roughnesses=roughnesses) "Correlation for the heat transfer coefficients" annotation (Placement(transformation(extent=
            {{-36,84},{-24,96}}, rotation=0)));
  Modelica.Units.SI.HeatFlowRate Q_flows[n]
    "Heat flow rate from surface to fluid";
  Modelica.Units.SI.TemperatureDifference dTs[n]
    "Surface minus fluid temperature";
  SI.ThermalResistance R[n] "Surface to fluid thermal resistance";
  Interfaces.HeatPort_Flow port_a[n] "Heat ports at the surface" annotation (Placement(transformation(
          extent={{-80,-10},{-60,10}}), iconTransformation(extent={{-80,-10},{-60,
            10}})));
  Interfaces.HeatPort_Flow port_b[n] "Heat ports at the fluid" annotation (Placement(transformation(
          extent={{60,-10},{80,10}}), iconTransformation(extent={{60,-10},{80,
            10}})));
equation
  port_a.Q_flow = Q_flows;
  port_b.Q_flow = -Q_flows;
  dTs =port_a.T - port_b.T;
  if heatTransferCoeff.flagIdeal == 1 then
    port_a.T = port_b.T;
  else
    Q_flows = heatTransferCoeff.alphas .* surfaceAreas .* dTs;
  end if;
  for i in 1:n loop
    R[i] = 1/max(Modelica.Constants.eps, heatTransferCoeff.alphas[i]*surfaceAreas[i]);
  end for;
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
        Line(points={{14,60},{14,-60}},   color={0,127,255}),
        Line(points={{44,60},{44,-60}}, color={0,127,255}),
        Line(points={{-16,-60},{-26,-40}}, color={0,127,255}),
        Line(points={{-16,-60},{-6,-40}},  color={0,127,255}),
        Line(points={{14,-60},{4,-40}},    color={0,127,255}),
        Line(points={{14,-60},{24,-40}},  color={0,127,255}),
        Line(points={{44,-60},{34,-40}},color={0,127,255}),
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
<p>Convection resistance between a surface and a fluid in each of <code>n</code> segments, which computes the heat transfer coefficient with a heat transfer model chosen from a list and the fluid's properties. <code>Convection</code> takes the coefficient as an input instead, and <code>ConvectionMedia_singleNode</code> is the same model for one segment, with scalar ports.</p>
<ul>
<li>The heat ports carry only a temperature and a heat flow rate: the fluid's pressure and flow reach the heat transfer model only through the inputs, not from the volume the port is connected to.</li>
<li>The segments are in series along the flow, segment 1 at the inlet when <code>m_flows</code> is positive: a correlation that depends on the distance from the inlet sees the <code>dlengths</code> of the segments upstream.</li>
</ul>
</html>"),
    Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}}), graphics={
        Line(points={{100,0},{100,0}}, color={0,127,255}),
        Line(points={{100,0},{100,0}}, color={0,127,255}),
        Line(points={{100,0},{100,0}}, color={0,127,255})}));
end ConvectionMedia;
