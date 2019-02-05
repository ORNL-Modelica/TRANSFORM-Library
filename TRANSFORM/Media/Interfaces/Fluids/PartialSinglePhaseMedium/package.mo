within TRANSFORM.Media.Interfaces.Fluids;
partial package PartialSinglePhaseMedium "Base class for single phase medium of one substance"
  extends TRANSFORM.Media.Interfaces.Fluids.PartialPureSubstance(redeclare
    record
      FluidConstants = Modelica.Media.Interfaces.Types.TwoPhase.FluidConstants);
  constant Boolean smoothModel=false
    "True if the (derived) model should not generate state events";
  constant Boolean onePhase=false
    "True if the (derived) model should never be called with two-phase inputs";

  constant FluidConstants[nS] fluidConstants "Constant data for the fluid";

  redeclare replaceable record extends ThermodynamicState
    "Thermodynamic state of two phase medium"
    FixedPhase phase(min=0, max=2)
      "Phase of the fluid: 1 for 1-phase, 2 for two-phase, 0 for not known, e.g., interactive use";
  end ThermodynamicState;

  redeclare replaceable partial model extends BaseProperties
    "Base properties (p, d, T, h, u, R, MM, sat) of two phase medium"
    SaturationProperties sat "Saturation properties at the medium pressure";
  end BaseProperties;

  replaceable partial function setDewState
    "Return the thermodynamic state on the dew line"
    extends Modelica.Icons.Function;
    input SaturationProperties sat "Saturation point";
    input FixedPhase phase(
      min=1,
      max=2) = 1 "Phase: default is one phase";
    output ThermodynamicState state "Complete thermodynamic state info";
  end setDewState;

  replaceable partial function setBubbleState
    "Return the thermodynamic state on the bubble line"
    extends Modelica.Icons.Function;
    input SaturationProperties sat "Saturation point";
    input FixedPhase phase(
      min=1,
      max=2) = 1 "Phase: default is one phase";
    output ThermodynamicState state "Complete thermodynamic state info";
  end setBubbleState;

  redeclare replaceable partial function extends setState_dTX
    "Return thermodynamic state as function of d, T and composition X or Xi"
    input FixedPhase phase=0
      "2 for two-phase, 1 for one-phase, 0 if not known";
  end setState_dTX;

  redeclare replaceable partial function extends setState_phX
    "Return thermodynamic state as function of p, h and composition X or Xi"
    input FixedPhase phase=0
      "2 for two-phase, 1 for one-phase, 0 if not known";
  end setState_phX;

  redeclare replaceable partial function extends setState_psX
    "Return thermodynamic state as function of p, s and composition X or Xi"
    input FixedPhase phase=0
      "2 for two-phase, 1 for one-phase, 0 if not known";
  end setState_psX;

  redeclare replaceable partial function extends setState_pTX
    "Return thermodynamic state as function of p, T and composition X or Xi"
    input FixedPhase phase=0
      "2 for two-phase, 1 for one-phase, 0 if not known";
  end setState_pTX;

  replaceable function setSat_T
    "Return saturation property record from temperature"
    extends Modelica.Icons.Function;
    input Temperature T "Temperature";
    output SaturationProperties sat "Saturation property record";
  algorithm
    sat.Tsat := T;
    sat.psat := saturationPressure(T);
  end setSat_T;

  replaceable function setSat_p
    "Return saturation property record from pressure"
    extends Modelica.Icons.Function;
    input AbsolutePressure p "Pressure";
    output SaturationProperties sat "Saturation property record";
  algorithm
    sat.psat := p;
    sat.Tsat := saturationTemperature(p);
  end setSat_p;

  replaceable partial function bubbleEnthalpy
    "Return bubble point specific enthalpy"
    extends Modelica.Icons.Function;
    input SaturationProperties sat "Saturation property record";
    output SI.SpecificEnthalpy hl "Boiling curve specific enthalpy";
  end bubbleEnthalpy;

  replaceable partial function dewEnthalpy
    "Return dew point specific enthalpy"
    extends Modelica.Icons.Function;
    input SaturationProperties sat "Saturation property record";
    output SI.SpecificEnthalpy hv "Dew curve specific enthalpy";
  end dewEnthalpy;

  replaceable partial function bubbleEntropy
    "Return bubble point specific entropy"
    extends Modelica.Icons.Function;
    input SaturationProperties sat "Saturation property record";
    output SI.SpecificEntropy sl "Boiling curve specific entropy";
  end bubbleEntropy;

  replaceable partial function dewEntropy "Return dew point specific entropy"
    extends Modelica.Icons.Function;
    input SaturationProperties sat "Saturation property record";
    output SI.SpecificEntropy sv "Dew curve specific entropy";
  end dewEntropy;

  replaceable partial function bubbleDensity "Return bubble point density"
    extends Modelica.Icons.Function;
    input SaturationProperties sat "Saturation property record";
    output Density dl "Boiling curve density";
  end bubbleDensity;

  replaceable partial function dewDensity "Return dew point density"
    extends Modelica.Icons.Function;
    input SaturationProperties sat "Saturation property record";
    output Density dv "Dew curve density";
  end dewDensity;

  replaceable partial function saturationPressure
    "Return saturation pressure"
    extends Modelica.Icons.Function;
    input Temperature T "Temperature";
    output AbsolutePressure p "Saturation pressure";
  end saturationPressure;

  replaceable partial function saturationTemperature
    "Return saturation temperature"
    extends Modelica.Icons.Function;
    input AbsolutePressure p "Pressure";
    output Temperature T "Saturation temperature";
  end saturationTemperature;

  replaceable function saturationPressure_sat "Return saturation temperature"
    extends Modelica.Icons.Function;
    input SaturationProperties sat "Saturation property record";
    output AbsolutePressure p "Saturation pressure";
  algorithm
    p := sat.psat;
  end saturationPressure_sat;

  replaceable function saturationTemperature_sat
    "Return saturation temperature"
    extends Modelica.Icons.Function;
    input SaturationProperties sat "Saturation property record";
    output Temperature T "Saturation temperature";
  algorithm
    T := sat.Tsat;
  end saturationTemperature_sat;

  replaceable partial function saturationTemperature_derp
    "Return derivative of saturation temperature w.r.t. pressure"
    extends Modelica.Icons.Function;
    input AbsolutePressure p "Pressure";
    output DerTemperatureByPressure dTp
      "Derivative of saturation temperature w.r.t. pressure";
  end saturationTemperature_derp;

  replaceable function saturationTemperature_derp_sat
    "Return derivative of saturation temperature w.r.t. pressure"
    extends Modelica.Icons.Function;
    input SaturationProperties sat "Saturation property record";
    output DerTemperatureByPressure dTp
      "Derivative of saturation temperature w.r.t. pressure";
  algorithm
    dTp := saturationTemperature_derp(sat.psat);
  end saturationTemperature_derp_sat;

  replaceable partial function surfaceTension
    "Return surface tension sigma in the two phase region"
    extends Modelica.Icons.Function;
    input SaturationProperties sat "Saturation property record";
    output SurfaceTension sigma
      "Surface tension sigma in the two phase region";
  end surfaceTension;

  redeclare replaceable function extends molarMass
    "Return the molar mass of the medium"
  algorithm
    MM := fluidConstants[1].molarMass;
  end molarMass;

  replaceable partial function dBubbleDensity_dPressure
    "Return bubble point density derivative"
    extends Modelica.Icons.Function;
    input SaturationProperties sat "Saturation property record";
    output DerDensityByPressure ddldp "Boiling curve density derivative";
  end dBubbleDensity_dPressure;

  replaceable partial function dDewDensity_dPressure
    "Return dew point density derivative"
    extends Modelica.Icons.Function;
    input SaturationProperties sat "Saturation property record";
    output DerDensityByPressure ddvdp "Saturated steam density derivative";
  end dDewDensity_dPressure;

  replaceable partial function dBubbleEnthalpy_dPressure
    "Return bubble point specific enthalpy derivative"
    extends Modelica.Icons.Function;
    input SaturationProperties sat "Saturation property record";
    output DerEnthalpyByPressure dhldp
      "Boiling curve specific enthalpy derivative";
  end dBubbleEnthalpy_dPressure;

  replaceable partial function dDewEnthalpy_dPressure
    "Return dew point specific enthalpy derivative"
    extends Modelica.Icons.Function;

    input SaturationProperties sat "Saturation property record";
    output DerEnthalpyByPressure dhvdp
      "Saturated steam specific enthalpy derivative";
  end dDewEnthalpy_dPressure;

  redeclare replaceable function specificEnthalpy_pTX
    "Return specific enthalpy from pressure, temperature and mass fraction"
    extends Modelica.Icons.Function;
    input AbsolutePressure p "Pressure";
    input Temperature T "Temperature";
    input MassFraction X[:] "Mass fractions";
    input FixedPhase phase=0
      "2 for two-phase, 1 for one-phase, 0 if not known";
    output SpecificEnthalpy h "Specific enthalpy at p, T, X";
  algorithm
    h := specificEnthalpy(setState_pTX(
            p,
            T,
            X,
            phase));
  end specificEnthalpy_pTX;

  redeclare replaceable function temperature_phX
    "Return temperature from p, h, and X or Xi"
    extends Modelica.Icons.Function;
    input AbsolutePressure p "Pressure";
    input SpecificEnthalpy h "Specific enthalpy";
    input MassFraction X[:] "Mass fractions";
    input FixedPhase phase=0
      "2 for two-phase, 1 for one-phase, 0 if not known";
    output Temperature T "Temperature";
  algorithm
    T := temperature(setState_phX(
            p,
            h,
            X,
            phase));
  end temperature_phX;

  redeclare replaceable function density_phX
    "Return density from p, h, and X or Xi"
    extends Modelica.Icons.Function;
    input AbsolutePressure p "Pressure";
    input SpecificEnthalpy h "Specific enthalpy";
    input MassFraction X[:] "Mass fractions";
    input FixedPhase phase=0
      "2 for two-phase, 1 for one-phase, 0 if not known";
    output Density d "Density";
  algorithm
    d := density(setState_phX(
            p,
            h,
            X,
            phase));
  end density_phX;

  redeclare replaceable function temperature_psX
    "Return temperature from p, s, and X or Xi"
    extends Modelica.Icons.Function;
    input AbsolutePressure p "Pressure";
    input SpecificEntropy s "Specific entropy";
    input MassFraction X[:] "Mass fractions";
    input FixedPhase phase=0
      "2 for two-phase, 1 for one-phase, 0 if not known";
    output Temperature T "Temperature";
  algorithm
    T := temperature(setState_psX(
            p,
            s,
            X,
            phase));
  end temperature_psX;

  redeclare replaceable function density_psX
    "Return density from p, s, and X or Xi"
    extends Modelica.Icons.Function;
    input AbsolutePressure p "Pressure";
    input SpecificEntropy s "Specific entropy";
    input MassFraction X[:] "Mass fractions";
    input FixedPhase phase=0
      "2 for two-phase, 1 for one-phase, 0 if not known";
    output Density d "Density";
  algorithm
    d := density(setState_psX(
            p,
            s,
            X,
            phase));
  end density_psX;

  redeclare replaceable function specificEnthalpy_psX
    "Return specific enthalpy from p, s, and X or Xi"
    extends Modelica.Icons.Function;
    input AbsolutePressure p "Pressure";
    input SpecificEntropy s "Specific entropy";
    input MassFraction X[:] "Mass fractions";
    input FixedPhase phase=0
      "2 for two-phase, 1 for one-phase, 0 if not known";
    output SpecificEnthalpy h "Specific enthalpy";
  algorithm
    h := specificEnthalpy(setState_psX(
            p,
            s,
            X,
            phase));
  end specificEnthalpy_psX;

  redeclare replaceable function setState_pT
    "Return thermodynamic state from p and T"
    extends Modelica.Icons.Function;
    input AbsolutePressure p "Pressure";
    input Temperature T "Temperature";
    input FixedPhase phase=0
      "2 for two-phase, 1 for one-phase, 0 if not known";
    output ThermodynamicState state "Thermodynamic state record";
  algorithm
    state := setState_pTX(
            p,
            T,
            fill(0, 0),
            phase);
  end setState_pT;

  redeclare replaceable function setState_ph
    "Return thermodynamic state from p and h"
    extends Modelica.Icons.Function;
    input AbsolutePressure p "Pressure";
    input SpecificEnthalpy h "Specific enthalpy";
    input FixedPhase phase=0
      "2 for two-phase, 1 for one-phase, 0 if not known";
    output ThermodynamicState state "Thermodynamic state record";
  algorithm
    state := setState_phX(
            p,
            h,
            fill(0, 0),
            phase);
  end setState_ph;

  redeclare replaceable function setState_ps
    "Return thermodynamic state from p and s"
    extends Modelica.Icons.Function;
    input AbsolutePressure p "Pressure";
    input SpecificEntropy s "Specific entropy";
    input FixedPhase phase=0
      "2 for two-phase, 1 for one-phase, 0 if not known";
    output ThermodynamicState state "Thermodynamic state record";
  algorithm
    state := setState_psX(
            p,
            s,
            fill(0, 0),
            phase);
  end setState_ps;

  redeclare replaceable function setState_dT
    "Return thermodynamic state from d and T"
    extends Modelica.Icons.Function;
    input Density d "Density";
    input Temperature T "Temperature";
    input FixedPhase phase=0
      "2 for two-phase, 1 for one-phase, 0 if not known";
    output ThermodynamicState state "Thermodynamic state record";
  algorithm
    state := setState_dTX(
            d,
            T,
            fill(0, 0),
            phase);
  end setState_dT;

  replaceable function setState_px
    "Return thermodynamic state from pressure and vapour quality"
    extends Modelica.Icons.Function;
    input AbsolutePressure p "Pressure";
    input MassFraction x "Vapour quality";
    output ThermodynamicState state "Thermodynamic state record";
  algorithm
    state := setState_ph(
            p,
            (1 - x)*bubbleEnthalpy(setSat_p(p)) + x*dewEnthalpy(setSat_p(p)),
            2);
  end setState_px;

  replaceable function setState_Tx
    "Return thermodynamic state from temperature and vapour quality"
    extends Modelica.Icons.Function;
    input Temperature T "Temperature";
    input MassFraction x "Vapour quality";
    output ThermodynamicState state "Thermodynamic state record";
  algorithm
    state := setState_ph(
            saturationPressure_sat(setSat_T(T)),
            (1 - x)*bubbleEnthalpy(setSat_T(T)) + x*dewEnthalpy(setSat_T(T)),
            2);
  end setState_Tx;

  replaceable function vapourQuality "Return vapour quality"
    extends Modelica.Icons.Function;
    input ThermodynamicState state "Thermodynamic state record";
    output MassFraction x "Vapour quality";
