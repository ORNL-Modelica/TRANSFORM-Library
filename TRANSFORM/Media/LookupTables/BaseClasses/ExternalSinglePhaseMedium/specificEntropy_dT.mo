within TRANSFORM.Media.LookupTables.BaseClasses.ExternalSinglePhaseMedium;
function specificEntropy_dT
  "returns specific entropy for a given d and T"
  extends Modelica.Icons.Function;
  input Density d "Density";
  input Temperature T "Temperature";
  output SpecificEntropy s "Specific Entropy";
algorithm
  s := specificEntropy_dT_state(
      d=d,
      T=T,
      state=setState_dT(d=d, T=T));
  annotation (Inline=true);
end specificEntropy_dT;
