within TRANSFORM.Media.Interfaces.Fluids;
package TableBased "Incompressible medium properties based on tables"
  import Modelica.Math.Polynomials;

  extends TRANSFORM.Media.Interfaces.Fluids.PartialMedium(
     ThermoStates = if enthalpyOfT then Modelica.Media.Interfaces.Choices.IndependentVariables.T
                                                                       else Modelica.Media.Interfaces.Choices.IndependentVariables.pT,
     final reducedX=true,
     final fixedX = true,
     mediumName="tableMedium",
     redeclare record ThermodynamicState =
        Modelica.Media.Incompressible.Common.BaseProps_Tpoly,
     singleState=true,
     reference_p = 1.013e5,
     Temperature(min = T_min, max = T_max));
  // Constants to be set in actual Medium
  constant Boolean enthalpyOfT=true
    "True if enthalpy is approximated as a function of T only, (p-dependence neglected)";
  constant Boolean densityOfT = size(tableDensity,1) > 1
    "True if density is a function of temperature";
  constant SI.Temperature T_min
    "Minimum temperature valid for medium model";
  constant SI.Temperature T_max
    "Maximum temperature valid for medium model";
  constant Temperature T0=273.15 "Reference Temperature";
  constant SpecificEnthalpy h0=0 "Reference enthalpy at T0, reference_p";
  constant SpecificEntropy s0=0 "Reference entropy at T0, reference_p";
  constant MolarMass MM_const=0.1 "Molar mass";
  constant Integer npol=2 "Degree of polynomial used for fitting";
  constant Integer npolDensity=npol
    "Degree of polynomial used for fitting rho(T)";
  constant Integer npolHeatCapacity=npol
    "Degree of polynomial used for fitting Cp(T)";
  constant Integer npolViscosity=npol
    "Degree of polynomial used for fitting eta(T)";
  constant Integer npolVaporPressure=npol
    "Degree of polynomial used for fitting pVap(T)";
  constant Integer npolConductivity=npol
    "Degree of polynomial used for fitting lambda(T)";
  constant Integer neta=size(tableViscosity,1)
    "Number of data points for viscosity";
  constant Real[:,2] tableDensity "Table for rho(T)";
  constant Real[:,2] tableHeatCapacity "Table for Cp(T)";
  constant Real[:,2] tableViscosity "Table for eta(T)";
  constant Real[:,2] tableVaporPressure "Table for pVap(T)";
  constant Real[:,2] tableConductivity "Table for lambda(T)";
  //    constant Real[:] TK=tableViscosity[:,1]+T0*ones(neta) "Temperature for Viscosity";
  constant Boolean TinK "True if T[K],Kelvin used for table temperatures";
  constant Boolean hasDensity = not (size(tableDensity,1)==0)
    "True if table tableDensity is present";
  constant Boolean hasHeatCapacity = not (size(tableHeatCapacity,1)==0)
    "True if table tableHeatCapacity is present";
  constant Boolean hasViscosity = not (size(tableViscosity,1)==0)
    "True if table tableViscosity is present";
  constant Boolean hasVaporPressure = not (size(tableVaporPressure,1)==0)
    "True if table tableVaporPressure is present";
  final constant Real invTK[neta] = if size(tableViscosity,1) > 0 then
      (if TinK then 1 ./ tableViscosity[:,1] else 1 ./ Modelica.Units.Conversions.from_degC(
                                                                    tableViscosity[:,1])) else fill(0,neta);
  final constant Real poly_rho[:] = if hasDensity then
                                       Polynomials.fitting(tableDensity[:,1],tableDensity[:,2],npolDensity) else
                                         zeros(npolDensity+1);
  final constant Real poly_Cp[:] = if hasHeatCapacity then
                                       Polynomials.fitting(tableHeatCapacity[:,1],tableHeatCapacity[:,2],npolHeatCapacity) else
                                         zeros(npolHeatCapacity+1);
  final constant Real poly_eta[:] = if hasViscosity then
                                       Polynomials.fitting(invTK, Modelica.Math.log(
                                                                           tableViscosity[:,2]),npolViscosity) else
                                         zeros(npolViscosity+1);
  final constant Real poly_pVap[:] = if hasVaporPressure then
                                       Polynomials.fitting(tableVaporPressure[:,1],tableVaporPressure[:,2],npolVaporPressure) else
                                          zeros(npolVaporPressure+1);
  final constant Real poly_lam[:] = if size(tableConductivity,1)>0 then
                                       Polynomials.fitting(tableConductivity[:,1],tableConductivity[:,2],npolConductivity) else
                                         zeros(npolConductivity+1);

  redeclare model extends BaseProperties(
    final standardOrderComponents=true,
    p_bar=Modelica.Units.Conversions.to_bar(
                    p),
    T_degC(start = T_start-273.15)=Modelica.Units.Conversions.to_degC(
                                              T),
    T(start = T_start,
      stateSelect=if preferredMediumStates then StateSelect.prefer else StateSelect.default))
    "Base properties of T dependent medium"

    SI.SpecificHeatCapacity cp "Specific heat capacity";
    parameter SI.Temperature T_start = 298.15 "Initial temperature";
  equation
    assert(hasDensity,"Medium " + mediumName +
                      " can not be used without assigning tableDensity.");
    assert(T >= T_min and T <= T_max, "Temperature T (= " + String(T) +
           " K) is not in the allowed range (" + String(T_min) +
           " K <= T <= " + String(T_max) + " K) required from medium model \""
           + mediumName + "\".");
    R_s = Modelica.Constants.R/MM_const;
    cp = Polynomials.evaluate(poly_Cp,if TinK then T else T_degC);
    h = specificEnthalpyOfT(p,T,densityOfT);
    u = h - (if singleState then reference_p/d else state.p/d);
    d = Polynomials.evaluate(poly_rho,if TinK then T else T_degC);
    state.T = T;
    state.p = p;
    MM = MM_const;
    annotation(Documentation(info="<html>
<p>
Note that the inner energy neglects the pressure dependence, which is only
true for an incompressible medium with d = constant. The neglected term is
(p-reference_p)/rho*(T/rho)*(&part;rho /&part;T). This is very small for
liquids due to proportionality to 1/d^2, but can be problematic for gases that are
modeled incompressible.
</p>
<p>It should be noted that incompressible media only have 1 state per control volume (usually T),
but have both T and p as inputs for fully correct properties. The error of using only T-dependent
properties is small, therefore a Boolean flag enthalpyOfT exists. If it is true, the
enumeration Choices.IndependentVariables is set to Choices.IndependentVariables.T otherwise
it is set to Choices.IndependentVariables.pT.</p>
<p>
Enthalpy is never a function of T only (h = h(T) + (p-reference_p)/d), but the
error is also small and non-linear systems can be avoided. In particular,
non-linear systems are small and local as opposed to large and over all volumes.
</p>

<p>
Entropy is calculated as
</p>
<blockquote><pre>
s = s0 + integral(Cp(T)/T,dt)
</pre></blockquote>
<p>
which is only exactly true for a fluid with constant density d=d0.
</p>
</html>"));
  end BaseProperties;

  redeclare function extends setState_pTX
    "Returns state record, given pressure and temperature"
  algorithm
    state := ThermodynamicState(p=p,T=T);
    annotation(smoothOrder=3);
  end setState_pTX;

  redeclare function extends setState_dTX
    "Returns state record, given pressure and temperature"
  algorithm
    assert(false, "For incompressible media with d(T) only, state can not be set from density and temperature");
  end setState_dTX;

  redeclare function extends setState_phX
    "Returns state record, given pressure and specific enthalpy"
  algorithm
    state :=ThermodynamicState(p=p,T=T_ph(p,h));
    annotation(Inline=true,smoothOrder=3);
  end setState_phX;

  redeclare function extends setState_psX
    "Returns state record, given pressure and specific entropy"
  algorithm
    state :=ThermodynamicState(p=p,T=T_ps(p,s));
    annotation(Inline=true,smoothOrder=3);
  end setState_psX;

  redeclare function extends setSmoothState
    "Return thermodynamic state so that it smoothly approximates: if x > 0 then state_a else state_b"
  algorithm
    state := ThermodynamicState(p=Modelica.Media.Common.smoothStep(
        x,
        state_a.p,
        state_b.p,
        x_small), T=Modelica.Media.Common.smoothStep(
        x,
        state_a.T,
        state_b.T,
        x_small));
    annotation(Inline=true,smoothOrder=3);
  end setSmoothState;

  redeclare function extends specificHeatCapacityCv
    "Specific heat capacity at constant volume (or pressure) of medium"

  algorithm
    assert(hasHeatCapacity,"Specific Heat Capacity, Cv, is not defined for medium "
                                           + mediumName + ".");
    cv := Polynomials.evaluate(poly_Cp,if TinK then state.T else state.T - 273.15);
   annotation(smoothOrder=2);
  end specificHeatCapacityCv;

  redeclare function extends specificHeatCapacityCp
    "Specific heat capacity at constant volume (or pressure) of medium"

  algorithm
    assert(hasHeatCapacity,"Specific Heat Capacity, Cv, is not defined for medium "
                                           + mediumName + ".");
    cp := Polynomials.evaluate(poly_Cp,if TinK then state.T else state.T - 273.15);
   annotation(smoothOrder=2);
  end specificHeatCapacityCp;

  redeclare function extends dynamicViscosity
    "Return dynamic viscosity as a function of the thermodynamic state record"

  algorithm
    assert(size(tableViscosity,1)>0,"DynamicViscosity, eta, is not defined for medium "
                                           + mediumName + ".");
    eta := Modelica.Math.exp(Polynomials.evaluate(poly_eta, 1/state.T));
   annotation(smoothOrder=2);
  end dynamicViscosity;

  redeclare function extends thermalConductivity
    "Return thermal conductivity as a function of the thermodynamic state record"

  algorithm
    assert(size(tableConductivity,1)>0,"ThermalConductivity, lambda, is not defined for medium "
                                           + mediumName + ".");
    lambda := Polynomials.evaluate(poly_lam, if TinK then state.T else
      Modelica.Units.Conversions.to_degC(state.T));
   annotation(smoothOrder=2);
  end thermalConductivity;

  redeclare function extends specificEntropy
    "Return specific entropy as a function of the thermodynamic state record"

  protected
    Integer npol=size(poly_Cp,1)-1;
  algorithm
    assert(hasHeatCapacity,"Specific Entropy, s(T), is not defined for medium "
                                           + mediumName + ".");
    s := s_T(state.T);
   annotation(smoothOrder=2);
  end specificEntropy;

  redeclare function extends temperature
    "Return temperature as a function of the thermodynamic state record"
  algorithm
   T := state.T;
   annotation(Inline=true,smoothOrder=2);
  end temperature;

  redeclare function extends pressure
    "Return pressure as a function of the thermodynamic state record"
  algorithm
   p := state.p;
   annotation(Inline=true,smoothOrder=2);
  end pressure;

  redeclare function extends density
    "Return density as a function of the thermodynamic state record"
  algorithm
    d := Polynomials.evaluate(poly_rho, if TinK then state.T else
      Modelica.Units.Conversions.to_degC(state.T));
   annotation(Inline=true,smoothOrder=2);
  end density;

  redeclare function extends specificEnthalpy
    "Return specific enthalpy as a function of the thermodynamic state record"
  algorithm
    h := specificEnthalpyOfT(state.p, state.T);
   annotation(Inline=true,smoothOrder=2);
  end specificEnthalpy;

  redeclare function extends specificInternalEnergy
    "Return specific internal energy as a function of the thermodynamic state record"
  algorithm
    u := specificEnthalpyOfT(state.p,state.T) - (if singleState then reference_p else state.p)/density(state);
   annotation(Inline=true,smoothOrder=2);
  end specificInternalEnergy;
protected

  function specificEnthalpyOfT
    "Return specific enthalpy from pressure and temperature, taking the flag enthalpyOfT into account"
    extends Modelica.Icons.Function;
    input AbsolutePressure p "Pressure";
    input Temperature T "Temperature";
    input Boolean densityOfT = false "Include or neglect density derivative dependence of enthalpy";
    output SpecificEnthalpy h "Specific enthalpy";
  algorithm
    h := if enthalpyOfT then h_T(T) else h_pT(p, T, densityOfT);
    annotation(Inline=true,smoothOrder=2);
  end specificEnthalpyOfT;
annotation(Documentation(info="<html>
<p>
This is the base package for medium models of incompressible fluids based on
tables. The minimal data to provide for a useful medium description is tables
of density and heat capacity as functions of temperature.
</p>

<p>It should be noted that incompressible media only have 1 state per control volume (usually T),
but have both T and p as inputs for fully correct properties. The error of using only T-dependent
properties is small, therefore a Boolean flag enthalpyOfT exists. If it is true, the
enumeration Choices.IndependentVariables is set to Choices.IndependentVariables.T otherwise
it is set to Choices.IndependentVariables.pT.</p>

<h4>Using the package TableBased</h4>
<p>
To implement a new medium model, create a package that <strong>extends</strong> TableBased
and provides one or more of the constant tables:
</p>

<blockquote><pre>
tableDensity        = [T, d];
tableHeatCapacity   = [T, Cp];
tableConductivity   = [T, lam];
tableViscosity      = [T, eta];
tableVaporPressure  = [T, pVap];
</pre></blockquote>

<p>
The table data is used to fit constant polynomials of order <strong>npol</strong>, the
temperature data points do not need to be same for different properties. Properties
like enthalpy, inner energy and entropy are calculated consistently from integrals
and derivatives of d(T) and Cp(T). The minimal
data for a useful medium model is thus density and heat capacity. Transport
properties and vapor pressure are optional, if the data tables are empty the corresponding
function calls can not be used.
</p>
</html>"));
end TableBased;
