within TRANSFORM.Math;
function arrheniusEquation "Arrhenius equation y = A*exp(-(Ea/RT)^b)"
  extends TRANSFORM.Icons.Function;

  input SI.Temperature T "Temperature";
  input Real A "Pre-exponential factor";
  input SI.MolarEnergy Ea "Activation energy";
  input SI.MolarHeatCapacity R = Modelica.Constants.R "Universal gas constant";
  input Real beta = 1.0 "Correction factor";

  output Real y "Result";
algorithm

 y :=A .* exp(-(Ea ./ (R .* T)) .^ beta);

 annotation(smoothOrder=4);
end arrheniusEquation;
