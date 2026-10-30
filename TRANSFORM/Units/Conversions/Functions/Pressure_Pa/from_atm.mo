within TRANSFORM.Units.Conversions.Functions.Pressure_Pa;
function from_atm "Pressure: [atm] -> [Pa]"
  extends BaseClasses.from;
algorithm
  y := u*101325;
  annotation (Inline=true,Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,
            -100},{100,100}})));
end from_atm;
