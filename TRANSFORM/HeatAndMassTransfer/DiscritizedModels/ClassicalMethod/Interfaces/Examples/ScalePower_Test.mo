within TRANSFORM.HeatAndMassTransfer.DiscritizedModels.ClassicalMethod.Interfaces.Examples;
model ScalePower_Test "Verification of ScalePower component"
  import TRANSFORM;
  extends Modelica.Icons.Example;

  ScalePower scalePower_Right(nParallel=10)
    annotation (Placement(transformation(extent={{-22,10},{32,70}})));
  TRANSFORM.HeatAndMassTransfer.BoundaryConditions.Heat.HeatFlow
                                                      fixedHeatFlow_Right(
      Q_flow=100)
    annotation (Placement(transformation(extent={{-78,30},{-58,50}})));
  Volumes.UnitVolume                                     heatCapacitor_Right(
    V=1,
    d=1,
    cp=1)  annotation (Placement(transformation(extent={{50,52},{70,72}})));
  ScalePower scalePower_Left(nParallel=10)
    annotation (Placement(transformation(extent={{-22,-90},{32,-30}})));
  TRANSFORM.HeatAndMassTransfer.BoundaryConditions.Heat.HeatFlow
                                                      fixedHeatFlow_Left(Q_flow=
       100) annotation (Placement(transformation(extent={{80,-70},{60,-50}})));
  Volumes.UnitVolume                                     heatCapacitor_Left(
    V=1,
    d=1,
    cp=1)
    annotation (Placement(transformation(extent={{-70,-48},{-50,-28}})));
equation
  connect(fixedHeatFlow_Right.port, scalePower_Right.heatPorts_a[1])
    annotation (Line(points={{-58,40},{-22,40},{-22,40}}, color={191,0,0}));
  connect(heatCapacitor_Right.port, scalePower_Right.heatPorts_b[1])
    annotation (Line(points={{60,52},{60,40},{32,40}}, color={191,0,0}));
  connect(heatCapacitor_Left.port, scalePower_Left.heatPorts_a[1])
    annotation (Line(points={{-60,-48},{-60,-60},{-22,-60}}, color={191,0,0}));
  connect(fixedHeatFlow_Left.port, scalePower_Left.heatPorts_b[1])
    annotation (Line(points={{60,-60},{32,-60},{32,-60}}, color={191,0,0}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})),
    experiment(
      StopTime=200,
      __Dymola_NumberOfIntervals=200,
      __Dymola_Algorithm="Esdirk45a"),
    __Dymola_experimentSetupOutput);
end ScalePower_Test;
