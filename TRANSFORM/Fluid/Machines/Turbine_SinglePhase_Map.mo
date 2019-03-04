within TRANSFORM.Fluid.Machines;
model Turbine_SinglePhase_Map
  extends BaseClasses.PartialTurbine(final eta_is=efficiencyIsentropic_PRN.y,
      eta_mech=1.0);
extends TRANSFORM.Icons.UnderConstruction;
  import NonSI = Modelica.SIunits.Conversions.NonSIunits;

  parameter NonSI.AngularVelocity_rpm N_nominal=1500 "Pump speed";

  parameter Real efficiencyChar[:,:]=fill(
      0.0,
      0,
      2) "Efficiency table where u1 = PR, u2 = N, and y = eta";
  parameter Real flowChar[:,:]=fill(
      0.0,
      0,
      2) "Flow table where u1 = PR, u2 = N, and y = m_flow";

    input Real scale_u1 = 1.0 "Scaling value for tableVar u1: input = var*scale" annotation(Dialog(group="Inputs"));
    input Real scale_u2 = 1.0 "Scaling value for tableVar u2: input = var*scale" annotation(Dialog(group="Inputs"));
    input Real scale_y = 1.0 "Scaling value for tableVar y: var = output*scale" annotation(Dialog(group="Inputs"));

  Modelica.Blocks.Tables.CombiTable2D efficiencyIsentropic_PRN(table=
        efficiencyChar, smoothness=Modelica.Blocks.Types.Smoothness.ContinuousDerivative)
    "Isentropic or aerodynamic efficiency"
    annotation (Placement(transformation(extent={{-10,10},{10,30}})));
  Modelica.Blocks.Tables.CombiTable2D massFlowRate_PRN(table=flowChar,
      smoothness=Modelica.Blocks.Types.Smoothness.ContinuousDerivative)
    annotation (Placement(transformation(extent={{-10,-30},{10,-10}})));

  NonSI.AngularVelocity_rpm N(start=N_nominal) "Shaft rotational speed";
  SIadd.NonDim PR = 1/p_ratio;
  SIadd.NonDim m_flow_c = m_flow*sqrt(T_inlet)/p_inlet "Referred or corrected mass flow rate";
  SIadd.NonDim N_c = N/sqrt(T_inlet) "Referred or corrected speed";

  SI.Temperature T_inlet = Medium.temperature(state_a);
  SI.Pressure p_inlet = port_a.p;
Real p_ratio "port_b.p/port_a.p pressure ratio";
equation
p_ratio = port_b.p/port_a.p;
  omega = N*2*Modelica.Constants.pi/60;

  massFlowRate_PRN.u1 = PR*scale_u1;
  massFlowRate_PRN.u2 = N*scale_u2;

  efficiencyIsentropic_PRN.u1 = PR*scale_u1;
  efficiencyIsentropic_PRN.u2 = N*scale_u2;

  m_flow =massFlowRate_PRN.y*scale_y;

  annotation (defaultComponentName="turbine",Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>Quasidimensionless group (corrected, referred, or non-dimensional) definitions are summarised in Chart 4.2 of Source 1. Additional resource for corrected or referred speed: https://en.wikipedia.org/wiki/Corrected_speed.</p>
<p><br>Sources</p>
<p>1. P. P. WALSH and P. FLETCHER, <i>Gas Turbine Performance</i>, 2. ed., [repr.], Blackwell Science, Oxford (2004). </p>
</html>"));
end Turbine_SinglePhase_Map;
