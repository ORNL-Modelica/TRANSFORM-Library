within TRANSFORM.Media.LookupTableMedia.Examples;
model ParaHydrogen
  extends TRANSFORM.Icons.Example;
  replaceable package Medium =
      TRANSFORM.Media.LookupTableMedia.ParaHydrogen;
  Medium.BaseProperties medium(T(start=T.offset));
  Modelica.Units.SI.DynamicViscosity eta=Medium.dynamicViscosity(medium.state);
  Modelica.Units.SI.ThermalConductivity lambda=Medium.thermalConductivity(
      medium.state);

 Real few = Medium.fluidConstants[1].criticalPressure;
  Modelica.Blocks.Sources.Constant p(k=1e5)
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));
  Modelica.Blocks.Sources.Ramp T(
    height=5000,
    duration=1,
    offset=50)
    annotation (Placement(transformation(extent={{-60,-20},{-40,0}})));
equation
  medium.p = p.y;
  medium.T = T.y;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end ParaHydrogen;
