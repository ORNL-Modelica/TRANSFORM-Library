within TRANSFORM.Media.Interfaces.Fluids.ExternalSinglePhaseMedium;
function density_hs_state "Return density for given h and s"
  extends Modelica.Icons.Function;
  input SpecificEnthalpy h "Enthalpy";
  input SpecificEntropy s "Specific entropy";
  input ThermodynamicState state;
  output Density d "density";
algorithm
  d := density(state);
annotation (
  Inline=false,
  LateInline=true);
end density_hs_state;
