within TRANSFORM.Media.IdealGases;
package SingleGases "Custom ideal gases of a single component"
  package He "Ideal gas \"He\""
    //Identical to MSL He except for the addition of temperature dependent thermal conductivity and viscosity
    extends Modelica.Media.IdealGases.Common.SingleGasNasa(
      mediumName="Helium",
      data=Modelica.Media.IdealGases.Common.SingleGasesData.He,
      fluidConstants={Modelica.Media.IdealGases.Common.FluidData.He});

    constant TRANSFORM.Media.IdealGases.Common.AdditionalDataRecord addData = TRANSFORM.Media.IdealGases.Common.SingleGasesData.He;

    redeclare replaceable function thermalConductivity
      "Thermal conductivity of gas"
      input ThermodynamicState state "Thermodynamic state record";
      input Integer method=1;
      output ThermalConductivity lambda "Thermal conductivity";
    algorithm
      assert(fluidConstants[1].hasCriticalData,
      "Failed to compute thermalConductivity: For the species \"" + mediumName + "\" no critical data is available.");
      lambda := TRANSFORM.Media.IdealGases.Common.Functions.thermalConductivity(state.T,data,addData)
      annotation (smoothOrder=2);
    end thermalConductivity;

    redeclare replaceable function dynamicViscosity
      "Dynamic viscosity of gas"
      input ThermodynamicState state "Thermodynamic state record";
      output DynamicViscosity eta "Dynamic viscosity";
    algorithm
      assert(fluidConstants[1].hasCriticalData,
      "Failed to compute dynamicViscosity: For the species \"" + mediumName + "\" no critical data is available.");
      eta := TRANSFORM.Media.IdealGases.Common.Functions.dynamicViscosity(state.T,data,addData)    annotation (smoothOrder=2);
    end dynamicViscosity;
    annotation (Documentation(info="<html>
      <img src=\"modelica://Modelica/Resources/Images/Media/IdealGases/SingleGases/He.png\"></html>"));
  end He;
  extends Modelica.Icons.VariantsPackage;
  package HeXe
    "Ideal gas \"HeXe\" (set constant X when instantiated)"
    //https://doi.org/10.1063/1.555703
    extends TRANSFORM.Icons.UnderConstruction;
    extends Modelica.Media.IdealGases.Common.SingleGasNasa(
      mediumName="HeXe",
      data=TRANSFORM.Media.IdealGases.Common.SingleGasesData.HeXe,
      fluidConstants={TRANSFORM.Media.IdealGases.Common.FluidData.HeXe});
      //The data and fluidConstants are for MM=40 only ATM
      //parameter Real reference_X[2];

      //constant SI.MolarMass MM_He = 0.004002602;

      //constant SI.MolarMass MM_Xe = 0.131293;

      //constant SI.MolarMass MMmix = reference_X[1]*MM_He + reference_X[2]*MM_Xe;
      //constant SI.SpecificHeatCapacity Rmix = Modelica.Constants.R/MMmix;
      constant Real refX = 0.7172026;
      constant Real xx[:] = {0.00,0.25,0.50,0.75,1.00};
      constant Real Ts[:] = {50.00,100.00,150.00,200.00,250.00,273.15,293.15,
                            300.00,313.15,333.15,353.15,373.15,423.15,473.15,
                            523.15,573.15,623.15,673.15,723.15,773.15,873.15,
                            973.15,1073.15,1173.15,1273.15,1773.15,2273.15,
                            2773.15,3273.15};

      constant Real tc_table[:,:] =  {{0.00113,0.00441,0.00974,0.01991,0.04717},
                                      {0.00198,0.00761,0.01656,0.03317,0.09863},
                                      {0.00281,0.01035,0.02223,0.04401,0.07554},
                                      {0.00366,0.01291,0.02739,0.05376,0.11932},
                                      {0.00457,0.01539,0.03228,0.06291,0.13853},
                                      {0.005,0.01652,0.03449,0.06702,0.14704},
                                      {0.00537,0.0175,0.03639,0.07052,0.15423},
                                      {0.0055,0.01782,0.03701,0.07167,0.15666},
                                      {0.00575,0.0184,0.03811,0.07375,0.16129},
                                      {0.00611,0.01927,0.03979,0.07691,0.16822},
                                      {0.00648,0.02015,0.04146,0.08004,0.17504},
                                      {0.00683,0.02101,0.04311,0.08313,0.18175},
                                      {0.00769,0.0231,0.04714,0.09069,0.19811},
                                      {0.00852,0.02512,0.05103,0.098,0.21396},
                                      {0.00931,0.02706,0.05479,0.10509,0.22937},
                                      {0.01006,0.02894,0.05844,0.11198,0.24439},
                                      {0.01079,0.03076,0.06198,0.11869,0.25907},
                                      {0.0115,0.03254,0.06544,0.12525,0.27344},
                                      {0.01218,0.03427,0.06882,0.13168,0.28754},
                                      {0.01284,0.03595,0.07213,0.13798,0.30139},
                                      {0.01411,0.03922,0.07857,0.15025,0.32843},
                                      {0.01531,0.04237,0.08478,0.16214,0.3547},
                                      {0.01646,0.04541,0.09082,0.1737,0.3803},
                                      {0.01756,0.04835,0.09669,0.18498,0.40533},
                                      {0.01862,0.05122,0.10242,0.19601,0.42984},
                                      {0.02344,0.06461,0.1294,0.24818,0.5463},
                                      {0.0277,0.07686,0.15436,0.29672,0.65533},
                                      {0.0316,0.08834,0.17791,0.34272,0.75914},
                                      {0.03524,0.09925,0.20039,0.38679,0.85901}};

    constant Real eta_table[:,:] =   {{4.7700E-06,5.1400E-06,5.6800E-06,6.4200E-06,6.0400E-06},
                                      {8.3400E-06,9.0000E-06,9.9000E-06,1.1050E-05,9.6600E-06},
                                      {1.1810E-05,1.2650E-05,1.3760E-05,1.5080E-05,1.2610E-05},
                                      {1.5420E-05,1.6360E-05,1.7570E-05,1.8890E-05,1.5260E-05},
                                      {1.9230E-05,2.0200E-05,2.1440E-05,2.2610E-05,1.7720E-05},
                                      {2.1040E-05,2.2020E-05,2.3240E-05,2.4310E-05,1.8810E-05},
                                      {2.2620E-05,2.3600E-05,2.4790E-05,2.5760E-05,1.9730E-05},
                                      {2.3160E-05,2.4140E-05,2.5320E-05,2.6250E-05,2.0040E-05},
                                      {2.4190E-05,2.5170E-05,2.6330E-05,2.7190E-05,2.0630E-05},
                                      {2.5750E-05,2.6710E-05,2.7840E-05,2.8590E-05,2.1520E-05},
                                      {2.7280E-05,2.8230E-05,2.9330E-05,2.9960E-05,2.2400E-05},
                                      {2.8770E-05,2.9710E-05,3.0780E-05,3.1310E-05,2.3250E-05},
                                      {3.2390E-05,3.3310E-05,3.4290E-05,3.4550E-05,2.5350E-05},
                                      {3.5850E-05,3.6740E-05,3.7650E-05,3.7660E-05,2.7380E-05},
                                      {3.9160E-05,4.0020E-05,4.0860E-05,4.0660E-05,2.9350E-05},
                                      {4.2340E-05,4.3180E-05,4.3960E-05,4.3540E-05,3.1280E-05},
                                      {4.5400E-05,4.6230E-05,4.6950E-05,4.6340E-05,3.3160E-05},
                                      {4.8360E-05,4.9170E-05,4.9840E-05,4.9050E-05,3.5000E-05},
                                      {5.1220E-05,5.2020E-05,5.2650E-05,5.1690E-05,3.6800E-05},
                                      {5.3990E-05,5.4780E-05,5.5370E-05,5.4270E-05,3.8580E-05},
                                      {5.9300E-05,6.0090E-05,6.0620E-05,5.9250E-05,4.2040E-05},
                                      {6.4340E-05,6.5130E-05,6.5620E-05,6.4030E-05,4.5410E-05},
                                      {6.9150E-05,6.9950E-05,7.0420E-05,6.8630E-05,4.8690E-05},
                                      {7.3760E-05,7.4580E-05,7.5040E-05,7.3090E-05,5.1900E-05},
                                      {7.8190E-05,7.9050E-05,7.9510E-05,7.7420E-05,5.5040E-05},
                                      {9.8370E-05,9.9440E-05,1.0004E-04,9.7540E-05,6.9960E-05},
                                      {1.1623E-04,1.1759E-04,1.1848E-04,1.1587E-04,8.3940E-05},
                                      {1.3257E-04,1.3426E-04,1.3551E-04,1.3298E-04,9.7240E-05},
                                      {1.4784E-04,1.4988E-04,1.5153E-04,1.4918E-04,1.1004E-04}};

     redeclare replaceable function thermalConductivity
      "Thermal conductivity of gas"
      input ThermodynamicState state "Thermodynamic state record";
      input Integer method=1;
      output SI.ThermalConductivity lambda "Thermal conductivity";
     algorithm
      lambda := TRANSFORM.Math.interpolate2D(Ts,xx,tc_table,state.T,refX);
       annotation (smoothOrder=2);
     end thermalConductivity;

    redeclare replaceable function dynamicViscosity
      "Dynamic vicosity of gas"
      input ThermodynamicState state "Thermodynamic state record";
      output SI.DynamicViscosity eta "Dynamic viscosity";
    algorithm
      eta := TRANSFORM.Math.interpolate2D(Ts,xx,eta_table,state.T,refX);
          annotation (smoothOrder=2);
    end dynamicViscosity;
    annotation (Documentation(info="<html>
      <img src=\"modelica://Modelica/Resources/Images/Media/IdealGases/SingleGases/He.png\"></html>"));
  end HeXe;

  package Xe "Ideal gas \"Xe\""
    //Expands on MSL technique to Xe as a working fluid and also
    //the addition of temperature dependent thermal conductivity and viscosity
    extends Modelica.Media.IdealGases.Common.SingleGasNasa(
      mediumName="Xenon",
      data=Modelica.Media.IdealGases.Common.SingleGasesData.Xe,
      fluidConstants={TRANSFORM.Media.IdealGases.Common.FluidData.Xe});

    constant TRANSFORM.Media.IdealGases.Common.AdditionalDataRecord addData = TRANSFORM.Media.IdealGases.Common.SingleGasesData.Xe;

    redeclare replaceable function thermalConductivity
      "Thermal conductivity of gas"
      input ThermodynamicState state "Thermodynamic state record";
      input Integer method=1;
      output ThermalConductivity lambda "Thermal conductivity";
    algorithm
      assert(fluidConstants[1].hasCriticalData,
      "Failed to compute thermalConductivity: For the species \"" + mediumName + "\" no critical data is available.");
      lambda := TRANSFORM.Media.IdealGases.Common.Functions.thermalConductivity(state.T,data,addData)
      annotation (smoothOrder=2);
    end thermalConductivity;

    redeclare replaceable function dynamicViscosity
      "Dynamic viscosity of gas"
      input ThermodynamicState state "Thermodynamic state record";
      output DynamicViscosity eta "Dynamic viscosity";
    algorithm
      assert(fluidConstants[1].hasCriticalData,
      "Failed to compute dynamicViscosity: For the species \"" + mediumName + "\" no critical data is available.");
      eta := TRANSFORM.Media.IdealGases.Common.Functions.dynamicViscosity(state.T,data,addData)    annotation (smoothOrder=2);
    end dynamicViscosity;
    annotation (Documentation(info="<html>
      <img src=\"modelica://Modelica/Resources/Images/Media/IdealGases/SingleGases/He.png\"></html>"));
  end Xe;

end SingleGases;
