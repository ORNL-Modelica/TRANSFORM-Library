within TRANSFORM.Media.Interfaces.Fluids;
partial package PartialSinglePhaseMedium "Base class for single phase medium of one substance"
  extends TRANSFORM.Media.Interfaces.Fluids.PartialPureSubstance(redeclare
    record
      FluidConstants = Modelica.Media.Interfaces.Types.Basic.FluidConstants);

  constant FluidConstants[nS] fluidConstants "Constant data for the fluid";

  redeclare replaceable record extends ThermodynamicState
    "A selection of variables that uniquely defines the thermodynamic state"
    AbsolutePressure p "Absolute pressure of medium";
    Temperature T "Temperature of medium";
  end ThermodynamicState;

  redeclare replaceable function extends molarMass
    "Return the molar mass of the medium"
  algorithm
    MM := fluidConstants[1].molarMass;
  end molarMass;

  redeclare replaceable function specificEnthalpy_pTX
    "Return specific enthalpy from pressure, temperature and mass fraction"
    extends Modelica.Icons.Function;
    input AbsolutePressure p "Pressure";
    input Temperature T "Temperature";
    input MassFraction X[:] "Mass fractions";
    output SpecificEnthalpy h "Specific enthalpy at p, T, X";
  algorithm
    h := specificEnthalpy(setState_pTX(
            p,
            T,
            X));
  end specificEnthalpy_pTX;

  redeclare replaceable function temperature_phX
    "Return temperature from p, h, and X or Xi"
    extends Modelica.Icons.Function;
    input AbsolutePressure p "Pressure";
    input SpecificEnthalpy h "Specific enthalpy";
    input MassFraction X[:] "Mass fractions";
    output Temperature T "Temperature";
  algorithm
    T := temperature(setState_phX(
            p,
            h,
            X));
  end temperature_phX;

  redeclare replaceable function density_phX
    "Return density from p, h, and X or Xi"
    extends Modelica.Icons.Function;
    input AbsolutePressure p "Pressure";
    input SpecificEnthalpy h "Specific enthalpy";
    input MassFraction X[:] "Mass fractions";
    output Density d "Density";
  algorithm
    d := density(setState_phX(
            p,
            h,
            X));
  end density_phX;

  redeclare replaceable function temperature_psX
    "Return temperature from p, s, and X or Xi"
    extends Modelica.Icons.Function;
    input AbsolutePressure p "Pressure";
    input SpecificEntropy s "Specific entropy";
    input MassFraction X[:] "Mass fractions";
    output Temperature T "Temperature";
  algorithm
    T := temperature(setState_psX(
            p,
            s,
            X));
  end temperature_psX;

  redeclare replaceable function density_psX
    "Return density from p, s, and X or Xi"
    extends Modelica.Icons.Function;
    input AbsolutePressure p "Pressure";
    input SpecificEntropy s "Specific entropy";
    input MassFraction X[:] "Mass fractions";
    output Density d "Density";
  algorithm
    d := density(setState_psX(
            p,
            s,
            X));
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
