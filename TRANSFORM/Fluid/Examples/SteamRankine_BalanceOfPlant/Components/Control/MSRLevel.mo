within TRANSFORM.Fluid.Examples.SteamRankine_BalanceOfPlant.Components.Control;
block MSRLevel
  extends Interfaces.CondenserLevel;
  Modelica.Blocks.Sources.RealExpression levelSP1(
                                                 y=30)       annotation (
      Placement(transformation(extent={{-58,-10},{-38,10}},  rotation=0)));
  Modelica.Blocks.Math.Gain scaling_out(k=1/100)
    annotation (Placement(transformation(extent={{38,-10},{58,10}})));
  Controls.LimPID controller(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    yMin=0,
    initType=Modelica.Blocks.Types.InitPID.InitialOutput,
    Td=0.1,
    k=-1,
    Ti=200,
    yMax=100,
    y_start=40)
    annotation (Placement(transformation(extent={{-10,-10},{11,10}})));
equation
  connect(scaling_out.y, y)
    annotation (Line(points={{59,0},{110,0}}, color={0,0,127}));
  connect(controller.u_s, levelSP1.y)
    annotation (Line(points={{-12.1,0},{-37,0}}, color={0,0,127}));
  connect(controller.y, scaling_out.u)
    annotation (Line(points={{12.05,0},{36,0}}, color={0,0,127}));
  connect(controller.u_m, u_m_level) annotation (Line(points={{0.5,-12},{0,
          -12},{0,-22},{0,-26},{-84,-26},{-84,0},{-120,0}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end MSRLevel;
