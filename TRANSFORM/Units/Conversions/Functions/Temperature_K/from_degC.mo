within TRANSFORM.Units.Conversions.Functions.Temperature_K;
function from_degC "Temperature: [degC] -> [K]"
  extends BaseClasses.from;
algorithm
  y := u + 273.15;
  annotation (Inline=true,Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,
            -100},{100,100}})));
end from_degC;
