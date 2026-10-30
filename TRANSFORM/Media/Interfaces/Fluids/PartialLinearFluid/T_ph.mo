within TRANSFORM.Media.Interfaces.Fluids.PartialLinearFluid;
function T_ph "Return temperature from pressure and specific enthalpy"
  extends Modelica.Icons.Function;
  input SpecificEnthalpy h "Specific enthalpy";
  input AbsolutePressure p "Pressure";
  output Temperature T "Temperature";
algorithm
  T := (h - reference_h - (p - reference_p)*((1 - beta_const*reference_T)/
    reference_d))/cp_const + reference_T;
end T_ph;
