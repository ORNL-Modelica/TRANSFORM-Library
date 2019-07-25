within TRANSFORM.Fluid.Examples.SteamRankine_BalanceOfPlant.Components.Control;
block CondenserLevel
  extends Interfaces.CondenserLevel;
  Controls.LimPID                           controller(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    initType=Modelica.Blocks.Types.InitPID.InitialOutput,
    Td=0.1,
    Ti=100,
    yMax=100,
    yMin=0.001,
    y_start=1200*(100/20000),
    k=-1) annotation (Placement(transformation(extent={{-12,-10},{8,10}})));
  Modelica.Blocks.Sources.RealExpression levelSP1(
                                                 y=20)       annotation (
      Placement(transformation(extent={{-58,-10},{-38,10}},  rotation=0)));
  Modelica.Blocks.Math.Gain scaling_out(k=20000/100)
    annotation (Placement(transformation(extent={{38,-10},{58,10}})));
equation
  connect(levelSP1.y, controller.u_s)
    annotation (Line(points={{-37,0},{-37,0},{-14,0}}, color={0,0,127}));
  connect(u_m_level, controller.u_m) annotation (Line(points={{-120,0},{-92,0},
          {-92,-22},{-2,-22},{-2,-12}}, color={0,0,127}));
  connect(scaling_out.u, controller.y)
    annotation (Line(points={{36,0},{9,0}}, color={0,0,127}));
  connect(scaling_out.y, y)
    annotation (Line(points={{59,0},{110,0}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end CondenserLevel;
