within TRANSFORM.Media.Fluids.Examples;
model IncompressibleLithium
  extends TRANSFORM.Icons.Example;
  parameter Integer n = 3;
  parameter SI.Temperature[n] Ts = {455,950,1500};
  parameter SI.Pressure[n] ps = fill(1e5,3);
  replaceable package Medium =
      TRANSFORM.Media.Fluids.Lithium.Lithium_Incompressible;
  Medium.BaseProperties mediums[n];
  SI.DynamicViscosity eta[n] = Medium.dynamicViscosity(mediums.state);
  SI.ThermalConductivity lambda[n] = Medium.thermalConductivity(mediums.state);
  SI.DynamicViscosity eta_exp[n] = {0.0006337235,0.000257527,0.00019011452};
  SI.ThermalConductivity lambda_exp[n] = {44.256348,57.141937,71.45926};
  TRANSFORM.Utilities.ErrorAnalysis.UnitTests unitTests(
    n=9,
    x=cat(
        1,
        eta,
        lambda),
    x_reference=cat(
        1,
        eta_exp,
        lambda_exp))
    annotation (Placement(transformation(extent={{80,80},{100,100}})));
equation
  mediums.p = ps;
  mediums.T = Ts;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end IncompressibleLithium;
