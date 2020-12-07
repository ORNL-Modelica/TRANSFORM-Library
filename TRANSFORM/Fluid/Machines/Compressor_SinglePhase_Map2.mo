within TRANSFORM.Fluid.Machines;
model Compressor_SinglePhase_Map2
  extends BaseClasses.PartialCompressor(eta_mech=1.0);
extends TRANSFORM.Icons.UnderConstruction;
  import         Modelica.Units.NonSI;

  parameter NonSI.AngularVelocity_rpm N_nominal=1500 "Pump speed";

  parameter Real efficiencyChar[:,:]=fill(
      0.0,
      0,
      2) "Efficiency table where u1 = RLine, u2 = N, and y = eta";
  parameter Real flowChar[:,:]=fill(
      0.0,
      0,
      2) "Flow table where u1 = RLine u2 = N, and y = m_flow";
  parameter Real pressureChar[:,:]=fill(
      0.0,
      0,
      2) "Pressure table where u1 = RLine, u2 = N, and y = p_ratio";

    // Questionable if need but the values are taken from Source 1 4.2.4
  parameter SI.Temperature T_ref = 288.15;
  parameter SI.Pressure p_ref = 101325;

  parameter SI.MassFlowRate m_c_design = m_c_design_map;
  parameter SI.MassFlowRate m_c_design_map = m_flow_start*sqrt(T_a_start/T_ref)*p_a_start/p_ref;

  parameter SIadd.NonDim PR_design = PR_design_map;
  parameter SIadd.NonDim PR_design_map = p_b_start/p_a_start;

  parameter SI.Efficiency eta_is_design = eta_is_design_map;
  parameter SI.Efficiency eta_is_design_map = 1.0;

  NonSI.AngularVelocity_rpm N(start=N_nominal) = omega*60/(2*Modelica.Constants.pi) "Shaft rotational speed";
  NonSI.AngularVelocity_rpm N_c=N/sqrt(T_inlet/T_ref) "Referred or corrected speed";

  SI.MassFlowRate m_flow_c=m_flow*sqrt(T_inlet/T_ref)*p_inlet/p_ref
    "Referred or corrected mass flow rate";
  SI.MassFlowRate m_flow_c_scaled  "Scaled corrected mass flow rate";

  SIadd.NonDim PR = port_b.p/port_a.p "Pressure ratio";
  SIadd.NonDim PR_scaled "Scaled pressure ratio";

  SI.Efficiency eta_is_scaled "Scaled efficiency";

  SI.Temperature T_inlet=Medium.temperature(state_a);
  SI.Pressure p_inlet=port_a.p;
  Real Rline(start=integer(size(pressureChar, 1)/2))
    "Arbitraty defined lines on compressor map. Also known as beta (Source 1 - 5.2.5)";

  Modelica.Blocks.Tables.CombiTable2Ds efficiencyIsentropic_RLineN(table=
        efficiencyChar, smoothness=Modelica.Blocks.Types.Smoothness.ContinuousDerivative)
    "Isentropic or aerodynamic efficiency"
    annotation (Placement(transformation(extent={{-10,30},{10,50}})));
  Modelica.Blocks.Tables.CombiTable2Ds massFlowRate_RLineN(table=flowChar,
      smoothness=Modelica.Blocks.Types.Smoothness.ContinuousDerivative)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Tables.CombiTable2Ds pressureRatio_RLineN(table=pressureChar,
      smoothness=Modelica.Blocks.Types.Smoothness.ContinuousDerivative)
    annotation (Placement(transformation(extent={{-10,-50},{10,-30}})));

equation

  m_flow_c_scaled = m_flow_c*m_c_design/m_c_design_map;

  PR_scaled = (PR_design-1)/(PR_design_map-1)*(PR-1) + 1;

  eta_is_scaled = eta_is_design/eta_is_design_map*eta_is;

  massFlowRate_RLineN.u1 = Rline;
  massFlowRate_RLineN.u2 = N_c;
  massFlowRate_RLineN.y = m_flow_c_scaled;

  efficiencyIsentropic_RLineN.u1 = Rline;
  efficiencyIsentropic_RLineN.u2 = N_c;
  efficiencyIsentropic_RLineN.y = eta_is_scaled;

  pressureRatio_RLineN.u1 = Rline;
  pressureRatio_RLineN.u2 = N_c;
  pressureRatio_RLineN.y = PR_scaled;

  annotation (
    defaultComponentName="compressor",
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>Quasidimensionless group (corrected, referred, or non-dimensional) definitions are summarised in Chart 4.2 of Source 1. Additional resource for corrected or referred speed: https://en.wikipedia.org/wiki/Corrected_speed.</p>
<p><br>Sources</p>
<p>1. P. P. WALSH and P. FLETCHER, <i>Gas Turbine Performance</i>, 2. ed., [repr.], Blackwell Science, Oxford (2004). </p>
</html>"));
end Compressor_SinglePhase_Map2;
