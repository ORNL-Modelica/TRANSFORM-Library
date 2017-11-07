within TRANSFORM.HeatAndMassTransfer.Examples.ExamplesFrom_NellisAndKlein;
model OvenBrazing "Example 3.2-1 Oven Brazing pp. 339-348"
  extends Icons.Example;

  Modelica.Blocks.Sources.Constant V(k=10/100^3) "volume"
    annotation (Placement(transformation(extent={{-100,84},{-92,92}})));
  Modelica.Blocks.Sources.Constant As(k=35/100^2)
    "surface area for heat transfer"
    annotation (Placement(transformation(extent={{-100,70},{-92,78}})));
  Modelica.Blocks.Sources.Constant lambda(each k=50) "thermal conductivity"
    annotation (Placement(transformation(extent={{-68,84},{-60,92}})));
  Modelica.Blocks.Sources.Constant d(each k=8700) "density"
    annotation (Placement(transformation(extent={{-68,70},{-60,78}})));
  Modelica.Blocks.Sources.Constant cp(each k=500) "heat capacity"
    annotation (Placement(transformation(extent={{-54,70},{-46,78}})));
  Utilities.Visualizers.displayReal display_tau_lumped(use_port=true, precision=
       1) annotation (Placement(transformation(extent={{-40,-34},{-20,-14}})));
  Utilities.Visualizers.displayReal display_biot(use_port=true, precision=3)
    annotation (Placement(transformation(extent={{-40,-12},{-20,8}})));
  Volumes.UnitVolume metalObject(
    V=V.y,
    d=d.y,
    cp=cp.y,
    T_start=Tini.k,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    annotation (Placement(transformation(extent={{30,-20},{50,-40}})));
  Resistances.Heat.Radiation radiation(surfaceArea=As.y, epsilon=e.y)
    annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=-90,
        origin={40,0})));
  BoundaryConditions.Heat.Temperature ovenWall(use_port=true) annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={40,30})));
  Modelica.Blocks.Sources.Constant Tini(each k=
        Units.Conversions.Functions.Temperature_K.from_degC(20))
    "initial plastic disk temperature"
    annotation (Placement(transformation(extent={{-84,84},{-76,92}})));
  Modelica.Blocks.Sources.Trapezoid Toven(
    amplitude=Units.Conversions.Functions.Temperature_K.from_degC(450),
    rising=450,
    width=1000,
    falling=450,
    nperiod=1,
    offset=Units.Conversions.Functions.Temperature_K.from_degC(20),
    period=3000) "oven temperature"
    annotation (Placement(transformation(extent={{-84,70},{-76,78}})));
  Resistances.Heat.Radiation Rrad(surfaceArea=As.y, epsilon=e.y)
    annotation (Placement(transformation(extent={{-50,16},{-30,36}})));
  BoundaryConditions.Heat.Temperature T_metal_max(T=
        Units.Conversions.Functions.Temperature_K.from_degC(470)) annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-66,26})));
  BoundaryConditions.Heat.Temperature T_oven_max(T=
        Units.Conversions.Functions.Temperature_K.from_degC(470)) annotation (
      Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={-14,26})));
  Modelica.Blocks.Sources.Constant e(each k=0.8) "surface emissivity"
    annotation (Placement(transformation(extent={{-54,84},{-46,92}})));
  Utilities.CharacteristicNumbers.Models.BiotNumber_general biotNumber(
    R_conv=Rrad.R,
    lambda=lambda.y,
    surfaceArea=As.y,
    L=V.y/As.y)
    annotation (Placement(transformation(extent={{-72,-12},{-52,8}})));
  Utilities.CharacteristicNumbers.Models.LumpedHeatTimeConstant tau_lumped(
    R=Rrad.R,
    d=d.y,
    cp=cp.y,
    V=V.y) annotation (Placement(transformation(extent={{-72,-34},{-52,-14}})));
  Modelica.Blocks.Sources.RealExpression T_boundary(y=Toven.y)
    annotation (Placement(transformation(extent={{70,30},{50,50}})));
  Utilities.ErrorAnalysis.UnitTests unitTests(n=1, x={metalObject.T})
    annotation (Placement(transformation(extent={{80,80},{100,100}})));
equation
  connect(ovenWall.port, radiation.port_b)
    annotation (Line(points={{40,20},{40,7}}, color={191,0,0}));
  connect(radiation.port_a, metalObject.port)
    annotation (Line(points={{40,-7},{40,-20}},         color={191,0,0}));
  connect(Rrad.port_a, T_metal_max.port)
    annotation (Line(points={{-47,26},{-56,26}}, color={191,0,0}));
  connect(Rrad.port_b, T_oven_max.port)
    annotation (Line(points={{-33,26},{-24,26}}, color={191,0,0}));
  connect(biotNumber.y, display_biot.u)
    annotation (Line(points={{-51,-2},{-41.5,-2}}, color={0,0,127}));
  connect(tau_lumped.y, display_tau_lumped.u)
    annotation (Line(points={{-51,-24},{-41.5,-24}}, color={0,0,127}));
  connect(T_boundary.y, ovenWall.T_ext)
    annotation (Line(points={{49,40},{40,40},{40,34}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(StopTime=3000, __Dymola_NumberOfIntervals=100));
end OvenBrazing;
