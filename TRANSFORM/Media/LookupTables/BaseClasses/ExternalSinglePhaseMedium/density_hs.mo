within TRANSFORM.Media.LookupTables.BaseClasses.ExternalSinglePhaseMedium;
function density_hs "Return density for given h and s"
  extends Modelica.Icons.Function;
  input SpecificEnthalpy h "Enthalpy";
  input SpecificEntropy s "Specific entropy";
  output Density d "density";
algorithm
  d := density_hs_state(
      h=h,
      s=s,
      state=setState_hs(h=h, s=s));
  annotation (Inline=true);
end density_hs;
