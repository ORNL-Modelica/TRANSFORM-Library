within TRANSFORM.Units.Conversions.Functions.Energy_J;
function to_MeV "Energy: [J] -> [MeV]"
  extends BaseClasses.to;

algorithm
  y := u*1/1.60218e-13;
end to_MeV;
