within TRANSFORM.Electrical.Sources;
model PowerSource "Defines power variable for electrical power connector"
parameter Boolean use_port = false "= true to use input signal" annotation(choices(checkBox=true));
parameter SI.Power W = 0 "Active power";
  Interfaces.ElectricalPowerPort_Flow port
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));
  Modelica.Blocks.Interfaces.RealInput W_input(unit="W") if use_port annotation (Placement(transformation(
          extent={{-140,-20},{-100,20}}), iconTransformation(extent={{-140,-20},
            {-100,20}})));
protected
  Modelica.Blocks.Interfaces.RealInput W_internal(unit="W");
equation
  connect(W_internal,W_input);
  if not use_port then
    W_internal = W;
  end if;
  port.W + W_internal = 0;
   annotation (defaultComponentName="boundary",
   Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Text(
          extent={{-150,106},{150,146}},
          lineColor={238,46,47},
          textString="%name"),
        Polygon(
          points={{-110,86},{-110,86}},
          lineColor={0,0,0},
          fillColor={0,0,209},
          fillPattern=FillPattern.Solid),
        Bitmap(extent={{-100,-100},{100,100}}, fileName="modelica://TRANSFORM/Resources/Images/Icons/PowerSource.jpg")}),
                                                                  Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end PowerSource;
