within TRANSFORM.Media.LookupTables.BaseClasses.ExternalSinglePhaseMedium;
function specificEntropy_pT "returns specific entropy for a given p and T"
  extends Modelica.Icons.Function;
  input AbsolutePressure p "Pressure";
  input Temperature T "Temperature";
  output SpecificEntropy s "Specific Entropy";
algorithm
  s := specificEntropy_pT_state(p=p, T=T, state=setState_pT(p=p, T=T));
annotation (
  Inline=true,
  inverse(T=temperature_ps(p=p, s=s)));
end specificEntropy_pT;
