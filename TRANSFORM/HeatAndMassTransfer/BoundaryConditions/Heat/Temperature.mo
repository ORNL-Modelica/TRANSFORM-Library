within TRANSFORM.HeatAndMassTransfer.BoundaryConditions.Heat;
model Temperature "Temperature boundary condition in Kelvin"
  parameter Boolean use_port=false "=true then use input port"
  annotation(Evaluate=true, HideResult=true, choices(checkBox=true));
  parameter SI.Temperature T=293.15 "Fixed temperature at port"             annotation(Dialog(                        enable=not use_port));
  parameter Boolean showName = true annotation(Dialog(tab="Visualization"));
  Modelica.Blocks.Interfaces.RealInput T_ext(unit="K") if use_port  annotation (Placement(transformation(
          extent={{-60,-20},{-20,20}}), iconTransformation(extent={{-60,-20},
            {-20,20}})));
protected
    Modelica.Blocks.Interfaces.RealInput T_int(unit="K");
public
  Interfaces.HeatPort_State port annotation (Placement(transformation(extent={{
            90,-10},{110,10}}), iconTransformation(extent={{90,-10},{110,10}})));
equation
  connect(T_int,T_ext);
  if not use_port then
    T_int = T;
  end if;
  port.T = T_int;
  annotation (defaultComponentName="boundary",
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{
            100,100}}), graphics={
        Rectangle(
          extent={{-40,60},{60,-60}},
          lineColor={0,0,0},
          pattern=LinePattern.None,
          fillColor={159,159,223},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{100,60},{60,-60}},
          lineColor={0,0,0},
          fillColor={175,175,175},
          fillPattern=FillPattern.Forward),
        Text(
          extent={{26,-14},{-20,-60}},
          lineColor={0,0,0},
          textString="T"),
        Line(
          points={{-40,0},{56,0}},
          color={191,0,0},
          thickness=0.5),
        Polygon(
          points={{50,-20},{50,20},{90,0},{50,-20}},
          lineColor={191,0,0},
          fillColor={191,0,0},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-100,112},{180,72}},
          textString="%name",
          lineColor={0,0,255},
          visible=showName)}),
    Documentation(info="<html>
<p>
This model defines a fixed temperature T at its port in Kelvin,
i.e., it defines a fixed temperature as a boundary condition.
</p>
</html>"), Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{
            100,100}})));
end Temperature;
