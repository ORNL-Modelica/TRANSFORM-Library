within TRANSFORM.Fluid.Machines.BaseClasses;
partial model PartialPump_Simple
  import TRANSFORM.Types.Dynamics;
  Interfaces.FluidPort_Flow  port_a(
    redeclare package Medium = Medium,
    m_flow(min=if allowFlowReversal then -Modelica.Constants.inf else -m_flow_start),
    h_outflow(start=h_a_start)) "low pressure port" annotation (Placement(
        transformation(extent={{-120,-20},{-80,20}},rotation=0),
        iconTransformation(extent={{-110,-10},{-90,10}})));
  Interfaces.FluidPort_Flow port_b(
    redeclare package Medium = Medium,
    m_flow(max=if allowFlowReversal then +Modelica.Constants.inf else m_flow_start),
    p(start=p_b_start)) "high pressure port" annotation (Placement(
        transformation(extent={{80,-20},{120,20}},rotation=0),
        iconTransformation(extent={{90,-10},{110,10}})));

  replaceable package Medium = Modelica.Media.Interfaces.PartialMedium
    "Medium properties" annotation (choicesAllMatching=true);

  parameter Real nParallel = 1 "# of parallel components";

  parameter Medium.AbsolutePressure p_a_start=Medium.p_default
    "Pressure at port a" annotation (Dialog(tab="Initialization", group="Start Value: Absolute Pressure"));
  parameter Medium.AbsolutePressure p_b_start=p_a_start "Pressure at port b"
    annotation (Dialog(tab="Initialization", group="Start Value: Absolute Pressure"));
  parameter Boolean use_T_start=true "Use T_start if true, otherwise h_start"
    annotation (Evaluate=true, Dialog(tab="Initialization", group="Start Value: Temperature"));
  parameter Medium.Temperature T_a_start=Medium.T_default
    "Temperature at port a" annotation (Dialog(
      tab="Initialization",
      group="Start Value: Temperature",
      enable=use_T_start));
  parameter Medium.Temperature T_b_start=T_a_start "Temperature at port b"
    annotation (Dialog(
      tab="Initialization",
      group="Start Value: Temperature",
      enable=use_T_start));
  parameter Medium.SpecificEnthalpy h_a_start=Medium.specificEnthalpy_pTX(
      p_a_start,
      T_a_start,
      X_start) "Specific enthalpy at port a" annotation (Dialog(
      tab="Initialization",
      group="Start Value: Specific Enthalpy",
      enable=not use_T_start));
  parameter Medium.SpecificEnthalpy h_b_start=Medium.isentropicEnthalpy(
      p_b_start, Medium.setState_phX(
      p_a_start,
      h_a_start,
      X_start)) "Specific enthalpy at port b" annotation (Dialog(
      tab="Initialization",
      group="Start Value: Specific Enthalpy",
      enable=not use_T_start));
  parameter Medium.MassFraction X_start[Medium.nX]=Medium.X_default
    "Mass fractions m_i/m" annotation (Dialog(
      tab="Initialization",
      group="Start Value: Mass Fractions",
      enable=Medium.nXi > 0));
  parameter Medium.ExtraProperty C_start[Medium.nC](quantity=Medium.extraPropertiesNames)=
       fill(0, Medium.nC) "Trace substances" annotation (Dialog(
      tab="Initialization",
      group="Start Value: Trace Substances",
      enable=Medium.nC > 0));
  parameter Medium.MassFlowRate m_flow_start=0 "Mass flow rate" annotation (
      Dialog(tab="Initialization", group="Start Value: Mass Flow Rate"));

  parameter Boolean allowFlowReversal=true
    "= true to allow flow reversal, false restricts to design direction (port_a -> port_b)"
    annotation (Dialog(tab="Advanced"), Evaluate=true);

  SI.Efficiency eta_is "Isentropic or aerodynamic efficiency";
  Medium.ThermodynamicState state_a;
  Medium.ThermodynamicState state_b;
  SI.PressureDifference dp(start=p_b_start-p_a_start) "Pressure change";
  SI.MassFlowRate m_flow(start=m_flow_start) "Mass flow rate";
  Medium.SpecificEnthalpy dh_ideal "Ideal enthalpy change";
  Medium.SpecificEnthalpy dh "Actual enthalpy change";
  SI.Power W "Pumping power required";
  SI.Power W_ideal=dh_ideal*m_flow "Ideal pumping power required";
  SI.Power Ub "Energy balance";

