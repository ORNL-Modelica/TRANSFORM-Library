within TRANSFORM.Media.LookupTables.BaseClasses.ExternalSinglePhaseMedium;
function density_pT_state
  extends Modelica.Icons.Function;
  input AbsolutePressure p "Pressure";
  input Temperature T "Temperature";
  input ThermodynamicState state;
  output Density d "Density";
algorithm
  d := density(state);
annotation (
  Inline=false,
  LateInline=true,
  inverse(p=pressure_dT_state(d=d, T=T, state=state)));
end density_pT_state;
