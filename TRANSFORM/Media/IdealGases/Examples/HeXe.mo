within TRANSFORM.Media.IdealGases.Examples;
model HeXe "Test of HeXe using default mixture"
  extends TRANSFORM.Icons.Example;
  parameter Integer n = 3;
  parameter SI.Temperature[n] Ts = {500,2000,5000};
  parameter SI.Pressure[n] ps = fill(1e5,3);
  replaceable package Medium =
      TRANSFORM.Media.IdealGases.MixtureGases.HeXe;
  Medium.BaseProperties mediums[n];
  SI.DynamicViscosity eta[n] = Medium.dynamicViscosity(mediums.state);
  SI.ThermalConductivity lambda[n] = Medium.thermalConductivity(mediums.state);
  SI.Density d_exp[n] = {0.18686399,0.046715997,0.018686399};
  SI.DynamicViscosity eta_exp[n] = {2.8623059e-05,7.183343e-05,0.00013018322};
  SI.ThermalConductivity lambda_exp[n] = {0.021353705,0.008118751,0.014723322};
  TRANSFORM.Utilities.ErrorAnalysis.UnitTests unitTests(
    n=9,
    x=cat(
        1,
        mediums.d,
        eta,
        lambda),
    x_reference=cat(
        1,
        d_exp,
        eta_exp,
        lambda_exp))
    annotation (Placement(transformation(extent={{80,80},{100,100}})));
equation
  mediums.p = ps;
  mediums.T = Ts;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end HeXe;
