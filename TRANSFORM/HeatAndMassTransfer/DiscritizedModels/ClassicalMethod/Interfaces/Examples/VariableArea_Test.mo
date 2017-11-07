within TRANSFORM.HeatAndMassTransfer.DiscritizedModels.ClassicalMethod.Interfaces.Examples;
model VariableArea_Test "Verification of VariableArea component"
  import TRANSFORM;
  extends Modelica.Icons.Example;

  VariableArea variableArea(
    nVar=2,
    surfaceAreas_Var={Area_1.y,Area_2.y},
    nFixed=2,
    surfaceAreas_Fixed={Area_3.y,Area_4.y})
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Sources.Ramp Area_1(
    height=0.8,
    duration=10,
    offset=0.2,
    startTime=5)
    annotation (Placement(transformation(extent={{-48,-96},{-28,-76}})));
  Modelica.Blocks.Math.Add Area_2
    annotation (Placement(transformation(extent={{-48,-56},{-28,-36}})));
  Modelica.Blocks.Sources.Constant const(k=1.0)
    annotation (Placement(transformation(extent={{-100,-50},{-80,-30}})));
  Modelica.Blocks.Math.Product product
    annotation (Placement(transformation(extent={{-58,-72},{-68,-62}})));
  Modelica.Blocks.Sources.Constant const1(k=-1.0)
    annotation (Placement(transformation(extent={{-66,-82},{-58,-74}})));
  TRANSFORM.HeatAndMassTransfer.Resistances.Heat.Convection
                                                      convection_var[
    variableArea.nVar](surfaceArea={Area_1.y,Area_2.y}, alpha={1,1})
    annotation (Placement(transformation(extent={{-30,-10},{-50,10}})));
  TRANSFORM.HeatAndMassTransfer.Resistances.Heat.Convection
                                                      convection[variableArea.nFixed](
      surfaceArea={Area_3.y,Area_4.y}, alpha={1,1})
    annotation (Placement(transformation(extent={{22,-10},{42,10}})));
  TRANSFORM.HeatAndMassTransfer.BoundaryConditions.Heat.Temperature
                                                         fixedTemperature[
    variableArea.nFixed](each T=573.15)
    annotation (Placement(transformation(extent={{80,-10},{60,10}})));
  TRANSFORM.HeatAndMassTransfer.BoundaryConditions.Heat.Temperature
                                                         fixedTemperature_var[
    variableArea.nVar](each T=473.15)
    annotation (Placement(transformation(extent={{-90,-10},{-70,10}})));
  Modelica.Blocks.Sources.Ramp Area_3(
    duration=10,
    offset=0.2,
    startTime=20,
    height=0.8)
    annotation (Placement(transformation(extent={{72,30},{92,50}})));
  Modelica.Blocks.Math.Add Area_4
    annotation (Placement(transformation(extent={{72,70},{92,90}})));
  Modelica.Blocks.Sources.Constant const3(k=1.0)
    annotation (Placement(transformation(extent={{20,76},{40,96}})));
  Modelica.Blocks.Math.Product product1
    annotation (Placement(transformation(extent={{62,54},{52,64}})));
  Modelica.Blocks.Sources.Constant const4(k=-1.0)
    annotation (Placement(transformation(extent={{54,44},{62,52}})));
equation
  connect(const.y, Area_2.u1)
    annotation (Line(points={{-79,-40},{-60,-40},{-50,-40}},
                                                       color={0,0,127}));
  connect(Area_1.y, product.u1) annotation (Line(points={{-27,-86},{-22,-86},{
          -22,-64},{-57,-64}},
                    color={0,0,127}));
  connect(const1.y, product.u2) annotation (Line(points={{-57.6,-78},{-52,-78},
          {-52,-70},{-57,-70}},
                        color={0,0,127}));
  connect(product.y, Area_2.u2) annotation (Line(points={{-68.5,-67},{-74,-67},
          {-74,-52},{-50,-52}},
                        color={0,0,127}));
  connect(const3.y, Area_4.u1)
    annotation (Line(points={{41,86},{60,86},{70,86}}, color={0,0,127}));
  connect(Area_3.y, product1.u1) annotation (Line(points={{93,40},{98,40},{98,
          62},{63,62}}, color={0,0,127}));
  connect(const4.y, product1.u2) annotation (Line(points={{62.4,48},{68,48},{68,
          56},{63,56}}, color={0,0,127}));
  connect(product1.y, Area_4.u2) annotation (Line(points={{51.5,59},{46,59},{46,
          74},{70,74}}, color={0,0,127}));
  connect(variableArea.heatPorts_Fixed, convection.port_a)
    annotation (Line(points={{10,0},{25,0}}, color={127,0,0}));
  connect(convection.port_b, fixedTemperature.port)
    annotation (Line(points={{39,0},{60,0},{60,0}}, color={191,0,0}));
  connect(fixedTemperature_var.port, convection_var.port_b)
    annotation (Line(points={{-70,0},{-47,0}}, color={191,0,0}));
  connect(convection_var.port_a, variableArea.heatPorts_Var) annotation (
      Line(points={{-33,0},{-21.5,0},{-10,0}}, color={191,0,0}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})),
    experiment(StopTime=35, __Dymola_Algorithm="Dassl"),
    __Dymola_experimentSetupOutput);
end VariableArea_Test;
