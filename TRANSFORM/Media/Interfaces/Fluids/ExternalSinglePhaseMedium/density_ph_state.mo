within TRANSFORM.Media.Interfaces.Fluids.ExternalSinglePhaseMedium;
function density_ph_state "returns density for given p and h"
  extends Modelica.Icons.Function;
  input AbsolutePressure p "Pressure";
  input SpecificEnthalpy h "Enthalpy";
  input ThermodynamicState state;
  output Density d "density";
algorithm
  d := density(state);
annotation (
  Inline=false,
  LateInline=true,
  derivative(noDerivative=state)=density_ph_der);
end density_ph_state;
