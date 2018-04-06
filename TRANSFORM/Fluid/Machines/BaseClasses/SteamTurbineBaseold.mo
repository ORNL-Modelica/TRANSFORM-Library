within TRANSFORM.Fluid.Machines.BaseClasses;
partial model SteamTurbineBaseold "Steam turbine"
  replaceable package Medium = Modelica.Media.Water.StandardWater
   constrainedby Modelica.Media.Interfaces.PartialTwoPhaseMedium "Medium in the component"
    annotation(choicesAllMatching = true);

  outer Modelica.Fluid.System system "System properties";

  TRANSFORM.Fluid.Interfaces.FluidPort_Flow portHP(
      redeclare package Medium = Medium,
      m_flow(min=if allowFlowReversal then -Modelica.Constants.inf else 0),
      h_outflow(start=h_a_start)) "high pressure port"
    annotation (Placement(transformation(extent={{-100,60},{-60,100}}, rotation=
           0), iconTransformation(extent={{-110,50},{-90,70}})));
  TRANSFORM.Fluid.Interfaces.FluidPort_Flow portLP(
      redeclare package Medium = Medium,
      m_flow(max=if allowFlowReversal then +Modelica.Constants.inf else 0),
      p(start=p_b_start)) "low pressure port"
                          annotation (Placement(transformation(extent={{50,-120},
            {90,-80}},
          rotation=0), iconTransformation(extent={{60,-110},{80,-90}})));

  Modelica.Mechanics.Rotational.Interfaces.Flange_a shaft_a annotation (
      Placement(transformation(extent={{-110,-10},{-90,10}},rotation=0),
        iconTransformation(extent={{-110,-10},{-90,10}})));
  Modelica.Mechanics.Rotational.Interfaces.Flange_b shaft_b annotation (
      Placement(transformation(extent={{90,-10},{110,10}},rotation=0),
        iconTransformation(extent={{90,-10},{110,10}})));

  // Assumptions
  parameter Boolean allowFlowReversal = system.allowFlowReversal
