within TRANSFORM.Media.LookupTables.BaseClasses;
package ExternalSinglePhaseMedium "Generic external single phase medium package"

  import TRANSFORM.Media.LookupTables.BaseClasses.Common.InputChoice;

  extends TRANSFORM.Media.Interfaces.Fluids.PartialSinglePhaseMedium(
    singleState=false,
    fluidConstants = {externalFluidConstants});

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
    molarMass = getMolarMass());

  constant InputChoice inputChoice=InputChoice.pT
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
    SpecificEntropy s "specific entropy";
  end ThermodynamicState;

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

    import TRANSFORM.Media.LookupTables.BaseClasses.Common.InputChoice;

    parameter InputChoice basePropertiesInputChoice=inputChoice
      "Choice of input variables for property computations";
    SpecificEntropy s(
      stateSelect = if (basePropertiesInputChoice == InputChoice.hs or
                        basePropertiesInputChoice == InputChoice.ps) then
                       StateSelect.prefer else StateSelect.default)
      "Specific entropy";

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
      h = specificEnthalpy(state);
      s = specificEntropy(state);
    end if;
    // Compute the internal energy
    u = h - p/d;
  end BaseProperties;

  redeclare replaceable function setState_ph
    "Return thermodynamic state record from p and h"
    extends Modelica.Icons.Function;
    input AbsolutePressure p "pressure";
    input SpecificEnthalpy h "specific enthalpy";
    output ThermodynamicState state;
  external "C" SinglePhaseMedium_setState_ph_C_impl(p, h, state, mediumName, libraryName, substanceName)
    annotation(Include="#include \"medialookuptableslib.h\"", Library="MediaLookupTables", IncludeDirectory="modelica://MediaLookupTables/Resources/Include", LibraryDirectory="modelica://MediaLookupTables/Resources/Library");
  end setState_ph;

  redeclare replaceable function setState_pT
    "Return thermodynamic state record from p and T"
    extends Modelica.Icons.Function;
    input AbsolutePressure p "pressure";
    input Temperature T "temperature";
    output ThermodynamicState state;
  external "C" SinglePhaseMedium_setState_pT_C_impl(p, T, state, mediumName, libraryName, substanceName)
    annotation(Include="#include \"medialookuptableslib.h\"", Library="MediaLookupTables", IncludeDirectory="modelica://MediaLookupTables/Resources/Include", LibraryDirectory="modelica://MediaLookupTables/Resources/Library");
  end setState_pT;

  redeclare replaceable function setState_dT
    "Return thermodynamic state record from d and T"
    extends Modelica.Icons.Function;
    input Density d "density";
    input Temperature T "temperature";
    output ThermodynamicState state;
  external "C" SinglePhaseMedium_setState_dT_C_impl(d, T, state, mediumName, libraryName, substanceName)
    annotation(Include="#include \"medialookuptableslib.h\"", Library="MediaLookupTables", IncludeDirectory="modelica://MediaLookupTables/Resources/Include", LibraryDirectory="modelica://MediaLookupTables/Resources/Library");
  end setState_dT;

  redeclare replaceable function setState_ps
    "Return thermodynamic state record from p and s"
    extends Modelica.Icons.Function;
    input AbsolutePressure p "pressure";
    input SpecificEntropy s "specific entropy";
    output ThermodynamicState state;
  external "C" SinglePhaseMedium_setState_ps_C_impl(p, s, state, mediumName, libraryName, substanceName)
    annotation(Include="#include \"medialookuptableslib.h\"", Library="MediaLookupTables", IncludeDirectory="modelica://MediaLookupTables/Resources/Include", LibraryDirectory="modelica://MediaLookupTables/Resources/Library");
  end setState_ps;

  replaceable function setState_hs
    "Return thermodynamic state record from h and s"
    extends Modelica.Icons.Function;
    input SpecificEnthalpy h "specific enthalpy";
    input SpecificEntropy s "specific entropy";
    output ThermodynamicState state;
  external "C" SinglePhaseMedium_setState_hs_C_impl(h, s, state, mediumName, libraryName, substanceName)
    annotation(Include="#include \"medialookuptableslib.h\"", Library="MediaLookupTables", IncludeDirectory="modelica://MediaLookupTables/Resources/Include", LibraryDirectory="modelica://MediaLookupTables/Resources/Library");
  end setState_hs;

  replaceable function partialDeriv_state
    "Return partial derivative from a thermodynamic state record"
    extends Modelica.Icons.Function;
    input String of "The property to differentiate";
    input String wrt "Differentiate with respect to this";
    input String cst "Keep this constant";
    input ThermodynamicState  state;
    output Real partialDerivative;
    external "C" partialDerivative = SinglePhaseMedium_partialDeriv_state_C_impl(of, wrt, cst, state, mediumName, libraryName, substanceName)
    annotation(Include="#include \"medialookuptableslib.h\"", Library="MediaLookupTables", IncludeDirectory="modelica://MediaLookupTables/Resources/Include", LibraryDirectory="modelica://MediaLookupTables/Resources/Library");
  end partialDeriv_state;

  redeclare function extends setState_phX
  algorithm
    // The composition is an empty vector
    state :=setState_ph(p, h);
  end setState_phX;

  redeclare function extends setState_pTX
  algorithm
    // The composition is an empty vector
    state :=setState_pT(p, T);
  end setState_pTX;

  redeclare function extends setState_dTX
  algorithm
    // The composition is an empty vector
    state :=setState_dT(d, T);
  end setState_dTX;

  redeclare function extends setState_psX
  algorithm
    // The composition is an empty vector
    state :=setState_ps(p, s);
  end setState_psX;

  replaceable function setState_hsX
                                    extends Modelica.Icons.Function;
    input SpecificEnthalpy h "specific enthalpy";
    input SpecificEntropy s "specific entropy";
    output ThermodynamicState state;
  algorithm
    // The composition is an empty vector
    state :=setState_hs(h, s);
  end setState_hsX;

  redeclare replaceable function density_ph "Return density from p and h"
    extends Modelica.Icons.Function;
    input AbsolutePressure p "Pressure";
    input SpecificEnthalpy h "Specific enthalpy";
    output Density d "Density";
  algorithm
    d := density_ph_state(p=p, h=h, state=setState_ph(p=p, h=h));
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
    output Temperature T "Temperature";
  algorithm
    T := temperature_ph_state(p=p, h=h, state=setState_ph(p=p, h=h));
  annotation (
    Inline=true,
    inverse(h=specificEnthalpy_pT(p=p, T=T)));
  end temperature_ph;

  replaceable function specificEntropy_ph
    "Return specific entropy from p and h"
    extends Modelica.Icons.Function;
    input AbsolutePressure p "Pressure";
    input SpecificEnthalpy h "Specific enthalpy";
    output SpecificEntropy s "specific entropy";
  algorithm
    s := specificEntropy_ph_state(p=p, h=h, state=setState_ph(p=p, h=h));
    annotation (
    Inline=true,
    inverse(h=specificEnthalpy_ps(p=p, s=s)));
  end specificEntropy_ph;

  redeclare replaceable function density_pT "Return density from p and T"
    extends Modelica.Icons.Function;
    input AbsolutePressure p "Pressure";
    input Temperature T "Temperature";
    output Density d "Density";
  algorithm
    d := density_pT_state(p=p, T=T, state=setState_pT(p=p, T=T));
  annotation (
    Inline=true,
    inverse(p=pressure_dT(d=d, T=T)));
  end density_pT;

  replaceable function density_pT_der "Total derivative of density_pT"
    extends Modelica.Icons.Function;
    input AbsolutePressure p "Pressure";
    input Temperature T "Temperature";
    input Real p_der;
    input Real T_der;
    output Real d_der;
  algorithm
    d_der:=density_derp_T(setState_pT(p, T))*p_der +
           density_derT_p(setState_pT(p, T))*T_der;
    /*  // If special definition in "C"
    external "C" d_der=  SinglePhaseMedium_density_pT_der_C_impl(state, mediumName, libraryName, substanceName)
    annotation(Include="#include \"medialookuptableslib.h\"", Library="MediaLookupTables", IncludeDirectory="modelica://MediaLookupTables/Resources/Include", LibraryDirectory="modelica://MediaLookupTables/Resources/Library");
    */
    annotation(Inline = true);
  end density_pT_der;

  redeclare replaceable function specificEnthalpy_pT
    "Return specific enthalpy from p and T"
    extends Modelica.Icons.Function;
    input AbsolutePressure p "Pressure";
    input Temperature T "Temperature";
    output SpecificEnthalpy h "specific enthalpy";
  algorithm
    h := specificEnthalpy_pT_state(p=p, T=T, state=setState_pT(p=p, T=T));
  annotation (
    Inline=true,
    inverse(T=temperature_ph(p=p, h=h)));
  end specificEnthalpy_pT;

  redeclare replaceable function pressure_dT "Return pressure from d and T"
    extends Modelica.Icons.Function;
    input Density d "Density";
    input Temperature T "Temperature";
    output AbsolutePressure p "Pressure";
  algorithm
    p := pressure_dT_state(d=d, T=T, state=setState_dT(d=d, T=T));
    annotation (
    Inline=true,
    inverse(d=density_pT(p=p, T=T)));
  end pressure_dT;

  redeclare replaceable function specificEnthalpy_dT
    "Return specific enthalpy from d and T"
    extends Modelica.Icons.Function;
    input Density d "Density";
    input Temperature T "Temperature";
    output SpecificEnthalpy h "specific enthalpy";
  algorithm
    h := specificEnthalpy_dT_state(d=d, T=T, state=setState_dT(d=d, T=T));
  annotation (
    Inline=true);
  end specificEnthalpy_dT;

  redeclare replaceable function density_ps "Return density from p and s"
    extends Modelica.Icons.Function;
    input AbsolutePressure p "Pressure";
    input SpecificEntropy s "Specific entropy";
    output Density d "Density";
  algorithm
    d := density_ps_state(p=p, s=s, state=setState_ps(p=p, s=s));
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
    output Temperature T "Temperature";
  algorithm
    T := temperature_ps_state(p=p, s=s, state=setState_ps(p=p, s=s));
  annotation (
    Inline=true,
    inverse(s=specificEntropy_pT(p=p, T=T)));
  end temperature_ps;

  redeclare replaceable function specificEnthalpy_ps
    "Return specific enthalpy from p and s"
    extends Modelica.Icons.Function;
    input AbsolutePressure p "Pressure";
    input SpecificEntropy s "Specific entropy";
    output SpecificEnthalpy h "specific enthalpy";
  algorithm
    h := specificEnthalpy_ps_state(p=p, s=s, state=setState_ps(p=p, s=s));
    annotation (
    Inline = true,
    inverse(s=specificEntropy_ph(p=p, h=h)));
  end specificEnthalpy_ps;

  replaceable function pressure_hs "Return pressure from h and s"
    extends Modelica.Icons.Function;
    input SpecificEnthalpy h "Specific enthalpy";
    input SpecificEntropy s "Specific entropy";
    output AbsolutePressure p "Pressure";
  algorithm
    p := pressure_hs_state(h=h, s=s, state=setState_hs(h=h, s=s));
    annotation (
      Inline = true,
      inverse(
        h=specificEnthalpy_ps(p=p, s=s),
        s=specificEntropy_ph(p=p, h=h)));
  end pressure_hs;

  replaceable function temperature_hs "Return temperature from h and s"
    extends Modelica.Icons.Function;
    input SpecificEnthalpy h "Specific enthalpy";
    input SpecificEntropy s "Specific entropy";
    output Temperature T "Temperature";
  algorithm
    T := temperature_hs_state(h=h, s=s, state=setState_hs(h=h, s=s));
    annotation (
      Inline = true);
  end temperature_hs;

  redeclare function extends prandtlNumber "Returns Prandtl number"
    /*  // If special definition in "C"
  external "C" T=  SinglePhaseMedium_prandtlNumber_C_impl(state, mediumName, libraryName, substanceName)
    annotation(Include="#include \"medialookuptableslib.h\"", Library="MediaLookupTables", IncludeDirectory="modelica://MediaLookupTables/Resources/Include", LibraryDirectory="modelica://MediaLookupTables/Resources/Library");
*/
    annotation(Inline = true);
  end prandtlNumber;

  redeclare replaceable function extends temperature
    "Return temperature from state"
    // Standard definition
  algorithm
    T := state.T;
    /*  // If special definition in "C"
  external "C" T=  SinglePhaseMedium_temperature_C_impl(state, mediumName, libraryName, substanceName)
    annotation(Include="#include \"medialookuptableslib.h\"", Library="MediaLookupTables", IncludeDirectory="modelica://MediaLookupTables/Resources/Include", LibraryDirectory="modelica://MediaLookupTables/Resources/Library");
*/
    annotation(Inline = true);
  end temperature;

  redeclare replaceable function extends velocityOfSound
    "Return velocity of sound from state"
    // Standard definition
  algorithm
    a := state.a;
    /*  // If special definition in "C"
  external "C" a=  SinglePhaseMedium_velocityOfSound_C_impl(state, mediumName, libraryName, substanceName)
    annotation(Include="#include \"medialookuptableslib.h\"", Library="MediaLookupTables", IncludeDirectory="modelica://MediaLookupTables/Resources/Include", LibraryDirectory="modelica://MediaLookupTables/Resources/Library");
*/
    annotation(Inline = true);
  end velocityOfSound;

  redeclare replaceable function extends isobaricExpansionCoefficient
    "Return isobaric expansion coefficient from state"
    // Standard definition
  algorithm
    beta := state.beta;
    /*  // If special definition in "C"
  external "C" beta=  SinglePhaseMedium_isobaricExpansionCoefficient_C_impl(state, mediumName, libraryName, substanceName)
    annotation(Include="#include \"medialookuptableslib.h\"", Library="MediaLookupTables", IncludeDirectory="modelica://MediaLookupTables/Resources/Include", LibraryDirectory="modelica://MediaLookupTables/Resources/Library");
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
  external "C" cp=  SinglePhaseMedium_specificHeatCapacityCp_C_impl(state, mediumName, libraryName, substanceName)
    annotation(Include="#include \"medialookuptableslib.h\"", Library="MediaLookupTables", IncludeDirectory="modelica://MediaLookupTables/Resources/Include", LibraryDirectory="modelica://MediaLookupTables/Resources/Library");
*/
    annotation(Inline = true);
  end specificHeatCapacityCp;

  redeclare replaceable function extends specificHeatCapacityCv
    "Return specific heat capacity cv from state"
    // Standard definition
  algorithm
    cv := state.cv;
    /*  // If special definition in "C"
  external "C" cv=  SinglePhaseMedium_specificHeatCapacityCv_C_impl(state, mediumName, libraryName, substanceName)
    annotation(Include="#include \"medialookuptableslib.h\"", Library="MediaLookupTables", IncludeDirectory="modelica://MediaLookupTables/Resources/Include", LibraryDirectory="modelica://MediaLookupTables/Resources/Library");
*/
    annotation(Inline = true);
  end specificHeatCapacityCv;

  redeclare replaceable function extends density "Return density from state"
    // Standard definition
  algorithm
    d := state.d;
    /*  // If special definition in "C"
  external "C" d=  SinglePhaseMedium_density_C_impl(state, mediumName, libraryName, substanceName)
    annotation(Include="#include \"medialookuptableslib.h\"", Library="MediaLookupTables", IncludeDirectory="modelica://MediaLookupTables/Resources/Include", LibraryDirectory="modelica://MediaLookupTables/Resources/Library");
*/
    annotation(Inline = true);
  end density;

  redeclare replaceable function extends density_derh_p
    "Return derivative of density wrt enthalpy at constant pressure from state"
    // Standard definition
  algorithm
    ddhp := state.ddhp;
    /*  // If special definition in "C"
  external "C" ddhp=  SinglePhaseMedium_density_derh_p_C_impl(state, mediumName, libraryName, substanceName)
    annotation(Include="#include \"medialookuptableslib.h\"", Library="MediaLookupTables", IncludeDirectory="modelica://MediaLookupTables/Resources/Include", LibraryDirectory="modelica://MediaLookupTables/Resources/Library");
*/
    annotation(Inline = true);
  end density_derh_p;

  redeclare replaceable function extends density_derp_h
    "Return derivative of density wrt pressure at constant enthalpy from state"
    // Standard definition
  algorithm
    ddph := state.ddph;
    /*  // If special definition in "C"
  external "C" ddph=  SinglePhaseMedium_density_derp_h_C_impl(state, mediumName, libraryName, substanceName)
    annotation(Include="#include \"medialookuptableslib.h\"", Library="MediaLookupTables", IncludeDirectory="modelica://MediaLookupTables/Resources/Include", LibraryDirectory="modelica://MediaLookupTables/Resources/Library");
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
  external "C" eta=  SinglePhaseMedium_dynamicViscosity_C_impl(state, mediumName, libraryName, substanceName)
    annotation(Include="#include \"medialookuptableslib.h\"", Library="MediaLookupTables", IncludeDirectory="modelica://MediaLookupTables/Resources/Include", LibraryDirectory="modelica://MediaLookupTables/Resources/Library");
*/
    annotation(Inline = true);
  end dynamicViscosity;

  redeclare replaceable function extends specificEnthalpy
    "Return specific enthalpy from state"
    // Standard definition
  algorithm
    h := state.h;
    /*  // If special definition in "C"
  external "C" h=  SinglePhaseMedium_specificEnthalpy_C_impl(state, mediumName, libraryName, substanceName)
    annotation(Include="#include \"medialookuptableslib.h\"", Library="MediaLookupTables", IncludeDirectory="modelica://MediaLookupTables/Resources/Include", LibraryDirectory="modelica://MediaLookupTables/Resources/Library");
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
  external "C" kappa=  SinglePhaseMedium_isothermalCompressibility_C_impl(state, mediumName, libraryName, substanceName)
    annotation(Include="#include \"medialookuptableslib.h\"", Library="MediaLookupTables", IncludeDirectory="modelica://MediaLookupTables/Resources/Include", LibraryDirectory="modelica://MediaLookupTables/Resources/Library");
*/
    annotation(Inline = true);
  end isothermalCompressibility;

  redeclare replaceable function extends thermalConductivity
    "Return thermal conductivity from state"
    // Standard definition
  algorithm
    lambda := state.lambda;
    /*  // If special definition in "C"
  external "C" lambda=  SinglePhaseMedium_thermalConductivity_C_impl(state, mediumName, libraryName, substanceName)
    annotation(Include="#include \"medialookuptableslib.h\"", Library="MediaLookupTables", IncludeDirectory="modelica://MediaLookupTables/Resources/Include", LibraryDirectory="modelica://MediaLookupTables/Resources/Library");
*/
    annotation(Inline = true);
  end thermalConductivity;

  redeclare replaceable function extends pressure "Return pressure from state"
    // Standard definition
  algorithm
    p := state.p;
    /*  // If special definition in "C"
  external "C" p=  SinglePhaseMedium_pressure_C_impl(state, mediumName, libraryName, substanceName)
    annotation(Include="#include \"medialookuptableslib.h\"", Library="MediaLookupTables", IncludeDirectory="modelica://MediaLookupTables/Resources/Include", LibraryDirectory="modelica://MediaLookupTables/Resources/Library");
*/
    annotation(Inline = true);
  end pressure;

  redeclare replaceable function extends specificEntropy
    "Return specific entropy from state"
    // Standard definition
  algorithm
    s := state.s;
    /*  // If special definition in "C"
    external "C" s=  SinglePhaseMedium_specificEntropy_C_impl(state, mediumName, libraryName, substanceName)
    annotation(Include="#include \"medialookuptableslib.h\"", Library="MediaLookupTables", IncludeDirectory="modelica://MediaLookupTables/Resources/Include", LibraryDirectory="modelica://MediaLookupTables/Resources/Library");
*/
    annotation(Inline = true);
  end specificEntropy;

  redeclare replaceable function extends isentropicEnthalpy
  external "C" h_is = SinglePhaseMedium_isentropicEnthalpy_C_impl(p_downstream, refState,
   mediumName, libraryName, substanceName)
    annotation(Include="#include \"medialookuptableslib.h\"", Library="MediaLookupTables", IncludeDirectory="modelica://MediaLookupTables/Resources/Include", LibraryDirectory="modelica://MediaLookupTables/Resources/Library");
  end isentropicEnthalpy;
// 
//   redeclare replaceable function extends surfaceTension
//     "Returns surface tension sigma in the two phase region"
//     //Standard definition
//   algorithm 
//     sigma := sat.sigma;
//     /*  //If special definition in "C"
//   external "C" sigma=  SinglePhaseMedium_surfaceTension_C_impl(sat, mediumName, libraryName, substanceName)
//     annotation(Include="#include \"medialookuptableslib.h\"", Library="MediaLookupTables", IncludeDirectory="modelica://MediaLookupTables/Resources/Include", LibraryDirectory="modelica://MediaLookupTables/Resources/Library");
// */
//     annotation(Inline = true);
//   end surfaceTension;

end ExternalSinglePhaseMedium;
