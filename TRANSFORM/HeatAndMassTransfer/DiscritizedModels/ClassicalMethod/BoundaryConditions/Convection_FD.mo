within TRANSFORM.HeatAndMassTransfer.DiscritizedModels.ClassicalMethod.BoundaryConditions;
model Convection_FD
  "Convection boundary condition for finite difference between port_a and port_b"
parameter Integer nNodes(min=2) "# of nodal points";
  parameter Modelica.Units.SI.CoefficientOfHeatTransfer[nNodes] alphas
    "Convection heat transfer coefficient";
  input Modelica.Units.SI.Area[nNodes] Areas=linspace(
      0,
      1,
      nNodes) "Nodal heat transfer area" annotation (Dialog(group="Inputs"));
Modelica.Fluid.Interfaces.HeatPorts_a[nNodes] port_a annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-100,0}), iconTransformation(
        extent={{-40,-10},{40,10}},
        rotation=-90,
        origin={-110,0})));
Modelica.Fluid.Interfaces.HeatPorts_b[nNodes] port_b annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={100,0}), iconTransformation(
        extent={{-40,-10},{40,10}},
        rotation=-90,
        origin={110,0})));
equation
  for i in 1:nNodes loop
    port_a[i].Q_flow + port_b[i].Q_flow = 0 "Conservation of energy";
    port_a[i].Q_flow = alphas[i]*Areas[i]*(port_a[i].T-port_b[i].T)
      "Heat transfer equation";
  end for;
  annotation (defaultComponentName="convection",
        Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics={
        Rectangle(
          extent={{-66,84},{94,-76}},
          lineColor={255,255,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-94,84},{-64,-76}},
          lineColor={0,0,0},
          fillColor={192,192,192},
          fillPattern=FillPattern.Backward),
        Text(
          extent={{-154,-86},{146,-126}},
          textString="%name",
          lineColor={0,0,255}),
        Line(points={{96,4},{96,4}},   color={0,127,255}),
        Line(points={{-64,24},{72,24}}, color={191,0,0}),
        Line(points={{-64,-16},{72,-16}}, color={191,0,0}),
        Line(points={{-38,84},{-38,-76}}, color={0,127,255}),
        Line(points={{2,84},{2,-76}}, color={0,127,255}),
        Line(points={{36,84},{36,-76}}, color={0,127,255}),
        Line(points={{72,84},{72,-76}}, color={0,127,255}),
        Line(points={{-38,-76},{-48,-56}}, color={0,127,255}),
        Line(points={{-38,-76},{-28,-56}}, color={0,127,255}),
        Line(points={{2,-76},{-8,-56}}, color={0,127,255}),
        Line(points={{2,-76},{12,-56}}, color={0,127,255}),
        Line(points={{36,-76},{26,-56}}, color={0,127,255}),
        Line(points={{36,-76},{46,-56}}, color={0,127,255}),
        Line(points={{72,-76},{62,-56}}, color={0,127,255}),
        Line(points={{72,-76},{82,-56}}, color={0,127,255}),
        Line(points={{52,-26},{72,-16}}, color={191,0,0}),
        Line(points={{52,-6},{72,-16}},  color={191,0,0}),
        Line(points={{52,14},{72,24}}, color={191,0,0}),
        Line(points={{52,34},{72,24}}, color={191,0,0})}), Icon(
        coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
        graphics={
        Rectangle(
          extent={{-64,84},{96,-76}},
          lineColor={255,255,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-92,84},{-62,-76}},
          lineColor={0,0,0},
          fillColor={192,192,192},
          fillPattern=FillPattern.Backward),
        Text(
          extent={{-152,-86},{148,-126}},
          textString="%name",
          lineColor={0,0,255}),
        Line(points={{98,4},{98,4}},   color={0,127,255}),
        Line(points={{-62,24},{74,24}}, color={191,0,0}),
        Line(points={{-62,-16},{74,-16}}, color={191,0,0}),
        Line(points={{-36,84},{-36,-76}}, color={0,127,255}),
        Line(points={{4,84},{4,-76}}, color={0,127,255}),
        Line(points={{38,84},{38,-76}}, color={0,127,255}),
        Line(points={{74,84},{74,-76}}, color={0,127,255}),
        Line(points={{-36,-76},{-46,-56}}, color={0,127,255}),
        Line(points={{-36,-76},{-26,-56}}, color={0,127,255}),
        Line(points={{4,-76},{-6,-56}}, color={0,127,255}),
        Line(points={{4,-76},{14,-56}}, color={0,127,255}),
        Line(points={{38,-76},{28,-56}}, color={0,127,255}),
        Line(points={{38,-76},{48,-56}}, color={0,127,255}),
        Line(points={{74,-76},{64,-56}}, color={0,127,255}),
        Line(points={{74,-76},{84,-56}}, color={0,127,255}),
        Line(points={{54,-26},{74,-16}}, color={191,0,0}),
        Line(points={{54,-6},{74,-16}},  color={191,0,0}),
        Line(points={{54,14},{74,24}}, color={191,0,0}),
        Line(points={{54,34},{74,24}}, color={191,0,0})}));
end Convection_FD;
