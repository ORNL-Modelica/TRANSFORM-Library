within TRANSFORM.HeatAndMassTransfer.Examples.ExamplesFrom_NellisAndKlein.Example_1_2_1_LiquidOxygenDewar;
model part_c_InsulationThickness
  "Part c) Rate of heat transfer as a function of the insulation thickness (Figure 1-8)"
  extends Icons.Example;
  Resistances.Heat.Sphere linerInner(
    lambda=15,
    r_in=r_in.y,
    r_out=r_ins_in.y)
    annotation (Placement(transformation(extent={{-48,-10},{-28,10}})));
  TRANSFORM.HeatAndMassTransfer.BoundaryConditions.Heat.Temperature
    LiquidOxygen(T(displayUnit="K") = 95.6)
    annotation (Placement(transformation(extent={{-94,-10},{-74,10}})));
  Resistances.Heat.Sphere linerOuter(
    lambda=15,
    r_in=r_ins_out.y,
    r_out=r_out.y)
    annotation (Placement(transformation(extent={{32,-10},{52,10}})));
  Resistances.Heat.Contact contact_1(Rc_pp=0.003, surfaceArea=4*Modelica.Constants.pi
        *r_ins_in.y^2)
    annotation (Placement(transformation(extent={{-28,-10},{-8,10}})));
  Resistances.Heat.Convection convectionInner(alpha=150, surfaceArea=4*Modelica.Constants.pi
        *r_in.y*r_in.y)
    annotation (Placement(transformation(extent={{-68,-10},{-48,10}})));
  Modelica.Blocks.Sources.Constant r_in(k=0.1)
    annotation (Placement(transformation(extent={{-100,76},{-90,86}})));
  Modelica.Blocks.Sources.Constant th_1(k=0.0025)
    annotation (Placement(transformation(extent={{-100,60},{-90,70}})));
  Modelica.Blocks.Sources.Constant th_2(k=0.0025)
    annotation (Placement(transformation(extent={{-100,28},{-90,38}})));
  TRANSFORM.HeatAndMassTransfer.BoundaryConditions.Heat.Temperature Ambient(T(
        displayUnit="degC") = 293.15)
    annotation (Placement(transformation(extent={{116,-10},{96,10}})));
  Resistances.Heat.Convection convectionOuter(alpha=6, surfaceArea=4*Modelica.Constants.pi
        *r_out.y^2)
    annotation (Placement(transformation(extent={{66,-30},{86,-10}})));
  Resistances.Heat.Radiation radiationOuter(epsilon=0.7, surfaceArea=4*Modelica.Constants.pi
        *r_out.y^2)
    annotation (Placement(transformation(extent={{66,10},{86,30}})));
  Resistances.Heat.Contact contact_2(Rc_pp=0.003, surfaceArea=4*Modelica.Constants.pi
        *r_ins_out.y^2)
    annotation (Placement(transformation(extent={{12,-10},{32,10}})));
  Resistances.Heat.Sphere insulation(
    lambda=0.033,
    r_in=r_ins_in.y,
    r_out=r_ins_out.y)
    annotation (Placement(transformation(extent={{-8,-10},{12,10}})));
  Modelica.Blocks.Sources.Ramp     th_ins(
    height=0.1 - th_ins.offset,
    duration=1,
    offset=0.0001)
    annotation (Placement(transformation(extent={{-100,44},{-90,54}})));
  Utilities.Visualizers.displayReal display_R_total(val=convectionInner.R +
        linerInner.R + contact_1.R + insulation.R + contact_2.R + linerOuter.R
         + 1/(1/radiationOuter.R + 1/convectionOuter.R))
    annotation (Placement(transformation(extent={{16,42},{36,62}})));
  Utilities.Visualizers.displayReal display_Q_total(val=-convectionInner.port_a.Q_flow)
    annotation (Placement(transformation(extent={{44,42},{64,62}})));
  Modelica.Blocks.Math.Add r_ins_in
    annotation (Placement(transformation(extent={{-82,68},{-74,76}})));
  Modelica.Blocks.Math.Add r_ins_out
    annotation (Placement(transformation(extent={{-66,54},{-58,62}})));
  Modelica.Blocks.Math.Add r_out
    annotation (Placement(transformation(extent={{-50,36},{-42,44}})));
  Utilities.Visualizers.displayReal display_r_ins_in(use_port=true)
    annotation (Placement(transformation(extent={{-66,62},{-46,82}})));
  Utilities.Visualizers.displayReal display_r_ins_out(use_port=true)
    annotation (Placement(transformation(extent={{-48,48},{-28,68}})));
  Utilities.Visualizers.displayReal display_r_out(use_port=true)
    annotation (Placement(transformation(extent={{-36,30},{-16,50}})));
  Utilities.ErrorAnalysis.UnitTests unitTests(n=1, x={display_Q_total.val})
    annotation (Placement(transformation(extent={{80,80},{100,100}})));
