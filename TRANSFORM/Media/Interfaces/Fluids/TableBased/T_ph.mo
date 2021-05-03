within TRANSFORM.Media.Interfaces.Fluids.TableBased;
function T_ph "Compute temperature from pressure and specific enthalpy"
  extends Modelica.Icons.Function;
  input AbsolutePressure p "Pressure";
  input SpecificEnthalpy h "Specific enthalpy";
  output Temperature T "Temperature";

protected
  function f_nonlinear "Solve specificEnthalpyOfT(p,T) for T with given h"
    extends Modelica.Math.Nonlinear.Interfaces.partialScalarFunction;
    input AbsolutePressure p "Pressure";
    input SpecificEnthalpy h "Specific enthalpy";
  algorithm
    y := specificEnthalpyOfT(p=p, T=u) - h;
  end f_nonlinear;

algorithm
  T := Modelica.Math.Nonlinear.solveOneNonlinearEquation(
    function f_nonlinear(p=p, h=h), T_min, T_max);
  annotation(Inline=false, LateInline=true, inverse(h=specificEnthalpyOfT(p,T)));
end T_ph;