protected
    constant SpecificEnthalpy eps=1e-8;
  algorithm
    x := min(max((specificEnthalpy(state) - bubbleEnthalpy(setSat_p(pressure(
      state))))/(dewEnthalpy(setSat_p(pressure(state))) - bubbleEnthalpy(
      setSat_p(pressure(state))) + eps), 0), 1);
  end vapourQuality;

  redeclare replaceable function density_ph "Return density from p and h"
    extends Modelica.Icons.Function;
    input AbsolutePressure p "Pressure";
    input SpecificEnthalpy h "Specific enthalpy";
    input FixedPhase phase=0
      "2 for two-phase, 1 for one-phase, 0 if not known";
    output Density d "Density";
  algorithm
    d := density_phX(
            p,
            h,
            fill(0, 0),
            phase);
  end density_ph;

  redeclare replaceable function temperature_ph
    "Return temperature from p and h"
    extends Modelica.Icons.Function;
    input AbsolutePressure p "Pressure";
    input SpecificEnthalpy h "Specific enthalpy";
    input FixedPhase phase=0
      "2 for two-phase, 1 for one-phase, 0 if not known";
    output Temperature T "Temperature";
  algorithm
    T := temperature_phX(
            p,
            h,
            fill(0, 0),
            phase);
  end temperature_ph;

  redeclare replaceable function pressure_dT "Return pressure from d and T"
    extends Modelica.Icons.Function;
    input Density d "Density";
    input Temperature T "Temperature";
    input FixedPhase phase=0
      "2 for two-phase, 1 for one-phase, 0 if not known";
    output AbsolutePressure p "Pressure";
  algorithm
    p := pressure(setState_dTX(
            d,
            T,
            fill(0, 0),
            phase));
  end pressure_dT;

  redeclare replaceable function specificEnthalpy_dT
    "Return specific enthalpy from d and T"
    extends Modelica.Icons.Function;
    input Density d "Density";
    input Temperature T "Temperature";
    input FixedPhase phase=0
      "2 for two-phase, 1 for one-phase, 0 if not known";
    output SpecificEnthalpy h "Specific enthalpy";
  algorithm
    h := specificEnthalpy(setState_dTX(
            d,
            T,
            fill(0, 0),
            phase));
  end specificEnthalpy_dT;

  redeclare replaceable function specificEnthalpy_ps
    "Return specific enthalpy from p and s"
    extends Modelica.Icons.Function;
    input AbsolutePressure p "Pressure";
    input SpecificEntropy s "Specific entropy";
    input FixedPhase phase=0
      "2 for two-phase, 1 for one-phase, 0 if not known";
    output SpecificEnthalpy h "Specific enthalpy";
  algorithm
    h := specificEnthalpy_psX(
            p,
            s,
            fill(0, 0));
  end specificEnthalpy_ps;

  redeclare replaceable function temperature_ps
    "Return temperature from p and s"
    extends Modelica.Icons.Function;
    input AbsolutePressure p "Pressure";
    input SpecificEntropy s "Specific entropy";
    input FixedPhase phase=0
      "2 for two-phase, 1 for one-phase, 0 if not known";
    output Temperature T "Temperature";
  algorithm
    T := temperature_psX(
            p,
            s,
            fill(0, 0),
            phase);
  end temperature_ps;

  redeclare replaceable function density_ps "Return density from p and s"
    extends Modelica.Icons.Function;
    input AbsolutePressure p "Pressure";
    input SpecificEntropy s "Specific entropy";
    input FixedPhase phase=0
      "2 for two-phase, 1 for one-phase, 0 if not known";
    output Density d "Density";
  algorithm
    d := density_psX(
            p,
            s,
            fill(0, 0),
            phase);
  end density_ps;

  redeclare replaceable function specificEnthalpy_pT
    "Return specific enthalpy from p and T"
    extends Modelica.Icons.Function;
    input AbsolutePressure p "Pressure";
    input Temperature T "Temperature";
    input FixedPhase phase=0
      "2 for two-phase, 1 for one-phase, 0 if not known";
    output SpecificEnthalpy h "Specific enthalpy";
  algorithm
    h := specificEnthalpy_pTX(
            p,
            T,
            fill(0, 0),
            phase);
  end specificEnthalpy_pT;

  redeclare replaceable function density_pT "Return density from p and T"
    extends Modelica.Icons.Function;
    input AbsolutePressure p "Pressure";
    input Temperature T "Temperature";
    input FixedPhase phase=0
      "2 for two-phase, 1 for one-phase, 0 if not known";
    output Density d "Density";
  algorithm
    d := density(setState_pTX(
            p,
            T,
            fill(0, 0),
            phase));
  end density_pT;
end PartialSinglePhaseMedium;
