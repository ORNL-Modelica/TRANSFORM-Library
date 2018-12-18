within TRANSFORM.Units.Conversions.Functions.TemperatureDifference_dK;
function from_degCorK_diff
  "Temperature Difference: [degC or K] -> [K]"
  extends BaseClasses.from;

algorithm
  y := u;
  annotation (Inline=true,Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,
            -100},{100,100}})));
end from_degCorK_diff;
