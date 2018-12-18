within TRANSFORM.Units.Conversions.Models;
model Conversion "Base model for conversion models"

  parameter Boolean use_port=true "=true then use input port"
    annotation (Evaluate=true, choices(checkBox=true));

  input Real val=0.0 "Value to be converted"
    annotation (Dialog(group="Inputs", enable=not use_port));

  replaceable function convert =
      TRANSFORM.Units.Conversions.Functions.BaseClasses.PartialConversion
    "Define conversion" annotation (choicesAllMatching=true);

  Modelica.Blocks.Interfaces.RealInput u if use_port annotation (Placement(
        transformation(extent={{-140,-20},{-100,20}}),
                                                     iconTransformation(extent={{-140,
            -20},{-100,20}})));
  Modelica.Blocks.Interfaces.RealOutput y
    annotation (Placement(transformation(extent={{100,-20},{140,20}})));

  parameter Boolean showName = true annotation(Dialog(tab="Visualization"));

protected
  Modelica.Blocks.Interfaces.RealInput u_int;

equation
  connect(u_int, u);
  if not use_port then
    u_int = val;
  end if;

  y = convert(u_int);

  annotation (defaultComponentName="conversion",Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},
            {100,100}}), graphics={
        Rectangle(
          extent={{-98,40},{100,-40}},
          lineColor={191,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(points={{-90,0},{30,0}}, color={191,0,0}),
        Polygon(
          points={{90,0},{30,20},{30,-20},{90,0}},
          lineColor={191,0,0},
          fillColor={191,0,0},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-149,82},{151,42}},
          lineColor={0,0,0},
          textString="%name",
          visible=showName)}));
end Conversion;
