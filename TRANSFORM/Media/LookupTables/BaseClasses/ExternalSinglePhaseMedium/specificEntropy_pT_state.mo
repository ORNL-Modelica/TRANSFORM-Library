within TRANSFORM.Media.LookupTables.BaseClasses.ExternalSinglePhaseMedium;
function specificEntropy_pT_state
  "returns specific entropy for a given p and T"
  extends Modelica.Icons.Function;
  input AbsolutePressure p "Pressure";
  input Temperature T "Temperature";
  input ThermodynamicState state;
  output SpecificEntropy s "Specific Entropy";
algorithm
  s := specificEntropy(state);
  annotation (Inline=false, LateInline=true);
end specificEntropy_pT_state;
