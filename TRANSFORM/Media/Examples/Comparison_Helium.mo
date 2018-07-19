within TRANSFORM.Media.Examples;
model Comparison_Helium

  extends TRANSFORM.Icons.Example;

  package Medium = Modelica.Media.IdealGases.SingleGases.He;
  //package Medium = TRANSFORM.Media.ExternalMedia.CoolProp.Helium;

  Medium.BaseProperties mediums[4](h(start=Medium.specificEnthalpy_pT(ps.k,Ts.offset)));

  SI.DynamicViscosity etas[4] = Medium.dynamicViscosity(mediums.state);
  SI.ThermalConductivity lambdas[4] = Medium.thermalConductivity(mediums.state);
  SI.SpecificHeatCapacity cps[4]=Medium.specificHeatCapacityCp(mediums.state);

  Modelica.Blocks.Sources.Constant ps[4](k=linspace(1e5,20e5,4))
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
end Comparison_Helium;
