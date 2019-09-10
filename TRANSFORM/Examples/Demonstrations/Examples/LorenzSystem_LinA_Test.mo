within TRANSFORM.Examples.Demonstrations.Examples;
model LorenzSystem_LinA_Test
  import TRANSFORM;
  extends Icons.Example;
  TRANSFORM.Examples.Demonstrations.Models.LorenzSystem lorenzSystem(
    rho=28,
    beta=8/3,
    x_start=0,
    y_start=1,
    z_start=1.05,
    sigma=add.y)
    annotation (Placement(transformation(extent={{-40,-30},{40,30}})));
  Modelica.Blocks.Sources.RealExpression realExpression(y=lorenzSystem.y)
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
  Modelica.Blocks.Interfaces.RealInput u annotation (Placement(transformation(
          extent={{-120,0},{-80,40}}), iconTransformation(extent={{-190,-16},{
            -150,24}})));
  Modelica.Blocks.Interfaces.RealOutput y annotation (Placement(transformation(
          extent={{90,-10},{110,10}}), iconTransformation(extent={{-186,-12},{
            -166,8}})));
  Modelica.Blocks.Sources.Constant const(k=10)
    annotation (Placement(transformation(extent={{-100,-30},{-80,-10}})));
  Modelica.Blocks.Math.Add add
    annotation (Placement(transformation(extent={{-70,-10},{-50,10}})));
  TRANSFORM.Utilities.ErrorAnalysis.UnitTests
                                    unitTests(
    printResult=false,
    n=3,
    x={lorenzSystem.x,lorenzSystem.y,lorenzSystem.z})
    annotation (Placement(transformation(extent={{80,80},{100,100}})));
equation
  connect(realExpression.y, y)
    annotation (Line(points={{81,0},{100,0}}, color={0,0,127}));
  connect(add.u1, u) annotation (Line(points={{-72,6},{-76,6},{-76,20},{-100,20}},
        color={0,0,127}));
  connect(add.u2, const.y) annotation (Line(points={{-72,-6},{-76,-6},{-76,-20},
          {-79,-20}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(StopTime=100, __Dymola_NumberOfIntervals=10000));
end LorenzSystem_LinA_Test;
