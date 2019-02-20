within TRANSFORM.Media.LookupTableMedia.BaseClasses;
package ExternalSinglePhaseMedium "Generic external single phase medium package"
  import TRANSFORM.Media.LookupTableMedia.BaseClasses.Common.InputChoice;

  extends TRANSFORM.Media.Interfaces.Fluids.PartialSinglePhaseMedium(
      ThermoStates=Modelica.Media.Interfaces.Choices.IndependentVariables.pT,
      singleState=false, fluidConstants={externalFluidConstants});
  constant FluidConstants externalFluidConstants=FluidConstants(
      iupacName="unknown",
      casRegistryNumber="unknown",
      chemicalFormula="unknown",
      structureFormula="unknown",
      molarMass=getMolarMass());
  constant SI.Temperature T_min = 0;
  constant SI.Temperature T_max = 1e9;

  constant InputChoice inputChoice=InputChoice.pT
    "Default choice of input variables for property computations";

  replaceable function Method =
      TRANSFORM.Math.Interpolation.Bicubic.bicubic_eval "Interpolation method selection";

  replaceable function Method_dx =
      TRANSFORM.Math.Interpolation.Bicubic.bicubic_eval_deriv_x "Interpolation method selection for derivative wrt x";

  replaceable function Method_dy =
      TRANSFORM.Math.Interpolation.Bicubic.bicubic_eval_deriv_y "Interpolation method selection for derivative wrt y";
  constant String tablePath="modelica://TRANSFORM/Resources/data/lookupTables/"
       + mediumName + (if inputChoice == InputChoice.pT then "/pT/" else "/error/");
  constant String tablePath_p=Modelica.Utilities.Files.loadResource(tablePath + "p.csv") "Pressure";
  constant String tablePath_T=Modelica.Utilities.Files.loadResource(tablePath + "T.csv") "Temperature";
  constant String tablePath_h=Modelica.Utilities.Files.loadResource(tablePath + "h.csv") "Specific enthalpy";
  constant String tablePath_a=Modelica.Utilities.Files.loadResource(tablePath + "a.csv") "Speed of sound";
  constant String tablePath_cp=Modelica.Utilities.Files.loadResource(tablePath + "cp.csv") "Isobaric specific heat capacity";
  constant String tablePath_cv=Modelica.Utilities.Files.loadResource(tablePath + "cv.csv") "Isochoric specific heat capacity";
  constant String tablePath_d=Modelica.Utilities.Files.loadResource(tablePath + "d.csv") "Density";
  constant String tablePath_lambda=Modelica.Utilities.Files.loadResource(tablePath + "k.csv") "Thermal conductivity";
  constant String tablePath_mu=Modelica.Utilities.Files.loadResource(tablePath + "mu.csv") "Dynamic viscosity";
  constant String tablePath_s=Modelica.Utilities.Files.loadResource(tablePath + "s.csv") "Specific entropy";
  constant String tablesPath_pT_h=TRANSFORM.Utilities.Strings.concatenate(
      {tablePath_p,tablePath_T,tablePath_h},
      "|",
      3);
  constant String tablesPath_pT_a=TRANSFORM.Utilities.Strings.concatenate(
      {tablePath_p,tablePath_T,tablePath_a},
      "|",
      3);
  constant String tablesPath_pT_cp=TRANSFORM.Utilities.Strings.concatenate(
      {tablePath_p,tablePath_T,tablePath_cp},
      "|",
      3);
  constant String tablesPath_pT_cv=TRANSFORM.Utilities.Strings.concatenate(
      {tablePath_p,tablePath_T,tablePath_cv},
      "|",
      3);
   constant String tablesPath_pT_d=TRANSFORM.Utilities.Strings.concatenate(
      {tablePath_p,tablePath_T,tablePath_d},
      "|",
      3);
  constant String tablesPath_pT_lambda=TRANSFORM.Utilities.Strings.concatenate(
      {tablePath_p,tablePath_T,tablePath_lambda},
      "|",
      3);
  constant String tablesPath_pT_mu=TRANSFORM.Utilities.Strings.concatenate(
      {tablePath_p,tablePath_T,tablePath_mu},
      "|",
      3);
  constant String tablesPath_pT_s=TRANSFORM.Utilities.Strings.concatenate(
      {tablePath_p,tablePath_T,tablePath_s},
      "|",
      3);

  redeclare record extends ThermodynamicState
    AbsolutePressure p "pressure";
    Temperature T "temperature";
    //     SpecificEnthalpy h "specific enthalpy";
    //     Density d "Density";
  end ThermodynamicState;

  redeclare replaceable model extends BaseProperties(
    p(stateSelect=if preferredMediumStates and (basePropertiesInputChoice ==
          InputChoice.ph or basePropertiesInputChoice == InputChoice.pT or
          basePropertiesInputChoice == InputChoice.ps) then StateSelect.prefer
           else StateSelect.default),
    T(stateSelect=if preferredMediumStates and (basePropertiesInputChoice ==
          InputChoice.pT or basePropertiesInputChoice == InputChoice.dT) then
          StateSelect.prefer else StateSelect.default),
    h(stateSelect=if preferredMediumStates and (basePropertiesInputChoice ==
          InputChoice.hs or basePropertiesInputChoice == InputChoice.ph) then
          StateSelect.prefer else StateSelect.default),
    d(stateSelect=if preferredMediumStates and basePropertiesInputChoice ==
          InputChoice.dT then StateSelect.prefer else StateSelect.default))
    import TRANSFORM.Media.LookupTableMedia.BaseClasses.Common.InputChoice;
    parameter InputChoice basePropertiesInputChoice=inputChoice
      "Choice of input variables for property computations";
    SpecificEntropy s(stateSelect=if (basePropertiesInputChoice == InputChoice.hs
           or basePropertiesInputChoice == InputChoice.ps) then StateSelect.prefer
           else StateSelect.default) "Specific entropy";
  equation
    MM = externalFluidConstants.molarMass;
    R = Modelica.Constants.R/MM;
    // if (basePropertiesInputChoice == InputChoice.ph) then
    //   // Compute the state record (including the unique ID)
    //   state = setState_ph(p, h, phaseInput);
    //   // Compute the remaining variables.
    //   // It is not possible to use the standard functions like
    //   // d = density(state), because differentiation for index
    //   // reduction and change of state variables would not be supported
    //   // density_ph(), which has an appropriate derivative annotation,
    //   // is used instead. The implementation of density_ph() uses
    //   // setState with the same inputs, so there's no actual overhead
    //   d = density_ph(p, h, phaseInput);
    //   s = specificEntropy_ph(p, h, phaseInput);
    //   T = temperature_ph(p, h, phaseInput);
    // elseif (basePropertiesInputChoice == InputChoice.dT) then
    //   state = setState_dT(d, T, phaseInput);
    //   h = specificEnthalpy(state);
    //   p = pressure(state);
    //   s = specificEntropy(state);
    // elseif (basePropertiesInputChoice == InputChoice.pT) then
    //   state = setState_pT(p, T, phaseInput);
    //   d = density(state);
    //   h = specificEnthalpy(state);
    //   s = specificEntropy(state);
    // elseif (basePropertiesInputChoice == InputChoice.ps) then
    //   state = setState_ps(p, s, phaseInput);
    //   d = density(state);
    //   h = specificEnthalpy(state);
    //   T = temperature(state);
    // elseif (basePropertiesInputChoice == InputChoice.hs) then
    //   state = setState_hs(h, s, phaseInput);
    //   d = density(state);
    //   p = pressure(state);
    //   T = temperature(state);
    // end if;
    if (basePropertiesInputChoice == InputChoice.pT) then
      state = setState_pT(p, T);
      d = density(state);
      h = specificEnthalpy_pT(p,T);//specificEnthalpy(state);
      s = specificEntropy_pT(p,T);//specificEntropy(state);
    end if;
    // Compute the internal energy
    u = h - p/d;
  end BaseProperties;

  replaceable function getMolarMass
    output MolarMass MM "molar mass";
  algorithm
    MM :=0.01;
  end getMolarMass;

  redeclare replaceable function setState_ph
    "Return thermodynamic state record from p and h"
    extends Modelica.Icons.Function;
    input AbsolutePressure p "pressure";
    input SpecificEnthalpy h "specific enthalpy";
    output ThermodynamicState state;
  algorithm
    state :=ThermodynamicState(p=p,T=T_ph(p,h));//,h=h);
    annotation(Inline=true,smoothOrder=3);
  end setState_ph;

  function T_ph "Compute temperature from pressure and specific enthalpy"
    extends Modelica.Icons.Function;
    input AbsolutePressure p "Pressure";
    input SpecificEnthalpy h "Specific enthalpy";
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
        y := specificEnthalpy_pT(p,x);
      end f_nonlinear;

    end Internal;
  algorithm
   T := Internal.solve(h, T_min, T_max, p, {1}, Internal.f_nonlinear_Data());
    annotation(Inline=false, LateInline=true, inverse(h=specificEnthalpy_pT(p,T)));
  end T_ph;

  redeclare replaceable function setState_pT
    "Return thermodynamic state record from p and T"
    extends Modelica.Icons.Function;
    input AbsolutePressure p "pressure";
    input Temperature T "temperature";
    output ThermodynamicState state;
  algorithm
    state := ThermodynamicState(
      p=p,
      T=T);
    //       h=Method(
    //          tablesPath_pT_h,
    //          p,
    //          T));
  end setState_pT;

  redeclare replaceable function setState_dT
    "Return thermodynamic state record from d and T"
    extends Modelica.Icons.Function;
    input Density d "density";
    input Temperature T "temperature";
    output ThermodynamicState state;
  algorithm
    assert(false,"This function is not yet supported");
  end setState_dT;

  redeclare replaceable function setState_ps
    "Return thermodynamic state record from p and s"
    extends Modelica.Icons.Function;
    input AbsolutePressure p "pressure";
    input SpecificEntropy s "specific entropy";
    output ThermodynamicState state;
  algorithm
    state :=ThermodynamicState(p=p,T=T_ps(p,s));
    annotation(Inline=true,smoothOrder=3);
  end setState_ps;

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

  replaceable function setState_hs
    "Return thermodynamic state record from h and s"
    extends Modelica.Icons.Function;
    input SpecificEnthalpy h "specific enthalpy";
    input SpecificEntropy s "specific entropy";
    output ThermodynamicState state;
  algorithm
    assert(false,"This function is not yet supported");
  end setState_hs;

  redeclare function extends setState_phX
  algorithm
    // The composition is an empty vector
    state := setState_ph(p, h);
  end setState_phX;

  redeclare function extends setState_pTX
  algorithm
    // The composition is an empty vector
    state := setState_pT(p, T);
  end setState_pTX;

  redeclare function extends setState_dTX
  algorithm
    // The composition is an empty vector
    state := setState_dT(d, T);
  end setState_dTX;

  redeclare function extends setState_psX
  algorithm
    // The composition is an empty vector
    state := setState_ps(p, s);
  end setState_psX;

  replaceable function setState_hsX
    extends Modelica.Icons.Function;
    input SpecificEnthalpy h "specific enthalpy";
    input SpecificEntropy s "specific entropy";
    output ThermodynamicState state;
  algorithm
    state := setState_hs(h, s);
  end setState_hsX;

  redeclare replaceable function density_ph
    "Return density from p and h"
    extends Modelica.Icons.Function;
    input AbsolutePressure p "Pressure";
    input SpecificEnthalpy h "Specific enthalpy";
    output Density d "Density";
  algorithm
    assert(false,"This function is not yet supported");
    annotation (Inline=true);
  end density_ph;

  replaceable function density_ph_der
    "Total derivative of density_ph"
    extends Modelica.Icons.Function;
    input AbsolutePressure p "Pressure";
    input SpecificEnthalpy h "Specific enthalpy";
    input ThermodynamicState state;
    input Real p_der "time derivative of pressure";
    input Real h_der "time derivative of specific enthalpy";
    output Real d_der "time derivative of density";
  algorithm
    d_der := p_der*density_derp_h(state=state) + h_der*density_derh_p(state=
      state);
    annotation (Inline=true);
  end density_ph_der;

  redeclare replaceable function temperature_ph
    "Return temperature from p and h"
    extends Modelica.Icons.Function;
    input AbsolutePressure p "Pressure";
    input SpecificEnthalpy h "Specific enthalpy";
    output Temperature T "Temperature";
  algorithm
    assert(false,"This function is not yet supported");
    annotation (Inline=true, inverse(h=specificEnthalpy_pT(p=p, T=T)));
  end temperature_ph;

  replaceable function specificEntropy_ph
    "Return specific entropy from p and h"
    extends Modelica.Icons.Function;
    input AbsolutePressure p "Pressure";
    input SpecificEnthalpy h "Specific enthalpy";
    output SpecificEntropy s "specific entropy";
  algorithm
    assert(false,"This function is not yet supported");
    annotation (Inline=true, inverse(h=specificEnthalpy_ps(p=p, s=s)));
  end specificEntropy_ph;

  replaceable function specificEntropy_ph_der
    "time derivative of specificEntropy_ph"
    extends Modelica.Icons.Function;
    input AbsolutePressure p;
    input SpecificEnthalpy h;
    input ThermodynamicState state;
    input Real p_der "time derivative of pressure";
    input Real h_der "time derivative of specific enthalpy";
    output Real s_der "time derivative of specific entropy";
  algorithm
    s_der := p_der*(-1.0/(density(setState_ph(p=p,h=h))*state.T)) + h_der*(1.0/state.T);
    annotation (Inline=true);
  end specificEntropy_ph_der;

  redeclare replaceable function density_pT
    "Return density from p and T"
    extends Modelica.Icons.Function;
    input AbsolutePressure p "Pressure";
    input Temperature T "Temperature";
    output Density d "Density";
  algorithm
    d := Method(
        tablesPath_pT_d,
        p,
        T);
    annotation (Inline=true, inverse(p=pressure_dT(d=d, T=T)));
  end density_pT;

  replaceable function density_pT_der
    "Total derivative of density_pT"
    extends Modelica.Icons.Function;
    input AbsolutePressure p "Pressure";
    input Temperature T "Temperature";
    input Real p_der;
    input Real T_der;
    output Real d_der;
  algorithm
    d_der := density_derp_T(setState_pT(p, T))*p_der + density_derT_p(
      setState_pT(p, T))*T_der;
    annotation (Inline=true);
  end density_pT_der;

  redeclare replaceable function specificEnthalpy_pT
    "Return specific enthalpy from p and T"
    extends Modelica.Icons.Function;
    input AbsolutePressure p "Pressure";
    input Temperature T "Temperature";
    output SpecificEnthalpy h "specific enthalpy";
  algorithm
    h := Method(
        tablesPath_pT_h,
        p,
        T);
    annotation (Inline=true, inverse(T=temperature_ph(p=p, h=h)));
  end specificEnthalpy_pT;

  replaceable function specificEntropy_pT
    "returns specific entropy for a given p and T"
    extends Modelica.Icons.Function;
    input AbsolutePressure p "Pressure";
    input Temperature T "Temperature";
    output SpecificEntropy s "Specific Entropy";
  algorithm
    s := Method(
        tablesPath_pT_s,
        p,
        T);
    annotation (Inline=true, inverse(T=temperature_ps(p=p, s=s)));
  end specificEntropy_pT;

  redeclare replaceable function pressure_dT
    "Return pressure from d and T"
    extends Modelica.Icons.Function;
    input Density d "Density";
    input Temperature T "Temperature";
    output AbsolutePressure p "Pressure";
  algorithm
    assert(false,"This function is not yet supported");
    annotation (Inline=true, inverse(d=density_pT(p=p, T=T)));
  end pressure_dT;

  redeclare replaceable function specificEnthalpy_dT
    "Return specific enthalpy from d and T"
    extends Modelica.Icons.Function;
    input Density d "Density";
    input Temperature T "Temperature";
    output SpecificEnthalpy h "specific enthalpy";
  algorithm
    assert(false,"This function is not yet supported");
    annotation (Inline=true);
  end specificEnthalpy_dT;

  replaceable function specificEntropy_dT
    "returns specific entropy for a given d and T"
    extends Modelica.Icons.Function;
    input Density d "Density";
    input Temperature T "Temperature";
    output SpecificEntropy s "Specific Entropy";
  algorithm
    assert(false,"This function is not yet supported");
    annotation (Inline=true);
  end specificEntropy_dT;

  redeclare replaceable function density_ps
    "Return density from p and s"
    extends Modelica.Icons.Function;
    input AbsolutePressure p "Pressure";
    input SpecificEntropy s "Specific entropy";
    output Density d "Density";
  algorithm
    assert(false,"This function is not yet supported");
    annotation (Inline=true);
  end density_ps;

  replaceable partial function density_ps_der
    "Total derivative of density_ps"
    extends Modelica.Icons.Function;
    input AbsolutePressure p "Pressure";
    input SpecificEntropy s "Specific entropy";
    input ThermodynamicState state;
    input Real p_der;
    input Real h_der;
    output Real d_der;
  algorithm
    assert(false,"This function is not yet supported");
    // To be implemented
    annotation (Inline=true);
  end density_ps_der;

  redeclare replaceable function temperature_ps
    "Return temperature from p and s"
    extends Modelica.Icons.Function;
    input AbsolutePressure p "Pressure";
    input SpecificEntropy s "Specific entropy";
    output Temperature T "Temperature";
  algorithm
    assert(false,"This function is not yet supported");
    annotation (Inline=true, inverse(s=specificEntropy_pT(p=p, T=T)));
  end temperature_ps;

  redeclare replaceable function specificEnthalpy_ps
    "Return specific enthalpy from p and s"
    extends Modelica.Icons.Function;
    input AbsolutePressure p "Pressure";
    input SpecificEntropy s "Specific entropy";
    output SpecificEnthalpy h "specific enthalpy";
  algorithm
    assert(false,"This function is not yet supported");
    annotation (Inline=true, inverse(s=specificEntropy_ph(p=p, h=h)));
  end specificEnthalpy_ps;

  replaceable function density_hs "Return density for given h and s"
    extends Modelica.Icons.Function;
    input SpecificEnthalpy h "Enthalpy";
    input SpecificEntropy s "Specific entropy";
    output Density d "density";
  algorithm
    assert(false,"This function is not yet supported");
    annotation (Inline=true);
  end density_hs;

  replaceable function pressure_hs "Return pressure from h and s"
    extends Modelica.Icons.Function;
    input SpecificEnthalpy h "Specific enthalpy";
    input SpecificEntropy s "Specific entropy";
    output AbsolutePressure p "Pressure";
  algorithm
    assert(false,"This function is not yet supported");
    annotation (Inline=true, inverse(h=specificEnthalpy_ps(p=p, s=s), s=
            specificEntropy_ph(p=p, h=h)));
  end pressure_hs;

  replaceable function temperature_hs
    "Return temperature from h and s"
    extends Modelica.Icons.Function;
    input SpecificEnthalpy h "Specific enthalpy";
    input SpecificEntropy s "Specific entropy";
    output Temperature T "Temperature";
  algorithm
    assert(false,"This function is not yet supported");
    annotation (Inline=true);
  end temperature_hs;

  redeclare function extends prandtlNumber "Returns Prandtl number"
    annotation (Inline=true);
  end prandtlNumber;

  redeclare replaceable function extends temperature
    "Return temperature from state"
  algorithm
    T := state.T;
    annotation (Inline=true);
  end temperature;

  redeclare replaceable function extends velocityOfSound
    "Return velocity of sound from state"
  algorithm
    a := Method(
        tablesPath_pT_a,
        state.p,
        state.T);
    annotation (Inline=true);
  end velocityOfSound;

  redeclare replaceable function extends isobaricExpansionCoefficient
    "Return isobaric expansion coefficient from state"
  algorithm
    assert(false,"This function is not yet supported");
    annotation (Inline=true);
  end isobaricExpansionCoefficient;

  redeclare replaceable function extends isentropicExponent
    "Return isentropic exponent"
    extends Modelica.Icons.Function;
  algorithm
    gamma := density(state)/pressure(state)*velocityOfSound(state)*
      velocityOfSound(state);
  end isentropicExponent;

  redeclare replaceable function extends specificHeatCapacityCp
    "Return specific heat capacity cp from state"
  algorithm
    cp := Method(
        tablesPath_pT_cp,
        state.p,
        state.T);
    annotation (Inline=true);
  end specificHeatCapacityCp;

  redeclare replaceable function extends specificHeatCapacityCv
    "Return specific heat capacity cv from state"
  algorithm
    cv := Method(
        tablesPath_pT_cv,
        state.p,
        state.T);
    annotation (Inline=true);
  end specificHeatCapacityCv;

  redeclare replaceable function extends density
    "Return density from state"
  algorithm
    d := Method(
        tablesPath_pT_d,
        state.p,
        state.T);
    annotation (Inline=true);
  end density;

  redeclare replaceable function extends density_derh_p
    "Return derivative of density wrt enthalpy at constant pressure from state"
  algorithm
    assert(false,"This function is not yet supported");
    annotation (Inline=true);
  end density_derh_p;

  redeclare replaceable function extends density_derp_h
    "Return derivative of density wrt pressure at constant enthalpy from state"
  algorithm
    assert(false,"This function is not yet supported");
    annotation (Inline=true);
  end density_derp_h;

  redeclare replaceable function extends density_derp_T
    "Return derivative of density wrt pressure at constant temperature from state"
  algorithm
    // ddpT := state.kappa*state.d;
    ddpT := Method_dx(
        tablesPath_pT_d,
        state.p,
        state.T);
  end density_derp_T;

  redeclare replaceable function extends density_derT_p
    "Return derivative of density wrt temperature at constant pressure from state"
  algorithm
    // ddTp := -state.beta*state.d;
    ddTp := Method_dx(
        tablesPath_pT_d,
        state.p,
        state.T);
  end density_derT_p;

  redeclare replaceable function extends dynamicViscosity
    "Return dynamic viscosity from state"
  algorithm
    eta := Method(
        tablesPath_pT_mu,
        state.p,
        state.T);
    annotation (Inline=true);
  end dynamicViscosity;

  redeclare replaceable function extends specificEnthalpy
    "Return specific enthalpy from state"
  algorithm
    h := Method(
        tablesPath_pT_h,
        state.p,
        state.T);//state.h;
    annotation (Inline=true);
  end specificEnthalpy;

  redeclare replaceable function extends specificInternalEnergy
    "Returns specific internal energy"
    extends Modelica.Icons.Function;
  algorithm
    u := specificEnthalpy(state) - pressure(state)/density(state);
  end specificInternalEnergy;

  redeclare replaceable function extends isothermalCompressibility
    "Return isothermal compressibility from state"
  algorithm
    assert(false,"This function is not yet supported");
    annotation (Inline=true);
  end isothermalCompressibility;

  redeclare replaceable function extends thermalConductivity
    "Return thermal conductivity from state"
  algorithm
    lambda := Method(
        tablesPath_pT_lambda,
        state.p,
        state.T);
    annotation (Inline=true);
  end thermalConductivity;

  redeclare replaceable function extends pressure
    "Return pressure from state"
  algorithm
    p := state.p;
    annotation (Inline=true);
  end pressure;

  redeclare replaceable function extends specificEntropy
    "Return specific entropy from state"
  algorithm
    s := Method(
        tablesPath_pT_s,
        state.p,
        state.T);
    annotation (Inline=true);
  end specificEntropy;
end ExternalSinglePhaseMedium;
