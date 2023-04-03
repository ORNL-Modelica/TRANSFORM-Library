within TRANSFORM.Fluid.Volumes;
model Pressurizer_Simple

  // Source
  // K. FRICK, “Modeling and Design of a Sensible Heat Thermal Energy Storage System for Small Modular Reactors,” North Carolina State University (2018).
  // Eqns. 3.1, 3.2, 3.6, and 3.7

  import Modelica.Fluid.Types.Dynamics;

  replaceable package Medium = Modelica.Media.Water.StandardWater constrainedby Modelica.Media.Interfaces.PartialTwoPhaseMedium
                                                    annotation (choicesAllMatching=true);

  parameter SI.Volume V_total=1 "Total pressurizer volume";
  parameter SI.Pressure p_start=160e5 "Initial pressure" annotation(Dialog(tab="Initialization"));
  parameter SIadd.NonDim alphaV_start=0.5 "Initial void fraction" annotation(Dialog(tab="Initialization"));

  final parameter Medium.SaturationProperties sat_start=Medium.setSat_p(p_start) "Properties of saturated fluid";
  final parameter Medium.ThermodynamicState bubble_start=Medium.setBubbleState(sat_start, 1) "Bubble point state";
  final parameter Medium.ThermodynamicState dew_start=Medium.setDewState(sat_start, 1) "Dew point state";
  final parameter SI.Density d_start=(1 - alphaV_start)*bubble_start.d + alphaV_start*dew_start.d;
  final parameter SI.SpecificInternalEnergy u_lsat_start=bubble_start.h - p_start/bubble_start.d;
  final parameter SI.SpecificInternalEnergy u_vsat_start=dew_start.h - p_start/dew_start.d;
  final parameter SI.SpecificInternalEnergy u_start=((1 - alphaV_start)*bubble_start.d*u_lsat_start + alphaV_start*
      dew_start.d*u_vsat_start)/d_start;

  parameter Dynamics energyDynamics=Dynamics.DynamicFreeInitial "Formulation of energy balances"
    annotation (Evaluate=true, Dialog(tab="Advanced", group="Dynamics"));
  parameter Dynamics massDynamics=energyDynamics "Formulation of mass balances"
    annotation (Evaluate=true, Dialog(tab="Advanced", group="Dynamics"));

  input SI.HeatFlowRate Q_heaters=0 "Heat input" annotation(Dialog(group="Inputs"));

  SI.Density d(start=d_start) "Average pressurizer density";

  SIadd.NonDim alphaV(start=alphaV_start) "Void fraction";
  SI.Density d_lsat=bubble.d "Saturated liquid density";
  SI.Density d_vsat=dew.d "Saturated vapor density";

  SI.SpecificInternalEnergy u(start=u_start) "Specific internal energy";
  SI.SpecificInternalEnergy u_lsat(start=u_lsat_start) "Specific internal energy";
  SI.SpecificInternalEnergy u_vsat(start=u_vsat_start) "Specific internal energy";

  SI.Pressure p(start=p_start);

  Medium.SaturationProperties sat "Properties of saturated fluid";
  Medium.ThermodynamicState bubble "Bubble point state";
  Medium.ThermodynamicState dew "Dew point state";

  Interfaces.FluidPort_State port_spray(redeclare package Medium = Medium) annotation (Placement(transformation(
          extent={{-10,90},{10,110}}), iconTransformation(extent={{-10,90},{10,110}})));
  Interfaces.FluidPort_State port_surge(redeclare package Medium = Medium) annotation (Placement(transformation(
          extent={{-10,-110},{10,-90}}), iconTransformation(extent={{-10,-110},{10,-90}})));

initial equation
  // Mass Balance
  if massDynamics == Dynamics.FixedInitial then
    p = p_start;
  elseif massDynamics == Dynamics.SteadyStateInitial then
    der(d) = 0;
  end if;

  // Energy Balance
  if energyDynamics == Dynamics.FixedInitial then
    u = u_start;
  elseif energyDynamics == Dynamics.SteadyStateInitial then
    der(d*u) = 0;
  end if;

