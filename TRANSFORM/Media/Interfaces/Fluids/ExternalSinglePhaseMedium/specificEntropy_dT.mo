within TRANSFORM.Media.Interfaces.Fluids.ExternalSinglePhaseMedium;
function specificEntropy_dT "returns specific entropy for a given d and T"
  extends Modelica.Icons.Function;
  input Density d "Density";
  input Temperature T "Temperature";
  input FixedPhase phase=0 "2 for two-phase, 1 for one-phase, 0 if not known";
output SpecificEntropy s "Specific Entropy";
algorithm
  s := specificEntropy_dT_state(d=d, T=T, state=setState_dT(d=d, T=T, phase=phase));
annotation (Inline=true);
end specificEntropy_dT;
