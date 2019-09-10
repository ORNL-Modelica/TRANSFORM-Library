within TRANSFORM.Examples.SupercriticalCO2.Examples;
model Properties_CO2_Test "Generate data for external plot file"
  extends TRANSFORM.Icons.Example;
  package Medium = Modelica.Media.IdealGases.SingleGases.CO2;
  //package Medium = HelmholtzMedia.HelmholtzFluids.Carbondioxide;
  //package Medium = ExternalMedia.Examples.CO2CoolProp; //Recommended but requires VS2012 compiler option
  //package Medium = ExternalMedia.Examples.CO2RefProp; //Does not work
  //package Medium = ExternalMedia.Examples.CO2StanMix; //Does not work
  Medium.BaseProperties mediums[4];
  SI.DynamicViscosity etas[4] = Medium.dynamicViscosity(mediums.state);
  SI.ThermalConductivity lambdas[4] = Medium.thermalConductivity(mediums.state);
  SI.SpecificHeatCapacity cps[4]=Medium.specificHeatCapacityCp(mediums.state);
  Modelica.Blocks.Sources.Constant ps[4](k={7.377,7.5,7.7,8}*1e6)
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
  Modelica.Blocks.Sources.Ramp Ts[4](
    height=10,
    duration=1,
    offset=25 + 273.15)
    annotation (Placement(transformation(extent={{-40,40},{-20,60}})));
equation
  mediums.p =ps.y;
  mediums.T =Ts.y;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    __Dymola_Commands(file="../../../Dymola/plotsco2.mos" "plotsco2"));
end Properties_CO2_Test;
