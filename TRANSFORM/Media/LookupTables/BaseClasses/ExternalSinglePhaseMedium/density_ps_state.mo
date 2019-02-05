within TRANSFORM.Media.LookupTables.BaseClasses.ExternalSinglePhaseMedium;
function density_ps_state "Return density from p and s"
  extends Modelica.Icons.Function;
  input AbsolutePressure p "Pressure";
  input SpecificEntropy s "Specific entropy";
  input ThermodynamicState state;
  output Density d "Density";
algorithm
  d := density(state);
  annotation (
    Inline=false,
    LateInline=true,
    derivative(noDerivative=state) = density_ps_der);
end density_ps_state;
