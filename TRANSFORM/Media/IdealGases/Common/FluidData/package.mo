within TRANSFORM.Media.IdealGases.Common;
package FluidData
  extends Modelica.Icons.Package;

  import Modelica.Media.Interfaces.PartialMixtureMedium;
  import Modelica.Media.IdealGases.Common.SingleGasesData;
    constant Modelica.Media.Interfaces.Types.IdealGas.FluidConstants Xe(
                       chemicalFormula =        "Xe",
                       iupacName =              "unknown",
                       structureFormula =       "unknown",
                       casRegistryNumber =      "7440-63-3",
                       meltingPoint =           161.40,
                       normalBoilingPoint =     165.051,
                       criticalTemperature =    289.733,
                       criticalPressure =         8.1747e4,
                       criticalMolarVolume =     1/8400,
                       acentricFactor =           0.00363,
                       dipoleMoment =             0.0,
                       molarMass =              SingleGasesData.Xe.MM,
                       hasDipoleMoment =       true,
                       hasIdealGasHeatCapacity=true,
                       hasCriticalData =       true,
                       hasAcentricFactor =     true);

end FluidData;
