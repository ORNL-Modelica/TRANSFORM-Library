within TRANSFORM.Media.Interfaces.Fluids;
package ExternalSinglePhaseMedium "Generic external single phase medium package"
  extends Modelica.Media.Interfaces.PartialTwoPhaseMedium(
    singleState = false,
    onePhase = false,
    smoothModel = false,
    fluidConstants = {externalFluidConstants});
  import ExternalMedia.Common.InputChoice;
  // mediumName is declared here instead of in the extends clause
  // to break a circular dependency in redeclaration that OpenModelica
  // cannot yet handle
  constant String mediumName="unusablePartialMedium" "Name of the medium";
  constant String libraryName = "UnusableExternalMedium"
    "Name of the external fluid property computation library";
  constant String substanceName = substanceNames[1]
    "Only one substance can be specified";
  constant FluidConstants externalFluidConstants = FluidConstants(
    iupacName = "unknown",
    casRegistryNumber = "unknown",
    chemicalFormula = "unknown",
    structureFormula = "unknown",
    molarMass = getMolarMass(),
    criticalTemperature = getCriticalTemperature(),
    criticalPressure = getCriticalPressure(),
    criticalMolarVolume = getCriticalMolarVolume(),
    acentricFactor = 0,
    triplePointTemperature = 280.0,
    triplePointPressure = 500.0,
    meltingPoint = 280,
    normalBoilingPoint = 380.0,
    dipoleMoment = 2.0);

  constant InputChoice inputChoice=InputChoice.ph
    "Default choice of input variables for property computations";

  redeclare replaceable record ThermodynamicState
    // Fields in ASCII lexicographical order to work in Dymola
    Temperature T "temperature";
    VelocityOfSound a "velocity of sound";
    Modelica.SIunits.CubicExpansionCoefficient beta
      "isobaric expansion coefficient";
    SpecificHeatCapacity cp "specific heat capacity cp";
    SpecificHeatCapacity cv "specific heat capacity cv";
    Density d "density";
    DerDensityByEnthalpy ddhp
      "derivative of density wrt enthalpy at constant pressure";
    DerDensityByPressure ddph
      "derivative of density wrt pressure at constant enthalpy";
    DynamicViscosity eta "dynamic viscosity";
    SpecificEnthalpy h "specific enthalpy";
    Modelica.SIunits.Compressibility kappa "compressibility";
    ThermalConductivity lambda "thermal conductivity";
    AbsolutePressure p "pressure";
    FixedPhase phase(min=0, max=2)
      "phase flag: 2 for two-phase, 1 for one-phase";
    SpecificEntropy s "specific entropy";
  end ThermodynamicState;

  redeclare record SaturationProperties
    // Fields in ASCII lexicographical order to work in Dymola
    Temperature Tsat "saturation temperature";
    Real dTp "derivative of Ts wrt pressure";
    DerDensityByPressure ddldp "derivative of dls wrt pressure";
    DerDensityByPressure ddvdp "derivative of dvs wrt pressure";
    DerEnthalpyByPressure dhldp "derivative of hls wrt pressure";
    DerEnthalpyByPressure dhvdp "derivative of hvs wrt pressure";
    Density dl "density at bubble line (for pressure ps)";
    Density dv "density at dew line (for pressure ps)";
    SpecificEnthalpy hl "specific enthalpy at bubble line (for pressure ps)";
    SpecificEnthalpy hv "specific enthalpy at dew line (for pressure ps)";
    AbsolutePressure psat "saturation pressure";
    SurfaceTension sigma "surface tension";
    SpecificEntropy sl "specific entropy at bubble line (for pressure ps)";
    SpecificEntropy sv "specific entropy at dew line (for pressure ps)";
  end SaturationProperties;

  redeclare replaceable model extends BaseProperties(
    p(stateSelect = if preferredMediumStates and
                       (basePropertiesInputChoice == InputChoice.ph or
                        basePropertiesInputChoice == InputChoice.pT or
                        basePropertiesInputChoice == InputChoice.ps) then
                            StateSelect.prefer else StateSelect.default),
    T(stateSelect = if preferredMediumStates and
                       (basePropertiesInputChoice == InputChoice.pT or
                        basePropertiesInputChoice == InputChoice.dT) then
                         StateSelect.prefer else StateSelect.default),
    h(stateSelect = if preferredMediumStates and
                       (basePropertiesInputChoice == InputChoice.hs or
                        basePropertiesInputChoice == InputChoice.ph) then
                         StateSelect.prefer else StateSelect.default),
    d(stateSelect = if preferredMediumStates and
                       basePropertiesInputChoice == InputChoice.dT then
                         StateSelect.prefer else StateSelect.default))
    import ExternalMedia.Common.InputChoice;
    parameter InputChoice basePropertiesInputChoice=inputChoice
      "Choice of input variables for property computations";
    FixedPhase phaseInput
      "Phase input for property computation functions, 2 for two-phase, 1 for one-phase, 0 if not known";
    Integer phaseOutput
      "Phase output for medium, 2 for two-phase, 1 for one-phase";
    SpecificEntropy s(
      stateSelect = if (basePropertiesInputChoice == InputChoice.hs or
                        basePropertiesInputChoice == InputChoice.ps) then
                       StateSelect.prefer else StateSelect.default)
      "Specific entropy";
    SaturationProperties sat "saturation property record";
  equation
    MM = externalFluidConstants.molarMass;
    R = Modelica.Constants.R/MM;
    if (onePhase or (basePropertiesInputChoice == InputChoice.pT)) then
      phaseInput = 1 "Force one-phase property computation";
    else
      phaseInput = 0 "Unknown phase";
    end if;
    if (basePropertiesInputChoice == InputChoice.ph) then
      // Compute the state record (including the unique ID)
      state = setState_ph(p, h, phaseInput);
      // Compute the remaining variables.
      // It is not possible to use the standard functions like
      // d = density(state), because differentiation for index
      // reduction and change of state variables would not be supported
      // density_ph(), which has an appropriate derivative annotation,
      // is used instead. The implementation of density_ph() uses
      // setState with the same inputs, so there's no actual overhead
      d = density_ph(p, h, phaseInput);
      s = specificEntropy_ph(p, h, phaseInput);
      T = temperature_ph(p, h, phaseInput);
    elseif (basePropertiesInputChoice == InputChoice.dT) then
      state = setState_dT(d, T, phaseInput);
      h = specificEnthalpy(state);
      p = pressure(state);
      s = specificEntropy(state);
    elseif (basePropertiesInputChoice == InputChoice.pT) then
      state = setState_pT(p, T, phaseInput);
      d = density(state);
      h = specificEnthalpy(state);
      s = specificEntropy(state);
    elseif (basePropertiesInputChoice == InputChoice.ps) then
      state = setState_ps(p, s, phaseInput);
      d = density(state);
      h = specificEnthalpy(state);
      T = temperature(state);
    elseif (basePropertiesInputChoice == InputChoice.hs) then
      state = setState_hs(h, s, phaseInput);
      d = density(state);
      p = pressure(state);
      T = temperature(state);
    end if;
    // Compute the internal energy
    u = h - p/d;
    // Compute the saturation properties record only if below critical point
    //sat = setSat_p(min(p,fluidConstants[1].criticalPressure));
    sat = setSat_p_state(state);
    // Event generation for phase boundary crossing
    if smoothModel then
      // No event generation
      phaseOutput = state.phase;
    else
      // Event generation at phase boundary crossing
      if basePropertiesInputChoice == InputChoice.ph then
        phaseOutput = if ((h > bubbleEnthalpy(sat) and h < dewEnthalpy(sat)) and
                           p < fluidConstants[1].criticalPressure) then 2 else 1;
      elseif basePropertiesInputChoice == InputChoice.dT then
        phaseOutput = if  ((d < bubbleDensity(sat) and d > dewDensity(sat)) and
                            T < fluidConstants[1].criticalTemperature) then 2 else 1;
      elseif basePropertiesInputChoice == InputChoice.ps then
        phaseOutput = if ((s > bubbleEntropy(sat) and s < dewEntropy(sat)) and
                           p < fluidConstants[1].criticalPressure) then 2 else 1;
      elseif basePropertiesInputChoice == InputChoice.hs then
        phaseOutput = if ((s > bubbleEntropy(sat)  and s < dewEntropy(sat)) and
                          (h > bubbleEnthalpy(sat) and h < dewEnthalpy(sat))) then 2 else 1;
      elseif basePropertiesInputChoice == InputChoice.pT then
        phaseOutput = 1;
      else
        assert(false, "You are using an unsupported pair of inputs.");
      end if;
    end if;
  end BaseProperties;

  redeclare function molarMass "Return the molar mass of the medium"
      input ThermodynamicState state;
      output MolarMass MM "Mixture molar mass";
  algorithm
    MM := fluidConstants[1].molarMass;
  end molarMass;

  replaceable function getMolarMass
    output MolarMass MM "molar mass";
    external "C" MM = TwoPhaseMedium_getMolarMass_C_impl(mediumName, libraryName, substanceName)
      annotation(Include="#include \"externalmedialib.h\"", Library="ExternalMediaLib", IncludeDirectory=
        "modelica://TRANSFORM/Resources/Include",                                                                                                      LibraryDirectory=
        "modelica://TRANSFORM/Resources/Library");
  end getMolarMass;

  replaceable function getCriticalTemperature
    output Temperature Tc "Critical temperature";
    external "C" Tc = TwoPhaseMedium_getCriticalTemperature_C_impl(mediumName, libraryName, substanceName)
      annotation(Include="#include \"externalmedialib.h\"", Library="ExternalMediaLib", IncludeDirectory=
        "modelica://TRANSFORM/Resources/Include",                                                                                                      LibraryDirectory=
        "modelica://TRANSFORM/Resources/Library");
  end getCriticalTemperature;

  replaceable function getCriticalPressure
    output AbsolutePressure pc "Critical temperature";
    external "C" pc = TwoPhaseMedium_getCriticalPressure_C_impl(mediumName, libraryName, substanceName)
      annotation(Include="#include \"externalmedialib.h\"", Library="ExternalMediaLib", IncludeDirectory=
        "modelica://TRANSFORM/Resources/Include",                                                                                                      LibraryDirectory=
        "modelica://TRANSFORM/Resources/Library");
  end getCriticalPressure;

  replaceable function getCriticalMolarVolume
    output MolarVolume vc "Critical molar volume";
    external "C" vc = TwoPhaseMedium_getCriticalMolarVolume_C_impl(mediumName, libraryName, substanceName)
      annotation(Include="#include \"externalmedialib.h\"", Library="ExternalMediaLib", IncludeDirectory=
        "modelica://TRANSFORM/Resources/Include",                                                                                                      LibraryDirectory=
        "modelica://TRANSFORM/Resources/Library");
  end getCriticalMolarVolume;

  redeclare replaceable function setState_ph
    "Return thermodynamic state record from p and h"
    extends Modelica.Icons.Function;
    input AbsolutePressure p "pressure";
    input SpecificEnthalpy h "specific enthalpy";
    input FixedPhase phase = 0
      "2 for two-phase, 1 for one-phase, 0 if not known";
    output ThermodynamicState state;
  external "C" TwoPhaseMedium_setState_ph_C_impl(p, h, phase, state, mediumName, libraryName, substanceName)
    annotation(Include="#include \"externalmedialib.h\"", Library="ExternalMediaLib", IncludeDirectory=
        "modelica://TRANSFORM/Resources/Include",                                                                                                    LibraryDirectory=
        "modelica://TRANSFORM/Resources/Library");
  end setState_ph;

  redeclare replaceable function setState_pT
    "Return thermodynamic state record from p and T"
    extends Modelica.Icons.Function;
    input AbsolutePressure p "pressure";
    input Temperature T "temperature";
    input FixedPhase phase = 0
      "2 for two-phase, 1 for one-phase, 0 if not known";
    output ThermodynamicState state;
  external "C" TwoPhaseMedium_setState_pT_C_impl(p, T, state, mediumName, libraryName, substanceName)
    annotation(Include="#include \"externalmedialib.h\"", Library="ExternalMediaLib", IncludeDirectory=
        "modelica://TRANSFORM/Resources/Include",                                                                                                    LibraryDirectory=
        "modelica://TRANSFORM/Resources/Library");
  end setState_pT;

  redeclare replaceable function setState_dT
    "Return thermodynamic state record from d and T"
    extends Modelica.Icons.Function;
    input Density d "density";
    input Temperature T "temperature";
    input FixedPhase phase = 0
      "2 for two-phase, 1 for one-phase, 0 if not known";
    output ThermodynamicState state;
  external "C" TwoPhaseMedium_setState_dT_C_impl(d, T, phase, state, mediumName, libraryName, substanceName)
    annotation(Include="#include \"externalmedialib.h\"", Library="ExternalMediaLib", IncludeDirectory=
        "modelica://TRANSFORM/Resources/Include",                                                                                                    LibraryDirectory=
        "modelica://TRANSFORM/Resources/Library");
  end setState_dT;

  redeclare replaceable function setState_ps
    "Return thermodynamic state record from p and s"
    extends Modelica.Icons.Function;
    input AbsolutePressure p "pressure";
    input SpecificEntropy s "specific entropy";
    input FixedPhase phase = 0
      "2 for two-phase, 1 for one-phase, 0 if not known";
    output ThermodynamicState state;
  external "C" TwoPhaseMedium_setState_ps_C_impl(p, s, phase, state, mediumName, libraryName, substanceName)
    annotation(Include="#include \"externalmedialib.h\"", Library="ExternalMediaLib", IncludeDirectory=
        "modelica://TRANSFORM/Resources/Include",                                                                                                    LibraryDirectory=
        "modelica://TRANSFORM/Resources/Library");
  end setState_ps;

  replaceable function setState_hs
    "Return thermodynamic state record from h and s"
    extends Modelica.Icons.Function;
    input SpecificEnthalpy h "specific enthalpy";
    input SpecificEntropy s "specific entropy";
    input FixedPhase phase = 0
      "2 for two-phase, 1 for one-phase, 0 if not known";
    output ThermodynamicState state;
  external "C" TwoPhaseMedium_setState_hs_C_impl(h, s, phase, state, mediumName, libraryName, substanceName)
    annotation(Include="#include \"externalmedialib.h\"", Library="ExternalMediaLib", IncludeDirectory=
        "modelica://TRANSFORM/Resources/Include",                                                                                                    LibraryDirectory=
        "modelica://TRANSFORM/Resources/Library");
  end setState_hs;

  replaceable function partialDeriv_state
    "Return partial derivative from a thermodynamic state record"
    extends Modelica.Icons.Function;
    input String of "The property to differentiate";
    input String wrt "Differentiate with respect to this";
    input String cst "Keep this constant";
    input ThermodynamicState  state;
    output Real partialDerivative;
    external "C" partialDerivative = TwoPhaseMedium_partialDeriv_state_C_impl(of, wrt, cst, state, mediumName, libraryName, substanceName)
    annotation(Include="#include \"externalmedialib.h\"", Library="ExternalMediaLib", IncludeDirectory=
        "modelica://TRANSFORM/Resources/Include",                                                                                                    LibraryDirectory=
        "modelica://TRANSFORM/Resources/Library");
  end partialDeriv_state;

  redeclare function extends setState_phX
  algorithm
    // The composition is an empty vector
    state :=setState_ph(p, h, phase);
  end setState_phX;

  redeclare function extends setState_pTX
  algorithm
    // The composition is an empty vector
    state :=setState_pT(p, T, phase);
  end setState_pTX;

  redeclare function extends setState_dTX
  algorithm
    // The composition is an empty vector
    state :=setState_dT(d, T, phase);
  end setState_dTX;

  redeclare function extends setState_psX
  algorithm
    // The composition is an empty vector
    state :=setState_ps(p, s, phase);
  end setState_psX;

  replaceable function setState_hsX
                                    extends Modelica.Icons.Function;
    input SpecificEnthalpy h "specific enthalpy";
    input SpecificEntropy s "specific entropy";
    input FixedPhase phase = 0
      "2 for two-phase, 1 for one-phase, 0 if not known";
    output ThermodynamicState state;
  algorithm
    // The composition is an empty vector
    state :=setState_hs(h, s, phase);
  end setState_hsX;

  redeclare replaceable function density_ph "Return density from p and h"
    extends Modelica.Icons.Function;
    input AbsolutePressure p "Pressure";
    input SpecificEnthalpy h "Specific enthalpy";
    input FixedPhase phase = 0
      "2 for two-phase, 1 for one-phase, 0 if not known";
    output Density d "Density";
  algorithm
    d := density_ph_state(p=p, h=h, state=setState_ph(p=p, h=h, phase=phase));
  annotation (Inline = true);
  end density_ph;


  replaceable function density_ph_der "Total derivative of density_ph"
    extends Modelica.Icons.Function;
    input AbsolutePressure p "Pressure";
    input SpecificEnthalpy h "Specific enthalpy";
    input ThermodynamicState state;
    input Real p_der "time derivative of pressure";
    input Real h_der "time derivative of specific enthalpy";
    output Real d_der "time derivative of density";
  algorithm
    d_der := p_der*density_derp_h(state=state)
           + h_der*density_derh_p(state=state);
  annotation (Inline=true);
  end density_ph_der;

  redeclare replaceable function temperature_ph
    "Return temperature from p and h"
    extends Modelica.Icons.Function;
    input AbsolutePressure p "Pressure";
    input SpecificEnthalpy h "Specific enthalpy";
    input FixedPhase phase = 0
      "2 for two-phase, 1 for one-phase, 0 if not known";
    output Temperature T "Temperature";
  algorithm
    T := temperature_ph_state(p=p, h=h, state=setState_ph(p=p, h=h, phase=phase));
  annotation (
    Inline=true,
    inverse(h=specificEnthalpy_pT(p=p, T=T, phase=phase)));
  end temperature_ph;


  replaceable function specificEntropy_ph
    "Return specific entropy from p and h"
    extends Modelica.Icons.Function;
    input AbsolutePressure p "Pressure";
    input SpecificEnthalpy h "Specific enthalpy";
    input FixedPhase phase = 0
      "2 for two-phase, 1 for one-phase, 0 if not known";
    output SpecificEntropy s "specific entropy";
  algorithm
    s := specificEntropy_ph_state(p=p, h=h, state=setState_ph(p=p, h=h, phase=phase));
    annotation (
    Inline=true,
    inverse(h=specificEnthalpy_ps(p=p, s=s, phase=phase)));
  end specificEntropy_ph;



  redeclare replaceable function density_pT "Return density from p and T"
    extends Modelica.Icons.Function;
    input AbsolutePressure p "Pressure";
    input Temperature T "Temperature";
    input FixedPhase phase = 0
      "2 for two-phase, 1 for one-phase, 0 if not known";
    output Density d "Density";
  algorithm
    d := density_pT_state(p=p, T=T, state=setState_pT(p=p, T=T, phase=phase));
  annotation (
    Inline=true,
    inverse(p=pressure_dT(d=d, T=T, phase=phase)));
  end density_pT;


  replaceable function density_pT_der "Total derivative of density_pT"
    extends Modelica.Icons.Function;
    input AbsolutePressure p "Pressure";
    input Temperature T "Temperature";
    input FixedPhase phase "2 for two-phase, 1 for one-phase, 0 if not known";
    input Real p_der;
    input Real T_der;
    output Real d_der;
  algorithm
    d_der:=density_derp_T(setState_pT(p, T))*p_der +
           density_derT_p(setState_pT(p, T))*T_der;
    /*  // If special definition in "C"
    external "C" d_der=  TwoPhaseMedium_density_pT_der_C_impl(state, mediumName, libraryName, substanceName)
    annotation(Include="#include \"externalmedialib.h\"", Library="ExternalMediaLib", IncludeDirectory="modelica://ExternalMedia/Resources/Include", LibraryDirectory="modelica://ExternalMedia/Resources/Library");
    */
    annotation(Inline = true);
  end density_pT_der;

  redeclare replaceable function specificEnthalpy_pT
    "Return specific enthalpy from p and T"
    extends Modelica.Icons.Function;
    input AbsolutePressure p "Pressure";
    input Temperature T "Temperature";
    input FixedPhase phase = 0
      "2 for two-phase, 1 for one-phase, 0 if not known";
    output SpecificEnthalpy h "specific enthalpy";
  algorithm
    h := specificEnthalpy_pT_state(p=p, T=T, state=setState_pT(p=p, T=T, phase=phase));
  annotation (
    Inline=true,
    inverse(T=temperature_ph(p=p, h=h, phase=phase)));
  end specificEnthalpy_pT;




  redeclare replaceable function pressure_dT "Return pressure from d and T"
    extends Modelica.Icons.Function;
    input Density d "Density";
    input Temperature T "Temperature";
    input FixedPhase phase = 0
      "2 for two-phase, 1 for one-phase, 0 if not known";
    output AbsolutePressure p "Pressure";
  algorithm
    p := pressure_dT_state(d=d, T=T, state=setState_dT(d=d, T=T, phase=phase));
    annotation (
    Inline=true,
    inverse(d=density_pT(p=p, T=T, phase=phase)));
  end pressure_dT;


  redeclare replaceable function specificEnthalpy_dT
    "Return specific enthalpy from d and T"
    extends Modelica.Icons.Function;
    input Density d "Density";
    input Temperature T "Temperature";
    input FixedPhase phase = 0
      "2 for two-phase, 1 for one-phase, 0 if not known";
    output SpecificEnthalpy h "specific enthalpy";
  algorithm
    h := specificEnthalpy_dT_state(d=d, T=T, state=setState_dT(d=d, T=T, phase=phase));
  annotation (
    Inline=true);
  end specificEnthalpy_dT;




  redeclare replaceable function density_ps "Return density from p and s"
    extends Modelica.Icons.Function;
    input AbsolutePressure p "Pressure";
    input SpecificEntropy s "Specific entropy";
    input FixedPhase phase = 0
      "2 for two-phase, 1 for one-phase, 0 if not known";
    output Density d "Density";
  algorithm
    d := density_ps_state(p=p, s=s, state=setState_ps(p=p, s=s, phase=phase));
  annotation (
    Inline=true);
  end density_ps;


  replaceable partial function density_ps_der "Total derivative of density_ps"
    extends Modelica.Icons.Function;
    input AbsolutePressure p "Pressure";
    input SpecificEntropy s "Specific entropy";
    input ThermodynamicState state;
    input Real p_der;
    input Real h_der;
    output Real d_der;
    // To be implemented
    annotation(Inline = true);
  end density_ps_der;

  redeclare replaceable function temperature_ps
    "Return temperature from p and s"
    extends Modelica.Icons.Function;
    input AbsolutePressure p "Pressure";
    input SpecificEntropy s "Specific entropy";
    input FixedPhase phase = 0
      "2 for two-phase, 1 for one-phase, 0 if not known";
    output Temperature T "Temperature";
  algorithm
    T := temperature_ps_state(p=p, s=s, state=setState_ps(p=p, s=s, phase=phase));
  annotation (
    Inline=true,
    inverse(s=specificEntropy_pT(p=p, T=T, phase=phase)));
  end temperature_ps;


  redeclare replaceable function specificEnthalpy_ps
    "Return specific enthalpy from p and s"
    extends Modelica.Icons.Function;
    input AbsolutePressure p "Pressure";
    input SpecificEntropy s "Specific entropy";
    input FixedPhase phase = 0
      "2 for two-phase, 1 for one-phase, 0 if not known";
    output SpecificEnthalpy h "specific enthalpy";
  algorithm
    h := specificEnthalpy_ps_state(p=p, s=s, state=setState_ps(p=p, s=s, phase=phase));
    annotation (
    Inline = true,
    inverse(s=specificEntropy_ph(p=p, h=h, phase=phase)));
  end specificEnthalpy_ps;




  replaceable function pressure_hs "Return pressure from h and s"
    extends Modelica.Icons.Function;
    input SpecificEnthalpy h "Specific enthalpy";
    input SpecificEntropy s "Specific entropy";
    input FixedPhase phase = 0
      "2 for two-phase, 1 for one-phase, 0 if not known";
    output AbsolutePressure p "Pressure";
  algorithm
    p := pressure_hs_state(h=h, s=s, state=setState_hs(h=h, s=s, phase=phase));
    annotation (
      Inline = true,
      inverse(
        h=specificEnthalpy_ps(p=p, s=s, phase=phase),
        s=specificEntropy_ph(p=p, h=h, phase=phase)));
  end pressure_hs;


  replaceable function temperature_hs "Return temperature from h and s"
    extends Modelica.Icons.Function;
    input SpecificEnthalpy h "Specific enthalpy";
    input SpecificEntropy s "Specific entropy";
    input FixedPhase phase = 0
      "2 for two-phase, 1 for one-phase, 0 if not known";
    output Temperature T "Temperature";
  algorithm
    T := temperature_hs_state(h=h, s=s, state=setState_hs(h=h, s=s, phase=phase));
    annotation (
      Inline = true);
  end temperature_hs;


  redeclare function extends prandtlNumber "Returns Prandtl number"
    /*  // If special definition in "C"
  external "C" T=  TwoPhaseMedium_prandtlNumber_C_impl(state, mediumName, libraryName, substanceName)
    annotation(Include="#include \"externalmedialib.h\"", Library="ExternalMediaLib", IncludeDirectory="modelica://ExternalMedia/Resources/Include", LibraryDirectory="modelica://ExternalMedia/Resources/Library");
*/
    annotation(Inline = true);
  end prandtlNumber;

  redeclare replaceable function extends temperature
    "Return temperature from state"
    // Standard definition
  algorithm
    T := state.T;
    /*  // If special definition in "C"
  external "C" T=  TwoPhaseMedium_temperature_C_impl(state, mediumName, libraryName, substanceName)
    annotation(Include="#include \"externalmedialib.h\"", Library="ExternalMediaLib", IncludeDirectory="modelica://ExternalMedia/Resources/Include", LibraryDirectory="modelica://ExternalMedia/Resources/Library");
*/
    annotation(Inline = true);
  end temperature;

  redeclare replaceable function extends velocityOfSound
    "Return velocity of sound from state"
    // Standard definition
  algorithm
    a := state.a;
    /*  // If special definition in "C"
  external "C" a=  TwoPhaseMedium_velocityOfSound_C_impl(state, mediumName, libraryName, substanceName)
    annotation(Include="#include \"externalmedialib.h\"", Library="ExternalMediaLib", IncludeDirectory="modelica://ExternalMedia/Resources/Include", LibraryDirectory="modelica://ExternalMedia/Resources/Library");
*/
    annotation(Inline = true);
  end velocityOfSound;

  redeclare replaceable function extends isobaricExpansionCoefficient
    "Return isobaric expansion coefficient from state"
    // Standard definition
  algorithm
    beta := state.beta;
    /*  // If special definition in "C"
  external "C" beta=  TwoPhaseMedium_isobaricExpansionCoefficient_C_impl(state, mediumName, libraryName, substanceName)
    annotation(Include="#include \"externalmedialib.h\"", Library="ExternalMediaLib", IncludeDirectory="modelica://ExternalMedia/Resources/Include", LibraryDirectory="modelica://ExternalMedia/Resources/Library");
*/
    annotation(Inline = true);
  end isobaricExpansionCoefficient;

  redeclare replaceable function extends isentropicExponent
    "Return isentropic exponent"
    extends Modelica.Icons.Function;
  algorithm
    gamma := density(state) / pressure(state) * velocityOfSound(state) * velocityOfSound(state);
  end isentropicExponent;

  redeclare replaceable function extends specificHeatCapacityCp
    "Return specific heat capacity cp from state"
    // Standard definition
  algorithm
    cp := state.cp;
    /*  // If special definition in "C"
  external "C" cp=  TwoPhaseMedium_specificHeatCapacityCp_C_impl(state, mediumName, libraryName, substanceName)
    annotation(Include="#include \"externalmedialib.h\"", Library="ExternalMediaLib", IncludeDirectory="modelica://ExternalMedia/Resources/Include", LibraryDirectory="modelica://ExternalMedia/Resources/Library");
*/
    annotation(Inline = true);
  end specificHeatCapacityCp;

  redeclare replaceable function extends specificHeatCapacityCv
    "Return specific heat capacity cv from state"
    // Standard definition
  algorithm
    cv := state.cv;
    /*  // If special definition in "C"
  external "C" cv=  TwoPhaseMedium_specificHeatCapacityCv_C_impl(state, mediumName, libraryName, substanceName)
    annotation(Include="#include \"externalmedialib.h\"", Library="ExternalMediaLib", IncludeDirectory="modelica://ExternalMedia/Resources/Include", LibraryDirectory="modelica://ExternalMedia/Resources/Library");
*/
    annotation(Inline = true);
  end specificHeatCapacityCv;

  redeclare replaceable function extends density "Return density from state"
    // Standard definition
  algorithm
    d := state.d;
    /*  // If special definition in "C"
  external "C" d=  TwoPhaseMedium_density_C_impl(state, mediumName, libraryName, substanceName)
    annotation(Include="#include \"externalmedialib.h\"", Library="ExternalMediaLib", IncludeDirectory="modelica://ExternalMedia/Resources/Include", LibraryDirectory="modelica://ExternalMedia/Resources/Library");
*/
    annotation(Inline = true);
  end density;

  redeclare replaceable function extends density_derh_p
    "Return derivative of density wrt enthalpy at constant pressure from state"
    // Standard definition
  algorithm
    ddhp := state.ddhp;
    /*  // If special definition in "C"
  external "C" ddhp=  TwoPhaseMedium_density_derh_p_C_impl(state, mediumName, libraryName, substanceName)
    annotation(Include="#include \"externalmedialib.h\"", Library="ExternalMediaLib", IncludeDirectory="modelica://ExternalMedia/Resources/Include", LibraryDirectory="modelica://ExternalMedia/Resources/Library");
*/
    annotation(Inline = true);
  end density_derh_p;

  redeclare replaceable function extends density_derp_h
    "Return derivative of density wrt pressure at constant enthalpy from state"
    // Standard definition
  algorithm
    ddph := state.ddph;
    /*  // If special definition in "C"
  external "C" ddph=  TwoPhaseMedium_density_derp_h_C_impl(state, mediumName, libraryName, substanceName)
    annotation(Include="#include \"externalmedialib.h\"", Library="ExternalMediaLib", IncludeDirectory="modelica://ExternalMedia/Resources/Include", LibraryDirectory="modelica://ExternalMedia/Resources/Library");
*/
    annotation(Inline = true);
  end density_derp_h;

  redeclare replaceable function extends density_derp_T
  algorithm
    ddpT := state.kappa*state.d;
  end density_derp_T;

  redeclare replaceable function extends density_derT_p
  algorithm
    ddTp :=-state.beta*state.d;
  end density_derT_p;

  redeclare replaceable function extends dynamicViscosity
    "Return dynamic viscosity from state"
    // Standard definition
  algorithm
    eta := state.eta;
    /*  // If special definition in "C"
  external "C" eta=  TwoPhaseMedium_dynamicViscosity_C_impl(state, mediumName, libraryName, substanceName)
    annotation(Include="#include \"externalmedialib.h\"", Library="ExternalMediaLib", IncludeDirectory="modelica://ExternalMedia/Resources/Include", LibraryDirectory="modelica://ExternalMedia/Resources/Library");
*/
    annotation(Inline = true);
  end dynamicViscosity;

  redeclare replaceable function extends specificEnthalpy
    "Return specific enthalpy from state"
    // Standard definition
  algorithm
    h := state.h;
    /*  // If special definition in "C"
  external "C" h=  TwoPhaseMedium_specificEnthalpy_C_impl(state, mediumName, libraryName, substanceName)
    annotation(Include="#include \"externalmedialib.h\"", Library="ExternalMediaLib", IncludeDirectory="modelica://ExternalMedia/Resources/Include", LibraryDirectory="modelica://ExternalMedia/Resources/Library");
*/
    annotation(Inline = true);
  end specificEnthalpy;

  redeclare replaceable function extends specificInternalEnergy
    "Returns specific internal energy"
    extends Modelica.Icons.Function;
  algorithm
    u := specificEnthalpy(state) - pressure(state)/density(state);
  end specificInternalEnergy;

  redeclare replaceable function extends isothermalCompressibility
    "Return isothermal compressibility from state"
    // Standard definition
  algorithm
    kappa := state.kappa;
    /*  // If special definition in "C"
  external "C" kappa=  TwoPhaseMedium_isothermalCompressibility_C_impl(state, mediumName, libraryName, substanceName)
    annotation(Include="#include \"externalmedialib.h\"", Library="ExternalMediaLib", IncludeDirectory="modelica://ExternalMedia/Resources/Include", LibraryDirectory="modelica://ExternalMedia/Resources/Library");
*/
    annotation(Inline = true);
  end isothermalCompressibility;

  redeclare replaceable function extends thermalConductivity
    "Return thermal conductivity from state"
    // Standard definition
  algorithm
    lambda := state.lambda;
    /*  // If special definition in "C"
  external "C" lambda=  TwoPhaseMedium_thermalConductivity_C_impl(state, mediumName, libraryName, substanceName)
    annotation(Include="#include \"externalmedialib.h\"", Library="ExternalMediaLib", IncludeDirectory="modelica://ExternalMedia/Resources/Include", LibraryDirectory="modelica://ExternalMedia/Resources/Library");
*/
    annotation(Inline = true);
  end thermalConductivity;

  redeclare replaceable function extends pressure "Return pressure from state"
    // Standard definition
  algorithm
    p := state.p;
    /*  // If special definition in "C"
  external "C" p=  TwoPhaseMedium_pressure_C_impl(state, mediumName, libraryName, substanceName)
    annotation(Include="#include \"externalmedialib.h\"", Library="ExternalMediaLib", IncludeDirectory="modelica://ExternalMedia/Resources/Include", LibraryDirectory="modelica://ExternalMedia/Resources/Library");
*/
    annotation(Inline = true);
  end pressure;

  redeclare replaceable function extends specificEntropy
    "Return specific entropy from state"
    // Standard definition
  algorithm
    s := state.s;
    /*  // If special definition in "C"
    external "C" s=  TwoPhaseMedium_specificEntropy_C_impl(state, mediumName, libraryName, substanceName)
    annotation(Include="#include \"externalmedialib.h\"", Library="ExternalMediaLib", IncludeDirectory="modelica://ExternalMedia/Resources/Include", LibraryDirectory="modelica://ExternalMedia/Resources/Library");
*/
    annotation(Inline = true);
  end specificEntropy;

  redeclare replaceable function extends isentropicEnthalpy
  external "C" h_is = TwoPhaseMedium_isentropicEnthalpy_C_impl(p_downstream, refState,
   mediumName, libraryName, substanceName)
    annotation(Include="#include \"externalmedialib.h\"", Library="ExternalMediaLib", IncludeDirectory=
        "modelica://TRANSFORM/Resources/Include",                                                                                                    LibraryDirectory=
        "modelica://TRANSFORM/Resources/Library");
  end isentropicEnthalpy;

  redeclare replaceable function setSat_p "Return saturation properties from p"
    extends Modelica.Icons.Function;
    input AbsolutePressure p "pressure";
    output SaturationProperties sat "saturation property record";
  external "C" TwoPhaseMedium_setSat_p_C_impl(p, sat, mediumName, libraryName, substanceName)
    annotation(Include="#include \"externalmedialib.h\"", Library="ExternalMediaLib", IncludeDirectory=
        "modelica://TRANSFORM/Resources/Include",                                                                                                    LibraryDirectory=
        "modelica://TRANSFORM/Resources/Library");
  end setSat_p;

  replaceable function setSat_p_state
    "Return saturation properties from the state"
    extends Modelica.Icons.Function;
    input ThermodynamicState state;
    output SaturationProperties sat "saturation property record";
    // Standard definition
  algorithm
    sat:=setSat_p(state.p);
    //Redeclare this function for more efficient implementations avoiding the repeated computation of saturation properties
  /*  // If special definition in "C"
  external "C" TwoPhaseMedium_setSat_p_state_C_impl(state, sat)
    annotation(Include="#include \"externalmedialib.h\"", Library="ExternalMediaLib", IncludeDirectory="modelica://ExternalMedia/Resources/Include", LibraryDirectory="modelica://ExternalMedia/Resources/Library");
*/
    annotation(Inline = true);
  end setSat_p_state;

  redeclare replaceable function setSat_T "Return saturation properties from p"
    extends Modelica.Icons.Function;
    input Temperature T "temperature";
    output SaturationProperties sat "saturation property record";
  external "C" TwoPhaseMedium_setSat_T_C_impl(T, sat, mediumName, libraryName, substanceName)
    annotation(Include="#include \"externalmedialib.h\"", Library="ExternalMediaLib", IncludeDirectory=
        "modelica://TRANSFORM/Resources/Include",                                                                                                    LibraryDirectory=
        "modelica://TRANSFORM/Resources/Library");
  end setSat_T;

  replaceable function setSat_T_state
    "Return saturation properties from the state"
    extends Modelica.Icons.Function;
    input ThermodynamicState state;
    output SaturationProperties sat "saturation property record";
    // Standard definition
  algorithm
    sat:=setSat_T(state.T);
    //Redeclare this function for more efficient implementations avoiding the repeated computation of saturation properties
  /*  // If special definition in "C"
  external "C" TwoPhaseMedium_setSat_T_state_C_impl(state, sat)
    annotation(Include="#include \"externalmedialib.h\"", Library="ExternalMediaLib", IncludeDirectory="modelica://ExternalMedia/Resources/Include", LibraryDirectory="modelica://ExternalMedia/Resources/Library");
*/
    annotation(Inline = true);
  end setSat_T_state;

  redeclare replaceable function extends setBubbleState
    "set the thermodynamic state on the bubble line"
    extends Modelica.Icons.Function;
    input SaturationProperties sat "saturation point";
    input FixedPhase phase(min = 1, max = 2) =  1 "phase: default is one phase";
    output ThermodynamicState state "complete thermodynamic state info";
    // Standard definition
  algorithm
    state :=setState_ph(sat.psat, sat.hl, phase);
    /*  // If special definition in "C"
  external "C" TwoPhaseMedium_setBubbleState_C_impl(sat, phase, state, mediumName, libraryName, substanceName)
    annotation(Include="#include \"externalmedialib.h\"", Library="ExternalMediaLib", IncludeDirectory="modelica://ExternalMedia/Resources/Include", LibraryDirectory="modelica://ExternalMedia/Resources/Library");
*/
    annotation(Inline = true);
  end setBubbleState;

  redeclare replaceable function extends setDewState
    "set the thermodynamic state on the dew line"
    extends Modelica.Icons.Function;
    input SaturationProperties sat "saturation point";
    input FixedPhase phase(min = 1, max = 2) = 1 "phase: default is one phase";
    output ThermodynamicState state "complete thermodynamic state info";
    // Standard definition
  algorithm
    state :=setState_ph(sat.psat, sat.hv, phase);
    /*  // If special definition in "C"
  external "C" TwoPhaseMedium_setDewState_C_impl(sat, phase, state, mediumName, libraryName, substanceName)
    annotation(Include="#include \"externalmedialib.h\"", Library="ExternalMediaLib", IncludeDirectory="modelica://ExternalMedia/Resources/Include", LibraryDirectory="modelica://ExternalMedia/Resources/Library");
*/
    annotation(Inline = true);
  end setDewState;

  redeclare replaceable function extends saturationTemperature
    // Standard definition
  algorithm
    T :=saturationTemperature_sat(setSat_p(p));
    /*  // If special definition in "C"
  external "C" T=  TwoPhaseMedium_saturationTemperature_C_impl(p, mediumName, libraryName, substanceName)
    annotation(Include="#include \"externalmedialib.h\"", Library="ExternalMediaLib", IncludeDirectory="modelica://ExternalMedia/Resources/Include", LibraryDirectory="modelica://ExternalMedia/Resources/Library");
*/
    annotation(Inline = true);
  end saturationTemperature;

  redeclare function extends saturationTemperature_sat

    annotation(Inline = true);
  end saturationTemperature_sat;

  redeclare replaceable function extends saturationTemperature_derp "Returns derivative of saturation temperature w.r.t.. pressureBeing this function inefficient, it is strongly recommended to use saturationTemperature_derp_sat
     and never use saturationTemperature_derp directly"
  external "C" dTp = TwoPhaseMedium_saturationTemperature_derp_C_impl(p, mediumName, libraryName, substanceName)
    annotation(Include="#include \"externalmedialib.h\"", Library="ExternalMediaLib", IncludeDirectory=
        "modelica://TRANSFORM/Resources/Include",                                                                                                    LibraryDirectory=
        "modelica://TRANSFORM/Resources/Library");
  end saturationTemperature_derp;

  redeclare replaceable function saturationTemperature_derp_sat
    "Returns derivative of saturation temperature w.r.t.. pressure"
    extends Modelica.Icons.Function;
    input SaturationProperties sat "saturation property record";
    output Real dTp "derivative of saturation temperature w.r.t. pressure";
    // Standard definition
  algorithm
    dTp := sat.dTp;
    /*  // If special definition in "C"
  external "C" dTp=  TwoPhaseMedium_saturationTemperature_derp_sat_C_impl(sat.psat, sat.Tsat, sat.uniqueID, mediumName, libraryName, substanceName)
    annotation(Include="#include \"externalmedialib.h\"", Library="ExternalMediaLib", IncludeDirectory="modelica://ExternalMedia/Resources/Include", LibraryDirectory="modelica://ExternalMedia/Resources/Library");
*/
    annotation(Inline = true);
  end saturationTemperature_derp_sat;

  redeclare replaceable function extends dBubbleDensity_dPressure
    "Returns bubble point density derivative"
    // Standard definition
  algorithm
    ddldp := sat.ddldp;
    /*  // If special definition in "C"
  external "C" ddldp=  TwoPhaseMedium_dBubbleDensity_dPressure_C_impl(sat, mediumName, libraryName, substanceName)
    annotation(Include="#include \"externalmedialib.h\"", Library="ExternalMediaLib", IncludeDirectory="modelica://ExternalMedia/Resources/Include", LibraryDirectory="modelica://ExternalMedia/Resources/Library");
*/
    annotation(Inline = true);
  end dBubbleDensity_dPressure;

  redeclare replaceable function extends dDewDensity_dPressure
    "Returns dew point density derivative"
    // Standard definition
  algorithm
    ddvdp := sat.ddvdp;
    /*  // If special definition in "C"
  external "C" ddvdp=  TwoPhaseMedium_dDewDensity_dPressure_C_impl(sat, mediumName, libraryName, substanceName)
    annotation(Include="#include \"externalmedialib.h\"", Library="ExternalMediaLib", IncludeDirectory="modelica://ExternalMedia/Resources/Include", LibraryDirectory="modelica://ExternalMedia/Resources/Library");
*/
    annotation(Inline = true);
  end dDewDensity_dPressure;

  redeclare replaceable function extends dBubbleEnthalpy_dPressure
    "Returns bubble point specific enthalpy derivative"
    // Standard definition
  algorithm
    dhldp := sat.dhldp;
    /*  // If special definition in "C"
  external "C" dhldp=  TwoPhaseMedium_dBubbleEnthalpy_dPressure_C_impl(sat, mediumName, libraryName, substanceName)
    annotation(Include="#include \"externalmedialib.h\"", Library="ExternalMediaLib", IncludeDirectory="modelica://ExternalMedia/Resources/Include", LibraryDirectory="modelica://ExternalMedia/Resources/Library");
*/
    annotation(Inline = true);
  end dBubbleEnthalpy_dPressure;

  redeclare replaceable function extends dDewEnthalpy_dPressure
    "Returns dew point specific enthalpy derivative"
    // Standard definition
  algorithm
    dhvdp := sat.dhvdp;
    /*  // If special definition in "C"
  external "C" dhvdp=  TwoPhaseMedium_dDewEnthalpy_dPressure_C_impl(sat, mediumName, libraryName, substanceName)
    annotation(Include="#include \"externalmedialib.h\"", Library="ExternalMediaLib", IncludeDirectory="modelica://ExternalMedia/Resources/Include", LibraryDirectory="modelica://ExternalMedia/Resources/Library");
*/
    annotation(Inline = true);
  end dDewEnthalpy_dPressure;

  redeclare replaceable function extends bubbleDensity
    "Returns bubble point density"
    // Standard definition
  algorithm
    dl := sat.dl;
    /*  // If special definition in "C"
  external "C" dl=  TwoPhaseMedium_bubbleDensity_C_impl(sat, mediumName, libraryName, substanceName)
    annotation(Include="#include \"externalmedialib.h\"", Library="ExternalMediaLib", IncludeDirectory="modelica://ExternalMedia/Resources/Include", LibraryDirectory="modelica://ExternalMedia/Resources/Library");
*/
    annotation(Inline = true);
  end bubbleDensity;

  redeclare replaceable function extends dewDensity "Returns dew point density"
    // Standard definition
  algorithm
    dv := sat.dv;
    /*  // If special definition in "C"
  external "C" dv=  TwoPhaseMedium_dewDensity_C_impl(sat, mediumName, libraryName, substanceName)
    annotation(Include="#include \"externalmedialib.h\"", Library="ExternalMediaLib", IncludeDirectory="modelica://ExternalMedia/Resources/Include", LibraryDirectory="modelica://ExternalMedia/Resources/Library");
*/
    annotation(Inline = true);
  end dewDensity;

  redeclare replaceable function extends bubbleEnthalpy
    "Returns bubble point specific enthalpy"
    // Standard definition
  algorithm
    hl := sat.hl;
    /*  // If special definition in "C"
  external "C" hl=  TwoPhaseMedium_bubbleEnthalpy_C_impl(sat, mediumName, libraryName, substanceName)
    annotation(Include="#include \"externalmedialib.h\"", Library="ExternalMediaLib", IncludeDirectory="modelica://ExternalMedia/Resources/Include", LibraryDirectory="modelica://ExternalMedia/Resources/Library");
*/
    annotation(Inline = true);
  end bubbleEnthalpy;

  redeclare replaceable function extends dewEnthalpy
    "Returns dew point specific enthalpy"
    // Standard definition
  algorithm
    hv := sat.hv;
    /*  // If special definition in "C"
  external "C" hv=  TwoPhaseMedium_dewEnthalpy_C_impl(sat, mediumName, libraryName, substanceName)
    annotation(Include="#include \"externalmedialib.h\"", Library="ExternalMediaLib", IncludeDirectory="modelica://ExternalMedia/Resources/Include", LibraryDirectory="modelica://ExternalMedia/Resources/Library");
*/
    annotation(Inline = true);
  end dewEnthalpy;

  redeclare replaceable function extends saturationPressure
    // Standard definition
  algorithm
    p :=saturationPressure_sat(setSat_T(T));
    /*  // If special definition in "C"
  external "C" p=  TwoPhaseMedium_saturationPressure_C_impl(T, mediumName, libraryName, substanceName)
    annotation(Include="#include \"externalmedialib.h\"", Library="ExternalMediaLib", IncludeDirectory="modelica://ExternalMedia/Resources/Include", LibraryDirectory="modelica://ExternalMedia/Resources/Library");
*/
    annotation(Inline = false,
               LateInline = true,
               derivative = saturationPressure_der);
  end saturationPressure;


  redeclare function extends saturationPressure_sat

    annotation(Inline = true);
  end saturationPressure_sat;

  redeclare replaceable function extends surfaceTension
    "Returns surface tension sigma in the two phase region"
    //Standard definition
  algorithm
    sigma := sat.sigma;
    /*  //If special definition in "C"
  external "C" sigma=  TwoPhaseMedium_surfaceTension_C_impl(sat, mediumName, libraryName, substanceName)
    annotation(Include="#include \"externalmedialib.h\"", Library="ExternalMediaLib", IncludeDirectory="modelica://ExternalMedia/Resources/Include", LibraryDirectory="modelica://ExternalMedia/Resources/Library");
*/
    annotation(Inline = true);
  end surfaceTension;

  redeclare replaceable function extends bubbleEntropy
    "Returns bubble point specific entropy"
    //Standard definition
  algorithm
    sl := specificEntropy(setBubbleState(sat));
    /*  //If special definition in "C"
  external "C" sl=  TwoPhaseMedium_bubbleEntropy_C_impl(sat, mediumName, libraryName, substanceName)
    annotation(Include="#include \"externalmedialib.h\"", Library="ExternalMediaLib", IncludeDirectory="modelica://ExternalMedia/Resources/Include", LibraryDirectory="modelica://ExternalMedia/Resources/Library");
*/
    annotation(Inline = true);
  end bubbleEntropy;

  redeclare replaceable function extends dewEntropy
    "Returns dew point specific entropy"
    //Standard definition
  algorithm
    sv := specificEntropy(setDewState(sat));
    /*  //If special definition in "C"
  external "C" sv=  TwoPhaseMedium_dewEntropy_C_impl(sat, mediumName, libraryName, substanceName)
    annotation(Include="#include \"externalmedialib.h\"", Library="ExternalMediaLib", IncludeDirectory="modelica://ExternalMedia/Resources/Include", LibraryDirectory="modelica://ExternalMedia/Resources/Library");
*/
    annotation(Inline = true);
  end dewEntropy;
end ExternalSinglePhaseMedium;
