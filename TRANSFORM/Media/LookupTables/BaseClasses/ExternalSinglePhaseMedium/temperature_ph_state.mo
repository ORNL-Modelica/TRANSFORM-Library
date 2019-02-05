within TRANSFORM.Media.LookupTables.BaseClasses.ExternalSinglePhaseMedium;
function temperature_ph_state "returns temperature for given p and h"
  extends Modelica.Icons.Function;
  input AbsolutePressure p "Pressure";
  input SpecificEnthalpy h "Enthalpy";
  input ThermodynamicState state;
  output Temperature T "Temperature";
algorithm
  T := temperature(state);
annotation (
  Inline=false,
  LateInline=true,
  inverse(h=specificEnthalpy_pT_state(p=p, T=T, state=state)));
end temperature_ph_state;
