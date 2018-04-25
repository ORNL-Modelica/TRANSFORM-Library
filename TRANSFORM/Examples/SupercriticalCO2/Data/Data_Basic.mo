within TRANSFORM.Examples.SupercriticalCO2.Data;
record Data_Basic

  extends TRANSFORM.Icons.Record;

  import TRANSFORM.Units.Conversions.Functions.Distance_m.from_inch;
  parameter String Medium_salt="KCl-MgCl2 (67-33mol%)";
  parameter String Medium_co2="Co2-CoolProp";

  parameter SI.Temperature T_hot_PCL = 725+273.15 "Hot temperature";
  parameter SI.Temperature T_cold_PCL = 28+273.15 "Cold temperature";

  parameter SI.Temperature T_out_pcx = T_hot_PCL "Hot temperature";
  parameter SI.Temperature T_in_pcx = 600+273.15 "Cold temperature";

  parameter SI.Temperature T_hot_salt = 750+273.15;
  parameter SI.Temperature T_cold_salt = 650+273.15;

  parameter SI.Pressure p_nominal_PCL=8e6 "Nominal pressure";
  parameter SI.Power Q_nominal = 300e3 "Nominal HX rating";

  // piping for sch 160 3inch
  parameter SI.Length d_inner_pipe = from_inch(2.626) "pipe ID";
  parameter SI.Length d_outer_pipe = from_inch(3.5) "pipe OD";
  parameter SI.Length th_pipe = 0.5.*(d_outer_pipe-d_inner_pipe) "pipe thickness";

  parameter SI.Length length_pumpToHx = 2;
  parameter SI.Length length_HX = 3;
  parameter SI.Length length_ahxToPump = 1;
  parameter SI.Length length_ahx = 1;
  parameter SI.Length d_outer_ahx=0.01715;
  parameter SI.Length th_ahx=0.0032;
  parameter SI.Length d_inner_ahx=d_outer_ahx-2*th_ahx;
  parameter Real nTubes_ahx = 30;

  // printed circuit hx
  parameter String Material_pcx="SS316";
  parameter SI.Length length_pcx=1;
  parameter SI.Length r_pcx = 0.5*0.0019;
  parameter SI.Length th_pcx=2*r_pcx;
  parameter Real nT_300 = 3000;
  parameter SI.MassFlowRate m_flow_co2_300kw = 2;
  parameter SI.MassFlowRate m_flow_salt_300kw = 2.5;

  parameter SI.MassFlowRate m_flow_co2_800kw = m_flow_co2_300kw*8/3;
  parameter SI.MassFlowRate m_flow_salt_800kw = m_flow_salt_300kw*8/3;

  annotation (defaultComponentName="data",
  Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Data_Basic;
