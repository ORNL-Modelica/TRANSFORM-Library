within TRANSFORM.Units.Conversions.Functions.Temperature_K;
function to_degC "Temperature: [K] -> [degC]"
  extends BaseClasses.to;

algorithm
  y := u - 273.15;
end to_degC;
