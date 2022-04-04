within TRANSFORM.Fluid.Volumes.InProgress.Verification.MIT_LowPressure_Experiment;
model Outsurge
  "Experiment described in 3.4.3 and Appendix B Outsurge Experiment by Kim (1984)"
  extends Icons.Example;
  // Experiment Parameters
  package Medium = Modelica.Media.Water.StandardWater "Medium in component";
  constant SI.Length mainTank_d_inner=
      Units.Conversions.Functions.Distance_m.from_in(7.625)
    "Inner diameter of the main (primary) tank";
  constant SI.Length mainTank_d_outer=
      Units.Conversions.Functions.Distance_m.from_in(8.625)
    "Outer diameter of the main (primary) tank";
  constant SI.Length mainTank_th = 0.5*(mainTank_d_outer - mainTank_d_inner) "Wall thickness of thee main (primary) tank";
  constant SI.Length mainTank_height=
      Units.Conversions.Functions.Distance_m.from_in(45)
    "Internal height of the main (primary) tank";
  constant SI.Volume mainTank_V = mainTank_height*0.25*pi*mainTank_d_inner^2 "Empty volume of the main (primary) tank (excludes ~negligible port/level indicator volumes)";
  constant SI.Volume wall_V = 0.25*pi*(mainTank_d_outer^2 - mainTank_d_inner^2)*mainTank_height "Wall volume";
  // Experiment Initial Conditions
  constant SI.Height mainTank_level_start=
      Units.Conversions.Functions.Distance_m.from_in(29.5)
    "Initial liquid level (empty = 0)";
  constant SI.Pressure mainTank_p_start=
      Units.Conversions.Functions.Pressure_Pa.from_psi(125.7)
    "Initial pressure of main (primary) tank";
  constant SI.Temperature insurge_T = Modelica.Units.Conversions.from_degF(
                                                               73) "Insurge water temperature";
  constant Units.NonDim mainTank_V_liquid_start = mainTank_V*mainTank_level_start/mainTank_height "Initial liquid level in main (primary) tank";
  constant Units.NonDim mainTank_Vfrac_liquid_start = mainTank_V_liquid_start/mainTank_V "Initial liquid level in main (primary) tank";
  constant SI.Temperature wall_Tavg = Modelica.Units.Conversions.from_degF(
                                                               300) "Average wall temperature";
  constant SI.ThermalConductivity wall_lambda=
      TRANSFORM.Media.Solids.SS316.thermalConductivity_T(wall_Tavg)
    "Wall thermalconductivity";
  constant SI.SpecificHeatCapacity wall_cp=
      TRANSFORM.Media.Solids.SS316.specificHeatCapacity_T(wall_Tavg)
    "Wall specific heat capacity";
  constant SI.Density wall_rho=TRANSFORM.Media.Solids.SS316.density_T(wall_Tavg)
    "Wall density";
  // Experiment Final Conditions
  constant SI.Height mainTank_level_final=
      Units.Conversions.Functions.Distance_m.from_in(9.6)
    "Final liquid level (empty = 0)";
  constant SI.Pressure mainTank_p_final=
      Units.Conversions.Functions.Pressure_Pa.from_psi(118.5)
    "Final pressure of main (primary) tank";
  Modelica.Blocks.Sources.TimeTable data_m_flow(table=[0,0; 3,0; 6.895544116,0;
        7.259061564,-0.334092452; 9.510461761,-0.319327177; 12.29366218,-0.306738169;
        14.86451606,-0.292838906; 20.28142266,-0.279819157; 25.68881454,-0.283052705;
        31.09077461,-0.295565038; 36.49037509,-0.312108065; 41.7939007,-0.334011641;
        47.13483039,-0.342988141; 52.14464186,-0.357080985; 54.81465463,-0.382008334;
        57.03914879,-0.402031347; 58.69562007,-0.420238949; 62.34269914,-0.426842298;
        62.612452,-0.397201436; 63.56882147,-0.351076839; 63.82305161,-0.234308336;
        64.64038567,-0.108173433; 64.79492806,0; 100,0; 150,0])
    "time (s) vs insurge m_flow (kg/s) from experiment: Figure B.1"
    annotation (Placement(transformation(extent={{-80,-62},{-60,-42}})));
  Real p_exp "Experimentally measured pressure in psia";
  // Models
  Modelica.Fluid.Sources.MassFlowSource_h spray(nPorts=1, redeclare package
      Medium = Medium)
    annotation (Placement(transformation(extent={{-48,50},{-28,70}})));
  Modelica.Fluid.Sources.MassFlowSource_h relief(nPorts=1, redeclare package
      Medium = Medium)
    annotation (Placement(transformation(extent={{48,50},{28,70}})));
  Modelica.Fluid.Sources.MassFlowSource_T insurge(nPorts=1, use_m_flow_in=true,
    T=insurge_T,
    redeclare package Medium = Medium)
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
  inner System system(energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
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
  Modelica.Blocks.Sources.TimeTable data_pressure(table=[0,867197.077; 3.984647074,
        867229.9496; 7.463129496,867245.9769; 9.057653003,859056.1962; 15.78677123,
        854681.9995; 22.38731343,849904.223; 29.39950608,844257.8899; 34.04471632,
        840384.4375; 39.74805135,835937.5215; 44.74677132,831045.3973; 49.21941964,
        826084.6052; 54.53314857,820140.6996; 58.18763262,815141.1757; 62.16276978,
        811185.7512; 63.99862242,814350.1401; 68.45053957,816646.3329; 72.91750828,
        816337.4416; 81.57462961,815035.5338; 90.05563773,814171.1618; 98.63979694,
        812696.7659; 107.0551343,811628.7; 115.552839,810252.4248; 124.0322127,808777.6347;
        132.5598044,808093.8619; 140.4272062,806560.5166; 147.3335678,805328.5999])
    "time (s) vs pressure (Pa) from experiment: Figure B.2"
    annotation (Placement(transformation(extent={{20,-90},{40,-70}})));
  Modelica.Blocks.Sources.TimeTable data_Temperature_centerline40(table=[0.84263782,
        448.4653003; 3.771132836,448.4193227; 7.014352067,448.3868453; 8.325089647,
        448.0684228; 12.89613684,447.9202272; 22.38748686,447.6043152; 30.42147337,
        447.2791273; 38.05410936,446.9732559; 44.08910224,446.6226887; 51.05948589,
        446.315764; 57.60671533,445.9391665; 61.6992319,445.6795141; 64.7375184,
        445.9327317; 72.04469905,445.9343527; 82.98584916,445.8689904; 93.71437186,
        445.7854217; 104.4438411,445.7101491; 115.1689583,445.5967328; 125.901857,
        445.5515175; 136.6287186,445.4533901; 145.9068676,445.3705483])
    "time (s) vs centerline temperature (K) at 40\" from experiment: Figure B.17"
    annotation (Placement(transformation(extent={{60,-90},{80,-70}})));
equation
 p_exp =TRANSFORM.Units.Conversions.Functions.Pressure_Pa.to_psi(data_pressure.y);
  connect(insurge.ports[1], pressurizer.surgePort) annotation (Line(points={{-28,-60},
          {-14,-60},{0,-60},{0,-26}},      color={0,127,255}));
  connect(spray.ports[1], pressurizer.sprayPort) annotation (Line(points={{-28,60},
          {-22,60},{-14.4,60},{-14.4,26}}, color={0,127,255}));
  connect(relief.ports[1], pressurizer.reliefPort)
    annotation (Line(points={{28,60},{14.4,60},{14.4,26}}, color={0,127,255}));
  connect(data_m_flow.y, insurge.m_flow_in) annotation (Line(points={{-59,-52},{
          -53.5,-52},{-48,-52}}, color={0,0,127}));
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
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(
      StopTime=150,
      __Dymola_NumberOfIntervals=5000,
      Tolerance=1e-006));
end Outsurge;
