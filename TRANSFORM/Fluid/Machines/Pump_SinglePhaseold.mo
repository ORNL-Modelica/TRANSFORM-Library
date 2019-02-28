within TRANSFORM.Fluid.Machines;
model Pump_SinglePhaseold
  extends BaseClasses.PartialPump_SinglePhase;

  import NonSI = Modelica.SIunits.Conversions.NonSIunits;

  parameter NonSI.AngularVelocity_rpm N_nominal=1500 "Pump speed";
  parameter SI.Length diameter_nominal=0.1524 "Impeller diameter";
  parameter SI.Length diameter = diameter_nominal "Impeller diameter";

  parameter Real flowChar[:,:]=fill(
      0.0,
      0,
      2);

  parameter SI.Efficiency eta_is_design = eta_is_design_map;
  parameter SI.Efficiency eta_is_design_map = 1.0;

  NonSI.AngularVelocity_rpm N(start=N_nominal) = omega*60/(2*Modelica.Constants.pi) "Shaft rotational speed";

  SI.Temperature T_inlet=Medium.temperature(state_a);
  SI.Pressure p_inlet=port_a.p;

  Modelica.Blocks.Tables.CombiTable1D FlowChar(table=flowChar, smoothness=
        Modelica.Blocks.Types.Smoothness.ContinuousDerivative)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

SI.Density d_inlet = Medium.density(state_a) "Inlet density";
SI.Height head "Pump pressure head";
SI.VolumeFlowRate V_flow = m_flow/d_inlet;
SIadd.NonDim affinityLaw_head;

equation

  affinityLaw_head = (N/N_nominal)^2*(diameter/diameter_nominal)^2;
  V_flow*N = FlowChar.y[1];
  FlowChar.u[1]*N^2 = head;

  dp = d_inlet*Modelica.Constants.g_n*head;

  eta_is = 0.7;

  annotation (
    defaultComponentName="pump",
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>Quasidimensionless group (corrected, referred, or non-dimensional) definitions are summarised in Chart 4.2 of Source 1. Additional resource for corrected or referred speed: https://en.wikipedia.org/wiki/Corrected_speed.</p>
<p><br>Sources</p>
<p>1. P. P. WALSH and P. FLETCHER, <i>Gas Turbine Performance</i>, 2. ed., [repr.], Blackwell Science, Oxford (2004). </p>
</html>"));
end Pump_SinglePhaseold;