equation
  connect(radiationOuter.port_b, Ambient.port)
    annotation (Line(points={{83,20},{90,20},{90,0},{96,0}}, color={191,0,0}));
  connect(convectionOuter.port_b, Ambient.port) annotation (Line(points={{83,-20},
          {90,-20},{90,0},{96,0}}, color={191,0,0}));
  connect(LiquidOxygen.port, convectionInner.port_a)
    annotation (Line(points={{-74,0},{-65,0},{-65,0}}, color={191,0,0}));
  connect(convectionInner.port_b, linerInner.port_a)
    annotation (Line(points={{-51,0},{-45,0}}, color={191,0,0}));
  connect(linerInner.port_b, contact_1.port_a)
    annotation (Line(points={{-31,0},{-25,0}}, color={191,0,0}));
  connect(contact_1.port_b, insulation.port_a)
    annotation (Line(points={{-11,0},{-5,0}},  color={191,0,0}));
  connect(insulation.port_b, contact_2.port_a)
    annotation (Line(points={{9,0},{15,0}},color={191,0,0}));
  connect(contact_2.port_b, linerOuter.port_a)
    annotation (Line(points={{29,0},{35,0}}, color={191,0,0}));
  connect(radiationOuter.port_a, linerOuter.port_b)
    annotation (Line(points={{69,20},{60,20},{60,0},{49,0}}, color={191,0,0}));
  connect(convectionOuter.port_a, linerOuter.port_b) annotation (Line(points={{69,-20},
          {60,-20},{60,0},{49,0}},      color={191,0,0}));
  connect(r_in.y, r_ins_in.u1) annotation (Line(points={{-89.5,81},{-86,81},{-86,
          74.4},{-82.8,74.4}}, color={0,0,127}));
  connect(th_1.y, r_ins_in.u2) annotation (Line(points={{-89.5,65},{-86,65},{-86,
          69.6},{-82.8,69.6}}, color={0,0,127}));
  connect(r_ins_in.y, r_ins_out.u1) annotation (Line(points={{-73.6,72},{-72,72},
          {-72,60.4},{-66.8,60.4}}, color={0,0,127}));
  connect(th_ins.y, r_ins_out.u2) annotation (Line(points={{-89.5,49},{-72,49},{
          -72,55.6},{-66.8,55.6}}, color={0,0,127}));
  connect(r_ins_out.y, r_out.u1) annotation (Line(points={{-57.6,58},{-54,58},{-54,
          42.4},{-50.8,42.4}}, color={0,0,127}));
  connect(th_2.y, r_out.u2) annotation (Line(points={{-89.5,33},{-54,33},{-54,37.6},
          {-50.8,37.6}}, color={0,0,127}));
  connect(display_r_ins_in.u, r_ins_in.y) annotation (Line(points={{-67.5,72},{
          -66,72},{-73.6,72}}, color={0,0,127}));
  connect(display_r_ins_out.u, r_out.u1) annotation (Line(points={{-49.5,58},{-49.5,
          58},{-54,58},{-54,42.4},{-50.8,42.4}}, color={0,0,127}));
  connect(display_r_out.u, r_out.y)
    annotation (Line(points={{-37.5,40},{-41.6,40}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}})),                                        Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{120,100}}),
        graphics={Text(
          extent={{16,64},{34,58}},
          lineColor={0,0,0},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid,
          textString="Total Resistance"),
                                 Text(
          extent={{44,64},{66,58}},
          lineColor={0,0,0},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid,
          textString="Total Heat to Dewar")}),
    experiment(__Dymola_NumberOfIntervals=100),
    Documentation(info="<html>
<p>Example 1.2-1 from Heat Transfer by Greg Nellis and Sandy Klein.</p>
<p>This demonstrates the use of heat transfer resistances by modeling the steady state approximate solution of a liquid oxygen dewar with a variable insulation layer.</p>
</html>"));
end part_c_InsulationThickness;
