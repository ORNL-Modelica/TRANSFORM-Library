within TRANSFORM.Media.Interfaces.Fluids.TableBased;
function setState_ph "Returns state record as function of p and h"
  extends Modelica.Icons.Function;
  input AbsolutePressure p "Pressure";
  input SpecificEnthalpy h "Specific enthalpy";
  output ThermodynamicState state "Thermodynamic state";
algorithm
  state :=ThermodynamicState(p=p,T=T_ph(p,h));
  annotation(Inline=true,smoothOrder=3);
end setState_ph;
