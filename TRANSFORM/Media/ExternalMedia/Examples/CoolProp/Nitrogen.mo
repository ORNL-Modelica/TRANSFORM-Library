within TRANSFORM.Media.ExternalMedia.Examples.CoolProp;
model Nitrogen
  extends TRANSFORM.Icons.Example;
  replaceable package Medium =
      TRANSFORM.Media.ExternalMedia.CoolProp.Nitrogen;
  Medium.BaseProperties medium(h(start=Medium.specificEnthalpy(Medium.setState_pT(p.k,T.offset))));
  SI.DynamicViscosity eta = Medium.dynamicViscosity(medium.state);
  SI.ThermalConductivity lambda = Medium.thermalConductivity(medium.state);

  Real p_c=Medium.fluidConstants[1].criticalPressure;
  Modelica.Blocks.Sources.Constant p(k=1e7)
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));
  Modelica.Blocks.Sources.Ramp T(
    height=5000,
    duration=1,
    offset=25 + 273.15)
    annotation (Placement(transformation(extent={{-60,-20},{-40,0}})));
equation
  medium.p = p.y;
  medium.h = Medium.specificEnthalpy(Medium.setState_pT(p.y,T.y));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Nitrogen;
