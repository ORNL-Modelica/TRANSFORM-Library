within TRANSFORM.HeatAndMassTransfer.Resistances.Mass;
model ConvectionMedia
  "Convective mass transfer resistance model with a correlation"
  replaceable package Medium = Modelica.Media.Air.MoistAir constrainedby Modelica.Media.Interfaces.PartialMedium
                                            "Medium in the component"
    annotation (choicesAllMatching=true);
  parameter Integer n=1 "# of mass transfer segments";
  parameter Integer nC = 1 "# of substances";
  input Medium.ThermodynamicState[n] states=Medium.setState_pTX(fill(1e5, n),
      fill(Medium.T_default, n)) "Fluid state for properties and velocity"
    annotation (Dialog(group="Inputs"));
  input SI.Temperature Ts_wall[n] "Wall temperature"
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
  input SI.Area surfaceAreas[n]=pi*dimensions .* dlengths
    "Mass transfer surface area"
    annotation (Dialog(group="Inputs"));
  input SI.Height roughnesses[n]=fill(2.5e-5, n)
    "Average height of surface asperities"
    annotation (Dialog(group="Inputs"));
  replaceable model MassTransferCoeff =
      TRANSFORM.HeatAndMassTransfer.ClosureRelations.MassTransfer.Models.Ideal
    constrainedby TRANSFORM.HeatAndMassTransfer.ClosureRelations.MassTransfer.Models.PartialMassTransfer
    "Mass transfer coefficient model" annotation (Dialog(group="Closure Models"), choicesAllMatching=true);
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
    final roughnesses=roughnesses) "Correlation for the mass transfer coefficients" annotation (Placement(transformation(extent={
            {-36,84},{-24,96}}, rotation=0)));
  SI.MolarFlowRate n_flows[n,nC] "Molar flow rate from surface to fluid";
  SI.Concentration dCs[n,nC] "Surface minus fluid concentration";
  SItf.DiffusionResistance R[n,nC] "Surface to fluid diffusion resistance";
  Interfaces.MolePort_Flow port_a[n](each nC=nC) "Mole ports at the surface" annotation (Placement(
        transformation(extent={{-80,-10},{-60,10}}),  iconTransformation(extent=
           {{-80,-10},{-60,10}})));
  Interfaces.MolePort_Flow port_b[n](each nC=nC) "Mole ports at the fluid" annotation (Placement(
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
      R[i,j] = 1/max(Modelica.Constants.eps, massTransferCoeff.alphasM[i,j]*surfaceAreas[i]);
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
          textColor={0,0,255})}),
    Documentation(info="<html>
<p>Convective mass transfer resistance between a surface and a fluid in each of <code>n</code> segments, which computes the mass transfer coefficients with a mass transfer model chosen from a list and the fluid's properties. <code>Convection</code> takes the coefficients as inputs instead.</p>
<ul>
<li>The mole ports carry only concentrations and molar flow rates: the fluid's state and flow and the wall temperature reach the mass transfer model only through the inputs, not from the volume the port is connected to.</li>
<li>Every mass transfer model except <code>Ideal</code> needs the diffusion coefficient <code>Ds_ab</code>, set in its redeclare: the medium does not provide it.</li>
</ul>
</html>"),
    Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}}), graphics={
        Line(points={{100,0},{100,0}}, color={0,127,255}),
        Line(points={{100,0},{100,0}}, color={0,127,255}),
        Line(points={{100,0},{100,0}}, color={0,127,255})}));
end ConvectionMedia;
