within TRANSFORM.Media.LookupTables.BaseClasses.ExternalSinglePhaseMedium;
function temperature_hs_state
  "Return temperature for given h and s"
  extends Modelica.Icons.Function;
  input SpecificEnthalpy h "Enthalpy";
  input SpecificEntropy s "Specific entropy";
  input ThermodynamicState state;
  output Temperature T "Temperature";
algorithm
  T := temperature(state);
  annotation (Inline=false, LateInline=true);
end temperature_hs_state;
