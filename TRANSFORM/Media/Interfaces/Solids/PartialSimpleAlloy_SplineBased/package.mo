within TRANSFORM.Media.Interfaces.Solids;
partial package PartialSimpleAlloy_SplineBased "Material properties based on tables"

  extends TRANSFORM.Media.Interfaces.Solids.PartialSimpleAlloy;

  constant Real[:,2] tableDensity "Table for d(T)";
  constant Real[:,2] tableHeatCapacity "Table for cp(T)";
  constant Real[:,2] tableConductivity "Table for lambda(T)";

  final constant Real[:] x_d=tableDensity[:, 1] "Support points";
  final constant Real[size(x_d, 1)] y_d=tableDensity[:, 2] "Support points";
  // Get the derivative values at the support points
  final constant Real[size(x_d, 1)] d_d=TRANSFORM.Math.splineDerivatives(
      x=x_d,
      y=y_d,
      ensureMonotonicity=false);

  final constant Real[:] x_cp=tableHeatCapacity[:, 1] "Support points";
  final constant Real[size(x_cp, 1)] y_cp=tableHeatCapacity[:, 2]
    "Support points";
  // Get the derivative values at the support points
  final constant Real[size(x_cp, 1)] d_cp=TRANSFORM.Math.splineDerivatives(
      x=x_cp,
      y=y_cp,
      ensureMonotonicity=false);

  final constant Real[:] x_lambda=tableConductivity[:, 1] "Support points";
  final constant Real[size(x_lambda, 1)] y_lambda=tableConductivity[:, 2]
    "Support points";
  // Get the derivative values at the support points
  final constant Real[size(x_lambda, 1)] d_lambda=
      TRANSFORM.Math.splineDerivatives(
      x=x_lambda,
      y=y_lambda,
      ensureMonotonicity=false);

  redeclare function extends density
    "Return density as a function of the thermodynamic state record"
  protected
    Temperature T=if use_constantDensity then T_density else state.T;
  algorithm
    d := TRANSFORM.Math.cspline(
        T,
        x_d,
        y_d,
        d_d);
    annotation (Inline=true, smoothOrder=2);
  end density;

  redeclare function extends specificEnthalpy
    "Return specific enthalpy as a function of the thermodynamic state record"
  protected
    Integer iPlace=TRANSFORM.Math.findPlace(state.T, x_cp);
    SI.SpecificHeatCapacity cp[:]=cat(
          1,
          {specificHeatCapacityCp(setState_T(T_reference))},
          y_cp[1:iPlace],
          {specificHeatCapacityCp(state)});
    SI.Temperature T[:]=cat(
          1,
          {T_reference},
          x_cp[1:iPlace],
          {state.T});
  algorithm
    h := h_reference + TRANSFORM.Math.integral_TrapezoidalRule(T, cp);
    annotation (Inline=true, smoothOrder=2);
  end specificEnthalpy;

  redeclare function extends specificHeatCapacityCp
    "Specific heat capacity at constant volume (or pressure) of medium"
  algorithm
    cp := TRANSFORM.Math.cspline(
        state.T,
        x_cp,
        y_cp,
        d_cp);
    annotation (Inline=true, smoothOrder=2);
  end specificHeatCapacityCp;

  redeclare function extends thermalConductivity
    "Return thermal conductivity as a function of the thermodynamic state record"
  algorithm
    lambda := TRANSFORM.Math.cspline(
        state.T,
        x_lambda,
        y_lambda,
        d_lambda);
    annotation (Inline=true, smoothOrder=2);
  end thermalConductivity;
  annotation (Documentation(info="<html>
<p>
This is the base package for medium models of incompressible fluids based on
tables. The minimal data to provide for a useful medium description is tables
of density and heat capacity as functions of temperature.
</p>

<p>It should be noted that incompressible media only have 1 state per control volume (usually T),
but have both T and p as inputs for fully correct properties. The error of using only T-dependent
properties is small, therefore a Boolean flag enthalpyOfT exists. If it is true, the
enumeration Choices.independentVariables  is set to  Choices.independentVariables.T otherwise
it is set to Choices.independentVariables.pT.</p>

<h4>Using the package TableBased</h4>
<p>
To implement a new medium model, create a package that <b>extends</b> TableBased
and provides one or more of the constant tables:
</p>

<pre>
tableDensity        = [T, d];
tableHeatCapacity   = [T, Cp];
tableConductivity   = [T, lam];
tableViscosity      = [T, eta];
tableVaporPressure  = [T, pVap];
</pre>

<p>
The table data is used to fit constant polynomials of order <b>npol</b>, the
temperature data points do not need to be same for different properties. Properties
like enthalpy, inner energy and entropy are calculated consistently from integrals
and derivatives of d(T) and Cp(T). The minimal
data for a useful medium model is thus density and heat capacity. Transport
properties and vapor pressure are optional, if the data tables are empty the corresponding
function calls can not be used.
</p>
</html>"));
end PartialSimpleAlloy_SplineBased;
