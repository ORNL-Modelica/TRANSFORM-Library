within TRANSFORM.Media.Solids.Examples;
model ZrHx "Compares some ZrHx results"
  extends TRANSFORM.Icons.Example;
  parameter Integer n = 5;
  parameter SI.Temperature[n] Ts = {100,300,500,700,900};
  replaceable package ZrH1p6 =
      TRANSFORM.Media.Solids.ZrHx(X=1.6);
  replaceable package ZrH1p9 =
      TRANSFORM.Media.Solids.ZrHx(X=1.9);
  ZrH1p6.BaseProperties zrh1p6[n];
  SI.ThermalConductivity lambda1p6[n] = ZrH1p6.thermalConductivity(zrh1p6.state);
  SI.ThermalConductivity cp1p6[n] = ZrH1p6.specificHeatCapacityCp(zrh1p6.state);
  ZrH1p9.BaseProperties zrh1p9[n];
  SI.ThermalConductivity lambda1p9[n] = ZrH1p9.thermalConductivity(zrh1p9.state);
  SI.ThermalConductivity cp1p9[n] = ZrH1p9.specificHeatCapacityCp(zrh1p9.state);
  TRANSFORM.Utilities.ErrorAnalysis.UnitTests unitTests(n=30,
         x=cat(1,zrh1p6.d,lambda1p6,cp1p6,zrh1p9.d,lambda1p9,cp1p9))
    annotation (Placement(transformation(extent={{80,80},{100,100}})));
equation
  zrh1p6.T = Ts;
  zrh1p9.T = Ts;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end ZrHx;
