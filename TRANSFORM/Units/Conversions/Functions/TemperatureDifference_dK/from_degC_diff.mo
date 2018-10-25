within TRANSFORM.Units.Conversions.Functions.TemperatureDifference_dK;
function from_degC_diff
  "Temperature Difference: [degC/degK] -> [K]"
  extends BaseClasses.from;

algorithm
  y := u;
  annotation (Inline=true,Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,
            -100},{100,100}})));
end from_degC_diff;
