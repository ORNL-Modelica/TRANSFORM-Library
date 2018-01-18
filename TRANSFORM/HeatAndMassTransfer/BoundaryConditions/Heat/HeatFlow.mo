within TRANSFORM.HeatAndMassTransfer.BoundaryConditions.Heat;
model HeatFlow "Heat flow boundary condition"

  parameter Boolean use_port=false "=true then use input port"
  annotation(Evaluate=true, HideResult=true, choices(checkBox=true));

  parameter SI.HeatFlowRate Q_flow=0 "Heat flow rate at port"             annotation(Dialog(                        enable=not
          use_port));
  parameter Boolean showName = true annotation(Dialog(tab="Visualization"));

  Modelica.Blocks.Interfaces.RealInput Q_flow_ext(unit="W") if use_port  annotation (Placement(transformation(
          extent={{-60,-20},{-20,20}}), iconTransformation(extent={{-60,-20},{
            -20,20}})));

protected
    Modelica.Blocks.Interfaces.RealInput Q_flow_int(unit="W");

public
  Interfaces.HeatPort_Flow port annotation (Placement(transformation(extent={{
            90,-10},{110,10}}), iconTransformation(extent={{90,-10},{110,10}})));
equation
  connect(Q_flow_int,Q_flow_ext);
  if not use_port then
    Q_flow_int = Q_flow;
  end if;

  port.Q_flow = - Q_flow_int;

  annotation (defaultComponentName="boundary",
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{
            100,100}}), graphics={
        Rectangle(
          extent={{100,60},{60,-60}},
          lineColor={0,0,0},
          fillColor={175,175,175},
          fillPattern=FillPattern.Forward),
        Line(
          points={{-40,0},{50,0}},
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
    Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},
            {100,100}})),
    Documentation(info="<html>
<p>
This model allows a specified amount of heat flow rate to be \"injected\"
into a thermal system at a given port.  The constant amount of heat
flow rate Q_flow is given as a parameter. The heat flows into the
component to which the component FixedHeatFlow is connected,
if parameter Q_flow is positive.
</p>
<p>
If parameter alpha is &lt;&gt; 0, the heat flow is multiplied by (1 + alpha*(port.T - T_ref))
in order to simulate temperature dependent losses (which are given with respect to reference temperature T_ref).
</p>
</html>"));
end HeatFlow;
