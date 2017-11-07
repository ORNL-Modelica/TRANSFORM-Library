within TRANSFORM.Units.Conversions.Functions.TemperatureDifference_dK;
function from_degF_diff
  "Temperature Difference: [degF] -> [K]"
  extends BaseClasses.from;

algorithm
  y := u*(5/9);
  annotation (Inline=true,Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,
            -100},{100,100}})));
end from_degF_diff;
