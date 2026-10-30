within TRANSFORM.Units.Conversions.Functions.Pressure_Pa;
function from_psi_to_mH2O
  "Pressure: [psi] -> [m] | of water at STP conditions (20C and 101325 Pa)"
  extends BaseClasses.from;
  import Modelica.Constants.g_n;
algorithm
  y := from_psi(u)/(g_n*998.2071);
end from_psi_to_mH2O;
