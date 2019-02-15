within TRANSFORM.HeatAndMassTransfer.BoundaryConditions.Mass;
model Concentration_multi "Mass concentration boundary condition"
  parameter Integer nPorts = 1 "# of ports";
  parameter Integer nC = 1 "Number of substances";
  parameter Boolean use_port=false "=true then use input port"
    annotation (
    Evaluate=true,
    HideResult=true,
    choices(checkBox=true));
  parameter SI.Concentration C[nPorts,nC]=zeros(nPorts,nC) "Fixed concentration at port"
    annotation (Dialog(enable=not use_port));
  parameter Boolean showName = true annotation(Dialog(tab="Visualization"));
  Modelica.Blocks.Interfaces.RealInput C_ext[nPorts,nC](unit="mol/m3") if use_port
    annotation (Placement(transformation(extent={{-60,-20},{-20,20}}),
        iconTransformation(extent={{-60,-20},{-20,20}})));
  Interfaces.MolePort_State port[nPorts](each nC=nC) annotation (Placement(transformation(
          extent={{90,-10},{110,10}}), iconTransformation(extent={{90,-10},{110,
            10}})));
protected
  Modelica.Blocks.Interfaces.RealInput C_int[nPorts,nC](unit="mol/m3");
equation
  connect(C_int, C_ext);
  if not use_port then
    C_int = C;
  end if;
  for i in 1:nPorts loop
    port[i].C = C_int[i,:];
  end for;
  annotation (
    defaultComponentName="boundary",
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}}), graphics={
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
        Line(
          points={{-40,0},{56,0}},
          color={0,127,0},
          thickness=0.5),
        Polygon(
          points={{50,-20},{50,20},{90,0},{50,-20}},
          lineColor={0,127,0},
          fillColor={0,127,0},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-100,112},{180,72}},
          textString="%name",
          lineColor={0,0,255},
          visible=showName),
        Text(
          extent={{26,-14},{-20,-60}},
          lineColor={0,0,0},
          textString="C")}),
    Documentation(info="<html>
<p>
This model defines a fixed temperature T at its port in Kelvin,
i.e., it defines a fixed temperature as a boundary condition.
</p>
</html>"),
    Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}})));
end Concentration_multi;
