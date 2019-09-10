within TRANSFORM.Nuclear.PowerProfiles;
model GenericPowerProfile
  "Transalets a total power input to user defined power profile (or shape)"
  parameter Integer nNodes = 4 "# of discrete volumes";
  parameter Units.NonDim Q_shape[nNodes]=1/nNodes*ones(nNodes)
    "Fractional power profile. Note: sum(Q_shape) = 1";
  Modelica.Blocks.Interfaces.RealInput Q_total "Total input power"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Interfaces.RealOutput[nNodes] Q_totalshaped
    "Total power shaped to desired power profile"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
equation
  Q_totalshaped = Q_total*Q_shape;
  annotation (defaultComponentName = "powerProfile",
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})),
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}), graphics={  Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Line(points={{-60,0},{60,0}}, color={0,0,0}),
        Line(
          points={{-60,-20},{-40,-18},{-26,-10},{-10,4},{2,16},{20,30},{36,22},
              {48,6},{56,-8},{60,-20}},
          color={255,0,0},
          smooth=Smooth.Bezier),        Text(
        extent={{-150,140},{150,100}},
        textString="%name",
        lineColor={0,0,255}),
        Polygon(
          points={{-80,80},{-88,58},{-72,58},{-80,80}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{90,-80},{68,-72},{68,-88},{90,-80}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(points={{-80,-80},{82,-80}}, color={192,192,192}),
        Line(points={{-80,58},{-80,-80}}, color={192,192,192})}));
end GenericPowerProfile;