"= true to allow flow reversal, false restricts to design direction"
    annotation(Dialog(tab="Assumptions"), Evaluate=true);

  // Efficiency
  parameter Real eta_mech=1.0 "Mechanical efficiency" annotation(Dialog(group="Efficiency"));
  replaceable model Eta_wetSteam =
      TRANSFORM.Fluid.Machines.BaseClasses.WetSteamEfficiency.eta_Constant
    constrainedby
    TRANSFORM.Fluid.Machines.BaseClasses.WetSteamEfficiency.Partial_eta
      "Isentropic efficiency" annotation(Dialog(group="Efficiency"),choicesAllMatching=true);

  Eta_wetSteam eta_wetSteam(
  x_abs_in = x_abs_in,
  x_abs_out = x_abs_out);

 //Initialization
  parameter Medium.AbsolutePressure p_a_start=system.p_start
      "Pressure at port a"
    annotation(Dialog(tab = "Initialization",group="Start Value: Absolute Pressure"));
  parameter Medium.AbsolutePressure p_b_start=p_a_start
      "Pressure at port b"
    annotation(Dialog(tab = "Initialization",group="Start Value: Absolute Pressure"));

  parameter Boolean use_T_start=true "Use T_start if true, otherwise h_start"
     annotation(Evaluate=true, Dialog(tab = "Initialization",group="Start Value: Temperature"));

  parameter Medium.Temperature T_a_start=system.T_start
      "Temperature at port a"
    annotation(Dialog(tab = "Initialization",group="Start Value: Temperature", enable = use_T_start));
  parameter Medium.Temperature T_b_start=T_a_start
      "Temperature at port b"
    annotation(Dialog(tab = "Initialization",group="Start Value: Temperature", enable = use_T_start));

  parameter Medium.SpecificEnthalpy h_a_start=Medium.specificEnthalpy_pTX(p_a_start,T_a_start,X_start)
      "Specific enthalpy at port a"
    annotation(Dialog(tab = "Initialization",group="Start Value: Specific Enthalpy", enable = not use_T_start));
  parameter Medium.SpecificEnthalpy h_b_start=Medium.specificEnthalpy_pTX(p_b_start,T_b_start,X_start)
      "Specific enthalpy at port b"
    annotation(Dialog(tab = "Initialization",group="Start Value: Specific Enthalpy", enable = not use_T_start));

  parameter Medium.MassFraction X_start[Medium.nX]=Medium.X_default
    "Mass fractions m_i/m"
    annotation (Dialog(tab="Initialization",group="Start Value: Mass Fractions", enable=Medium.nXi > 0));
  parameter Medium.ExtraProperty C_start[Medium.nC](
        quantity=Medium.extraPropertiesNames)=fill(0, Medium.nC)
     "Trace substances"
     annotation (Dialog(tab="Initialization",group="Start Value: Trace Substances", enable=Medium.nC > 0));
  parameter Medium.MassFlowRate m_flow_start = system.m_flow_start
     "Mass flow rate"
      annotation(Dialog(tab = "Initialization",group="Start Value: Mass Flow Rate"));

  Medium.ThermodynamicState state_a;
  Medium.ThermodynamicState state_b;

  Real p_ratio "p_out/p_in pressure ratio";

  SI.Angle phi "Shaft rotation angle";
  SI.Torque tau "Net torque acting on the turbine";
  SI.AngularVelocity omega "Shaft angular velocity";
  SI.MassFlowRate m_flow(start=m_flow_start) "Mass flow rate";
  Medium.SpecificEnthalpy h_in(start=h_a_start) "Inlet enthalpy";
  Medium.SpecificEnthalpy h_out(start=h_b_start) "Outlet enthalpy";
  Medium.SpecificEnthalpy h_is(start=h_b_start) "Isentropic outlet enthalpy";
  Medium.AbsolutePressure p_in(start=p_a_start) "Inlet pressure";
  Medium.AbsolutePressure p_out(start=p_b_start) "Outlet pressure";

  SI.Power Q_mech "Mechanical power input";
  SI.Efficiency eta_is "Isentropic efficiency";

  constant SI.Pressure p_crit = Medium.fluidConstants[1].criticalPressure "Medium critical pressure";

  Medium.SaturationProperties sat_in = Medium.setSat_p(p_in) "Properties of saturated fluid at inlet";
  Medium.SaturationProperties sat_out = Medium.setSat_p(p_out) "Properties of saturated fluid at outlet";

  Medium.ThermodynamicState bubble_in = Medium.setBubbleState(sat_in, 1) "Bubble point state at inlet";
  Medium.ThermodynamicState dew_in = Medium.setDewState(sat_in, 1) "Dew point state at inlet";

  Medium.ThermodynamicState bubble_out = Medium.setBubbleState(sat_out, 1) "Bubble point state at outlet";
  Medium.ThermodynamicState dew_out = Medium.setDewState(sat_out, 1) "Dew point state at outlet";

  SI.SpecificEnthalpy h_fsat_in=bubble_in.h
     "Saturated liquid specific enthalpy at inlet";
  SI.SpecificEnthalpy h_gsat_in=dew_in.h
     "Saturated vapor specific enthalpy  at inlet";

  SI.SpecificEnthalpy h_fsat_out=bubble_out.h
     "Saturated liquid specific enthalpy at outlet";
  SI.SpecificEnthalpy h_gsat_out=dew_out.h
     "Saturated vapor specific enthalpy  at outlet";

  Units.NonDim x_th_in "Inlet thermodynamic quality";
  Units.NonDim x_abs_in "Inlet absolute mass quality";

  Units.NonDim x_th_out "Outlet thermodynamic quality";
  Units.NonDim x_abs_out "Outlet absolute mass quality";

  Modelica.Blocks.Interfaces.RealInput partialArc annotation (Placement(
        transformation(extent={{-60,-50},{-40,-30}}, rotation=0),
        iconTransformation(extent={{-60,-50},{-40,-30}})));
