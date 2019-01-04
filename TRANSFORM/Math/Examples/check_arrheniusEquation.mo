within TRANSFORM.Math.Examples;
model check_arrheniusEquation

  extends TRANSFORM.Icons.Example;

  parameter SI.Temperature T=350 "Temperature";
  parameter Real A=10 "Pre-exponential factor";
  parameter SI.MolarEnergy Ea=1e4 "Activation energy";
  parameter SI.MolarHeatCapacity R=Modelica.Constants.R
    "Universal gas constant";
  //   parameter Real beta = 1.0 "Correction factor";

  Real y;

  Utilities.ErrorAnalysis.UnitTests unitTests(x={y})
    annotation (Placement(transformation(extent={{80,80},{100,100}})));

  Modelica.Blocks.Sources.Sine beta(freqHz=1/10, offset=1)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
equation
  y = arrheniusEquation(
    T,
    A,
    Ea,
    R,
    beta.y);

  annotation (experiment(StopTime=10), Documentation(info="<html>
</html>"));
end check_arrheniusEquation;
