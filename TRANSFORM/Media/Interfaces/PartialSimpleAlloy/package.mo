within TRANSFORM.Media.Interfaces;
partial package PartialSimpleAlloy "Material properties based on tables"

  extends TRANSFORM.Media.Interfaces.PartialAlloy(   Temperature(min=T_min, max=
         T_max));

  // Constants to be set in actual Medium
  constant Modelica.SIunits.Temperature T_min
    "Minimum temperature valid for medium model";
  constant Modelica.SIunits.Temperature T_max
    "Maximum temperature valid for medium model";

  constant MolarMass MM_const=0.1 "Molar mass";

  redeclare record extends ThermodynamicState "Thermodynamic state"
    Temperature T "Temperature";
  end ThermodynamicState;

  redeclare model extends BaseProperties(T(stateSelect=if preferredMediumStates
           then StateSelect.prefer else StateSelect.default))
    "Base properties of T dependent medium"

  equation
    assert(T >= T_min and T <= T_max, "Temperature T (= " + String(T) + " K) is not in the allowed range ("
       + String(T_min) + " K <= T <= " + String(T_max) + " K) required from medium model \""
       + mediumName + "\".");

    state.T = T;

    d = density(state);
    h = specificEnthalpy(state);
    u = h;
    MM = MM_const;

  end BaseProperties;

  redeclare function extends setState_T
    "Returns state record, given temperature"
  algorithm
    state := ThermodynamicState(T=T);
    annotation (smoothOrder=3);
  end setState_T;

  redeclare function extends setSmoothState
    "Return thermodynamic state so that it smoothly approximates: if x > 0 then state_a else state_b"
  algorithm
    state := ThermodynamicState(T=Modelica.Media.Common.smoothStep(
        x,
        state_a.T,
        state_b.T,
        x_small));
    annotation (Inline=true, smoothOrder=3);
  end setSmoothState;

  redeclare function extends temperature
    "Return temperature as a function of the thermodynamic state record"
  algorithm
    T := state.T;
    annotation (Inline=true, smoothOrder=2);
  end temperature;

  redeclare function extends specificInternalEnergy
    "Return specific internal energy as a function of the thermodynamic state record"
  algorithm
    u:=specificEnthalpy(state);
    annotation (Inline=true, smoothOrder=2);
  end specificInternalEnergy;

  redeclare function extends molarMass
    "Molar mass"
  algorithm
    MM := MM_const;
    annotation (Inline=true, smoothOrder=2);
  end molarMass;

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
end PartialSimpleAlloy;
