within TRANSFORM.Media.LookupTables.BaseClasses.ExternalSinglePhaseMedium;
function temperature_ps_state
  "returns temperature for given p and s"
  extends Modelica.Icons.Function;
  input AbsolutePressure p "Pressure";
  input SpecificEntropy s "Specific entropy";
  input ThermodynamicState state;
  output Temperature T "Temperature";
algorithm
  T := temperature(state);
  annotation (
    Inline=false,
    LateInline=true,
    inverse(s=specificEntropy_pT_state(
            p=p,
            T=T,
            state=state)));
end temperature_ps_state;
