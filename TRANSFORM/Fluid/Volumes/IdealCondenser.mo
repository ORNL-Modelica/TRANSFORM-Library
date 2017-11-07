within TRANSFORM.Fluid.Volumes;
model IdealCondenser "Ideal condenser with fixed pressure"

  import Modelica.Fluid.Types.Dynamics;

  outer Modelica.Fluid.System system "System properties";

  replaceable package Medium = Modelica.Media.Water.StandardWater constrainedby
    Modelica.Media.Interfaces.PartialMedium "Medium in component" annotation(choicesAllMatching=true);

  Modelica.Fluid.Interfaces.FluidPort_b port_a(redeclare package Medium =
        Medium) "Steam port" annotation (Placement(transformation(extent={{-90,80},
            {-50,120}},
          rotation=0), iconTransformation(extent={{-80,90},{-60,110}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b(redeclare package Medium =
        Medium) "Condensed liquid port" annotation (Placement(transformation(extent={{-20,-120},{20,-80}},
          rotation=0), iconTransformation(extent={{-10,-110},{10,-90}})));

  /* Parameters */
  parameter SI.Pressure p "Condenser operating pressure";
  parameter SI.Volume V_total=10
    "Total volume (liquid + vapor)";

  /* Assumptions */
  parameter Dynamics massDynamics=system.massDynamics
    "Formulation of mass balance"
    annotation(Evaluate=true, Dialog(tab = "Assumptions", group="Dynamics"));

  /* Initialziation */
  parameter SI.Volume V_liquid_start=0.15*V_total
    "Start value of the liquid volume"  annotation(Dialog(tab="Initialization"));

  //Variables
  Medium.SaturationProperties sat "Saturation properties";

  Medium.SpecificEnthalpy h_fsat = Medium.bubbleEnthalpy(sat) "Specific enthalpy of saturated liquid";
  Medium.SpecificEnthalpy h_gsat = Medium.dewEnthalpy(sat) "Specific enthalpy of saturated vapor";

  SI.Density rho_fsat = Medium.bubbleDensity(sat) "Density of saturated liquid";
  SI.Density rho_gsat = Medium.dewDensity(sat) "Density of saturated steam";

  SI.Mass m_total "Total mass, steam+liquid";
  SI.Mass m_liquid "Liquid mass";
  SI.Mass m_vapor "Steam mass";
  SI.Volume V_liquid(start=V_liquid_start) "Liquid volume";
  SI.Volume V_vapor "Steam volume";
  SI.Energy E "Internal energy";
  SI.Power Q_total "Total thermal energy removed";

initial equation
  if massDynamics == Dynamics.FixedInitial then
    V_liquid = V_liquid_start;
  elseif massDynamics == Dynamics.SteadyStateInitial then
    V_liquid = V_liquid_start; //this seems incorrect
  end if;

equation

  assert(V_liquid < V_total, "Liquid volume has exceed the total condenser volume.");

  sat.psat = p;
  sat.Tsat = Medium.saturationTemperature(p);

  m_liquid = V_liquid*rho_fsat;
  m_vapor = V_vapor*rho_gsat;
  V_total = V_vapor + V_liquid;
  m_total = m_liquid + m_vapor;
  E = m_liquid*h_fsat + m_vapor*inStream(port_a.h_outflow) - p*V_total;

  //Energy and Mass Balances
  der(m_total) = port_a.m_flow + port_b.m_flow;
  der(E) = port_a.m_flow*actualStream(port_a.h_outflow) + port_b.m_flow*actualStream(port_b.h_outflow) + Q_total;

  // Boundary Conditions
  port_a.p = p;
  port_b.p = p;

  port_a.h_outflow = h_fsat;
  port_b.h_outflow = h_fsat;

  annotation (defaultComponentName="condenser",
    Icon(graphics={
        Polygon(
          points={{-100,80},{-100,94},{-94,100},{-80,100},{-79.062,100},{79.534,
              100},{80,100},{92,100},{100,94},{100,80},{100,80},{100,-78},{100,-80},
              {100,-92},{94,-100},{82,-100},{80,-100},{-80,-100},{-82,-100},{-94,
              -100},{-100,-94},{-100,-80},{-100,-78},{-100,80},{-100,80}},
          lineColor={0,0,0},
          smooth=Smooth.Bezier,
          lineThickness=0.5,
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-88,100},{88,-100}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-98,137},{102,107}},
          lineColor={0,0,0},
          textString="%name"),
        Line(
          points={{-10,-5},{-10,-1},{-6,3},{0,5},{6,3},{10,-1},{10,-5}},
          color={0,0,0},
          smooth=Smooth.Bezier,
          origin={65,30},
          rotation=-90,
          thickness=0.5),
        Line(
          points={{-10,-5},{-10,-1},{-6,3},{0,5},{6,3},{10,-1},{10,-5}},
          color={0,0,0},
          smooth=Smooth.Bezier,
          origin={-65,10},
          rotation=90,
          thickness=0.5),
        Line(
          points={{-10,-5},{-10,-1},{-6,3},{0,5},{6,3},{10,-1},{10,-5}},
          color={0,0,0},
          smooth=Smooth.Bezier,
          origin={-65,50},
          rotation=90,
          thickness=0.5),
        Line(
          points={{-60,0},{100,0}},
          color={0,0,0},
          thickness=0.5),
        Line(
          points={{-60,20},{60,20}},
          color={0,0,0},
          thickness=0.5),
        Line(
          points={{60,40},{-60,40}},
          color={0,0,0},
          thickness=0.5),
        Line(
          points={{-60,60},{100,60}},
          color={0,0,0},
          thickness=0.5),
        Ellipse(
          extent={{2,5},{-2,-5}},
          fillColor={85,170,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0},
          origin={-78,79},
          rotation=-30),
        Ellipse(
          extent={{-71,83},{-75,73}},
          fillColor={85,170,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Ellipse(
          extent={{-66,83},{-70,73}},
          fillColor={85,170,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Ellipse(
          extent={{2,5},{-2,-5}},
          fillColor={85,170,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0},
          origin={-62,79},
          rotation=30),
        Rectangle(
          extent={{-75,96},{-65,84}},
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Polygon(
          points={{-40,40},{-40,40}},
          lineColor={0,0,0},
          fillColor={85,170,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-60,40},{-54,38},{-50,36},{-50,34},{-48,36},{-44,38},{-38,38},
              {-36,38},{-34,40},{-60,40}},
          lineColor={0,0,0},
          smooth=Smooth.Bezier,
          fillColor={85,170,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-166,78},{-166,78}},
          lineColor={0,0,0},
          smooth=Smooth.Bezier,
          fillColor={85,170,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{10,60},{16,58},{20,56},{20,54},{22,56},{26,58},{32,58},{34,58},
              {36,60},{10,60}},
          lineColor={0,0,0},
          smooth=Smooth.Bezier,
          fillColor={85,170,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{4,20},{10,18},{14,16},{14,14},{16,16},{20,18},{26,18},{28,18},
              {30,20},{4,20}},
          lineColor={0,0,0},
          smooth=Smooth.Bezier,
          fillColor={85,170,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-66,0},{-60,-2},{-56,-4},{-56,-6},{-54,-4},{-50,-2},{-44,-2},
              {-42,-2},{-40,0},{-66,0}},
          lineColor={0,0,0},
          smooth=Smooth.Bezier,
          fillColor={85,170,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-48,32},{-50,28}},
          lineColor={0,0,0},
          fillColor={85,170,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{22,52},{20,48}},
          lineColor={0,0,0},
          fillColor={85,170,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{14,12},{12,8}},
          lineColor={0,0,0},
          fillColor={85,170,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-56,-8},{-58,-12}},
          lineColor={0,0,0},
          fillColor={85,170,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-88,-70},{88,-100}},
          lineColor={0,0,0},
          fillColor={0,122,236},
          fillPattern=FillPattern.Solid)}),
    Documentation(revisions="<html>
</html>", info="<html>
<p>The steam enters through port a and saturated water leaves port b.</p>
<p>The total heat removed to bring the inlet steam to saturated liquid conditions at the set pressure is Q_total.</p>
</html>"));
end IdealCondenser;
