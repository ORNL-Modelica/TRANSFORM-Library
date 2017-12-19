within TRANSFORM.Media.Interfaces.Fluids;
partial package PartialPureSubstance "Base class for pure substances of one chemical substance"
  //extends Modelica.Media.Interfaces.PartialMedium
  extends TRANSFORM.Media.Interfaces.Fluids.PartialMedium(final reducedX=true, final
      fixedX=true);

  replaceable function setState_pT "Return thermodynamic state from p and T"
    extends Modelica.Icons.Function;
    input AbsolutePressure p "Pressure";
    input Temperature T "Temperature";
    output ThermodynamicState state "Thermodynamic state record";
  algorithm
    state := setState_pTX(
            p,
            T,
            fill(0, 0));
  end setState_pT;

  replaceable function setState_ph "Return thermodynamic state from p and h"
    extends Modelica.Icons.Function;
    input AbsolutePressure p "Pressure";
    input SpecificEnthalpy h "Specific enthalpy";
    output ThermodynamicState state "Thermodynamic state record";
  algorithm
    state := setState_phX(
            p,
            h,
            fill(0, 0));
  end setState_ph;

  replaceable function setState_ps "Return thermodynamic state from p and s"
    extends Modelica.Icons.Function;
    input AbsolutePressure p "Pressure";
    input SpecificEntropy s "Specific entropy";
    output ThermodynamicState state "Thermodynamic state record";
  algorithm
    state := setState_psX(
            p,
            s,
            fill(0, 0));
  end setState_ps;

  replaceable function setState_dT "Return thermodynamic state from d and T"
    extends Modelica.Icons.Function;
    input Density d "Density";
    input Temperature T "Temperature";
    output ThermodynamicState state "Thermodynamic state record";
  algorithm
    state := setState_dTX(
            d,
            T,
            fill(0, 0));
  end setState_dT;

  replaceable function density_ph "Return density from p and h"
    extends Modelica.Icons.Function;
    input AbsolutePressure p "Pressure";
    input SpecificEnthalpy h "Specific enthalpy";
    output Density d "Density";
  algorithm
    d := density_phX(
            p,
            h,
            fill(0, 0));
  end density_ph;

  replaceable function temperature_ph "Return temperature from p and h"
    extends Modelica.Icons.Function;
    input AbsolutePressure p "Pressure";
    input SpecificEnthalpy h "Specific enthalpy";
    output Temperature T "Temperature";
  algorithm
    T := temperature_phX(
            p,
            h,
            fill(0, 0));
  end temperature_ph;

  replaceable function pressure_dT "Return pressure from d and T"
    extends Modelica.Icons.Function;
    input Density d "Density";
    input Temperature T "Temperature";
    output AbsolutePressure p "Pressure";
  algorithm
    p := pressure(setState_dTX(
            d,
            T,
            fill(0, 0)));
  end pressure_dT;

  replaceable function specificEnthalpy_dT
    "Return specific enthalpy from d and T"
    extends Modelica.Icons.Function;
    input Density d "Density";
    input Temperature T "Temperature";
    output SpecificEnthalpy h "Specific enthalpy";
  algorithm
    h := specificEnthalpy(setState_dTX(
            d,
            T,
            fill(0, 0)));
  end specificEnthalpy_dT;

  replaceable function specificEnthalpy_ps
    "Return specific enthalpy from p and s"
    extends Modelica.Icons.Function;
    input AbsolutePressure p "Pressure";
    input SpecificEntropy s "Specific entropy";
    output SpecificEnthalpy h "Specific enthalpy";
  algorithm
    h := specificEnthalpy_psX(
            p,
            s,
            fill(0, 0));
  end specificEnthalpy_ps;

  replaceable function temperature_ps "Return temperature from p and s"
    extends Modelica.Icons.Function;
    input AbsolutePressure p "Pressure";
    input SpecificEntropy s "Specific entropy";
    output Temperature T "Temperature";
  algorithm
    T := temperature_psX(
            p,
            s,
            fill(0, 0));
  end temperature_ps;

  replaceable function density_ps "Return density from p and s"
    extends Modelica.Icons.Function;
    input AbsolutePressure p "Pressure";
    input SpecificEntropy s "Specific entropy";
    output Density d "Density";
  algorithm
    d := density_psX(
            p,
            s,
            fill(0, 0));
  end density_ps;

  replaceable function specificEnthalpy_pT
    "Return specific enthalpy from p and T"
    extends Modelica.Icons.Function;
    input AbsolutePressure p "Pressure";
    input Temperature T "Temperature";
    output SpecificEnthalpy h "Specific enthalpy";
  algorithm
    h := specificEnthalpy_pTX(
            p,
            T,
            fill(0, 0));
  end specificEnthalpy_pT;

  replaceable function density_pT "Return density from p and T"
    extends Modelica.Icons.Function;
    input AbsolutePressure p "Pressure";
    input Temperature T "Temperature";
    output Density d "Density";
  algorithm
    d := density(setState_pTX(
            p,
            T,
            fill(0, 0)));
  end density_pT;

  redeclare replaceable partial model extends BaseProperties(final
      standardOrderComponents=true)
  end BaseProperties;
end PartialPureSubstance;
