within TRANSFORM.HeatAndMassTransfer.DiscritizedModels.ClassicalMethod.BoundaryConditions;
model FixedTemperature_FD
  "Fixed temperature boundary condition in Kelvin for finite difference"
  parameter Integer nNodes(min=2);
  parameter Modelica.Units.SI.Temperature[nNodes] T
    "Fixed temperature at port";
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b[nNodes] port annotation (
      Placement(transformation(extent={{90,-10},{110,10}}, rotation=0)));
equation
  for i in 1:nNodes loop
    port[i].T = T[i];
  end for;
  annotation (defaultComponentName="fixedTemperature",
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{
            100,100}}), graphics={
        Text(
          extent={{-150,150},{150,110}},
          textString="%name",
          lineColor={0,0,255}),
        Text(
          extent={{-150,-110},{150,-140}},
          lineColor={0,0,0},
          textString="T=%T"),
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          pattern=LinePattern.None,
          fillColor={159,159,223},
          fillPattern=FillPattern.Backward),
        Text(
          extent={{0,0},{-100,-100}},
          lineColor={0,0,0},
          textString="K"),
        Line(
          points={{-52,0},{56,0}},
          color={191,0,0},
          thickness=0.5),
        Polygon(
          points={{50,-20},{50,20},{90,0},{50,-20}},
          lineColor={191,0,0},
          fillColor={191,0,0},
          fillPattern=FillPattern.Solid)}),
    Documentation(info="<HTML>
<p>
This model defines a fixed temperature T at its port in Kelvin,
i.e., it defines a fixed temperature as a boundary condition.
</p>
</html>"), Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{
            100,100}}), graphics={
        Rectangle(
          extent={{-100,100},{100,-101}},
          lineColor={0,0,0},
          pattern=LinePattern.None,
          fillColor={159,159,223},
          fillPattern=FillPattern.Backward),
        Line(
          points={{-52,0},{56,0}},
          color={191,0,0},
          thickness=0.5),
        Text(
          extent={{0,0},{-100,-100}},
          lineColor={0,0,0},
          textString="K"),
        Polygon(
          points={{52,-20},{52,20},{90,0},{52,-20}},
          lineColor={191,0,0},
          fillColor={191,0,0},
          fillPattern=FillPattern.Solid)}));
end FixedTemperature_FD;
