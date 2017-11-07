within TRANSFORM.Fluid.Examples.SteamRankine_BalanceOfPlant.Components.Control;
block FWH_LP_level
  extends Interfaces.CondenserLevel;

  Modelica.Blocks.Sources.RealExpression level_setPoint(y=
        30)
           annotation (Placement(transformation(extent={{-50,-10},{-30,10}},
          rotation=0)));
  Controls.LimPID controller(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    initType=Modelica.Blocks.Types.InitPID.InitialOutput,
    Td=0.1,
    Ti=200,
    k=-1,
    yMax=100,
    yMin=0.001,
    y_start=1200*(100/20000))
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Math.Gain scaling_out(k=20000/100)
    annotation (Placement(transformation(extent={{34,-10},{54,10}})));
equation
  connect(level_setPoint.y, controller.u_s)
    annotation (Line(points={{-29,0},{-12,0}}, color={0,0,127}));
  connect(u_m_level, controller.u_m) annotation (Line(points={{-120,0},{-88,0},
          {-88,-30},{0,-30},{0,-12}}, color={0,0,127}));
  connect(scaling_out.u, controller.y)
    annotation (Line(points={{32,0},{11,0}}, color={0,0,127}));
  connect(scaling_out.y, y)
    annotation (Line(points={{55,0},{110,0}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end FWH_LP_level;
