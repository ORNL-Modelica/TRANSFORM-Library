within TRANSFORM.Media.IdealGases.Common;
package Functions
  "Basic Functions for ideal gases: cp, h, s, thermal conductivity, viscosity"
  extends Modelica.Icons.FunctionsPackage;

  function thermalConductivity
    input SI.Temp_K T "Gas temperature";
    input Modelica.Media.IdealGases.Common.DataRecord data "Ideal gas data";
    input TRANSFORM.Media.IdealGases.Common.AdditionalDataRecord addData "Additional ideal gas data";
    output SI.ThermalConductivity lambda "Thermal conductivity of gas";
  protected
    Real lnlambda;
  algorithm
    lnlambda :=if T > data.Tlimit then addData.lambdahigh[1]*log(T) + addData.lambdahigh[2]/T + addData.lambdahigh[3]/T^2 +
      addData.lambdahigh[4] else addData.lambdalow[1]*log(T) + addData.lambdalow[2]/T + addData.lambdalow[3]/T^2 + addData.lambdalow[4];
    lambda := 1e-4*Modelica.Math.exp(lnlambda);
    annotation (smoothOrder=2);
  end thermalConductivity;

  function dynamicViscosity
    input SI.Temp_K T "Gas temperature";
    input Modelica.Media.IdealGases.Common.DataRecord data "Ideal gas data";
    input TRANSFORM.Media.IdealGases.Common.AdditionalDataRecord addData "Additional ideal gas data";
    output SI.DynamicViscosity eta "Dynamic viscosity of gas";
  protected
    Real lneta;
  algorithm
    lneta :=if T > data.Tlimit then addData.etahigh[1]*log(T) + addData.etahigh[2]/T + addData.etahigh[3]/T^2 +
      addData.etahigh[4] else addData.etalow[1]*log(T) + addData.etalow[2]/T + addData.etalow[3]/T^2 + addData.etalow[4];
    eta := 1e-7*Modelica.Math.exp(lneta);
    annotation (smoothOrder=2);
  end dynamicViscosity;

  function h_T "Compute specific enthalpy from temperature and gas data; reference is decided by the
    refChoice input, or by the referenceChoice package constant by default"
    import Modelica.Media.Interfaces.Choices;
    extends Modelica.Icons.Function;
    input Modelica.Media.IdealGases.Common.DataRecord data "Ideal gas data";
    input SI.Temperature T "Temperature";
    //input Boolean exclEnthForm=Modelica.Media.IdealGases.Common.Functions.excludeEnthalpyOfFormation
    //  "If true, enthalpy of formation Hf is not included in specific enthalpy h";
    input Modelica.Media.Interfaces.Choices.ReferenceEnthalpy
                                    refChoice=Modelica.Media.IdealGases.Common.Functions.referenceChoice
      "Choice of reference enthalpy";
    input SI.SpecificEnthalpy h_off=Modelica.Media.IdealGases.Common.Functions.h_offset
      "User defined offset for reference enthalpy, if referenceChoice = UserDefined";
    output SI.SpecificEnthalpy h "Specific enthalpy at temperature T";

  algorithm
    h := smooth(0, (if T < data.Tlimit then data.R*((-data.alow[1] + T*(data.blow[
      1] + data.alow[2]*Modelica.Math.log(T) + T*(1.*data.alow[3] + T*(0.5*data.alow[
      4] + T*(1/3*data.alow[5] + T*(0.25*data.alow[6] + 0.2*data.alow[7]*T))))))/
      T) else data.R*((-data.ahigh[1] + T*(data.bhigh[1] + data.ahigh[2]*
      Modelica.Math.log(T) + T*(1.*data.ahigh[3] + T*(0.5*data.ahigh[4] + T*(1/3*
      data.ahigh[5] + T*(0.25*data.ahigh[6] + 0.2*data.ahigh[7]*T))))))/T)) + (
      -data.Hf) + (if (refChoice == Choices.ReferenceEnthalpy.ZeroAt0K)
       then data.H0 else 0.0) + (if refChoice == Choices.ReferenceEnthalpy.UserDefined
       then h_off else 0.0));
    annotation (Inline=false,smoothOrder=2);
  end h_T;

  function gasTable2D
    "2D gas property table lookup for mixed gases with known Xi"
    input Real data;
    //First column T, second-last columns are data correspeodning to constant xx[i-1]
    input Real xx;
    input Real reference_X;
    output Real value;
  algorithm
    value := 5;
  end gasTable2D;
end Functions;
