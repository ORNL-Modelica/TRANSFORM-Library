within TRANSFORM.Fluid.Volumes.InProgress.Verification.MIT_LowPressure_Experiment;
model InsurgeToHotWall
  "Experiment described in 3.4.4 and Appendix C Insurge to the Hot Wall Experiment by Kim (1984)"
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
      Units.Conversions.Functions.Distance_m.from_in(11.0)
    "Initial liquid level (empty = 0)";
  constant SI.Pressure mainTank_p_start=
      Units.Conversions.Functions.Pressure_Pa.from_psi(113.7)
    "Initial pressure of main (primary) tank";
  constant SI.Temperature insurge_T = SI.Conversions.from_degF(78) "Insurge water temperature";

  constant SI.Height mainTank_level_beforeInsurge_start=
      Units.Conversions.Functions.Distance_m.from_in(10.4)
    "Liquid level before insurge (empty = 0)";
  constant SI.Pressure mainTank_p_beforeInsurge_start=
      Units.Conversions.Functions.Pressure_Pa.from_psi(86.4)
    "pressure of main (primary) tank before insurge";

  constant Units.NonDim mainTank_V_liquid_start = mainTank_V*mainTank_level_start/mainTank_height "Initial liquid level in main (primary) tank";
  constant Units.NonDim mainTank_Vfrac_liquid_start = mainTank_V_liquid_start/mainTank_V "Initial liquid level in main (primary) tank";

  constant SI.Temperature wall_Tavg = SI.Conversions.from_degF(300) "Average wall temperature";
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
      Units.Conversions.Functions.Distance_m.from_in(35)
    "Final liquid level (empty = 0)";
  constant SI.Pressure mainTank_p_final=
      Units.Conversions.Functions.Pressure_Pa.from_psi(123.5)
    "Final pressure of main (primary) tank";

  Modelica.Blocks.Sources.TimeTable data_m_flow(table=[0,0; 30,0; 60.62491523,0;
        61.01983887,0.189333682; 61.43302512,0.454831731; 67.87527918,
        0.430313189; 74.02758168,0.415679011; 82.4245408,0.393215569;
        93.10662712,0.377378851; 104.0374277,0.361923454; 110.4483638,
        0.343957035; 110.709687,0.235146535; 110.7284499,0.082244279;
        110.8733532,-0.12053175; 111.5347994,-0.047307642; 111.8166939,0; 130,0;
        150,0]) "time (s) vs insurge m_flow (kg/s) from experiment: Figure C.1"
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
  Modelica.Blocks.Sources.TimeTable data_pressure(table=[0,784853.6278; 3,
        784845.7303; 6.838186631,784277.5437; 7.869973649,731378.1489;
        8.795162509,694924.0827; 9.824014733,655939.6754; 11.06207584,
        615203.7269; 12.36241918,568328.9229; 14.68322049,511821.7836;
        15.50406462,531540.251; 16.43002596,549297.5255; 18.3321113,571869.833;
        22.2555745,587321.2712; 28.97923875,592952.9326; 38.66767578,595602.549;
        49.22841108,595655.4709; 60.22107112,595606.2647; 67.83318326,
        640069.3516; 74.20985288,677622.0701; 80.27612007,714645.2625;
        84.93375503,745459.6531; 88.40585204,757232.4922; 94.67832052,
        778997.1382; 98.72923514,796326.1631; 104.4260678,818128.7381;
        107.2829499,833549.2719; 110.8774754,853353.6715; 112.1234664,
        837686.6404; 114.0010436,829290.2034; 117.1341572,822009.0792;
        126.1565078,812525.2319; 136.4193351,806291.5915; 145.9887678,
        802243.2176]) "time (s) vs pressure (Pa) from experiment: Figure C.2"
    annotation (Placement(transformation(extent={{20,-90},{40,-70}})));
  Modelica.Blocks.Sources.TimeTable data_Temperature_centerline40(table=[0,
        443.1123341; 4.058724545,442.9573717; 6.820804771,443.0326696;
        8.41843502,439.3500609; 10.05502797,435.9654181; 11.10768683,
        433.4352314; 12.62745983,429.7755981; 14.69116444,425.6534272;
        15.85958287,428.0078785; 17.86422077,430.1191707; 20.27187173,
        431.2795917; 23.69174395,431.8507805; 28.00932805,434.3582478;
        30.69904341,436.1217403; 35.28484965,437.2931786; 42.17149371,
        438.0623317; 50.83280307,438.6665401; 57.15406861,438.8819267;
        61.96506719,439.1668339; 65.45671493,440.8204503; 68.51241188,
        442.954251; 72.43728067,444.8854598; 78.3436607,446.9885469;
        80.74977731,447.5197275; 84.71799836,449.2663471; 88.14530808,
        450.2535932; 93.39008552,450.5776436; 101.3241194,450.9282747;
        107.2030253,451.2120743; 111.7539987,451.7132002; 114.4944038,
        450.5625261; 118.1106514,449.6877668; 125.4435893,448.0940404;
        134.3115543,446.8601214; 142.8963728,445.8127305; 148.5086462,
        445.3176336])
    "time (s) vs centerline temperature (K) at 40\" from experiment: Figure C.17"
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
end InsurgeToHotWall;
