within TRANSFORM.Utilities.Diagnostics.Examples;
model CheckEquality
  extends TRANSFORM.Icons.Example;
  TRANSFORM.Utilities.Diagnostics.CheckEquality check
    annotation (Placement(transformation(extent={{20,-4},{40,16}})));
  Modelica.Blocks.Sources.Constant con(k=0.1) "Input"
    annotation (Placement(transformation(extent={{-60,16},{-40,36}})));
  Modelica.Blocks.Sources.Sine sin1(f=1, amplitude=0.03) "Input"
    annotation (Placement(transformation(extent={{-60,-24},{-40,-4}})));
  Modelica.Blocks.Math.Add add "Adder to offset the sin input signal"
    annotation (Placement(transformation(extent={{-20,-14},{0,6}})));
  ErrorAnalysis.UnitTests unitTests(x={check.y})
    annotation (Placement(transformation(extent={{80,80},{100,100}})));
equation
  connect(con.y, check.u1) annotation (Line(points={{-39,26},{-20,26},{-20,
          12},{18,12}}, color={0,0,127}));
  connect(add.u1, con.y) annotation (Line(points={{-22,2},{-30,2},{-30,26},
          {-39,26}},
                color={0,0,127}));
  connect(sin1.y, add.u2) annotation (Line(points={{-39,-14},{-30,-14},{-30,
          -10},{-22,-10}},
               color={0,0,127}));
  connect(add.y, check.u2) annotation (Line(points={{1,-4},{10,-4},{10,0},{
          18,0}}, color={0,0,127}));
  annotation (Documentation(
    info="",
revisions="<html>
</html>"),
    experiment(Tolerance=1e-6, StopTime=1));
end CheckEquality;
