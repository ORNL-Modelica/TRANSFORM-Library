within TRANSFORM.Media.LookupTables.BaseClasses.ExternalSinglePhaseMedium;
function specificEnthalpy_dT_state
  extends Modelica.Icons.Function;
  input Density d "Density";
  input Temperature T "Temperature";
  input ThermodynamicState state;
  output SpecificEnthalpy h "SpecificEnthalpy";
algorithm
  h := specificEnthalpy(state);
annotation (
  Inline=false,
  LateInline=true);
end specificEnthalpy_dT_state;
