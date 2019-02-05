within TRANSFORM.Media.Interfaces.Fluids.ExternalSinglePhaseMedium;
function specificEntropy_ph_state
  "returns specific entropy for a given p and h"
  extends Modelica.Icons.Function;
  input AbsolutePressure p "Pressure";
  input SpecificEnthalpy h "Specific Enthalpy";
  input ThermodynamicState state;
  output SpecificEntropy s "Specific Entropy";
algorithm
  s := specificEntropy(state);
annotation (
  Inline=false,
  LateInline=true,
  derivative(noDerivative=state)=specificEntropy_ph_der);
end specificEntropy_ph_state;
