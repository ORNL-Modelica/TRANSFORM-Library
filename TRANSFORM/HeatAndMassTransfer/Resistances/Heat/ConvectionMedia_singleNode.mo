within TRANSFORM.HeatAndMassTransfer.Resistances.Heat;
model ConvectionMedia_singleNode
  "One-segment convective heat transfer model with a correlation"
  import Modelica.Constants.pi;
  replaceable package Medium = Modelica.Media.Air.MoistAir constrainedby Modelica.Media.Interfaces.PartialMedium
                                            "Medium in the component"
    annotation (choicesAllMatching=true);
  input SI.Pressure p = 1e5 "Fluid pressure, if state is not given" annotation (Dialog(group="Inputs"));
  input Medium.ThermodynamicState state=
      Medium.setState_pTX(p, port_b.T)
    "Fluid state for properties and velocity" annotation (Dialog(group="Inputs"));
  input SI.Velocity v=0 "Fluid velocity, if m_flow is not given"
    annotation (Dialog(group="Inputs"));
  input SI.MassFlowRate m_flow=Medium.density(state)*crossArea*v
    "Fluid mass flow rate" annotation (Dialog(group="Inputs"));
  input SI.Diameter dimension=4*crossArea/perimeter
    "Characteristic dimension (e.g. hydraulic diameter); give it, or crossArea and perimeter"
    annotation (Dialog(group="Inputs"));
  input SI.Area crossArea=0.25*pi*dimension^2 "Cross sectional flow area"
    annotation (Dialog(group="Inputs"));
  input SI.Length perimeter=pi*dimension "Wetted perimeter"
    annotation (Dialog(group="Inputs"));

  input SI.Length dlength=1 "Segment length along the flow"
    annotation (Dialog(group="Inputs"));
  input SI.Area surfaceArea=perimeter*dlength "Heat transfer surface area"
    annotation (Dialog(group="Inputs"));
  input SI.Height roughness=2.5e-5 "Average height of surface asperities"
    annotation (Dialog(group="Inputs"));
  replaceable model HeatTransferCoeff =
      TRANSFORM.HeatAndMassTransfer.ClosureRelations.HeatTransfer.Models.Ideal
    constrainedby TRANSFORM.HeatAndMassTransfer.ClosureRelations.HeatTransfer.Models.PartialHeatTransfer
    "Heat transfer coefficient model" annotation (Dialog(group="Closure Models"), choicesAllMatching=true);
  HeatTransferCoeff heatTransferCoeff(
    redeclare final package Medium = Medium,
    final nHT=1,
    final states={state},
    final Ts_wall={port_a.T},
    final Ts_fluid={port_b.T},
    final vs={m_flow/(Medium.density(state)*crossArea)},
    final dimensions={dimension},
    final crossAreas={crossArea},
    final dlengths={dlength},
    final roughnesses={roughness}) "Correlation for the heat transfer coefficient" annotation (Placement(transformation(extent={
            {-36,84},{-24,96}}, rotation=0)));
            SI.CoefficientOfHeatTransfer alpha = heatTransferCoeff.alphas[1] "Convection heat transfer coefficient";
  SI.HeatFlowRate Q_flow "Heat flow rate from surface to fluid";
  SI.TemperatureDifference dT "Surface minus fluid temperature";
  SI.ThermalResistance R "Surface to fluid thermal resistance";
  Interfaces.HeatPort_Flow port_a "Heat port at the surface" annotation (Placement(transformation(extent={{
            -80,-10},{-60,10}}), iconTransformation(extent={{-80,-10},{-60,10}})));
  Interfaces.HeatPort_Flow port_b "Heat port at the fluid" annotation (Placement(transformation(extent={{
            60,-10},{80,10}}), iconTransformation(extent={{60,-10},{80,10}})));
equation
  assert(dimension > 0, "Characteristic dimension must be > 0: give dimension, or crossArea and perimeter");

  port_a.Q_flow = Q_flow;
  port_b.Q_flow = -Q_flow;
  dT = port_a.T - port_b.T;
  if heatTransferCoeff.flagIdeal == 1 then
    port_a.T = port_b.T;
  else
    Q_flow = alpha*surfaceArea*dT;
  end if;
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
<p>Convection resistance between a surface and a fluid, which computes the heat transfer coefficient with a heat transfer model chosen from a list and the fluid's properties. It is <code>ConvectionMedia</code> for one segment, with scalar ports.</p>
<ul>
<li>The heat ports carry only a temperature and a heat flow rate: the fluid's pressure and flow reach the heat transfer model only through the inputs, not from the volume the port is connected to.</li>
<li>The segment is taken to start at the inlet: a correlation that depends on the distance from the inlet sees half of <code>dlength</code>.</li>
</ul>
</html>"),
    Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}}), graphics={
        Line(points={{100,0},{100,0}}, color={0,127,255}),
        Line(points={{100,0},{100,0}}, color={0,127,255}),
        Line(points={{100,0},{100,0}}, color={0,127,255})}));
end ConvectionMedia_singleNode;
