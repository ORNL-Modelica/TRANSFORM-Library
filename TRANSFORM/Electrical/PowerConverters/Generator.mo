within TRANSFORM.Electrical.PowerConverters;
model Generator "Generates power from shaft to electrical power connector"
  parameter SI.Efficiency eta=1.0 "Mechanical to electric power conversion efficiency";
  parameter SI.MomentOfInertia J=0 "Moment of inertia";
  parameter Integer nPoles=2 "Number of electrical poles";
  parameter SI.Frequency f_start=60 "Start value of the electrical frequency"
    annotation (Dialog(tab="Initialization"));
  /* Assumptions */
  parameter Modelica.Fluid.Types.Dynamics momentumDynamics=
    Modelica.Fluid.Types.Dynamics.DynamicFreeInitial
    "Default formulation of momentum balances"
    annotation(Evaluate=true, Dialog(tab = "Assumptions", group="Dynamics"));
  SI.Power Q_mech "Mechanical power";
  SI.Power Q_elec "Electrical Power";
  SI.Power Q_loss "Inertial power Loss";
  SI.Torque tau "Torque at shaft";
  SI.AngularVelocity omega_m(start=2*Modelica.Constants.pi*
        f_start/nPoles) "Angular velocity of the shaft";
  SI.AngularVelocity omega_e "Angular velocity of the e.m.f. rotating frame";
  Modelica.Units.NonSI.AngularVelocity_rpm shaft_rpm=
      Modelica.Units.Conversions.to_rpm(omega_m) "Shaft rotational speed";
  SI.Frequency f "Electrical frequency";
  Interfaces.ElectricalPowerPort_Flow port annotation (Placement(transformation(
          extent={{90,-10},{110,10}}, rotation=0), iconTransformation(extent={{90,-10},
            {110,10}})));
  Modelica.Mechanics.Rotational.Interfaces.Flange_a shaft annotation (Placement(
        transformation(extent={{-110,-10},{-90,10}}, rotation=0),
        iconTransformation(extent={{-110,-10},{-90,10}})));
initial equation
  if momentumDynamics == Modelica.Fluid.Types.Dynamics.SteadyStateInitial then
    der(omega_m) = 0;
  end if;
equation
  omega_m =der(shaft.phi)   "Mechanical boundary condition";
  omega_e = omega_m*nPoles;
  f = omega_e/(2*Modelica.Constants.pi) "Electrical frequency";
  Q_mech = omega_m*tau;
  if J > 0 then
    Q_loss = J*der(omega_m)*omega_m;
  else
    Q_loss = 0;
  end if;
  Q_mech = Q_elec/eta + Q_loss "Energy balance";
  // Boundary Conditions
  f =port.f;
  Q_elec =-port.W;
  tau =shaft.tau;
  annotation (defaultComponentName="generator",
    Icon(graphics={                          Line(points={{60,0},{90,0}},
          color={255,0,0},
          thickness=0.5),
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
              textString="G"),
        Text(
          extent={{-149,-68},{151,-108}},
          lineColor={238,46,47},
          textString="%name")}),
    Documentation(info="<html>
<p>This model describes the conversion between mechanical power and electrical power in an ideal synchronous generator. 
The frequency in the electrical connector is the e.m.f. of generator.
<p>It is possible to consider the generator inertia in the model, by setting the parameter <tt>J > 0</tt>. 
</html>"));
end Generator;
