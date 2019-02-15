within TRANSFORM.Media.LookupTableMedia.Examples;
model ParaHydrogen
  extends TRANSFORM.Icons.Example;
  replaceable package Medium =
      TRANSFORM.Media.LookupTableMedia.ParaHydrogen;
  Medium.BaseProperties medium(h(start=Medium.specificEnthalpy(Medium.setState_pT(p.k,T.offset))));
  Modelica.SIunits.DynamicViscosity eta=Medium.dynamicViscosity(medium.state);
  Modelica.SIunits.ThermalConductivity lambda=Medium.thermalConductivity(medium.state);
  Modelica.Blocks.Sources.Constant p(k=1e5)
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));
  Modelica.Blocks.Sources.Ramp T(
    height=5000,
    duration=1,
    offset=50)
    annotation (Placement(transformation(extent={{-60,-20},{-40,0}})));
equation
  medium.p = p.y;
  medium.h = Medium.specificEnthalpy(Medium.setState_pT(p.y,T.y));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end ParaHydrogen;
