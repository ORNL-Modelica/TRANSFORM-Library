within TRANSFORM.Electrical.PowerConverters;
model Generator_Basic "Boundary condition generator for a shaft connector with no electical power connector"

  Modelica.Mechanics.Rotational.Interfaces.Flange_a shaft annotation (Placement(
        transformation(extent={{-110,-10},{-90,10}}, rotation=0),
        iconTransformation(extent={{-111,-11},{-91,9}})));

  SI.Angle phi(start=0,fixed=true) "Absolute rotation angle of component";
  SI.AngularVelocity omega_m "Absolute angular velocity of component (= der(phi))";
  SI.AngularAcceleration a
    "Absolute angular acceleration of component (= der(w))";

  parameter Real efficiency=0.99 "Constant generator efficiency";
  parameter SI.AngularVelocity omega_nominal=50*2*3.14
    "Fixed angular mechanical flange velocity";
  Modelica.SIunits.Power power "Generated power";

equation
  // Assumes that the rotational inertia rotates with a fixed speed, i.e. the acceleration is 0
  power =shaft.tau*omega_m*efficiency;
  phi =shaft.phi;
  der(phi) = omega_m;
  omega_m = omega_nominal;
  a = 0;

  annotation (defaultComponentName="generator",
    Icon(graphics={
        Rectangle(
          extent={{-102,6},{-60,-6}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={160,160,164}),    Ellipse(
              extent={{60,-60},{-60,60}},
              lineColor={0,0,0},
              lineThickness=0.5,
              fillColor={255,255,255},
              fillPattern=FillPattern.Solid),
                         Text(
              extent={{-26,24},{28,-28}},
              lineColor={0,0,0},
              fillColor={255,255,255},
              fillPattern=FillPattern.Solid,
              textString="G")}),
    Documentation(info="<html>
<p>This model describes the conversion between mechanical power and electrical power in an ideal synchronous generator. 
The frequency in the electrical connector is the e.m.f. of generator.
<p>It is possible to consider the generator inertia in the model, by setting the parameter <tt>J > 0</tt>. 
</html>"));
end Generator_Basic;
