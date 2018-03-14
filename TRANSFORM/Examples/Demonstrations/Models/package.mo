within TRANSFORM.Examples.Demonstrations;
package Models

  extends Icons.ModelPackage;

  model LorenzSystem

    parameter Real sigma = 1;
    parameter Real rho = 1;
    parameter Real beta = 1;

    parameter Real x_start = 1 "Initial x-coordinate" annotation(Dialog(tab="Initialization"));
    parameter Real y_start = 1 "Initial y-coordinate" annotation(Dialog(tab="Initialization"));
    parameter Real z_start = 1 "Initial z-coordinate" annotation(Dialog(tab="Initialization"));

    Real x "x-coordinate";
    Real y "y-coordinate";
    Real z "z-coordinate";

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
          Bitmap(extent={{-100,-100},{100,100}}, fileName=
              "modelica://TRANSFORM/Resources/Images/LorenzSystemFig.png"),
          Rectangle(extent={{-100,100},{100,-100}}, lineColor={28,108,200})}),
                                                                   Diagram(
          coordinateSystem(preserveAspectRatio=false)));
  end LorenzSystem;

annotation (Documentation(info="<html>
<p>Implementation of a Lorenz-Attractor System</p>
<p>https://en.wikipedia.org/wiki/Lorenz_system </p>
</html>"));
end Models;
