within TRANSFORM.Examples.MoltenSaltReactor.Data;
model data_BOP
  extends Icons.Record;
  import TRANSFORM.Units.Conversions.Functions.Pressure_Pa.from_psi;
  parameter SI.Pressure p_condenser = 1e5;
  parameter SI.Pressure p_outlet_HP = from_psi(1146)
    "Outlet pressure from HP turbine";
  parameter SI.Pressure p_outlet_LP = from_psi(500)
    "Outlet pressure from HP turbine";
end data_BOP;
