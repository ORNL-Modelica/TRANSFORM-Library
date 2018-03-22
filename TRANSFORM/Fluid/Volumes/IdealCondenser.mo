within TRANSFORM.Fluid.Volumes;
model IdealCondenser "Ideal condenser with fixed pressure"

  import Modelica.Fluid.Types.Dynamics;
  extends BaseClasses.Icon_TwoVolume;

  outer Modelica.Fluid.System system "System properties";

  replaceable package Medium = Modelica.Media.Water.StandardWater constrainedby
    Modelica.Media.Interfaces.PartialMedium "Medium in component" annotation(choicesAllMatching=true);

  Interfaces.FluidPort_State            port_a(redeclare package Medium =
        Medium) "Steam port" annotation (Placement(transformation(extent={{-90,80},
            {-50,120}},
          rotation=0), iconTransformation(extent={{-80,60},{-60,80}})));
  Interfaces.FluidPort_State            port_b(redeclare package Medium =
        Medium) "Condensed liquid port" annotation (Placement(transformation(extent={{-20,-120},{20,-80}},
          rotation=0), iconTransformation(extent={{-10,-90},{10,-70}})));

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

  parameter Boolean set_m_flow = false "=true to set port_b.m_flow = -port_a.m_flow" annotation(Dialog(tab="Advanced"));

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

  if set_m_flow then
    port_b.m_flow = -port_a.m_flow;
  else
    port_b.p = p;
  end if;

  port_a.h_outflow = h_fsat;
  port_b.h_outflow = h_fsat;

  annotation (defaultComponentName="condenser",
    Icon(graphics={
        Text(
          extent={{-98,137},{102,107}},
          lineColor={0,0,0},
          textString="%name"),
        Polygon(
          points={{-166,78},{-166,78}},
          lineColor={0,0,0},
          smooth=Smooth.Bezier,
          fillColor={85,170,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{100,40},{-59.1953,40},{-64,40},{-68,36},{-70,30},{-68,24},{
              -64,20},{-60,20},{58,20},{64,20},{68,16},{70,10},{68,4},{64,0},{
              58,0},{-58,0},{-64,0},{-68,-4},{-70,-10},{-68,-16},{-64,-20},{-58,
              -20},{100,-20}},
          color={0,0,0},
          smooth=Smooth.Bezier),
        Polygon(
          points={{10,40},{16,38},{20,36},{20,34},{22,36},{26,38},{32,38},{34,
              38},{36,40},{10,40}},
          lineColor={0,0,0},
          smooth=Smooth.Bezier,
          fillColor={85,170,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{22,32},{20,28}},
          lineColor={0,0,0},
          fillColor={85,170,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-60,20},{-54,18},{-50,16},{-50,14},{-48,16},{-44,18},{-38,18},
              {-36,18},{-34,20},{-60,20}},
          lineColor={0,0,0},
          smooth=Smooth.Bezier,
          fillColor={85,170,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-48,12},{-50,8}},
          lineColor={0,0,0},
          fillColor={85,170,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{4,0},{10,-2},{14,-4},{14,-6},{16,-4},{20,-2},{26,-2},{28,-2},
              {30,0},{4,0}},
          lineColor={0,0,0},
          smooth=Smooth.Bezier,
          fillColor={85,170,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{14,-8},{12,-12}},
          lineColor={0,0,0},
          fillColor={85,170,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-66,-20},{-60,-22},{-56,-24},{-56,-26},{-54,-24},{-50,-22},{
              -44,-22},{-42,-22},{-40,-20},{-66,-20}},
          lineColor={0,0,0},
          smooth=Smooth.Bezier,
          fillColor={85,170,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-56,-28},{-58,-32}},
          lineColor={0,0,0},
          fillColor={85,170,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{0,62},{88,50}},
          lineColor={0,0,0},
          fillPattern=FillPattern.VerticalCylinder,
          fillColor={135,135,135},
          textString="IDEAL"),
        Ellipse(
          extent={{8,30},{-8,-30}},
          lineColor={0,0,0},
          fillColor={0,122,236},
          fillPattern=FillPattern.Solid,
          origin={0,-80},
          rotation=90,
          visible=set_m_flow)}),
    Documentation(revisions="<html>
</html>", info="<html>
<p>The steam enters through port a and saturated water leaves port b.</p>
<p>The total heat removed to bring the inlet steam to saturated liquid conditions at the set pressure is Q_total.</p>
</html>"));
end IdealCondenser;
