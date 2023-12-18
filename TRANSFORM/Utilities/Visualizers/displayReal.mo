within TRANSFORM.Utilities.Visualizers;
model displayReal "Real number display"
  parameter Boolean use_port=false "=true then use input port"
    annotation (choices(checkBox=true), Evaluate=true);
  input Real val=0.0 "Input variable" annotation (Dialog(enable=not use_port));
  parameter Integer precision(min=0) = 0 "Number of decimals displayed";
  parameter String unitLabel="";

  Modelica.Blocks.Interfaces.RealInput u if use_port
    "Input displayed in diagram layer if use_port = true" annotation (
      HideResult=true, Placement(transformation(extent={{-130,-15},{-100,15}})));
  Modelica.Blocks.Interfaces.RealOutput y "Result";
equation
  if use_port then
    connect(u, y);
  else
    y = val;
  end if;
  annotation (
    defaultComponentName="display",
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
        graphics={Rectangle(
          extent={{100,50},{-100,-50}},
          lineColor={0,0,255},
          fillColor={236,230,228},
          fillPattern=FillPattern.Solid,
          borderPattern=BorderPattern.Sunken), Text(extent={{-100,-36},{100,36}},
            textString=DynamicSelect("0.0", String(y, format="1." +
              String(precision) + "f"))),
        Text(
          extent={{110,36},{260,-32}},
          textColor={0,0,0},
          textString="%{unitLabel}",
          horizontalAlignment=TextAlignment.Left)}),
    Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}})));
end displayReal;
