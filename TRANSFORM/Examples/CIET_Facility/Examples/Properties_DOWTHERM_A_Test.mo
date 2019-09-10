within TRANSFORM.Examples.CIET_Facility.Examples;
model Properties_DOWTHERM_A_Test "Generate data for external plot file"
  extends TRANSFORM.Icons.Example;
  package Medium =
      TRANSFORM.Media.Fluids.DOWTHERM.LinearDOWTHERM_A_95C;
  Medium.BaseProperties medium;
  SI.DynamicViscosity eta = Medium.dynamicViscosity(medium.state);
  SI.ThermalConductivity lambda = Medium.thermalConductivity(medium.state);
  SI.SpecificHeatCapacity cp=Medium.specificHeatCapacityCp(medium.state);
  Modelica.Blocks.Sources.Constant p(k=1e5)
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
  Modelica.Blocks.Sources.Ramp T(
    duration=1,
    height=280,
    offset=20 + 273.15)
    annotation (Placement(transformation(extent={{-40,40},{-20,60}})));
equation
  medium.p =p.y;
  medium.T =T.y;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    __Dymola_Commands(file="../../../Dymola/plotsco2.mos" "plotsco2"));
end Properties_DOWTHERM_A_Test;
