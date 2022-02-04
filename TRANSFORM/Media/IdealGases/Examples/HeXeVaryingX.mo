within TRANSFORM.Media.IdealGases.Examples;
model HeXeVaryingX "Test of HeXe using dynamic mixture"
  extends TRANSFORM.Icons.Example;
  parameter Integer n = 2;
  parameter SI.Temperature[n] Ts = {400,1200};
  parameter SI.Pressure[n] ps = fill(7e6,2);
  replaceable package Medium =
      TRANSFORM.Media.IdealGases.MixtureGases.HeXe (
                                      reference_X={0.25,0.75},fixedX=false);
  Medium.BaseProperties mediums[n];
  SI.DynamicViscosity eta[n] = Medium.dynamicViscosity(mediums.state);
  SI.ThermalConductivity lambda[n] = Medium.thermalConductivity(mediums.state);
  SI.SpecificHeatCapacity cp[n] = Medium.specificHeatCapacityCp(mediums.state);
  SI.PrandtlNumber pr[n] = Medium.prandtlNumber(mediums.state);
  Real z[n];
  SI.MolarHeatCapacity R[n] = Medium.gasConstant(mediums.state);
  SI.Density rho[n] = Medium.density(mediums.state);
  SI.MolarMass MM[n] = Medium.molarMass(mediums.state);

  Modelica.Blocks.Sources.Ramp ramp(
    height=-1,                      duration=1,
    offset=1)
    annotation (Placement(transformation(extent={{-12,-10},{8,10}})));
equation
  mediums.p = ps;
  mediums.T = Ts;
  mediums.X[1]=fill(ramp.y,n);
  mediums.X[2]=fill(1-ramp.y,n);
  z = MM*ps./Ts./Modelica.Constants.R./rho;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(__Dymola_Algorithm="Dassl"));
end HeXeVaryingX;
