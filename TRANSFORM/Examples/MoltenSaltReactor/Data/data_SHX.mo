within TRANSFORM.Examples.MoltenSaltReactor.Data;
model data_SHX
  "Secondary heat exchanger: Tube - Supercritical Steam, Shell - Primary Coolant Salt"
  extends Icons.Record;

import TRANSFORM.Units.Conversions.Functions.Temperature_K.from_degF;
import
    TRANSFORM.Units.Conversions.Functions.MassFlowRate_kg_s.from_lbm_hr;
import TRANSFORM.Units.Conversions.Functions.Pressure_Pa.from_psi;
import TRANSFORM.Units.Conversions.Functions.Distance_m.from_inch;

parameter Real nHX_total = 6 "Total # of HXs";
parameter Real nParallel = 3 "# of parallel HX loops";
parameter Real nHX_loop = nHX_total/nParallel "# of HXs per loop";

parameter SI.Power Qt_capacity = 125e6 "Nominal capacity per HX";
parameter String Material = "Alloy-N" "HX material";

parameter SI.Temperature T_inlet_tube = from_degF(800) "Inlet temperature";
parameter SI.Temperature T_outlet_tube = from_degF(1050) "Outlet temperature";
parameter SI.Temperature T_inlet_shell = from_degF(1100) "Inlet temperature";
parameter SI.Temperature T_outlet_shell = from_degF(900) "Outlet temperature";

parameter SI.PressureDifference dp_tube = from_psi(152) "Pressure drop";
parameter SI.Pressure p_inlet_tube = from_psi(3752) "Inlet pressure"; //from MSBR
parameter SI.Pressure p_outlet_tube = p_inlet_tube - dp_tube "Outlet pressure";

parameter SI.PressureDifference dp_shell = from_psi(115) "Pressure drop";
parameter SI.Pressure p_inlet_shell = from_psi(264) "Inlet pressure"; //slightly higher than MSBR (233)
parameter SI.Pressure p_outlet_shell = p_inlet_shell - dp_shell "Outlet pressure";

parameter SI.MassFlowRate m_flow_tube = from_lbm_hr(1.79e6) "Mass flow rate per HX";
parameter SI.MassFlowRate m_flow_shell = from_lbm_hr(3.7e6) "Mass flow rate per HX";

parameter SI.Length th_tube = from_inch(0.035) "Tube thickness";
parameter SI.Length D_tube_outer = from_inch(0.375) "Tube outer diameter";
parameter SI.Length D_tube_inner = D_tube_outer-2*th_tube "Tube inner diameter";

parameter SI.Length th_shell = from_inch(0.5) "Shell thickness";
parameter SI.Length D_shell_inner = from_inch(30.5) "Shell inner diameter";
parameter Real nTubes = 1604 "# of tubes";
parameter String pitchType = "Triangular" "Tube pitch type";
parameter SI.Length pitch_tube = from_inch(0.7188) "Tube pitch";
parameter SI.Length length_tube = from_inch(37.5*12) "Tubesheet to tubesheet distance";

parameter SI.Area surfaceArea_tubeouter = D_tube_outer*pi*length_tube*nTubes "Surface area outer tube basis";//TRANSFORM.Units.Conversions.Functions.Area_m2.from_feet2(5904);
parameter SI.CoefficientOfHeatTransfer U = TRANSFORM.Units.Conversions.Functions.CoefficientOfHeatTransfer_W_m2K.from_btuhrft2f(500);

parameter Real nBaffles = 52 "# of baffles";
parameter String baffleType="Disk and Dougnut" "Baffle type";
parameter SI.Length spacing_baffle = from_inch(8.6) "Distance between baffles";
parameter SI.Length D_diskBaffle = from_inch(22) "Outer diameter of disk type baffle";
parameter SI.Length D_doughnutBaffle = from_inch(21.6) "Inner diameter of doughnut type baffle";
end data_SHX;
