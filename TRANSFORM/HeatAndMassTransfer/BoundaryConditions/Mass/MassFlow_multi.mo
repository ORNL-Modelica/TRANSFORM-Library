within TRANSFORM.HeatAndMassTransfer.BoundaryConditions.Mass;
model MassFlow_multi "Mass flow boundary condition"

  parameter Integer nPorts = 1 "# of ports";
  parameter Integer nC = 1 "Number of substances";
  parameter Boolean use_port=false "=true then use input port"
    annotation (
    Evaluate=true,
    HideResult=true,
    choices(checkBox=true));

  parameter SI.MolarFlowRate n_flow[nPorts,nC]=zeros(nPorts,nC) "Molar flow rate at port"
    annotation (Dialog(enable=not use_port));
  parameter Boolean showName = true annotation(Dialog(tab="Visualization"));
  Modelica.Blocks.Interfaces.RealInput n_flow_ext[nPorts,nC](unit="mol/s") if use_port
                  annotation (Placement(transformation(extent={{-60,-20},{-20,
            20}}), iconTransformation(extent={{-60,-20},{-20,20}})));
  Interfaces.MolePort_Flow port[nPorts](each nC=nC) annotation (Placement(transformation(
          extent={{90,-10},{110,10}}), iconTransformation(extent={{90,-10},{110,
            10}})));
protected
  Modelica.Blocks.Interfaces.RealInput n_flow_int[nPorts,nC](unit="mol/s");

equation
  connect(n_flow_int, n_flow_ext);
  if not use_port then
    n_flow_int = n_flow;
  end if;

  for i in 1:nPorts loop
  port[i].n_flow = -n_flow_int[i,:];
  end for;

  annotation (
    defaultComponentName="boundary",
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}}), graphics={
        Rectangle(
          extent={{100,60},{60,-60}},
          lineColor={0,0,0},
          fillColor={175,175,175},
          fillPattern=FillPattern.Forward),
        Line(
          points={{-40,0},{50,0}},
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
          visible=showName)}),
    Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}})),
    Documentation(info="<html>
</html>"));
end MassFlow_multi;
