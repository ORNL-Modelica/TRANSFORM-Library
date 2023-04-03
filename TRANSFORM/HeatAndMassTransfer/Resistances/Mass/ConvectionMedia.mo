within TRANSFORM.HeatAndMassTransfer.Resistances.Mass;
model ConvectionMedia
  "Mass element for mass convection with Media models"
  replaceable package Medium = Modelica.Media.Air.MoistAir constrainedby Modelica.Media.Interfaces.PartialMedium
                                            "Medium in the component"
    annotation (choicesAllMatching=true);
  parameter Integer n=1 "Number of mass transfer segments";
  parameter Integer nC = 1 "Number of substances";
  input Medium.ThermodynamicState[n] states=Medium.setState_pTX(fill(1e5, n),
      fill(Medium.T_default, n)) "Thermodynamic state of fluid at port_b"
    annotation (Dialog(group="Inputs"));
  input SI.Temperature Ts_wall[n] "Wall temperature"
    annotation (Dialog(group="Inputs"));
  input SI.MassFlowRate m_flows[n]=zeros(n) "Mass flow rate"
    annotation (Dialog(group="Inputs"));
  input SI.Diameter dimensions[n]=fill(1, n)
    "Characteristic dimension (e.g. hydraulic diameter)"
    annotation (Dialog(group="Inputs"));
  input SI.Area crossAreas[n]=fill(1, n) "Cross sectional flow area"
    annotation (Dialog(group="Inputs"));
  input SI.Length dlengths[n]=fill(1, n)
    "Characteristic length of mass transfer segment"
    annotation (Dialog(group="Inputs"));
  input SI.Area surfaceAreas[n]=dimensions ./ dlengths
    "Surface area for mass transfer"
    annotation (Dialog(group="Inputs"));
  input SI.Height roughnesses[n]=fill(2.5e-5, n)
    "Average height of surface asperities"
    annotation (Dialog(group="Inputs"));
  replaceable model MassTransferCoeff =
      TRANSFORM.HeatAndMassTransfer.ClosureRelations.MassTransfer.Models.Ideal
    constrainedby TRANSFORM.HeatAndMassTransfer.ClosureRelations.MassTransfer.Models.PartialMassTransfer
    "Coefficient of mass transfer" annotation (Dialog(group="Closure Models",
        enable=not IdealHeatTransfer), choicesAllMatching=true);
  MassTransferCoeff massTransferCoeff(
    redeclare final package Medium = Medium,
    final nMT=n,
    final nC=nC,
    final Ts_wall=Ts_wall,
    final states=states,
    final Cs_wall=port_a.C,
    final Cs_fluid=port_b.C,
    final vs=m_flows ./ (Medium.density(states) .* crossAreas),
    final dimensions=dimensions,
    final crossAreas=crossAreas,
    final dlengths=dlengths,
    final roughnesses=roughnesses) annotation (Placement(transformation(extent={
            {-36,84},{-24,96}}, rotation=0)));
  SI.MolarFlowRate n_flows[n,nC] "Mole flow rate from port_a -> port_b";
  SI.Concentration dCs[n,nC] "= port_a.C - port_b.C";
  Units.DiffusionResistance R[n,nC] "Thermal resistance";
  Interfaces.MolePort_Flow port_a[n](each nC=nC) annotation (Placement(
        transformation(extent={{-80,-10},{-60,10}}),  iconTransformation(extent=
           {{-80,-10},{-60,10}})));
  Interfaces.MolePort_Flow port_b[n](each nC=nC) annotation (Placement(
        transformation(extent={{60,-10},{80,10}}), iconTransformation(extent={{60,
            -10},{80,10}})));
equation
  port_a.n_flow = n_flows;
  port_b.n_flow = -n_flows;
  dCs =port_a.C - port_b.C;
  if massTransferCoeff.flagIdeal == 1 then
    port_a.C = port_b.C;
  else
    for i in 1:n loop
      n_flows[i,:] = massTransferCoeff.alphasM[i,:]  .* surfaceAreas[i] .* dCs[i,:];
    end for;
  end if;
  for i in 1:n loop
    for j in 1:nC loop
      R[i,j] = 1./min(Modelica.Constants.eps,massTransferCoeff.alphasM[i,j] .* surfaceAreas[i]);
    end for;
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
