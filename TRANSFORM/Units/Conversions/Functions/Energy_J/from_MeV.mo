within TRANSFORM.Units.Conversions.Functions.Energy_J;
function from_MeV "Energy: [MeV] -> [J]"
  extends BaseClasses.from;

algorithm
  y := u*1.60218e-13;
end from_MeV;