equation

  state_a = Medium.setState_phX(portHP.p,
    inStream(portHP.h_outflow),
    inStream(portHP.Xi_outflow));

  state_b = Medium.setState_phX(portLP.p,
    inStream(portLP.h_outflow),
    inStream(portLP.Xi_outflow));

  p_ratio = p_out/p_in;
  if cardinality(partialArc) == 0 then
    partialArc = 1.0 "Default value if not connected";
  end if;

  h_is = Medium.isentropicEnthalpy(portLP.p, state_a) "Isentropic enthalpy";

  eta_is = eta_wetSteam.eta;

  h_in - h_out = eta_is*(h_in - h_is) "Computation of outlet enthalpy";

  Q_mech = eta_mech*m_flow*(h_in - h_out)  "Mechanical power from the steam";
  Q_mech = -omega*tau "Mechanical power balance";

  portHP.m_flow + portLP.m_flow  = 0 "Mass balance";

  // Mechanical boundary conditions
  tau = shaft_a.tau + shaft_b.tau;
  shaft_a.phi = phi;
  shaft_b.phi = phi;
  der(phi) = omega;

  // Fluid Port Boundary Conditions
  h_in = inStream(portHP.h_outflow);
  m_flow =portHP.m_flow;

  portHP.p = p_in;
  portLP.p = p_out;

  portHP.h_outflow = inStream(portLP.h_outflow) + h_in - h_out;
  portHP.Xi_outflow = inStream(portLP.Xi_outflow);
  portHP.C_outflow = inStream(portLP.C_outflow);

  portLP.h_outflow = inStream(portHP.h_outflow) + h_out - h_in;
  portLP.Xi_outflow = inStream(portHP.Xi_outflow);
  portLP.C_outflow = inStream(portHP.C_outflow);

  // Thermodynamic Quality calculations
   x_th_in = (h_in - h_fsat_in)/max(h_gsat_in - h_fsat_in, 1e-6);
   x_th_out = (h_out - h_fsat_out)/max(h_gsat_out - h_fsat_out, 1e-6);

   x_abs_in = noEvent(if p_in/p_crit < 1.0 then max(0.0, min(1.0, x_th_in)) else 1.0) "Steam inlet quality";
   x_abs_out = noEvent(if p_out/p_crit < 1.0 then max(0.0, min(1.0, x_th_out)) else 1.0) "Steam outlet quality";

  annotation (
    Icon(graphics={
        Rectangle(
          extent={{-6,15.5},{6,-15.5}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillPattern=FillPattern.VerticalCylinder,
          fillColor={0,127,255},
          origin={70,-83.5},
          rotation=180),
        Rectangle(
          extent={{40,-68},{64,-80}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={0,127,255}),
        Rectangle(
          extent={{-6,18.5},{6,-18.5}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillPattern=FillPattern.VerticalCylinder,
          fillColor={0,127,255},
          origin={-34,47.5},
          rotation=180),
        Rectangle(
          extent={{-102,6},{98,-6}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={160,160,164}),
        Polygon(
          points={{-40,30},{-40,-30},{40,-80},{40,80},{-40,30}},
          lineColor={0,0,0},
          fillColor={0,114,208},
          fillPattern=FillPattern.Solid),
        Text(extent={{-126,114},{132,74}},   textString="%name"),
        Polygon(
          points={{-104,38},{-104,38}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={0,0,255}),
        Rectangle(
          extent={{-94,66},{-40,54}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={0,127,255})}),
    Documentation(info="<html>
<p>This base model contains the basic interface, parameters and definitions for steam turbine models. It lacks the actual performance characteristics, i.e. two more equations to determine the flow rate and the efficiency.
<p>This model does not include any shaft inertia by itself; if that is needed, connect a <tt>Modelica.Mechanics.Rotational.Inertia</tt> model to one of the shaft connectors.
<p><b>Modelling options</b></p>
<p>The following options are available to calculate the enthalpy of the outgoing steam:
<ul><li><tt>explicitIsentropicEnthalpy = true</tt>: the isentropic enthalpy <tt>h_out_iso</tt> is calculated by the <tt>Medium.isentropicEnthalpy</tt> function. <li><tt>explicitIsentropicEnthalpy = false</tt>: the isentropic enthalpy is given equating the specific entropy of the inlet steam <tt>steam_in</tt> and of a fictional steam state <tt>steam_iso</tt>, which has the same pressure of the outgoing steam, both computed with the function <tt>Medium.specificEntropy</tt>.</pp></ul>
</html>",
      revisions="<html>
<ul>
<li><i>20 Apr 2005</i>
    by <a href=\"mailto:francesco.casella@polimi.it\">Francesco Casella</a>:<br>
       First release.</li>
<li><i>5 Oct 2011</i>
    by <a href=\"mailto:francesco.casella@polimi.it\">Francesco Casella</a>:<br>
       Small changes in alias variables.</li>
</ul>
</html>"));
end SteamTurbineBaseold;
