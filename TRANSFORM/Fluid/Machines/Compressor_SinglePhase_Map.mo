within TRANSFORM.Fluid.Machines;
model Compressor_SinglePhase_Map
  extends BaseClasses.PartialCompressor(eta_mech=1.0);
extends TRANSFORM.Icons.UnderConstruction;
  import NonSI = Modelica.SIunits.Conversions.NonSIunits;

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

  input Real scale_u1=1.0 "Scaling value for tableVar u1: input = var*scale"
    annotation (Dialog(group="Inputs"));
  input Real scale_u2=1.0 "Scaling value for tableVar u2: input = var*scale"
    annotation (Dialog(group="Inputs"));
  input Real scale_y=1.0 "Scaling value for tableVar y: var = output*scale"
    annotation (Dialog(group="Inputs"));

  NonSI.AngularVelocity_rpm N(start=N_nominal) "Shaft rotational speed";
  SIadd.NonDim m_flow_c=m_flow*sqrt(T_inlet)/p_inlet
    "Referred or corrected mass flow rate";
  SIadd.NonDim N_c=N/sqrt(T_inlet) "Referred or corrected speed";

  SI.Temperature T_inlet=Medium.temperature(state_a);
  SI.Pressure p_inlet=port_a.p;
  Real Rline(start=integer(size(pressureChar, 1)/2))
    "Arbitraty defined lines on compressor map. Also known as beta (Source 1 5.2.5)";

  Modelica.Blocks.Tables.CombiTable2D efficiencyIsentropic_RLineN(table=
        efficiencyChar, smoothness=Modelica.Blocks.Types.Smoothness.ContinuousDerivative)
    "Isentropic or aerodynamic efficiency"
    annotation (Placement(transformation(extent={{-10,30},{10,50}})));
  Modelica.Blocks.Tables.CombiTable2D massFlowRate_RLineN(table=flowChar,
      smoothness=Modelica.Blocks.Types.Smoothness.ContinuousDerivative)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Tables.CombiTable2D pressureRatio_RLineN(table=pressureChar,
      smoothness=Modelica.Blocks.Types.Smoothness.ContinuousDerivative)
    annotation (Placement(transformation(extent={{-10,-50},{10,-30}})));

equation

  omega = N*2*Modelica.Constants.pi/60;

  massFlowRate_RLineN.u1 = Rline*scale_u1;
  massFlowRate_RLineN.u2 = N*scale_u2;
  massFlowRate_RLineN.y*scale_y = m_flow;

  efficiencyIsentropic_RLineN.u1 = Rline*scale_u1;
  efficiencyIsentropic_RLineN.u2 = N*scale_u2;
  efficiencyIsentropic_RLineN.y = eta_is;
  pressureRatio_RLineN.u1 = Rline*scale_u1;
  pressureRatio_RLineN.u2 = N*scale_u2;
  pressureRatio_RLineN.y*scale_y = p_ratio;

  annotation (
    defaultComponentName="compressor",
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>Quasidimensionless group (corrected, referred, or non-dimensional) definitions are summarised in Chart 4.2 of Source 1. Additional resource for corrected or referred speed: https://en.wikipedia.org/wiki/Corrected_speed.</p>
<p><br>Sources</p>
<p>1. P. P. WALSH and P. FLETCHER, <i>Gas Turbine Performance</i>, 2. ed., [repr.], Blackwell Science, Oxford (2004). </p>
</html>"));
end Compressor_SinglePhase_Map;
