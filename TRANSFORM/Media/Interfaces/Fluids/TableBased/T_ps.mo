within TRANSFORM.Media.Interfaces.Fluids.TableBased;
function T_ps "Compute temperature from pressure and specific enthalpy"
  extends Modelica.Icons.Function;
  input AbsolutePressure p "Pressure (unused)";
  input SpecificEntropy s "Specific entropy";
  output Temperature T "Temperature";

protected
  function f_nonlinear "Solve s_T(T) for T with given s"
    extends Modelica.Math.Nonlinear.Interfaces.partialScalarFunction;
    input SpecificEntropy s "Specific entropy";
  algorithm
    y := s_T(T=u) - s;
  end f_nonlinear;

algorithm
  T := Modelica.Math.Nonlinear.solveOneNonlinearEquation(
    function f_nonlinear(s=s), T_min, T_max);
end T_ps;
