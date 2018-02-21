within TRANSFORM.Controls;
model TankLevelControl

  extends Modelica.Blocks.Interfaces.SO;

  parameter SI.Length level_max "Max fluid level (pump turns on)";
  parameter SI.Length level_min "Min fluid level (pump turns off)";

  input SI.Length level "Fluid level"
    annotation (Dialog(group="Input Variables"));
  input Real drainRate_active "Specified flow rate out of tank when active"
    annotation (Dialog(group="Input Variables"));
  input Real drainRate_nonActive=0
    "Specified flow rate out of tank when not active"
    annotation (Dialog(group="Input Variables"));

  Modelica.Blocks.Logical.Hysteresis hysteresis(uLow=level_min, uHigh=level_max)
    annotation (Placement(transformation(extent={{-30,-10},{-10,10}})));
  Modelica.Blocks.Logical.Switch switch
    annotation (Placement(transformation(extent={{10,-10},{30,10}})));
equation

  hysteresis.u = level;
  switch.u1 = drainRate_active;
  switch.u3 = drainRate_nonActive;

  connect(hysteresis.y, switch.u2)
    annotation (Line(points={{-9,0},{8,0}},    color={255,0,255}));
  connect(switch.y, y)
    annotation (Line(points={{31,0},{110,0}},color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end TankLevelControl;
