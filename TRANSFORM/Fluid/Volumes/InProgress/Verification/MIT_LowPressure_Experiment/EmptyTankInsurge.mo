within TRANSFORM.Fluid.Volumes.InProgress.Verification.MIT_LowPressure_Experiment;
model EmptyTankInsurge
  "Experiment described in 3.4.6 and Appendix E Empty Tank Insurge Experiment by Kim (1984)"
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
      Units.Conversions.Functions.Distance_m.from_inch(9.3)
    "Initial liquid level (empty = 0)";
  constant SI.Pressure mainTank_p_start=
      Units.Conversions.Functions.Pressure_Pa.from_psi(126)
    "Initial pressure of main (primary) tank";
  constant SI.Temperature insurge_T = SI.Conversions.from_degF(75) "Insurge water temperature";

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
      Units.Conversions.Functions.Distance_m.from_inch(27.8)
    "Final liquid level (empty = 0)";
  constant SI.Pressure mainTank_p_empty=
      Units.Conversions.Functions.Pressure_Pa.from_psi(112.5)
    "Empty main (primary) tank pressure";
  constant SI.Pressure mainTank_p_final=
      Units.Conversions.Functions.Pressure_Pa.from_psi(54.5)
    "Final main (primary) tank pressure";

  Modelica.Blocks.Sources.TimeTable data_m_flow(table=[0,0; 20,0; 43.45024059,0;
        44.52345734,0.086628967; 44.65950883,0.195130832; 45.06077874,
        0.268220252; 48.89497755,0.282032931; 51.395329,0.30123847; 52.69955612,
        0.323627967; 55.21833986,0.357334752; 58.05260037,0.393096898;
        59.92671525,0.415331178; 62.51430969,0.433029094; 65.550152,0.439406732;
        68.48630177,0.432644068; 71.14972956,0.420053075; 79.00285214,
        0.380559346; 85.56507135,0.345438132; 91.47542431,0.310180178;
        97.03133635,0.276419122; 101.5206731,0.243086463; 105.7287499,
        0.207498007; 108.5492507,0.185507632; 111.388234,0.162294412;
        111.9346083,0.091205168; 113.1949885,0; 130,0; 150,0])
    "time (s) vs insurge m_flow (kg/s) from experiment: Figure E.1"
    annotation (Placement(transformation(extent={{-80,-62},{-60,-42}})));

  Real p_exp "Experimentally measured pressure in psia";

  // Models
  Modelica.Fluid.Sources.MassFlowSource_h spray(nPorts=1, redeclare package
              Medium =
               Medium)
    annotation (Placement(transformation(extent={{-48,50},{-28,70}})));
  Modelica.Fluid.Sources.MassFlowSource_h relief(nPorts=1, redeclare package
              Medium =
               Medium)
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
  Modelica.Blocks.Sources.TimeTable data_pressure(table=[0,872203.5002;
        4.419589059,870904.7953; 8.590625913,847214.8633; 12.96638061,
        830125.3729; 16.50231899,815009.4125; 17.89356508,752075.8853;
        19.15822645,744819.8275; 21.41038486,763547.0668; 24.60047572,
        769194.6267; 31.49070649,769283.5885; 40.13272799,765825.3835;
        45.49792706,764624.9819; 46.23587451,741746.6299; 49.36269447,
        682735.3379; 51.54046487,622293.7833; 53.19312951,564785.766;
        54.95098001,506977.4244; 56.60183377,446320.5313; 58.15040981,
        391020.7697; 59.90701098,331040.0434; 62.71030146,261037.5801;
        65.0070926,214502.9693; 68.32349362,189656.5921; 73.24310343,
        194659.3885; 79.71413635,211711.9656; 88.08984417,248069.6948;
        96.66781852,296496.9427; 104.9964389,342813.3571; 110.9371864,377010.05;
        115.8934393,377471.8514; 122.3670437,375885.4495; 130.6031964,
        374347.7324; 139.3716108,373201.0376; 146.5037855,369540.9798])
    "time (s) vs pressure (Pa) from experiment: Figure E.2"
    annotation (Placement(transformation(extent={{20,-90},{40,-70}})));
  Modelica.Blocks.Sources.TimeTable data_Temperature_centerline40(table=[0,
        447.6355833; 6.173760315,446.9398258; 11.24242548,445.632821;
        16.96273358,444.3512484; 18.86309734,440.6677054; 21.80132,441.8772474;
        30.32258738,442.2273242; 39.09075655,442.0382547; 45.34508442,
        441.9987276; 46.58687138,440.2007813; 50.79483679,435.5145822;
        53.33657623,429.5768141; 55.36606612,424.2196992; 57.07853447,
        419.0611437; 58.57889567,414.1785261; 59.97512704,409.0702204;
        61.36999154,404.2203031; 63.19173689,398.3144371; 65.64250602,
        392.9602776; 67.40669117,390.0569932; 69.4476111,389.4327284;
        74.76329323,391.2981328; 80.18851135,394.1363866; 88.24948223,
        399.5342535; 95.07296542,404.3366979; 98.84430069,408.17762;
        99.73714728,411.7364807; 101.9038916,415.9715366; 103.7236293,
        418.8373102; 105.48361,421.7383954; 107.2077233,421.7430489;
        108.1433895,422.6452504; 110.3305767,424.0006678; 112.9506545,
        423.3781533; 116.7649079,422.4885849; 120.8930907,421.2570977;
        129.5348664,420.2682658; 138.2390993,419.4187722; 146.1682196,
        419.3283312])
    "time (s) vs centerline temperature (K) at 40\" from experiment: Figure E.17"
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
end EmptyTankInsurge;
