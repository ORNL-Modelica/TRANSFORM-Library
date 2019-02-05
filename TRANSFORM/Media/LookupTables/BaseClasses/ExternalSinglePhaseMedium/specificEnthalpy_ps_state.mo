within TRANSFORM.Media.LookupTables.BaseClasses.ExternalSinglePhaseMedium;
function specificEnthalpy_ps_state "Return enthalpy from p and s"
  extends Modelica.Icons.Function;
  input AbsolutePressure p "Pressure";
  input SpecificEntropy s "Specific entropy";
  input ThermodynamicState state;
  output SpecificEnthalpy h "Enthalpy";
algorithm
  h := specificEnthalpy(state);
annotation (
  Inline=false,
  LateInline=true,
  inverse(s=specificEntropy_ph_state(p=p, h=h, state=state)));
end specificEnthalpy_ps_state;
