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

  annotation (Documentation(info="<html>

</html>"));
end HeXe;
