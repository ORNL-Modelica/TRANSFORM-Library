within TRANSFORM.Media.LookupTableMedia.BaseClasses.ExternalSinglePhaseMedium;
function T_ps "Compute temperature from pressure and specific enthalpy"
  extends Modelica.Icons.Function;

  input AbsolutePressure p "Pressure";
  input SpecificEntropy s "Specific entropy";
  output Temperature T "Temperature";
protected
  package Internal
    "Solve h(T) for T with given h (use only indirectly via temperature_phX)"
    extends Modelica.Media.Common.OneNonLinearEquation;

    redeclare record extends f_nonlinear_Data
      "Superfluous record, fix later when better structure of inverse functions exists"
        constant Real[5] dummy = {1,2,3,4,5};
    end f_nonlinear_Data;

    redeclare function extends f_nonlinear "P is smuggled in via vector"
    algorithm
      y := specificEntropy_pT(p,x);
    end f_nonlinear;

  end Internal;
algorithm
 T := Internal.solve(s, T_min, T_max, p, {1}, Internal.f_nonlinear_Data());
end T_ps;
