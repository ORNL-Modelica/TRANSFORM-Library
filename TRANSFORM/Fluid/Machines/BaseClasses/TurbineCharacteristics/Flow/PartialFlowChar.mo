within TRANSFORM.Fluid.Machines.BaseClasses.TurbineCharacteristics.Flow;
partial model PartialFlowChar
  "Base class for turbine flow characteristics. Extending class solves for m_flow."

  replaceable package Medium = Modelica.Media.Interfaces.PartialMedium
    "Medium in the component" annotation (Dialog(tab="Internal Interface"));

  input SIadd.NonDim PR annotation (Dialog(tab="Internal Interface", group="Inputs"));

  input Medium.ThermodynamicState state "Inlet thermodynamic state"
    annotation (Dialog(tab="Internal Interface", group="Inputs"));
  input Modelica.Units.NonSI.AngularVelocity_rpm N "Turbine speed"
    annotation (Dialog(tab="Internal Interface", group="Inputs"));

  parameter Modelica.Units.NonSI.AngularVelocity_rpm N_nominal "Pump speed"
    annotation (Dialog(tab="Internal Interface", group=
          "Nominal Operating Parameters"));
  parameter SI.MassFlowRate m_flow_nominal "Mass flow rate" annotation (Dialog(tab="Internal Interface", group="Nominal Operating Parameters"));
  parameter SI.Temperature T_nominal "Inlet temperature" annotation (Dialog(tab="Internal Interface", group="Nominal Operating Parameters"));
  parameter SI.Pressure p_nominal "Inlet pressure" annotation (Dialog(tab="Internal Interface", group="Nominal Operating Parameters"));
  parameter SIadd.NonDim PR_nominal "Outlet/inlet nominal pressure ratio" annotation (Dialog(tab="Internal Interface", group="Nominal Operating Parameters"));

  constant SI.Temperature T_ref = 288.15;
  constant SI.Pressure p_ref = 101325;

  final parameter Real m_flow_c_nominal = m_flow_nominal*sqrt(T_nominal/T_ref)/p_nominal/p_ref;

  SI.Temperature T_inlet = Medium.temperature(state);
  SI.Pressure p_inlet = Medium.pressure(state);

  SI.MassFlowRate m_flow_c = m_flow*sqrt(T_inlet/T_ref)/p_inlet/p_ref "Referred or corrected mass flow rate";
  Modelica.Units.NonSI.AngularVelocity_rpm N_c=N/sqrt(T_inlet/T_ref)
    "Referred or corrected speed";

  SI.MassFlowRate m_flow;

  annotation (
    defaultComponentName="flowCurve",
    Icon(coordinateSystem(preserveAspectRatio=false), graphics={Ellipse(
          extent={{100,100},{-100,-100}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid), Text(
          extent={{-64,12},{64,-14}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="%name")}),
    Diagram(coordinateSystem(preserveAspectRatio=false)));
end PartialFlowChar;
