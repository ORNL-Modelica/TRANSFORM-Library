within TRANSFORM.Mechanics;
model SimpleMotor
  "A simple model of an electrical dc motor (based on DriveLib model)."
  parameter Modelica.SIunits.Resistance Rm=10 "Motor Resistance";
  parameter Modelica.SIunits.Inductance Lm=1 "Motor Inductance";
  parameter Real kT=1 "Torque Constant";
  parameter Modelica.SIunits.Inertia Jm=10 "Motor Inertia";
  parameter Real dm(
    final unit="N.m.s/rad",
    final min=0) = 0 "Damping constant";
  Modelica.SIunits.Conversions.NonSIunits.AngularVelocity_rpm n;
  Modelica.Electrical.Analog.Sources.SignalVoltage Vs annotation (Placement(
        transformation(
        origin={-70,0},
        extent={{10,-10},{-10,10}},
        rotation=90)));
  Modelica.Electrical.Analog.Basic.Ground G annotation (Placement(
        transformation(extent={{-80,-60},{-60,-40}}, rotation=0)));
  Modelica.Electrical.Analog.Basic.Resistor R(R=Rm) annotation (Placement(
        transformation(extent={{-60,30},{-40,50}}, rotation=0)));
  Modelica.Electrical.Analog.Basic.Inductor L(L=Lm) annotation (Placement(
        transformation(extent={{-20,30},{0,50}}, rotation=0)));
  Modelica.Electrical.Analog.Basic.EMF emf(k=kT) annotation (Placement(
        transformation(extent={{0,-10},{20,10}}, rotation=0)));
  Modelica.Blocks.Interfaces.RealInput inPort annotation (Placement(
        transformation(extent={{-108,-10},{-90,10}}, rotation=0)));
  Modelica.Mechanics.Rotational.Components.Inertia J(J=Jm) annotation (
      Placement(transformation(extent={{48,-10},{68,10}}, rotation=0)));
  Modelica.Mechanics.Rotational.Interfaces.Flange_b flange_b annotation (
      Placement(transformation(extent={{88,-12},{112,12}}, rotation=0)));
  Modelica.Mechanics.Rotational.Components.Fixed Fixed annotation (
      Placement(transformation(extent={{26,-52},{46,-32}}, rotation=0)));
  Modelica.Mechanics.Rotational.Components.Damper Damper(d=dm) annotation (
      Placement(transformation(
        origin={36,-22},
        extent={{-10,-10},{10,10}},
        rotation=90)));
equation
  n = Modelica.SIunits.Conversions.to_rpm(J.w);
  connect(R.n, L.p) annotation (Line(points={{-40,40},{-20,40}}));
  connect(L.n, emf.p) annotation (Line(points={{0,40},{10,40},{10,10}}));
  connect(emf.flange, J.flange_a) annotation (Line(points={{20,0},{48,0}}));
  connect(R.p, Vs.p) annotation (Line(points={{-60,40},{-70,40},{-70,10}}));
  connect(Vs.n, emf.n)
    annotation (Line(points={{-70,-10},{-70,-20},{10,-20},{10,-10}}));
  connect(G.p, Vs.n) annotation (Line(points={{-70,-40},{-70,-10}}));
  connect(J.flange_b, flange_b) annotation (Line(points={{68,0},{100,0}}));
  connect(inPort, Vs.v)
    annotation (Line(points={{-99,0},{-77,4.28626e-016}}));
  connect(Fixed.flange, Damper.flange_a)
    annotation (Line(points={{36,-42},{36,-32}}, color={0,0,0}));
  connect(Damper.flange_b, J.flange_a)
    annotation (Line(points={{36,-12},{36,0},{48,0}}, color={0,0,0}));
  annotation (
    Icon(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}},
        grid={2,2}), graphics={Rectangle(
              extent={{60,6},{96,-6}},
              lineColor={0,0,0},
              fillColor={95,95,95},
              fillPattern=FillPattern.HorizontalCylinder),
                                             Rectangle(
              extent={{-60,40},{60,-40}},
              lineColor={0,0,0},
              fillPattern=FillPattern.HorizontalCylinder,
              fillColor={127,127,0}),        Line(points={{-90,0},{-60,0}}),
          Text(extent={{-80,100},{80,60}}, textString="%name"),Polygon(
              points={{-60,-80},{-30,-40},{30,-40},{60,-80},{60,-80},{-60,-80}},
              lineColor={0,0,0},
              pattern=LinePattern.None,
              fillPattern=FillPattern.VerticalCylinder,
              fillColor={0,0,0})}),
    Documentation(info="<HTML>
<p>This is a basic model of an electrical DC motor used to drive a pump.
</HTML>"),
    Diagram(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}},
        grid={2,2})));
end SimpleMotor;