equation
  // Port states
  state_a = Medium.setState_phX(
    port_a.p,
    inStream(port_a.h_outflow),
    inStream(port_a.Xi_outflow));
  state_b = Medium.setState_phX(
    port_b.p,
    inStream(port_b.h_outflow),
    inStream(port_b.Xi_outflow));

  // Pressure relations
  dp = port_b.p - port_a.p;

  // Mass balance equations
  port_a.m_flow + port_b.m_flow = 0;

  // Enthalpy relations
  dh_ideal = dp/Medium.density(state_a);
  dh*eta_is = dh_ideal;

  // Energy balace
  Ub = port_a.m_flow*actualStream(port_a.h_outflow) + port_b.m_flow*
    actualStream(port_b.h_outflow) + W*nParallel;
  0 = Ub;

  // Fluid Port Boundary Conditions
  m_flow = port_a.m_flow/nParallel;
  port_a.h_outflow = inStream(port_b.h_outflow) + dh;
  port_a.Xi_outflow = inStream(port_b.Xi_outflow);
  port_a.C_outflow = inStream(port_b.C_outflow);
  port_b.h_outflow = inStream(port_a.h_outflow) + dh;
  port_b.Xi_outflow = inStream(port_a.Xi_outflow);
  port_b.C_outflow = inStream(port_a.C_outflow);

  annotation (
    defaultComponentName="compressor",
    Icon(graphics={
        Polygon(
          points={{-104,38},{-104,38}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={0,0,255}),
        Text(
          extent={{-149,-68},{151,-108}},
          lineColor={0,0,255},
          textString="%name",
          visible=DynamicSelect(true, showName)),
        Rectangle(
          extent={{-80,30},{-40,-30}},
          lineColor={0,0,0},
          fillColor={0,127,255},
          fillPattern=FillPattern.HorizontalCylinder),
        Rectangle(
          extent={{-2,60},{80,0}},
          lineColor={0,0,0},
          fillColor={0,127,255},
          fillPattern=FillPattern.HorizontalCylinder),
        Ellipse(
          extent={{60,60},{-60,-60}},
          lineColor={0,0,0},
          fillColor={0,128,255},
          fillPattern=FillPattern.Sphere),
        Polygon(
          points={{-20,20},{-20,-22},{30,0},{-20,20}},
          lineColor={0,0,0},
          pattern=LinePattern.None,
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={255,255,255})}),
    Documentation(info="<html>
<p>This base model contains the basic interface, parameters and definitions for steam turbine models. It lacks the actual performance characteristics, i.e. two more equations to determine the flow rate and the efficiency.
<p>This model does not include any shaft inertia by itself; if that is needed, connect a <tt>Modelica.Mechanics.Rotational.Inertia</tt> model to one of the shaft connectors.
<p><b>Modelling options</b></p>
<p>The following options are available to calculate the enthalpy of the outgoing steam:
<ul><li><tt>explicitIsentropicEnthalpy = true</tt>: the isentropic enthalpy <tt>h_out_iso</tt> is calculated by the <tt>Medium.isentropicEnthalpy</tt> function. <li><tt>explicitIsentropicEnthalpy = false</tt>: the isentropic enthalpy is given equating the specific entropy of the inlet steam <tt>steam_in</tt> and of a fictional steam state <tt>steam_iso</tt>, which has the same pressure of the outgoing steam, both computed with the function <tt>Medium.specificEntropy</tt>.</pp></ul>
</html>", revisions="<html>
<ul>
<li><i>20 Apr 2005</i>
    by <a href=\"mailto:francesco.casella@polimi.it\">Francesco Casella</a>:<br>
       First release.</li>
<li><i>5 Oct 2011</i>
    by <a href=\"mailto:francesco.casella@polimi.it\">Francesco Casella</a>:<br>
       Small changes in alias variables.</li>
</ul>
</html>"));
end PartialPump_Simple;
