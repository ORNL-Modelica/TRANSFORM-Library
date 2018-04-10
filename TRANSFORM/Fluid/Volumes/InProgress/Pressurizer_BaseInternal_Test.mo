within TRANSFORM.Fluid.Volumes.InProgress;
model Pressurizer_BaseInternal_Test
  import TRANSFORM;
  extends TRANSFORM.Icons.Example;

  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow vaporHeater
    annotation (Placement(transformation(extent={{-58,10},{-38,30}})));
  Modelica.Blocks.Sources.Constant vaporHeaterSource(k=0)
    annotation (Placement(transformation(extent={{-90,10},{-70,30}})));
  Modelica.Blocks.Sources.Constant liquidHeaterSource(k=0)
    annotation (Placement(transformation(extent={{-90,-30},{-70,-10}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow liquidHeater
    annotation (Placement(transformation(extent={{-58,-30},{-38,-10}})));
  inner TRANSFORM.Fluid.System    system(energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyStateInitial)
    annotation (Placement(transformation(extent={{-90,70},{-70,90}})));
  Modelica.Fluid.Sources.MassFlowSource_h surge(
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    h=400e3,
    m_flow=0,
    nPorts=1)
    annotation (Placement(transformation(extent={{-48,-70},{-28,-50}})));
  Modelica.Fluid.Sources.MassFlowSource_h relief(          redeclare package
              Medium =
               Modelica.Media.Water.StandardWater,
    h=relief.Medium.dewEnthalpy(relief.Medium.setSat_p(system.p_start)),
    nPorts=1)
    annotation (Placement(transformation(extent={{48,50},{28,70}})));
  Modelica.Fluid.Sources.MassFlowSource_h spray(
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    h=400e3,
    m_flow=0,
    nPorts=1)
             annotation (Placement(transformation(extent={{-48,50},{-28,70}})));
  TRANSFORM.Fluid.Volumes.InProgress.Pressurizer drum2Phase(
    V_total=2/3*pi + pi + 2/3*pi,
    redeclare model DrumType =
        TRANSFORM.Fluid.Volumes.ClosureModels.Geometry.DrumTypes.Traditional (
        r_1=1,
        r_2=1,
        h_2=1,
        r_3=1),
    Vfrac_liquid_start=0.6,
    redeclare model BulkEvaporation =
        TRANSFORM.Fluid.ClosureRelations.MassTransfer.Models.Lumped.ConstantTimeDelay
        (m=drum2Phase.m_liquid),
    redeclare model BulkCondensation =
        TRANSFORM.Fluid.ClosureRelations.MassTransfer.Models.Lumped.ConstantTimeDelay
        (m=drum2Phase.m_vapor),
    redeclare model HeatTransfer_WL =
        TRANSFORM.Fluid.ClosureRelations.HeatTransfer.Models.Lumped.Alphas,
    redeclare model HeatTransfer_WV =
        TRANSFORM.Fluid.ClosureRelations.HeatTransfer.Models.Lumped.Alphas)
    annotation (Placement(transformation(extent={{-23,-24},{23,24}})));

  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature Temp_wallVapor(T=398.15)
                annotation (Placement(transformation(extent={{70,10},{50,30}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature Temp_walLiquid(T=348.15)
    annotation (Placement(transformation(extent={{70,-30},{50,-10}})));
equation
  connect(relief.ports[1], drum2Phase.steamPort)
    annotation (Line(points={{28,60},{13.8,60},{13.8,24}}, color={0,127,255}));
  connect(spray.ports[1], drum2Phase.sprayPort) annotation (Line(points={{-28,60},
          {-13.8,60},{-13.8,24}},              color={0,127,255}));
  connect(surge.ports[1], drum2Phase.surgePort) annotation (Line(points={{-28,-60},
          {-0.23,-60},{-0.23,-23.76}},      color={0,127,255}));
  connect(Temp_wallVapor.port, drum2Phase.heatPort_WV) annotation (Line(points={{50,20},
          {40,20},{40,9.6},{23,9.6}},          color={191,0,0}));
  connect(Temp_walLiquid.port, drum2Phase.heatPort_WL) annotation (Line(points=
          {{50,-20},{40,-20},{40,-9.6},{23,-9.6}}, color={191,0,0}));
  connect(liquidHeater.port, drum2Phase.liquidHeater) annotation (Line(points={
          {-38,-20},{-30,-20},{-30,-9.6},{-23,-9.6}}, color={191,0,0}));
  connect(vaporHeater.port, drum2Phase.vaporHeater) annotation (Line(points={{
          -38,20},{-30,20},{-30,9.6},{-23,9.6}}, color={191,0,0}));
  connect(vaporHeaterSource.y, vaporHeater.Q_flow)
    annotation (Line(points={{-69,20},{-58,20},{-58,20}}, color={0,0,127}));
  connect(liquidHeaterSource.y, liquidHeater.Q_flow) annotation (Line(points={{
          -69,-20},{-63.5,-20},{-58,-20}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})),
    experiment(StopTime=1000, __Dymola_NumberOfIntervals=1000),
    __Dymola_experimentSetupOutput);
end Pressurizer_BaseInternal_Test;
