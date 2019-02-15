within TRANSFORM.Fluid.FittingsAndResistances;
model NominalLoss
  extends BaseClasses.PartialResistance;
  parameter Boolean from_dp=true "=true then m_flow is calculated from dp"
    annotation (Dialog(tab="Advanced"));
  parameter SI.PressureDifference dp_nominal=0.1e5 "Nominal pressure drop";
  parameter SI.MassFlowRate m_flow_nominal=1.0
    "Nominal mass flow rate";
  parameter Real deltax=0.01 "Interpolation interval near 0"
    annotation (Dialog(tab="Advanced"));
  parameter SI.Density d_nominal=Medium.density(Medium.setState_pTX(
      p_nominal,
      T_nominal,
      Medium.X_default)) "Nominal density";
  parameter SI.Pressure p_nominal=1e5 "Nominal inlet pressure";
  parameter SI.Temperature T_nominal=298.15
    "Nominal inlet Temperature";
  SI.Density d(start=100.0) "Inlet density";
  SI.Temperature T(start=T_nominal);
equation
  d = Medium.density(state);
  T = Medium.temperature(state);
  if from_dp then
    port_a.m_flow = m_flow_nominal*TRANSFORM.Math.regRoot_cinterp(dp/dp_nominal*d
      /d_nominal, deltax);
  else
    dp = dp_nominal*d_nominal*port_a.m_flow*port_a.m_flow/(m_flow_nominal*m_flow_nominal*d);
  end if;
  annotation (defaultComponentName="generic",
        Icon(coordinateSystem(preserveAspectRatio=false), graphics={Text(
          extent={{-30,-50},{30,-70}},
          lineColor={0,0,0},
          textString="Set Nominal")}),
        Diagram(coordinateSystem(preserveAspectRatio=false)));
end NominalLoss;
