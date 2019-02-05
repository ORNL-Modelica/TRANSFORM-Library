within TRANSFORM.Media.LookupTables.BaseClasses.ExternalSinglePhaseMedium;
function specificEntropy_dT_state
  "returns specific entropy for a given d and T"
  extends Modelica.Icons.Function;
  input Density d "Density";
  input Temperature T "Temperature";
  input ThermodynamicState state;
  output SpecificEntropy s "Specific Entropy";
algorithm
  s := specificEntropy(state);
  annotation (Inline=false, LateInline=true);
end specificEntropy_dT_state;
