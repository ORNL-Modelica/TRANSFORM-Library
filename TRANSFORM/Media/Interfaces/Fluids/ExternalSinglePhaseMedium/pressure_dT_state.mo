within TRANSFORM.Media.Interfaces.Fluids.ExternalSinglePhaseMedium;
function pressure_dT_state
  extends Modelica.Icons.Function;
  input Density d "Density";
  input Temperature T "Temperature";
  input ThermodynamicState state;
  output AbsolutePressure p "pressure";
algorithm
  p := pressure(state);
annotation (
  Inline=false,
  LateInline=true,
  inverse(d=density_pT_state(p=p, T=T, state=state)));
end pressure_dT_state;
