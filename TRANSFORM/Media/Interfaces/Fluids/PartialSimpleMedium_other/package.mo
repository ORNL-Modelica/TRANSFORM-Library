within TRANSFORM.Media.Interfaces.Fluids;
partial package PartialSimpleMedium_other "Medium model with linear dependency of u, h from temperature."

  extends Modelica.Media.Interfaces.PartialPureSubstance(final ThermoStates=
        Modelica.Media.Interfaces.Choices.IndependentVariables.pT, final
      singleState=true);

  // Coefficents are of form y = c[1]*x + c[2] where x is value specified (e.g., T - cp_T_coef)
  constant Real cp_T_coef[2]={0,cp_const}
    "Specific heat capacity at constant pressure coefficients";
  constant Real cp_h_coef[2]={0,cp_const}
    "Specific heat capacity at constant pressure coefficients as a function of enthalpy";
  constant Real cv_T_coef[2]={0,cv_const}
    "Specific heat capacity at constant volume coefficients";
  constant Real d_T_coef[2]={0,d_const} "Density coefficients";
  constant Real eta_T_coef[2]={0,eta_const}
    "Dynamic viscosity capacity coefficients";
  constant Real lambda_T_coef[2]={0,lambda_const}
    "Thermal conductivity coefficients";
  constant Real a_T_coef[2]={0,a_const} "Velocity of sound coefficients";

  constant SpecificHeatCapacity cp_const
    "Constant specific heat capacity at constant pressure";
  constant SpecificHeatCapacity cv_const
    "Constant specific heat capacity at constant volume";
  constant Density d_const "Constant density";
  constant DynamicViscosity eta_const "Constant dynamic viscosity";
  constant ThermalConductivity lambda_const "Constant thermal conductivity";
  constant VelocityOfSound a_const "Constant velocity of sound";
  constant Temperature T_min "Minimum temperature valid for medium model";
  constant Temperature T_max "Maximum temperature valid for medium model";
  constant Temperature T0=reference_T "Zero enthalpy temperature";
  constant MolarMass MM_const "Molar mass";

  constant FluidConstants[nS] fluidConstants "Fluid constants";

  redeclare record extends ThermodynamicState "Thermodynamic state"
    AbsolutePressure p "Absolute pressure of medium";
    Temperature T "Temperature of medium";
  end ThermodynamicState;

  redeclare replaceable model extends BaseProperties(
    T(stateSelect=if preferredMediumStates then StateSelect.prefer else
          StateSelect.default),
     p(stateSelect=if preferredMediumStates then StateSelect.prefer else
           StateSelect.default)) "Base properties"
  equation
    assert(T >= T_min and T <= T_max, "
Temperature T (= " + String(T) + " K) is not
in the allowed range (" + String(T_min) + " K <= T <= " + String(T_max) + " K)
required from medium model \"" + mediumName + "\".
");

    // h = cp_const*(T-T0);
    h = specificEnthalpy_pTX(
        p,
        T,
        X);
    //u = specificHeatCapacityCv_T(T)*(T - T0);
    // u=cv_const*(T - T0);
    d = density_T(T);
    R = 0;
    MM = MM_const;
    state.T = T;
    state.p = p;

    // h = specificEnthalpy_pT(
    //       p,
    //       T,
    //       Region);
    // d = density_pT(
    //       p,
    //       T,
    //       Region);

    u = h;
    // - p/d;

    annotation (Documentation(info="<html>
<p>
This is the most simple incompressible medium model, where
specific enthalpy h and specific internal energy u are only
a function of temperature T and all other provided medium
quantities are assumed to be constant.
Note that the (small) influence of the pressure term p/d is neglected.
</p>
</html>"));
  end BaseProperties;

  redeclare function setState_pTX
    "Return thermodynamic state from p, T, and X or Xi"
    extends Modelica.Icons.Function;
    input AbsolutePressure p "Pressure";
    input Temperature T "Temperature";
    input MassFraction X[:]=reference_X "Mass fractions";
    output ThermodynamicState state "Thermodynamic state record";
  algorithm
    state := ThermodynamicState(p=p, T=T);
    annotation (Inline=true);
  end setState_pTX;

  redeclare function setState_phX
    "Return thermodynamic state from p, h, and X or Xi"
    extends Modelica.Icons.Function;
    input AbsolutePressure p "Pressure";
    input SpecificEnthalpy h "Specific enthalpy";
    input MassFraction X[:]=reference_X "Mass fractions";
    output ThermodynamicState state "Thermodynamic state record";
  algorithm
    state := ThermodynamicState(p=p, T=T0 + h/specificHeatCapacityCp_h(h));
    // state := ThermodynamicState(p=p, T=T0 + h/cp_const);
    annotation (Inline=true);
  end setState_phX;

  redeclare replaceable function setState_psX
    "Return thermodynamic state from p, s, and X or Xi"
    extends Modelica.Icons.Function;
    input AbsolutePressure p "Pressure";
    input SpecificEntropy s "Specific entropy";
    input MassFraction X[:]=reference_X "Mass fractions";
    output ThermodynamicState state "Thermodynamic state record";
  algorithm
    state := ThermodynamicState(p=p, T=Modelica.Math.exp(s/cp_const +
      Modelica.Math.log(reference_T)))
      "Here the incompressible limit is used, with cp as heat capacity";
    annotation (Inline=true);
  end setState_psX;

  redeclare function setState_dTX
    "Return thermodynamic state from d, T, and X or Xi"
    extends Modelica.Icons.Function;
    input Density d "Density";
    input Temperature T "Temperature";
    input MassFraction X[:]=reference_X "Mass fractions";
    output ThermodynamicState state "Thermodynamic state record";
  algorithm
    assert(false, "Pressure can not be computed from temperature and density for an incompressible fluid!");
    annotation (Inline=true);
  end setState_dTX;

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
    annotation (Inline=true);
  end setSmoothState;

  redeclare function extends dynamicViscosity
    "Return dynamic viscosity"

  algorithm
    eta := dynamicViscosity_T(state.T);
    //     eta := eta_const;
    annotation (Inline=true);
  end dynamicViscosity;

  redeclare function extends thermalConductivity
    "Return thermal conductivity"

  algorithm
    lambda := thermalConductivity_T(state.T);
    //     lambda := lambda_const;
    annotation (Inline=true);
  end thermalConductivity;

  redeclare function extends pressure "Return pressure"

  algorithm
    p := state.p;
    annotation (Inline=true);
  end pressure;

  redeclare function extends temperature "Return temperature"

  algorithm
    T := state.T;
    annotation (Inline=true);
  end temperature;

  redeclare function extends density "Return density"

  algorithm
    d := density_T(state.T);
    //     d := d_const;
    annotation (Inline=true);
  end density;

  redeclare function extends specificEnthalpy
    "Return specific enthalpy"

  algorithm
    h := specificHeatCapacityCp_T(state.T)*(state.T - T0);
    //h := cp_const*(state.T - T0);
    annotation (Inline=true);
  end specificEnthalpy;

  redeclare function extends specificHeatCapacityCp
    "Return specific heat capacity at constant pressure"

  algorithm
    cp := specificHeatCapacityCp_T(state.T);
    //cp = cp_const;
    annotation (Inline=true);
  end specificHeatCapacityCp;

  redeclare function extends specificHeatCapacityCv
    "Return specific heat capacity at constant volume"

  algorithm
    cv := specificHeatCapacityCv_T(state.T);
    //     cv := cv_const;
    annotation (Inline=true);
  end specificHeatCapacityCv;

  redeclare function extends isentropicExponent
    "Return isentropic exponent"

  algorithm
    gamma := specificHeatCapacityCp_T(state.T)/specificHeatCapacityCv_T(state.T);
    //     gamma := cp_const/cv_const;
    annotation (Inline=true);
  end isentropicExponent;

  redeclare function extends velocityOfSound
    "Return velocity of sound"

  algorithm
    a := velocityOfSound_T(state.T);
    //     a := a_const;
    annotation (Inline=true);
  end velocityOfSound;

  redeclare function specificEnthalpy_pTX
    "Return specific enthalpy from p, T, and X or Xi"
    extends Modelica.Icons.Function;
    input AbsolutePressure p "Pressure";
    input Temperature T "Temperature";
    input MassFraction X[nX] "Mass fractions";
    output SpecificEnthalpy h "Specific enthalpy";
  algorithm
    h := specificHeatCapacityCp_T(T)*(T - T0);
    //h := cp_const*(T - T0);
    annotation (Inline=true);
  end specificEnthalpy_pTX;

  redeclare function temperature_phX
    "Return temperature from p, h, and X or Xi"
    extends Modelica.Icons.Function;
    input AbsolutePressure p "Pressure";
    input SpecificEnthalpy h "Specific enthalpy";
    input MassFraction X[nX] "Mass fractions";
    output Temperature T "Temperature";
  algorithm
    T := T0 + h/specificHeatCapacityCp_h(h);
    // T := T0 + h/cp_const;
    annotation (Inline=true);
  end temperature_phX;

  redeclare function density_phX
    "Return density from p, h, and X or Xi"
    extends Modelica.Icons.Function;
    input AbsolutePressure p "Pressure";
    input SpecificEnthalpy h "Specific enthalpy";
    input MassFraction X[nX] "Mass fractions";
    output Density d "Density";
  algorithm
    d := density(setState_phX(
        p,
        h,
        X));
    annotation (Inline=true);
  end density_phX;

  redeclare function extends specificInternalEnergy
    "Return specific internal energy"
    extends Modelica.Icons.Function;
  algorithm
    //  u := cv_const*(state.T - T0) - reference_p/d_const;
    u := specificHeatCapacityCv_T(state.T)*(state.T - T0);
    //u := cv_const*(state.T - T0);
    annotation (Inline=true);
  end specificInternalEnergy;

  redeclare function extends specificEntropy
    "Return specific entropy"
    extends Modelica.Icons.Function;
  algorithm
    s := specificHeatCapacityCv_T(state.T)*Modelica.Math.log(state.T/T0);
    //     s := cv_const*Modelica.Math.log(state.T/T0);
    annotation (Inline=true);
  end specificEntropy;

  redeclare function extends specificGibbsEnergy
    "Return specific Gibbs energy"
    extends Modelica.Icons.Function;
  algorithm
    g := specificEnthalpy(state) - state.T*specificEntropy(state);
    annotation (Inline=true);
  end specificGibbsEnergy;

  redeclare function extends specificHelmholtzEnergy
    "Return specific Helmholtz energy"
    extends Modelica.Icons.Function;
  algorithm
    f := specificInternalEnergy(state) - state.T*specificEntropy(state);
    annotation (Inline=true);
  end specificHelmholtzEnergy;

  redeclare function extends isentropicEnthalpy
    "Return isentropic enthalpy"
  algorithm
    h_is := specificHeatCapacityCp_T(temperature(refState))*(temperature(
      refState) - T0);
    annotation (Inline=true);
  end isentropicEnthalpy;

  redeclare function extends isobaricExpansionCoefficient
    "Returns overall the isobaric expansion coefficient beta"
  algorithm
    beta := 0.0;
    annotation (Inline=true);
  end isobaricExpansionCoefficient;

  redeclare function extends isothermalCompressibility
    "Returns overall the isothermal compressibility factor"
  algorithm
    kappa := 0;
    annotation (Inline=true);
  end isothermalCompressibility;

  redeclare function extends density_derp_T
    "Returns the partial derivative of density with respect to pressure at constant temperature"
  algorithm
    ddpT := 0;
    annotation (Inline=true);
  end density_derp_T;

  redeclare function extends density_derT_p
    "Returns the partial derivative of density with respect to temperature at constant pressure"
  algorithm
    //ddTp := 0;
    ddTp := d_T_coef[1];
    annotation (Inline=true);
  end density_derT_p;

  redeclare function extends density_derX
    "Returns the partial derivative of density with respect to mass fractions at constant pressure and temperature"
  algorithm
    dddX := fill(0, nX);
    annotation (Inline=true);
  end density_derX;

  redeclare function extends molarMass
    "Return the molar mass of the medium"
  algorithm
    MM := MM_const;
    annotation (Inline=true);
  end molarMass;
  // Added linear relationships













end PartialSimpleMedium_other;
