within TRANSFORM.Media.Interfaces.Fluids.TableBased;
function setState_ps "Returns state record as function of p and s"
  extends Modelica.Icons.Function;
  input AbsolutePressure p "Pressure";
  input SpecificEntropy s "Specific entropy";
  output ThermodynamicState state "Thermodynamic state";
algorithm
  state :=ThermodynamicState(p=p,T=T_ps(p,s));
  annotation(Inline=true,smoothOrder=3);
end setState_ps;
