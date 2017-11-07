within TRANSFORM.Fluid.Examples.SteamRankine_BalanceOfPlant.Components.Control;
block FWH_HP_level
  extends Interfaces.CondenserLevel;

  Controls.LimPID                           controller(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    yMin=0,
    initType=Modelica.Blocks.Types.InitPID.InitialOutput,
    Td=0.1,
    k=-1,
    Ti=200,
    yMax=100,
    y_start=40)
    annotation (Placement(transformation(extent={{-12,-10},{9,10}})));
  Modelica.Blocks.Sources.RealExpression level_setPoint(y=
        30)
           annotation (Placement(transformation(extent={{-56,-10},{-36,10}},
          rotation=0)));
  Modelica.Blocks.Math.Gain scaling_out(k=1/100)
    annotation (Placement(transformation(extent={{32,-10},{52,10}})));
equation
  connect(level_setPoint.y, controller.u_s)
    annotation (Line(points={{-35,0},{-14.1,0}}, color={0,0,127}));
  connect(u_m_level, controller.u_m) annotation (Line(points={{-120,0},{-80,0},
          {-80,-28},{-1.5,-28},{-1.5,-12}}, color={0,0,127}));
  connect(scaling_out.u, controller.y)
    annotation (Line(points={{30,0},{10.05,0}}, color={0,0,127}));
  connect(scaling_out.y, y)
    annotation (Line(points={{53,0},{110,0}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end FWH_HP_level;
