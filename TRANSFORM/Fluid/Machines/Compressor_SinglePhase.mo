within TRANSFORM.Fluid.Machines;
model Compressor_SinglePhase
  extends BaseClasses.PartialCompressor;

  parameter SI.MassFlowRate m_flow_nominal=m_flow_start "Nominal mass flowrate";
  parameter SI.Pressure p_inlet_nominal=p_a_start "Nominal inlet pressure";
  parameter SI.Pressure p_outlet_nominal=p_b_start "Nominal outlet pressure"
    annotation (Dialog(group="Stodola's Law Coefficient", enable=if
          use_NominalInlet and use_Stodola then true else false));
  parameter SI.Temperature T_nominal=T_a_start "Nominal inlet temperature"
    annotation (Dialog(group="Stodola's Law Coefficient", enable=if
          use_NominalInlet and use_T_nominal and use_Stodola then true else false));
  parameter SI.Density d_nominal=Medium.density(Medium.setState_pTX(
      p_inlet_nominal,
      T_nominal,
      Medium.reference_X)) "Nominal inlet density" annotation (Dialog(group="Stodola's Law Coefficient",
        enable=if use_NominalInlet and not use_T_nominal and use_Stodola then true
           else false));
  final parameter SI.VolumeFlowRate V_flow_nominal = m_flow_nominal/d_nominal;
  final parameter Real p_ratio_nominal = p_outlet_nominal/p_inlet_nominal;
  final parameter SI.PressureDifference dp_nominal = p_outlet_nominal-p_inlet_nominal;
  final parameter SI.Torque tau_nominal = dp_nominal*V_flow_nominal/eta_nominal/omega_nominal;

  SI.SpecificHeatCapacity cp_a = Medium.specificHeatCapacityCp(state_a);
  SI.SpecificHeatCapacity cv_a = Medium.specificHeatCapacityCv(state_a);
  //SI.SpecificHeatCapacity cp_b = Medium.specificHeatCapacityCp(state_b);
  //SI.SpecificHeatCapacity cv_b = Medium.specificHeatCapacityCv(state_b);
  Real gamma_a = cp_a/cv_a;
  //Real gamma_b = cp_b/cv_b;
  SI.VolumeFlowRate V_flow_a;
  SI.Density d_a = Medium.density(state_a);
  SI.PressureDifference dp;

  SI.Temperature T_a;
equation
  dp = port_b.p - port_a.p;
  port_a.m_flow = V_flow_a * d_a;
  T_a = state_a.T;

  tau*omega*eta_nominal = dp * V_flow_a;
  tau*omega*eta_nominal = cp_a * T_a * (p_ratio^((gamma_a-1)/gamma_a)-1);

  annotation (
    defaultComponentName="compressor_singlePhase",
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>http://www.thermopedia.com/content/647/</p>
</html>"));
end Compressor_SinglePhase;
