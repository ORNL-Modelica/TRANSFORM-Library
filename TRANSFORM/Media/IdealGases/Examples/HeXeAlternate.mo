within TRANSFORM.Media.IdealGases.Examples;
model HeXeAlternate "Test of HeXe using alternate mixture"
  extends TRANSFORM.Icons.Example;
  parameter Integer n = 3;
  parameter SI.Temperature[n] Ts = {500,2000,5000};
  parameter SI.Pressure[n] ps = fill(1e5,3);
  replaceable package Medium =
      TRANSFORM.Media.IdealGases.HeXe(reference_X={0.25,0.75});
  Medium.BaseProperties mediums[n];
  SI.DynamicViscosity eta[n] = Medium.dynamicViscosity(mediums.state);
  SI.ThermalConductivity lambda[n] = Medium.thermalConductivity(mediums.state);
  SI.Density d_exp[n] = {0.35285044,0.08821261,0.035285044};
  SI.DynamicViscosity eta_exp[n] = {3.3651588e-05,8.628391e-05,0.00015639707};
  SI.ThermalConductivity lambda_exp[n] = {0.011834513,0.014603701,0.026483329};
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
end HeXeAlternate;