equation

  sat = Medium.setSat_p(p);
  bubble = Medium.setBubbleState(sat, 1);
  dew = Medium.setDewState(sat, 1);

  u_lsat = bubble.h - p/bubble.d;
  u_vsat = dew.h - p/dew.d;

  d = (1 - alphaV)*d_lsat + alphaV*d_vsat;
  d*u = (1 - alphaV)*d_lsat*u_lsat + alphaV*d_vsat*u_vsat;

  // Mass Balance
  if massDynamics == Dynamics.SteadyState then
    0 = port_spray.m_flow + port_surge.m_flow;
  else
    V_total*der(d) = port_spray.m_flow + port_surge.m_flow;
  end if;

  // Energy Balance
  if energyDynamics == Dynamics.SteadyState then
    0 = port_spray.m_flow*actualStream(port_spray.h_outflow) + port_surge.m_flow*actualStream(port_surge.h_outflow) +
      Q_heaters;
  else
    V_total*der(d*u) = port_spray.m_flow*actualStream(port_spray.h_outflow) + port_surge.m_flow*actualStream(
      port_surge.h_outflow) + Q_heaters;
  end if;

  // Port Parameters
  port_spray.p = p;
  port_surge.p = p;
  port_surge.h_outflow = bubble.h;
  port_spray.h_outflow = dew.h;
  // add trace substances and species balance

  annotation (defaultComponentName="pressurizer",Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={28,108,200},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-99,1},{99,-99}},
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Ellipse(
          extent={{-66,46},{-60,38}},
          pattern=LinePattern.None,
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-82,72},{-76,64}},
          pattern=LinePattern.None,
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-16,54},{-10,46}},
          pattern=LinePattern.None,
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-28,84},{-22,76}},
          pattern=LinePattern.None,
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{20,36},{26,28}},
          pattern=LinePattern.None,
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-38,28},{-32,20}},
          pattern=LinePattern.None,
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{64,66},{70,58}},
          pattern=LinePattern.None,
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{24,74},{30,66}},
          pattern=LinePattern.None,
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{66,34},{72,26}},
          pattern=LinePattern.None,
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-72,-16},{-66,-24}},
          pattern=LinePattern.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Ellipse(
          extent={{-36,-40},{-30,-48}},
          pattern=LinePattern.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Ellipse(
          extent={{-72,-44},{-66,-52}},
          pattern=LinePattern.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Ellipse(
          extent={{14,-32},{20,-40}},
          pattern=LinePattern.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Ellipse(
          extent={{64,-48},{70,-56}},
          pattern=LinePattern.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Ellipse(
          extent={{48,-12},{54,-20}},
          pattern=LinePattern.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Ellipse(
          extent={{32,-64},{38,-72}},
          pattern=LinePattern.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Ellipse(
          extent={{-12,-14},{-6,-22}},
          pattern=LinePattern.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Ellipse(
          extent={{-52,-68},{-46,-76}},
          pattern=LinePattern.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={28,108,200},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-99,1},{99,-99}},
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Ellipse(
          extent={{-66,46},{-60,38}},
          pattern=LinePattern.None,
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-82,72},{-76,64}},
          pattern=LinePattern.None,
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-16,54},{-10,46}},
          pattern=LinePattern.None,
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-28,84},{-22,76}},
          pattern=LinePattern.None,
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{20,36},{26,28}},
          pattern=LinePattern.None,
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-38,28},{-32,20}},
          pattern=LinePattern.None,
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{64,66},{70,58}},
          pattern=LinePattern.None,
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{24,74},{30,66}},
          pattern=LinePattern.None,
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{66,34},{72,26}},
          pattern=LinePattern.None,
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-72,-16},{-66,-24}},
          pattern=LinePattern.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Ellipse(
          extent={{-36,-40},{-30,-48}},
          pattern=LinePattern.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Ellipse(
          extent={{-72,-44},{-66,-52}},
          pattern=LinePattern.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Ellipse(
          extent={{14,-32},{20,-40}},
          pattern=LinePattern.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Ellipse(
          extent={{64,-48},{70,-56}},
          pattern=LinePattern.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Ellipse(
          extent={{48,-12},{54,-20}},
          pattern=LinePattern.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Ellipse(
          extent={{32,-64},{38,-72}},
          pattern=LinePattern.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Ellipse(
          extent={{-12,-14},{-6,-22}},
          pattern=LinePattern.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Ellipse(
          extent={{-52,-68},{-46,-76}},
          pattern=LinePattern.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0})}),                                  Diagram(coordinateSystem(preserveAspectRatio=false)));
end Pressurizer_Simple;
