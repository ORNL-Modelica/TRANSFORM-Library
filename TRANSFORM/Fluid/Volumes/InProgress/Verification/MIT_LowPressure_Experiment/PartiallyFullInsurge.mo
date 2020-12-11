within TRANSFORM.Fluid.Volumes.InProgress.Verification.MIT_LowPressure_Experiment;
model PartiallyFullInsurge
  "Experiment described in 3.4.2 and Appendix A Partially Full Insurge Experiment by Kim (1984)"
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
      Units.Conversions.Functions.Distance_m.from_in(13.9)
    "Initial liquid level (empty = 0)";
  constant SI.Pressure mainTank_p_start=
      Units.Conversions.Functions.Pressure_Pa.from_psi(101)
    "Initial pressure of main (primary) tank";
  constant SI.Temperature insurge_T = Modelica.Units.Conversions.from_degF(
                                                               75) "Insurge water temperature";
  constant Units.NonDim mainTank_V_liquid_start = mainTank_V*mainTank_level_start/mainTank_height "Initial liquid level in main (primary) tank";
  constant Units.NonDim mainTank_Vfrac_liquid_start = mainTank_V_liquid_start/mainTank_V "Initial liquid level in main (primary) tank";
//   constant SI.Temperature wall_Tavg = SI.Conversions.from_degF(300) "Average wall temperature";
//   constant SI.ThermalConductivity wall_lambda = TRANSFORM.Media.Solids.SS316.thermalConductivity(wall_Tavg) "Wall thermalconductivity";
//   constant SI.SpecificHeatCapacity wall_cp = TRANSFORM.Media.Solids.SS316.specificHeatCapacity(wall_Tavg) "Wall specific heat capacity";
//   constant SI.Density wall_rho = TRANSFORM.Media.Solids.SS316.density(wall_Tavg) "Wall density";
  // Experiment Final Conditions
  constant SI.Height mainTank_level_final=
      Units.Conversions.Functions.Distance_m.from_in(34.0)
    "Final liquid level (empty = 0)";
  Modelica.Blocks.Sources.TimeTable data_m_flow(table=[0,0; 10,0; 22.28437644,0;
        22.91577121,0.272367524; 31.86942254,0.266409136; 43.06925393,0.260400477;
        53.62958548,0.251100563; 61.8038418,0.24413366; 69.79479562,0.236071427;
        76.67156336,0.225544443; 81.39570882,0.217938478; 84.60789982,0.211600851;
        85.72181909,0.161960042; 85.83104657,0; 100,0; 150,0; 200,0])
    "time (s) vs insurge m_flow (kg/s) from experiment: Figure A.1"
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
    redeclare model BulkEvaporation =
        Volumes.ClosureModels.MassTransfer.Evaporation.PhaseSeparationHypothesis
        (Ac=pressurizer.drum2Phase.drumType.crossArea_liquid),
    redeclare model BulkCondensation =
        Volumes.ClosureModels.MassTransfer.Condensation.PhaseSeparation_TerminalVelocity
        (V_fluid=pressurizer.drum2Phase.V_vapor, L_c=0.5*pressurizer.drum2Phase.drumType.level_vapor),
    redeclare model HeatTransfer_VL =
        Volumes.ClosureModels.MassTransfer.PhaseInterface.ConstantHeatTransferCoefficient,
    redeclare model MassTransfer_VL =
        Volumes.ClosureModels.MassTransfer.PhaseInterface.ConstantMassTransportCoefficient,
    r_inner=0.5*mainTank_d_inner,
    r_outer=0.5*mainTank_d_outer,
    length=mainTank_height,
    nRadial=5,
    redeclare model SolutionMethod_FD =
        HeatAndMassTransfer.DiscritizedModels.ClassicalMethod.Cylindrical.SolutionMethods.AxVolCentered_1DRadial,
    redeclare model HeatTransfer_WL =
        ClosureRelations.HeatTransfer.Models.Lumped.Alphas,
    redeclare model HeatTransfer_WV =
        ClosureRelations.HeatTransfer.Models.Lumped.Alphas)
    annotation (Placement(transformation(extent={{-24,-26},{24,26}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow heaterVapor
    annotation (Placement(transformation(extent={{-60,0},{-40,20}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow heaterLiquid
    annotation (Placement(transformation(extent={{-60,-20},{-40,0}})));
  Modelica.Blocks.Sources.Constant heaterVapor_input(k=0)
    annotation (Placement(transformation(extent={{-100,10},{-80,30}})));
  Modelica.Blocks.Sources.Constant heaterLiquid_input(k=0)
    annotation (Placement(transformation(extent={{-100,-30},{-80,-10}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature temperatureAmbient[
  pressurizer.wall.nAxial](each T=298.15)
  annotation (Placement(transformation(extent={{100,-10},{80,10}})));
  inner System system
    annotation (Placement(transformation(extent={{80,80},{100,100}})));
  Utilities.Visualizers.displayReal pressure(val=
        Units.Conversions.Functions.Pressure_Pa.to_psi(pressurizer.drum2Phase.p))
    annotation (Placement(transformation(extent={{-10,0},{10,20}})));
  Modelica.Blocks.Sources.TimeTable data_pressure(table=[0,698124.0814; 5.420768248,
        698364.516; 13.15619768,698276.8626; 21.6295517,697730.8655; 24.93400029,
        705901.1191; 33.29035873,720709.582; 42.57094714,737038.5337; 50.84981993,
        753407.5281; 57.56880057,768829.902; 63.99878865,784764.4787; 70.05180953,
        800759.9799; 75.46984649,816469.1783; 80.44196129,833729.5192; 83.08695685,
        844727.617; 85.36252611,853598.4594; 87.16002905,840354.222; 91.7875087,
        829877.9584; 97.80844989,823919.9183; 108.4607088,817756.9107; 119.0722664,
        812116.5765; 129.5137701,806094.4734; 139.8361229,800872.4748; 147.6158298,
        797018.9055]) "time (s) vs pressure (Pa) from experiment: Figure A.2"
    annotation (Placement(transformation(extent={{20,-90},{40,-70}})));
  Modelica.Blocks.Sources.TimeTable data_Temperature_centerline40(table=[0,440.0364239;
        8.040575108,439.9322594; 16.18912194,439.8828563; 22.55499404,439.9145577;
        26.18366495,440.5266649; 35.30748241,441.3317224; 44.616211,442.3108726;
        54.31978287,443.4240063; 62.851096,444.5645298; 70.0631272,445.6007153;
        76.20127406,446.684937; 81.35385616,447.8010456; 85.56623897,448.8780387;
        88.45383194,448.3523416; 99.17309509,447.1396752; 109.9168917,446.4864512;
        120.6743259,446.0960435; 131.4315293,445.701187; 141.8797238,445.3496209;
        148.5190725,445.1236491])
    "time (s) vs centerline temperature (K) at 40\" from experiment: Figure A.17"
    annotation (Placement(transformation(extent={{60,-90},{80,-70}})));
  HeatAndMassTransfer.DiscritizedModels.ClassicalMethod.BoundaryConditions.Convection_FD
    convection(
    nNodes=pressurizer.wall.nAxial,
    Areas=pressurizer.wall.solutionMethod.A_outer,
    alphas={100,100})
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
equation
 p_exp =TRANSFORM.Units.Conversions.Functions.Pressure_Pa.to_psi(data_pressure.y);
  connect(insurge.ports[1], pressurizer.surgePort) annotation (Line(points={{-28,-60},
        {-14,-60},{0,-60},{0,-26}},        color={0,127,255}));
  connect(spray.ports[1], pressurizer.sprayPort) annotation (Line(points={{-28,60},
        {-22,60},{-14.4,60},{-14.4,26}},   color={0,127,255}));
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
        {-24,-10},{-24,-10.4}},             color={191,0,0}));
connect(pressurizer.heatPorts_b, convection.port_a)
  annotation (Line(points={{24,0},{39,0}}, color={127,0,0}));
connect(convection.port_b, temperatureAmbient.port)
  annotation (Line(points={{61,0},{70.5,0},{80,0}}, color={127,0,0}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(
    StopTime=150,
    __Dymola_NumberOfIntervals=5000,
    Tolerance=1e-006,
    __Dymola_Algorithm="Dassl"));
end PartiallyFullInsurge;
