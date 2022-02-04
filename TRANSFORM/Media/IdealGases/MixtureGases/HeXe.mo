within TRANSFORM.Media.IdealGases.MixtureGases;
package HeXe "Helium xenon mixture (Change reference_X to customize)"
  //To get a known molar mass (MM_X) here is how to set X (X is the He fraction, 1-X is the Xe fraction):
  //X = MM_He/MM_X * (MM_Xe-MM_X)/(MM_Xe-MM_He)
  //Ex. MM_X = 15 gm/mol, X = 0.2437862
  extends Modelica.Media.IdealGases.Common.MixtureGasNasa(
    mediumName="HeliumXenon",
    data={Modelica.Media.IdealGases.Common.SingleGasesData.He,Modelica.Media.IdealGases.Common.SingleGasesData.Xe},
    fluidConstants={Modelica.Media.IdealGases.Common.FluidData.He,TRANSFORM.Media.IdealGases.Common.FluidData.Xe},
    substanceNames={"Helium","Xenon"},
    reference_X={0.5,0.5},
    fixedX=true);
  constant TRANSFORM.Media.IdealGases.Common.AdditionalDataRecord addData[2] = {TRANSFORM.Media.IdealGases.Common.SingleGasesData.He,TRANSFORM.Media.IdealGases.Common.SingleGasesData.Xe};

  redeclare replaceable function thermalConductivity
    input ThermodynamicState state;
    input Integer method=methodForThermalConductivity;
    output ThermalConductivity lambda "Thermal conductivity";
  protected
      ThermalConductivity[nX] lambdaX "Component thermal conductivities";
  algorithm
      for i in 1:nX loop
    assert(fluidConstants[i].hasCriticalData, "Critical data for "+ fluidConstants[i].chemicalFormula +
       " not known. Can not compute thermal conductivity.");
    lambdaX[i] := TRANSFORM.Media.IdealGases.Common.Functions.thermalConductivity(state.T,data[i],addData[i]);
      end for;
      lambda := lowPressureThermalConductivity(massToMoleFractions(state.X,
                                   fluidConstants[:].molarMass),
                           state.T,
                           fluidConstants[:].criticalTemperature,
                           fluidConstants[:].criticalPressure,
                           fluidConstants[:].molarMass,
                           lambdaX);
      annotation (smoothOrder=2);
  end thermalConductivity;

  redeclare replaceable function dynamicViscosity
    input ThermodynamicState state;
    output DynamicViscosity eta "Dynamic viscosity";
  protected
      DynamicViscosity[nX] etaX "Component dynamic viscosities";
  algorithm
      for i in 1:nX loop
    etaX[i] := TRANSFORM.Media.IdealGases.Common.Functions.dynamicViscosity(state.T,data[i],addData[i]);
      end for;
      eta := gasMixtureViscosity(massToMoleFractions(state.X,
                             fluidConstants[:].molarMass),fluidConstants[:].molarMass,etaX);
      annotation (smoothOrder=2);
  end dynamicViscosity;
  annotation (Documentation(info="<html>

</html>"));
end HeXe;
