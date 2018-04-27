within TRANSFORM.Fluid;
model SystemTF
  "Fluid system properties and default values (ambient, flow direction, initialization)"

  import TRANSFORM.Types.Dynamics;

  replaceable package Medium = Modelica.Media.Water.StandardWater
    constrainedby Modelica.Media.Interfaces.PartialMedium "Medium properties"
    annotation (choicesAllMatching=true);

  parameter Modelica.SIunits.AbsolutePressure p_ambient=101325
    "Default ambient pressure"
    annotation(Dialog(group="Environment"));
  parameter Modelica.SIunits.Temperature T_ambient=293.15
    "Default ambient temperature"
    annotation(Dialog(group="Environment"));
  parameter Modelica.SIunits.Acceleration g=Modelica.Constants.g_n
    "Constant gravity acceleration"
    annotation(Dialog(group="Environment"));
  input Modelica.SIunits.Acceleration g_n=Modelica.Constants.g_n
    "Constant gravity acceleration"
    annotation(Dialog(group="Environment"));

  parameter Boolean allowFlowReversal = true
    "= true to allow flow reversal, false restricts to design direction (port_a -> port_b)"
    annotation(Dialog(tab="Advanced"), Evaluate=true);

  parameter Dynamics energyDynamics=Dynamics.DynamicFreeInitial
    "Formulation of energy balances"
    annotation (Evaluate=true, Dialog(tab="Advanced", group="Dynamics"));
  parameter Dynamics massDynamics=energyDynamics "Formulation of mass balances"
    annotation (Evaluate=true, Dialog(tab="Advanced", group="Dynamics"));
  parameter Dynamics substanceDynamics=massDynamics
    "Formulation of substance balances"
    annotation (Evaluate=true, Dialog(tab="Advanced", group="Dynamics"));
  parameter Dynamics traceDynamics=massDynamics
    "Formulation of trace substance balances"
    annotation (Evaluate=true, Dialog(tab="Advanced", group="Dynamics"));
  parameter Dynamics momentumDynamics=Dynamics.SteadyState
    "Formulation of momentum balances"
    annotation (Evaluate=true, Dialog(tab="Advanced", group="Dynamics"));

  parameter SI.AbsolutePressure p_start=Medium.p_default "Pressure" annotation (
     Dialog(tab="Initialization", group="Start Value: Absolute Pressure"));
  parameter Boolean use_T_start=true "Use T_start if true, otherwise h_start"
    annotation (Evaluate=true, Dialog(tab="Initialization", group="Start Value: Temperature"));
  parameter SI.Temperature T_start=Medium.T_default "Temperature" annotation (
      Evaluate=true, Dialog(
      tab="Initialization",
      group="Start Value: Temperature",
      enable=use_T_start));
  parameter SI.SpecificEnthalpy h_start=Medium.specificEnthalpy_pTX(
      p_start,
      T_start,
      X_start) "Specific enthalpy" annotation (Dialog(
      tab="Initialization",
      group="Start Value: Specific Enthalpy",
      enable=not use_T_start));
  parameter SI.MassFraction X_start[Medium.nX]=Medium.X_default "Mass fraction"
    annotation (Dialog(
      tab="Initialization",
      group="Start Value: Species Mass Fraction",
      enable=Medium.nXi > 0));
  parameter SIadd.ExtraProperty C_start[Medium.nC]=fill(0, Medium.nC)
    "Mass-Specific value" annotation (Dialog(
      tab="Initialization",
      group="Start Value: Trace Substances",
      enable=Medium.nC > 0));

  parameter SI.MassFlowRate m_flow_start = 0 "Mass flow rate"
    annotation (Dialog(tab="Initialization", group="Start Value: Mass Flow Rate"));

  // Visualization
  parameter Boolean showName = true annotation(Dialog(tab="Visualization"));
  parameter Boolean showDesignFlowDirection = true annotation(Dialog(tab="Visualization"));

  parameter Boolean showColors = false "Toggle dynamic color display"  annotation(Dialog(tab="Visualization",group="Color Coding"));
  input Real val_min = 293.15 "val <= val_min is mapped to colorMap[1,:]" annotation(Dialog(tab="Visualization",group="Color Coding",enable=showColors));
  input Real val_max = 373.15
                             "val >= val_max is mapped to colorMap[end,:]" annotation(Dialog(tab="Visualization",group="Color Coding",enable=showColors));

  annotation (
    defaultComponentName="systemTF",
    defaultComponentPrefixes="inner",
    missingInnerMessage="
Your model is using an outer \"systemTF\" component but
an inner \"systemTF\" component is not defined.
For simulation drag TRANSFORM.Fluid.SystemTF into your model
to specify system properties.",
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}), graphics={
        Text(
          extent={{-150,150},{150,110}},
          lineColor={0,0,255},
          textString="%name",
          visible=DynamicSelect(true, showName)),
          Ellipse(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Solid,
          fillColor={226,226,226})}),
    Documentation(info="<html>
<p>
 A system component is needed in each fluid model to provide system-wide settings, such as ambient conditions and overall modeling assumptions.
 The system settings are propagated to the fluid models using the inner/outer mechanism.
</p>
<p>
 A model should never directly use system parameters.
 Instead a local parameter should be declared, which uses the global setting as default.
 The only exceptions are:</p>
 <ul>
  <li>the gravity system.g,</li>
  <li>the global system.eps_m_flow, which is used to define a local m_flow_small for the local m_flow_nominal:
      <pre>m_flow_small = system.eps_m_flow*m_flow_nominal</pre>
  </li>
 </ul>
<p>
 The global system.m_flow_small and system.dp_small are classic parameters.
 They do not distinguish between laminar flow and regularization of zero flow.
 Absolute small values are error prone for models with local nominal values.
 Moreover dp_small can generally be obtained automatically.
 Consider using the new system.use_eps_Re = true (see Advanced tab).
</p>
</html>"));
end SystemTF;
