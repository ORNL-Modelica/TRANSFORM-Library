within TRANSFORM.Media.Interfaces.Fluids.TableBased;
function setState_pT "Returns state record as function of p and T"
  extends Modelica.Icons.Function;
  input AbsolutePressure p "Pressure";
  input Temperature T "Temperature";
  output ThermodynamicState state "Thermodynamic state";
algorithm
  state.T := T;
  state.p := p;
  annotation(smoothOrder=3);
end setState_pT;
