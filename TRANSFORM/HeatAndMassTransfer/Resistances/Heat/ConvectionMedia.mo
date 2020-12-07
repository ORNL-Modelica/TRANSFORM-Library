within TRANSFORM.HeatAndMassTransfer.Resistances.Heat;
model ConvectionMedia
  "Thermal element for heat convection with Media models"
  import Modelica.Constants.pi;
  replaceable package Medium = Modelica.Media.Air.MoistAir constrainedby
    Modelica.Media.Interfaces.PartialMedium "Medium in the component"
    annotation (choicesAllMatching=true);
  parameter Integer n=1 "Number of heat transfer segments";
  input Medium.ThermodynamicState[n] states=Medium.setState_pTX(fill(1e5, n),
      port_b.T) "Thermodynamic state of fluid at port_b"
    annotation (Dialog(group="Inputs"));
  input SI.MassFlowRate m_flows[n]=zeros(n) "Mass flow rate"
    annotation (Dialog(group="Inputs"));
  input SI.Diameter dimensions[n]=fill(1, n)
    "Characteristic dimension (e.g. hydraulic diameter)"
    annotation (Dialog(group="Inputs"));
  input SI.Area crossAreas[n]=0.25*pi*dimensions.^2 "Cross sectional flow area"
    annotation (Dialog(group="Inputs"));
  input SI.Length dlengths[n]=fill(1, n)
    "Characteristic length of heat transfer segment"
    annotation (Dialog(group="Inputs"));
  input SI.Area surfaceAreas[n]=dimensions .* dlengths
    "Surface area for heat transfer"
    annotation (Dialog(group="Inputs"));
  input SI.Height roughnesses[n]=fill(2.5e-5, n)
    "Average height of surface asperities"
    annotation (Dialog(group="Inputs"));
  replaceable model HeatTransferCoeff =
      TRANSFORM.HeatAndMassTransfer.ClosureRelations.HeatTransfer.Models.Ideal
    constrainedby
    TRANSFORM.HeatAndMassTransfer.ClosureRelations.HeatTransfer.Models.PartialHeatTransfer
    "Coefficient of heat transfer" annotation (Dialog(group="Closure Models",
        enable=not IdealHeatTransfer), choicesAllMatching=true);
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
    final roughnesses=roughnesses) annotation (Placement(transformation(extent=
            {{-36,84},{-24,96}}, rotation=0)));
  Modelica.Units.SI.HeatFlowRate Q_flows[n]
    "Heat flow rate from solid -> fluid";
  Modelica.Units.SI.TemperatureDifference dTs[n] "= port_a.T - port_b.T";
  SI.ThermalResistance R[n] "Thermal resistance";
  Interfaces.HeatPort_Flow port_a[n] annotation (Placement(transformation(
          extent={{-80,-10},{-60,10}}), iconTransformation(extent={{-80,-10},{-60,
            10}})));
  Interfaces.HeatPort_Flow port_b[n] annotation (Placement(transformation(
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
    R[i] = 1/min(Modelica.Constants.eps,heatTransferCoeff.alphas* surfaceAreas);
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
          lineColor={0,0,255})}),
    Documentation(info="<html>
<p>
This is a model of linear heat convection, e.g., the heat transfer between a plate and the surrounding air; see also:
<a href=\"modelica://Modelica.Thermal.HeatTransfer.Components.ConvectiveResistor\">ConvectiveResistor</a>.
It may be used for complicated solid geometries and fluid flow over the solid by determining the
convective thermal conductance Gc by measurements. The basic constitutive equation for convection is
</p>
<pre>
   Q_flow = Gc*(solid.T - fluid.T);
   Q_flow: Heat flow rate from connector 'solid' (e.g., a plate)
      to connector 'fluid' (e.g., the surrounding air)
</pre>
<p>
Gc = G.signal[1] is an input signal to the component, since Gc is
nearly never constant in practice. For example, Gc may be a function
of the speed of a cooling fan. For simple situations,
Gc may be <i>calculated</i> according to
</p>
<pre>
   Gc = A*h
   A: Convection area (e.g., perimeter*length of a box)
   h: Heat transfer coefficient
</pre>
<p>
where the heat transfer coefficient h is calculated
from properties of the fluid flowing over the solid. Examples:
</p>
<p>
<b>Machines cooled by air</b> (empirical, very rough approximation according
to R. Fischer: Elektrische Maschinen, 10th edition, Hanser-Verlag 1999,
p. 378):
</p>
<pre>
    h = 7.8*v^0.78 [W/(m2.K)] (forced convection)
      = 12         [W/(m2.K)] (free convection)
    where
      v: Air velocity in [m/s]
</pre>
<p><b>Laminar</b> flow with constant velocity of a fluid along a
<b>flat plate</b> where the heat flow rate from the plate
to the fluid (= solid.Q_flow) is kept constant
(according to J.P.Holman: Heat Transfer, 8th edition,
McGraw-Hill, 1997, p.270):
</p>
<pre>
   h  = Nu*k/x;
   Nu = 0.453*Re^(1/2)*Pr^(1/3);
   where
      h  : Heat transfer coefficient
      Nu : = h*x/k       (Nusselt number)
      Re : = v*x*rho/mue (Reynolds number)
      Pr : = cp*mue/k    (Prandtl number)
      v  : Absolute velocity of fluid
      x  : distance from leading edge of flat plate
      rho: density of fluid (material constant
      mue: dynamic viscosity of fluid (material constant)
      cp : specific heat capacity of fluid (material constant)
      k  : thermal conductivity of fluid (material constant)
   and the equation for h holds, provided
      Re &lt; 5e5 and 0.6 &lt; Pr &lt; 50
</pre>
</html>"),
    Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}}), graphics={
        Line(points={{100,0},{100,0}}, color={0,127,255}),
        Line(points={{100,0},{100,0}}, color={0,127,255}),
        Line(points={{100,0},{100,0}}, color={0,127,255})}));
end ConvectionMedia;
