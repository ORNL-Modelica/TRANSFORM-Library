within TRANSFORM.Media.Interfaces.Fluids.PartialSimpleMedium_other;
function specificHeatCapacityCv_T_der
  input Temperature T "Temperature";
  input Real der_T;
  output Real der_cv;
algorithm
  der_cv := cv_T_coef[1];
  annotation (Inline=true);
end specificHeatCapacityCv_T_der;
