within TRANSFORM.Media.IdealGases.Examples;
model HeXeVaryingX "Test of HeXe using dynamic mixture"
  extends TRANSFORM.Icons.Example;
  parameter Integer n = 3;
  parameter SI.Temperature[n] Ts = {500,2000,5000};
  parameter SI.Pressure[n] ps = fill(1e5,3);
  replaceable package Medium =
      TRANSFORM.Media.IdealGases.MixtureGases.HeXe (
                                      reference_X={0.25,0.75},fixedX=false);
  Medium.BaseProperties mediums[n];
  SI.DynamicViscosity eta[n] = Medium.dynamicViscosity(mediums.state);
  SI.ThermalConductivity lambda[n] = Medium.thermalConductivity(mediums.state);
  SI.SpecificHeatCapacity cp[n] = Medium.specificHeatCapacityCp(mediums.state);

  Modelica.Blocks.Sources.Ramp ramp(duration=1)
    annotation (Placement(transformation(extent={{-12,-10},{8,10}})));
equation
  mediums.p = ps;
  mediums.T = Ts;
  mediums.X[1]=fill(ramp.y,n);
  mediums.X[2]=fill(1-ramp.y,n);
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(__Dymola_Algorithm="Dassl"));
end HeXeVaryingX;
