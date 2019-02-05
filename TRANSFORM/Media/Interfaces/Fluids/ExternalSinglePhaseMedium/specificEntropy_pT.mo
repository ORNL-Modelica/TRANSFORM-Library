within TRANSFORM.Media.Interfaces.Fluids.ExternalSinglePhaseMedium;
function specificEntropy_pT "returns specific entropy for a given p and T"
  extends Modelica.Icons.Function;
  input AbsolutePressure p "Pressure";
  input Temperature T "Temperature";
  input FixedPhase phase=0 "2 for two-phase, 1 for one-phase, 0 if not known";
  output SpecificEntropy s "Specific Entropy";
algorithm
  s := specificEntropy_pT_state(p=p, T=T, state=setState_pT(p=p, T=T, phase=phase));
annotation (
  Inline=true,
  inverse(T=temperature_ps(p=p, s=s, phase=phase)));
end specificEntropy_pT;
