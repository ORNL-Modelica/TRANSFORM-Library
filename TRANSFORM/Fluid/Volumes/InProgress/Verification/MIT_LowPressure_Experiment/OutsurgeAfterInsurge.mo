within TRANSFORM.Fluid.Volumes.InProgress.Verification.MIT_LowPressure_Experiment;
model OutsurgeAfterInsurge
  "Experiment described in 3.4.5 and Appendix D Outsurge after Insurge Experiment by Kim (1984)"
  extends Icons.Example;

  // Experiment Parameters
  package Medium = Modelica.Media.Water.StandardWater "Medium in component";
  constant SI.Length mainTank_d_inner=
      Units.Conversions.Functions.Distance_m.from_inch(7.625)
    "Inner diameter of the main (primary) tank";
  constant SI.Length mainTank_d_outer=
      Units.Conversions.Functions.Distance_m.from_inch(8.625)
    "Outer diameter of the main (primary) tank";
  constant SI.Length mainTank_th = 0.5*(mainTank_d_outer - mainTank_d_inner) "Wall thickness of thee main (primary) tank";
  constant SI.Length mainTank_height=
      Units.Conversions.Functions.Distance_m.from_inch(45)
    "Internal height of the main (primary) tank";
  constant SI.Volume mainTank_V = mainTank_height*0.25*pi*mainTank_d_inner^2 "Empty volume of the main (primary) tank (excludes ~negligible port/level indicator volumes)";
  constant SI.Volume wall_V = 0.25*pi*(mainTank_d_outer^2 - mainTank_d_inner^2)*mainTank_height "Wall volume";

  // Experiment Initial Conditions
  constant SI.Height mainTank_level_start=
      Units.Conversions.Functions.Distance_m.from_inch(20.5)
    "Initial liquid level (empty = 0)";
  constant SI.Pressure mainTank_p_start=
      Units.Conversions.Functions.Pressure_Pa.from_psi(101.3)
    "Initial pressure of main (primary) tank";
  constant SI.Temperature insurge_T = SI.Conversions.from_degF(78) "Insurge water temperature";

  constant Units.nonDim mainTank_V_liquid_start = mainTank_V*mainTank_level_start/mainTank_height "Initial liquid level in main (primary) tank";
  constant Units.nonDim mainTank_Vfrac_liquid_start = mainTank_V_liquid_start/mainTank_V "Initial liquid level in main (primary) tank";

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
      Units.Conversions.Functions.Distance_m.from_inch(7.7)
    "Final liquid level (empty = 0)";

  Modelica.Blocks.Sources.TimeTable data_m_flow(table=[0,0; 7.166899212,0;
        14.04723543,0; 14.8008195,0.163682959; 15.11310244,0.310242216;
        18.42266587,0.298937991; 25.88575619,0.293070624; 33.55059433,
        0.286518434; 41.41572073,0.277589034; 49.01202142,0.265671711;
        56.60272511,0.248338292; 59.30257006,0.222102301; 61.84683702,
        0.174601885; 62.21760057,0.139220771; 63.01509939,0.09555795;
        63.57910973,0.064001073; 64.09525025,0.01580303; 64.96859494,-0.070050931;
        67.49159935,-0.122234962; 69.53803642,-0.151891478; 73.083908,-0.170890486;
        80.99826595,-0.201522712; 88.55097344,-0.23720439; 96.08617456,-0.270009275;
        103.7421097,-0.302034036; 111.2924592,-0.33331693; 118.8223699,-0.354877228;
        126.3623229,-0.356742212; 133.9253328,-0.354197191; 139.6847263,-0.345512717;
        142.4235341,-0.240361803; 142.7599634,-0.158928423; 143.7452373,-0.06613594;
        144.151542,0; 146.7217951,0; 149.5260854,0])
    "time (s) vs insurge m_flow (kg/s) from experiment: Figure D.1"
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
  Modelica.Blocks.Sources.TimeTable data_pressure(table=[0,699205.0819;
        6.72111215,698727.8032; 14.31388999,698519.0619; 21.49573976,
        718508.6312; 29.9392322,738957.4103; 38.12216866,762256.5214;
        45.02416154,783617.5058; 51.11830015,807312.9101; 56.63958352,
        830883.4551; 61.23779141,849314.7224; 63.61451328,846591.0904;
        68.1216369,808538.1407; 71.01850711,786932.7015; 73.45043124,
        764538.9829; 76.53087948,739110.9763; 79.79702753,714654.6992;
        83.57909524,691854.5328; 87.44994729,681348.275; 91.79383233,
        675637.4746; 100.2778944,664788.1431; 108.971572,651021.6192;
        117.2887713,634614.3974; 121.9204279,619005.8007; 125.5033988,
        608425.6617; 127.6706467,610826.2311; 132.9335998,591212.3648;
        137.0420413,574801.2889; 139.6213921,560859.4706; 144.0553887,
        558480.5513; 148.5355168,555446.8143])
    "time (s) vs pressure (Pa) from experiment: Figure D.2"
    annotation (Placement(transformation(extent={{20,-90},{40,-70}})));
  Modelica.Blocks.Sources.TimeTable data_Temperature_centerline40(table=[0,
        438.4857826; 7.847461119,438.4510711; 14.35547108,438.4948704;
        21.03141302,439.6393628; 29.42093342,440.8207825; 37.65088337,
        442.0299023; 45.54399786,443.3681323; 53.0946252,444.875834;
        60.77173083,446.5001276; 63.43624231,446.5062817; 68.77171062,
        444.1005102; 72.07934804,442.7095433; 76.01056974,440.9105375;
        79.35401708,439.5508125; 84.38365111,438.0225745; 92.39196132,
        437.0503727; 100.7858452,436.3067509; 109.4097646,435.4263884;
        118.1411491,434.2666231; 126.0083114,432.8854419; 133.1466482,
        431.5449726; 139.1965922,429.7996596; 147.6559854,429.1784382])
    "time (s) vs centerline temperature (K) at 40\" from experiment: Figure D.17"
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
end OutsurgeAfterInsurge;
