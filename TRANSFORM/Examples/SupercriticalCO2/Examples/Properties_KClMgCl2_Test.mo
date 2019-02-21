within TRANSFORM.Examples.SupercriticalCO2.Examples;
model Properties_KClMgCl2_Test "Generate data for external plot file"
  extends TRANSFORM.Icons.Example;
  package Medium =
      TRANSFORM.Media.Fluids.KClMgCl2.LinearKClMgCl2_67_33_pT;
  Medium.BaseProperties medium;
  SI.DynamicViscosity eta = Medium.dynamicViscosity(medium.state);
  SI.ThermalConductivity lambda = Medium.thermalConductivity(medium.state);
  SI.SpecificHeatCapacity cp=Medium.specificHeatCapacityCp(medium.state);
  Modelica.Blocks.Sources.Constant p(k=1e5)
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
  Modelica.Blocks.Sources.Ramp T(
    duration=1,
    height=500,
    offset=800 + 273.15)
    annotation (Placement(transformation(extent={{-40,40},{-20,60}})));
equation
  medium.p =p.y;
  medium.T =T.y;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    __Dymola_Commands(file="../../../Dymola/plotsco2.mos" "plotsco2"));
end Properties_KClMgCl2_Test;
