within TRANSFORM.Fluid.Examples.SteamRankine_BalanceOfPlant.Components.Control;
block DrumLevel
  extends Interfaces.DrumLevel;
  package Medium=Modelica.Media.Water.StandardWater;

  Controls.LimPID controller(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    initType=Modelica.Blocks.Types.InitPID.InitialOutput,
    Td=0.1,
    Ti=200,
    yMax=100,
    k=1,
    yMin=1,
    y_start=40)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Sources.RealExpression level_setpoint(y=
        50) annotation (Placement(transformation(extent={{-42,-10},{-22,9}},
          rotation=0)));
  Modelica.Blocks.Math.Gain scaling_out(k=1/100)
    annotation (Placement(transformation(extent={{34,-10},{54,10}})));
  parameter Records.RankineNominalValues nominalData "Nominal data"
    annotation (Dialog(group="Nominal operating data"), Placement(
        transformation(extent={{60,60},{80,80}})));
equation
  connect(level_setpoint.y, controller.u_s)
    annotation (Line(points={{-21,-0.5},{-21,0},{-12,0}}, color={0,0,127}));
  connect(u_m_level, controller.u_m) annotation (Line(points={{-120,0},{-82,0},{
          -82,-30},{0,-30},{0,-12}}, color={0,0,127}));
  connect(scaling_out.u, controller.y)
    annotation (Line(points={{32,0},{11,0}}, color={0,0,127}));
  connect(scaling_out.y, y)
    annotation (Line(points={{55,0},{110,0}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end DrumLevel;
