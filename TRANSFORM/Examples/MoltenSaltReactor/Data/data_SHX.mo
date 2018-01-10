within TRANSFORM.Examples.MoltenSaltReactor.Data;
model data_SHX
  "Secondary heat exchanger: Tube - Supercritical Steam, Shell - Primary Coolant Salt"
  extends Icons.Record;

import TRANSFORM.Units.Conversions.Functions.Temperature_K.from_degF;
import TRANSFORM.Units.Conversions.Functions.MassFlowRate_kg_s.from_lbm_hr;
import TRANSFORM.Units.Conversions.Functions.Pressure_Pa.from_psi;

parameter Integer nHX_total = 6 "Total # of HXs";
parameter Integer nParallel = 3 "# of parallel HX loops";
parameter Integer nHX_loop = nHX_total/nParallel "# of HXs per loop";

parameter SI.Power Qt_capacity = 125e6 "Nominal capacity";
parameter String Material = "Alloy-N" "HX material";

parameter SI.Temperature T_inlet_tube = from_degF(800) "Inlet temperature";
parameter SI.Temperature T_outlet_tube = from_degF(1050) "Outlet temperature";
parameter SI.Temperature T_inlet_shell = from_degF(1100) "Inlet temperature";
parameter SI.Temperature T_outlet_shell = from_degF(900) "Outlet temperature";

parameter SI.PressureDifference dp_tube = from_psi(152) "Pressure drop";
parameter SI.Pressure p_inlet_tube = 99999 "Inlet pressure"; //update
parameter SI.Pressure p_outlet_tube = p_inlet_tube - dp_tube "Outlet pressure";

parameter SI.PressureDifference dp_shell = from_psi(115) "Pressure drop";
parameter SI.Pressure p_inlet_shell = 99999 "Inlet pressure"; //update
parameter SI.Pressure p_outlet_shell = p_inlet_shell - dp_shell "Outlet pressure";

parameter SI.MassFlowRate m_flow_tube = from_lbm_hr(1.79e6) "Mass flow rate";
parameter SI.MassFlowRate m_flow_shell = from_lbm_hr(3.7e6) "Mass flow rate";

end data_SHX;
