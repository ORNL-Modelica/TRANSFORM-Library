within TRANSFORM.Units.Conversions.Functions.Pressure_Pa;
function to_bar "Pressure: [Pa] -> [bar]"
  extends BaseClasses.to;

algorithm
  y := u*1e-5;
end to_bar;
