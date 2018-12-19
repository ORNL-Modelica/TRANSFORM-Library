within TRANSFORM.Units.Conversions.Functions.Pressure_Pa;
function from_mH2O_to_psi
  "Pressure: [m] -> [psi] | of water at STP conditions (20C and 101325 Pa)"
  extends BaseClasses.to;
  import Modelica.Constants.g_n;

algorithm
  y := to_psi(u)*(g_n*998.2071);
end from_mH2O_to_psi;
