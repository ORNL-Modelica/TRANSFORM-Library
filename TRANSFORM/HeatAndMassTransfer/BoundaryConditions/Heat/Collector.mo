within TRANSFORM.HeatAndMassTransfer.BoundaryConditions.Heat;
model Collector
  parameter Integer n(min=1)=1 "Number of collected heat flows";
  parameter Boolean showName = true annotation(Dialog(tab="Visualization"));
  Interfaces.HeatPort_Flow port_a[n]
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  Interfaces.HeatPort_Flow port_b
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));

equation
  port_b.Q_flow + sum(port_a.Q_flow) = 0;
  port_a.T = fill(port_b.T, n);

  annotation (defaultComponentName="collector",
  Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{
            100,100}}), graphics={
        Rectangle(
          extent={{-100,60},{100,-60}},
          pattern=LinePattern.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Rectangle(
          extent={{-50,5},{50,-5}},
          fillColor={191,0,0},
          fillPattern=FillPattern.Solid,
          origin={-85,0},
          rotation=90,
          pattern=LinePattern.None),
        Line(
          points={{-80,-50},{20,0},{90,0}},
          color={181,0,0}),
        Line(
          points={{20,0},{-80,-20}},
          color={181,0,0}),
        Line(
          points={{-80,50},{20,0}},
          color={181,0,0}),
        Line(
          points={{-80,20},{20,0}},
          color={181,0,0}),
        Text(
          extent={{-138,102},{142,62}},
          textString="%name",
          lineColor={0,0,255},
          visible=showName)}),
    Documentation(info="<html>
<p>
This is a model to collect the heat flows from <i>m</i> heatports to one single heatport.
</p>
</html>"));
end Collector;
