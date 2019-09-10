within TRANSFORM.Units.Conversions.Functions.Temperature_K;
function from_K "Temperature: [K] -> [K]"
  extends BaseClasses.from;
algorithm
  y := u;
  annotation (Inline=true,Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,
            -100},{100,100}})));
end from_K;
