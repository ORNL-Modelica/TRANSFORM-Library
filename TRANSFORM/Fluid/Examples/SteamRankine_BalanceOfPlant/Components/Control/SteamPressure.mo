within TRANSFORM.Fluid.Examples.SteamRankine_BalanceOfPlant.Components.Control;
block SteamPressure "Steam pressure"
  extends Interfaces.SteamPressure;
  Controls.LimPID                          controller(
    Ti=5,
    yMin=0.05,
    k=-1e-6,
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    y_start=0.75,
    initType=Modelica.Blocks.Types.InitPID.InitialOutput,
    yMax=1)                annotation (Placement(transformation(extent={{-10,
            -10},{10,10}}, rotation=0)));
  Modelica.Blocks.Sources.RealExpression pressure_setPoint(y=
        Modelica.SIunits.Conversions.from_bar(69)) annotation (Placement(
        transformation(extent={{-52,-10},{-32,10}}, rotation=0)));
equation
  connect(pressure_setPoint.y, controller.u_s)
    annotation (Line(points={{-31,0},{-31,0},{-12,0}}, color={0,0,127}));
  connect(u_m_pressure, controller.u_m) annotation (Line(points={{-120,0},{
          -90,0},{-90,-20},{0,-20},{0,-12}}, color={0,0,127}));
  connect(controller.y, y)
    annotation (Line(points={{11,0},{110,0}}, color={0,0,127}));
  annotation (Icon(graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,127},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{36,68},{-40,-74}},
          lineColor={255,255,255},
          textString="C")}));
end SteamPressure;
