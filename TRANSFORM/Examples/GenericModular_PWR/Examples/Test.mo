within TRANSFORM.Examples.GenericModular_PWR.Examples;
model Test
  extends Modelica.Icons.Example;

  GenericModule PHS
    annotation (Placement(transformation(extent={{-40,-42},{40,38}})));

  TRANSFORM.Fluid.BoundaryConditions.Boundary_pT sink(
    nPorts=1,
    p=PHS.port_b_nominal.p,
    T=PHS.port_b_nominal.T,
    redeclare package Medium = Modelica.Media.Water.StandardWater)
    annotation (Placement(transformation(extent={{70,30},{50,50}})));
  TRANSFORM.Fluid.BoundaryConditions.Boundary_pT      source(
    nPorts=1,
    T=PHS.port_a_nominal.T,
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    p=PHS.port_a_nominal.p)
    annotation (Placement(transformation(extent={{70,-42},{50,-22}})));
equation
  connect(sink.ports[1], PHS.port_b) annotation (Line(points={{50,40},{46,40},
          {46,14},{40,14}}, color={0,127,255}));
  connect(source.ports[1], PHS.port_a) annotation (Line(points={{50,-32},{46,
          -32},{46,-18},{40,-18}}, color={0,127,255}));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,100}})),
    experiment(
      StopTime=1000,
      __Dymola_NumberOfIntervals=1000,
      __Dymola_Algorithm="Esdirk45a"),
    __Dymola_experimentSetupOutput);
end Test;
