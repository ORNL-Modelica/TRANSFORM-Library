within TRANSFORM.Media.LookupTableMedia.BaseClasses.ExternalSinglePhaseMedium;
function T_ps "Compute temperature from pressure and specific entropy"
  extends Modelica.Icons.Function;

  input AbsolutePressure p "Pressure";
  input SpecificEntropy s "Specific entropy";
  output Temperature T "Temperature";

protected
 function f_nonlinear
   extends Modelica.Math.Nonlinear.Interfaces.partialScalarFunction;
   input AbsolutePressure p "Pressure";
   input Temperature T "Temperature";
 algorithm
   y := specificEntropy_pT(p,T);
 end f_nonlinear;

algorithm

T := Modelica.Math.Nonlinear.solveOneNonlinearEquation(
          function f_nonlinear(p=p,T=T), T_min, T_max);
end T_ps;
