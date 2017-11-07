within TRANSFORM.Electrical;
model Grid "Ideal grid with finite droop"
  parameter SI.Frequency f_nominal=60 "Nominal frequency";
  parameter SI.Power Q_nominal "Nominal power installed on the network";
  parameter Real droop=0.0 "Network droop";

  TRANSFORM.Electrical.Interfaces.ElectricalPowerPort_State port annotation (
      Placement(transformation(extent={{-114,-14},{-86,14}}, rotation=0),
        iconTransformation(extent={{-110,-10},{-90,10}})));
equation
  port.f = f_nominal + droop*f_nominal*port.W/Q_nominal;
  annotation (defaultComponentName="grid",
                   Icon(graphics={Line(points={{18,-16},{2,-38}},
          color={0,0,0}),Line(points={{-90,0},{-40,0}}, color={0,0,0},
          thickness=0.5),
          Ellipse(
              extent={{100,-68},{-40,68}},
              lineColor={0,0,0},
              lineThickness=0.5),Line(points={{-40,0},{-6,0},{24,36},{54,50}},
          color={0,0,0}),Line(points={{24,36},{36,-6}}, color={0,0,0}),Line(
          points={{-6,0},{16,-14},{40,-52}}, color={0,0,0}),Line(points={{18,
          -14},{34,-6},{70,-22}}, color={0,0,0}),Line(points={{68,18},{36,-4},
          {36,-4}}, color={0,0,0}),Ellipse(
              extent={{-8,2},{-2,-4}},
              lineColor={0,0,0},
              fillColor={255,255,255},
              fillPattern=FillPattern.Solid),Ellipse(
              extent={{20,38},{26,32}},
              lineColor={0,0,0},
              fillColor={255,255,255},
              fillPattern=FillPattern.Solid),Ellipse(
              extent={{52,54},{58,48}},
              lineColor={0,0,0},
              fillColor={255,255,255},
              fillPattern=FillPattern.Solid),Ellipse(
              extent={{14,-12},{20,-18}},
              lineColor={0,0,0},
              fillColor={255,255,255},
              fillPattern=FillPattern.Solid),Ellipse(
              extent={{66,22},{72,16}},
              lineColor={0,0,0},
              fillColor={255,255,255},
              fillPattern=FillPattern.Solid),Ellipse(
              extent={{32,-2},{38,-8}},
              lineColor={0,0,0},
              fillColor={255,255,255},
              fillPattern=FillPattern.Solid),Ellipse(
              extent={{38,-50},{44,-56}},
              lineColor={0,0,0},
              fillColor={255,255,255},
              fillPattern=FillPattern.Solid),Ellipse(
              extent={{66,-18},{72,-24}},
              lineColor={0,0,0},
              fillColor={255,255,255},
              fillPattern=FillPattern.Solid),Ellipse(
              extent={{0,-34},{6,-40}},
              lineColor={0,0,0},
              fillColor={255,255,255},
              fillPattern=FillPattern.Solid)}));
end Grid;
