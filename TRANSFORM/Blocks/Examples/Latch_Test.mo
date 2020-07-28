within TRANSFORM.Blocks.Examples;
model Latch_Test
  extends TRANSFORM.Icons.Example;

  Logical.Latch latch
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Sources.BooleanPulse booleanPulse(
    width=50,
    period=1,
    startTime=0.25)
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  Utilities.ErrorAnalysis.UnitTests unitTests(x={booleanToReal.y})
    annotation (Placement(transformation(extent={{80,80},{100,100}})));
  Modelica.Blocks.Math.BooleanToReal booleanToReal
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
equation
  connect(booleanPulse.y, latch.u)
    annotation (Line(points={{-19,0},{-12,0}}, color={255,0,255}));
  connect(latch.y, booleanToReal.u)
    annotation (Line(points={{11,0},{18,0}}, color={255,0,255}));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    experiment(__Dymola_NumberOfIntervals=100, __Dymola_Algorithm="Dassl"));
end Latch_Test;
