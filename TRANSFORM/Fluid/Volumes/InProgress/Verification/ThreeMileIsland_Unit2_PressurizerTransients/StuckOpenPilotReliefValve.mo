within TRANSFORM.Fluid.Volumes.InProgress.Verification.ThreeMileIsland_Unit2_PressurizerTransients;
model StuckOpenPilotReliefValve
  "Section 4.1.1 of EPRI 1987 report for Three Mile Island Unit-2 Transient: Stuck open pilot operated relief valve"
  extends Icons.Example;

  // Experiment Initial Conditions
  constant SI.Height level_start = 2.65 "Initial liquid level (empty = 0)";
  constant SI.Pressure p_start = SI.Conversions.from_bar(151.3) "Initial pressure";
  constant SI.Temperature T_start = 616 "Initial temperature";

  Real p_exp "Experimentally measured pressure in psia";

  // Models
  Modelica.Fluid.Sources.MassFlowSource_h spray(nPorts=1, redeclare package
      Medium = Medium)
    annotation (Placement(transformation(extent={{-48,50},{-28,70}})));
  Modelica.Fluid.Sources.MassFlowSource_h relief(nPorts=1, redeclare package
      Medium = Medium)
    annotation (Placement(transformation(extent={{48,50},{28,70}})));
  Modelica.Fluid.Sources.MassFlowSource_T insurge(nPorts=1,
    redeclare package Medium = Medium,
    use_m_flow_in=false)
    annotation (Placement(transformation(extent={{-48,-70},{-28,-50}})));
  Volumes.InProgress.Pressurizer_withWall pressurizer(
    V_total=mainTank_V,
    redeclare model DrumType =
        Volumes.ClosureModels.Geometry.DrumTypes.SimpleCylinder (r_1=0.5*
            mainTank_d_inner, h_1=mainTank_height),
    Vfrac_liquid_start=mainTank_Vfrac_liquid_start,
    p_start=mainTank_p_start,
    redeclare package Medium = Medium,
    cp_wall=wall_cp,
    rho_wall=wall_rho,
    V_wall=wall_V,
    redeclare model BulkEvaporation =
        Volumes.ClosureModels.MassTransfer.Evaporation.PhaseSeparationHypothesis
        (Ac=pressurizer.drum2Phase.drumType.crossArea_liquid),
    redeclare model BulkCondensation =
        Volumes.ClosureModels.MassTransfer.Condensation.PhaseSeparation_TerminalVelocity
        (V_fluid=pressurizer.drum2Phase.V_vapor, L_c=0.5*pressurizer.drum2Phase.drumType.level_vapor),
    redeclare model HeatTransfer_VL =
        Volumes.ClosureModels.MassTransfer.PhaseInterface.ConstantHeatTransferCoefficient,
    redeclare model MassTransfer_VL =
        Volumes.ClosureModels.MassTransfer.PhaseInterface.GasKineticTheory)
    annotation (Placement(transformation(extent={{-24,-26},{24,26}})));

    //G=2*pi*wall_lambda*0.5*mainTank_height/Modelica.Math.log(mainTank_d_outer/mainTank_d_inner)
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow heaterVapor
    annotation (Placement(transformation(extent={{-60,0},{-40,20}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow heaterLiquid
    annotation (Placement(transformation(extent={{-60,-20},{-40,0}})));
  Modelica.Blocks.Sources.Constant heaterVapor_input(k=0)
    annotation (Placement(transformation(extent={{-100,10},{-80,30}})));
  Modelica.Blocks.Sources.Constant heaterLiquid_input(k=0)
    annotation (Placement(transformation(extent={{-100,-30},{-80,-10}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature
                                                         temperatureAmbient
    annotation (Placement(transformation(extent={{70,10},{50,30}})));
  inner System    system(energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    annotation (Placement(transformation(extent={{80,80},{100,100}})));
  Utilities.Visualizers.displayReal pressure(val=
        Units.Conversions.Functions.Pressure_Pa.to_psi(pressurizer.drum2Phase.p))
    annotation (Placement(transformation(extent={{-10,0},{10,20}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature temperatureAmbient1(T=
        Medium.saturationTemperature(mainTank_p_start))
    annotation (Placement(transformation(extent={{70,-30},{50,-10}})));
  Modelica.Blocks.Sources.RealExpression realExpression(y=
        Medium.saturationTemperature(pressurizer.drum2Phase.p))
    annotation (Placement(transformation(extent={{110,10},{90,30}})));
  Modelica.Blocks.Sources.TimeTable data_pressure(table=[0,151.335901;
        30.31232409,140.2749444; 59.84444455,130.9573664; 90.22808165,
        121.1950804; 119.7853177,112.2942647; 150.1925874,106.4456227;
        189.6424925,98.78120209; 209.3330919,92.3191549; 239.3262373,
        83.97451379; 268.8476062,80.20022111; 299.6525968,82.7406793])
    "time (s) vs pressure (bar) from experiment: Figure 4-1-1"
    annotation (Placement(transformation(extent={{20,-90},{40,-70}})));
  Data_Geometry data
    annotation (Placement(transformation(extent={{60,80},{80,100}})));
  Units.Conversions.Models.Conversion conversion(redeclare function convert =
        Units.Conversions.Functions.Pressure_Pa.from_bar)
    annotation (Placement(transformation(extent={{50,-90},{70,-70}})));
equation

 p_exp =TRANSFORM.Units.Conversions.Functions.Pressure_Pa.to_psi(data_pressure.y);

  connect(insurge.ports[1], pressurizer.surgePort) annotation (Line(points={{-28,-60},
          {-14,-60},{0,-60},{0,-26}},      color={0,127,255}));
  connect(spray.ports[1], pressurizer.sprayPort) annotation (Line(points={{-28,60},
          {-22,60},{-14.4,60},{-14.4,26}}, color={0,127,255}));
  connect(relief.ports[1], pressurizer.reliefPort)
    annotation (Line(points={{28,60},{14.4,60},{14.4,26}}, color={0,127,255}));
  connect(heaterVapor_input.y, heaterVapor.Q_flow) annotation (Line(points={{-79,
          20},{-72,20},{-72,10},{-60,10}}, color={0,0,127}));
  connect(heaterLiquid_input.y, heaterLiquid.Q_flow) annotation (Line(points={{-79,
          -20},{-72,-20},{-72,-10},{-60,-10}}, color={0,0,127}));
  connect(heaterVapor.port, pressurizer.vaporHeater)
    annotation (Line(points={{-40,10},{-24,10},{-24,10.4}}, color={191,0,0}));
  connect(heaterLiquid.port, pressurizer.liquidHeater) annotation (Line(points={{-40,-10},
          {-24,-10},{-24,-10.4}},           color={191,0,0}));
  connect(pressurizer.heatTransfer_wall, temperatureAmbient.port) annotation (
      Line(points={{24,3.12},{33,3.12},{33,20},{50,20}}, color={191,0,0}));
  connect(temperatureAmbient1.port, pressurizer.heatTransfer_wall1) annotation (
     Line(points={{50,-20},{34,-20},{34,-2.6},{24,-2.6}}, color={191,0,0}));
  connect(realExpression.y, temperatureAmbient.T)
    annotation (Line(points={{89,20},{72,20}}, color={0,0,127}));
  connect(data_pressure.y, conversion.u)
    annotation (Line(points={{41,-80},{48,-80},{48,-80}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(
      StopTime=150,
      __Dymola_NumberOfIntervals=5000,
      Tolerance=1e-006));
end StuckOpenPilotReliefValve;
