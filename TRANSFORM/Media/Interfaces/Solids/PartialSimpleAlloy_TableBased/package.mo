within TRANSFORM.Media.Interfaces.Solids;
partial package PartialSimpleAlloy_TableBased "Material properties based on tables"

  import Poly =
    TRANSFORM.Media.Interfaces.Solids.PartialSimpleAlloy_TableBased.Polynomials_Temp;

  extends TRANSFORM.Media.Interfaces.Solids.PartialSimpleAlloy;

  constant Integer npol=2 "Degree of polynomial used for fitting";
  constant Integer npolDensity=npol
    "Degree of polynomial used for fitting d(T)";
  constant Integer npolHeatCapacity=npol
    "Degree of polynomial used for fitting cp(T)";
  constant Integer npolConductivity=npol
    "Degree of polynomial used for fitting lambda(T)";

  constant Real[:,2] tableDensity "Table for d(T)";
  constant Real[:,2] tableHeatCapacity "Table for cp(T)";
  constant Real[:,2] tableConductivity "Table for lambda(T)";

  final constant Real poly_d[:]=if size(tableDensity, 1) > 0 then
      Poly.fitting(
      tableDensity[:, 1],
      tableDensity[:, 2],
      npolDensity) else zeros(npolDensity + 1);
  final constant Real poly_cp[:]=if size(tableHeatCapacity, 1) > 0 then
      Poly.fitting(
      tableHeatCapacity[:, 1],
      tableHeatCapacity[:, 2],
      npolHeatCapacity) else zeros(npolHeatCapacity + 1);
  final constant Real poly_lambda[:]=if size(tableConductivity, 1) > 0 then
      Poly.fitting(
      tableConductivity[:, 1],
      tableConductivity[:, 2],
      npolConductivity) else zeros(npolConductivity + 1);

  redeclare function extends density
    "Return density as a function of the thermodynamic state record"
  algorithm
    d := Poly.evaluate(poly_d, state.T);
    annotation (Inline=true, smoothOrder=2);
  end density;

  redeclare function extends specificEnthalpy
    "Return specific enthalpy as a function of the thermodynamic state record"
  algorithm
    h := h_reference + Poly.integralValue(
      poly_cp,
      state.T,
      T_reference);
    annotation (Inline=true, smoothOrder=2);
  end specificEnthalpy;

  redeclare function extends specificHeatCapacityCp
    "Specific heat capacity at constant volume (or pressure) of medium"

  algorithm
    cp := Poly.evaluate(poly_cp, state.T);
    annotation (Inline=true, smoothOrder=2);
  end specificHeatCapacityCp;

  redeclare function extends thermalConductivity
    "Return thermal conductivity as a function of the thermodynamic state record"

  algorithm
    lambda := Poly.evaluate(poly_lambda, state.T);
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
end PartialSimpleAlloy_TableBased;
