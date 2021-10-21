within TRANSFORM.Examples.Demonstrations.Models;
model LorenzSystem_inputs
//   input Real sigma = 1 annotation(Dialog(group="Input"));
//   input Real rho = 1 annotation(Dialog(group="Input"));
//   input Real beta = 1 annotation(Dialog(group="Input"));
  parameter Real x_start = 1 "Initial x-coordinate" annotation(Dialog(tab="Initialization"));
  parameter Real y_start = 1 "Initial y-coordinate" annotation(Dialog(tab="Initialization"));
  parameter Real z_start = 1 "Initial z-coordinate" annotation(Dialog(tab="Initialization"));
//   Real x "x-coordinate";
//   Real y "y-coordinate";
//   Real z "z-coordinate";
  Modelica.Blocks.Interfaces.RealInput sigma(start=10)
    annotation (Placement(transformation(extent={{-140,20},{-100,60}})));
  Modelica.Blocks.Interfaces.RealInput rho(start=28)
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Interfaces.RealInput beta(start=8/3)
    annotation (Placement(transformation(extent={{-140,-60},{-100,-20}})));
  Modelica.Blocks.Interfaces.RealOutput x
    annotation (Placement(transformation(extent={{100,30},{120,50}})));
  Modelica.Blocks.Interfaces.RealOutput y
    annotation (Placement(transformation(extent={{100,-12},{120,10}})));
  Modelica.Blocks.Interfaces.RealOutput z
    annotation (Placement(transformation(extent={{100,-52},{120,-30}})));
initial equation
  x = x_start;
  y = y_start;
  z = z_start;
equation
  der(x) = sigma*(y-x);
  der(y) = rho*x - y - x*z;
  der(z) = x*y - beta*z;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          pattern=LinePattern.None,
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Bitmap(extent={{-100,-100},{100,100}}, fileName="modelica://TRANSFORM/Resources/Images/LorenzSystemFig.png"),
        Rectangle(extent={{-100,100},{100,-100}}, lineColor={28,108,200})}),
                                                                 Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end LorenzSystem_inputs;
