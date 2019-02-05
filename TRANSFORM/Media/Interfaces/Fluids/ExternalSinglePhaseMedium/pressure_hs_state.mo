within TRANSFORM.Media.Interfaces.Fluids.ExternalSinglePhaseMedium;
function pressure_hs_state "Return pressure for given h and s"
  extends Modelica.Icons.Function;
  input SpecificEnthalpy h "Enthalpy";
  input SpecificEntropy s "Specific entropy";
  input ThermodynamicState state;
  output AbsolutePressure p "Pressure";
algorithm
  p := pressure(state);
annotation (
  Inline=false,
  LateInline=true);
end pressure_hs_state;
