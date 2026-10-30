within TRANSFORM.Fluid.ClosureRelations.PressureLoss.Functions.HeatExchangers.BellDelawareSTHX_ShellSide;
function fRe2_Nozzle
  input SI.Length d_N "Nozzle diameter";
  input SI.Length d_o "Outer diameter of tubes";
  input Real n_T "Total # of tubes (including blind and support)";
  input SI.Length D_i "Inside shell diameter";
  input SI.Length D_BE "Diameter of circle that touches outermost tubes";
  input SI.DynamicViscosity mu "Upstream dynamic viscosity";
  input SI.MassFlowRate m_flow "Mass flow rate";
  input Boolean isReducingNozzle "=true if flow from large nozzle (d_N) to small tubes (d_o)";
  output Units.NonDim fRe2 "Modified friction coefficient (= f*Re^2)";
protected
  Real A_NF = d_N*d_N/(D_i*D_i-n_T*d_o*d_o)
    "Cross-sectional area ratio of the nozzle to the free area of the heat exchanger shell";
  Real C_InOut = if isReducingNozzle then 3.308 else 2.482 "Constant for inlet vs outlet flow";
  SI.ReynoldsNumber Re "Reynolds number";
algorithm
  Re := (4/pi)*abs(m_flow)/(d_N*mu);
  fRe2 := Re*Re*C_InOut*A_NF^(1.14)*(d_N/D_i)*(D_BE/d_N)^(2.4);
end fRe2_Nozzle;
