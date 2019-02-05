within TRANSFORM.Media.Interfaces.Fluids.ExternalSinglePhaseMedium;
function density_hs "Return density for given h and s"
  extends Modelica.Icons.Function;
  input SpecificEnthalpy h "Enthalpy";
  input SpecificEntropy s "Specific entropy";
  input FixedPhase phase=0 "2 for two-phase, 1 for one-phase, 0 if not known";
  output Density d "density";
algorithm
  d := density_hs_state(h=h, s=s, state=setState_hs(h=h, s=s, phase=phase));
annotation (
  Inline=true);
end density_hs;
