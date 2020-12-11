within TRANSFORM.Media.LookupTableMedia.BaseClasses.ExternalSinglePhaseMedium;
function T_ph "Compute temperature from pressure and specific enthalpy"
  extends Modelica.Icons.Function;
  input AbsolutePressure p "Pressure";
  input SpecificEnthalpy h "Specific enthalpy";
  output Temperature T "Temperature";

protected
 function f_nonlinear
   extends Modelica.Math.Nonlinear.Interfaces.partialScalarFunction;
   input AbsolutePressure p "Pressure";
   input Temperature T "Temperature";
 algorithm
   y := specificEnthalpy_pT(p,T);
 end f_nonlinear;

algorithm

T := Modelica.Math.Nonlinear.solveOneNonlinearEquation(
          function f_nonlinear(p=p,T=T), T_min, T_max);

  annotation(Inline=false, LateInline=true, inverse(h=specificEnthalpy_pT(p,T)));
end T_ph;
