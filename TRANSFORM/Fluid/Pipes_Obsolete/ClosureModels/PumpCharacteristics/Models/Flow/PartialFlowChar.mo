within TRANSFORM.Fluid.Pipes_Obsolete.ClosureModels.PumpCharacteristics.Models.Flow;
partial model PartialFlowChar
  "Base class for pump flow characteristics. Extending class solves for head."

  // Parameters
  replaceable package Medium =
    Modelica.Media.Water.StandardWater
    constrainedby Modelica.Media.Interfaces.PartialTwoPhaseMedium
    "Medium in the component"
    annotation(Dialog(tab="Internal Interface"));

  // Inputs provided to heat transfer model
  input Medium.ThermodynamicState state
    "Thermodynamic state" annotation(Dialog(tab="Internal Interface",group="Input Variables:"));

  input SI.PressureDifference dp "Pressure rise difference" annotation(Dialog(tab="Internal Interface",group="Input Variables:"));
  input SI.Conversions.NonSIunits.AngularVelocity_rpm N "Pump speed" annotation(Dialog(tab="Internal Interface",group="Input Variables:"));
  input SI.Length diameter "Impeller Diameter" annotation(Dialog(tab="Internal Interface",group="Input Variables:"));

  parameter SI.MassFlowRate m_flow_nominal "Mass flow rate" annotation(Dialog(tab="Internal Interface",group="Nominal Operating Parameters:"));
  parameter SI.Density rho_nominal "Density" annotation(Dialog(tab="Internal Interface",group="Nominal Operating Parameters:"));
  parameter SI.Conversions.NonSIunits.AngularVelocity_rpm N_nominal "Pump speed" annotation(Dialog(tab="Internal Interface",group="Nominal Operating Parameters:"));
  parameter SI.Length diameter_nominal "Impeller Diameter" annotation(Dialog(tab="Internal Interface",group="Nominal Operating Parameters:"));
  parameter SI.PressureDifference dp_nominal "Nominal pressure gain" annotation(Dialog(tab="Internal Interface",group="Nominal Operating Parameters:"));

  final parameter SI.VolumeFlowRate V_flow_nominal = m_flow_nominal/rho_nominal "Nominal volumetric flow rate";
  final parameter SI.Height head_nominal = dp_nominal/(rho_nominal*Modelica.Constants.g_n) "Nominal head";

  parameter Boolean isPump = true "=true then affinity laws for pump else fan";

  parameter SI.MassFlowRate m_flow_start annotation(Dialog(tab="Initialization"));
  parameter SI.Pressure p_a_start annotation(Dialog(tab="Initialization"));
  parameter SI.Pressure p_b_start annotation(Dialog(tab="Initialization"));
  parameter SI.SpecificEnthalpy h_start annotation(Dialog(tab="Initialization"));
  final parameter SI.PressureDifference dp_start = p_b_start - p_a_start;

  SI.Density rho = Medium.density(state) "Density";
  SI.VolumeFlowRate V_flow "Volumetric flow rate";

  Units.nonDim affinityLaw "Affinity law for scaling";

  SI.Height head "Pump pressure head";
  SI.MassFlowRate m_flow(start=m_flow_start);

equation

  if isPump then
    affinityLaw = (N/N_nominal)*(diameter/diameter_nominal);
  else
    affinityLaw = (N/N_nominal)*(diameter/diameter_nominal)^3;
  end if;

  annotation (defaultComponentName="flowCurve",
  Icon(coordinateSystem(preserveAspectRatio=false), graphics={
                             Ellipse(
          extent={{100,100},{-100,-100}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid), Text(
          extent={{-64,12},{64,-14}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="%name")}),                     Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end PartialFlowChar;
