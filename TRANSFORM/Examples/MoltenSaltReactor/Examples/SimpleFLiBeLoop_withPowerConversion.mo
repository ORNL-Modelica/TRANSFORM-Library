within TRANSFORM.Examples.MoltenSaltReactor.Examples;
model SimpleFLiBeLoop_withPowerConversion
  import TRANSFORM;

  package Medium = TRANSFORM.Media.Fluids.FLiBe.LinearFLiBe_pT (
  extraPropertiesNames={"PreGroup_1","PreGroup_2","PreGroup_3","PreGroup_4","PreGroup_5","PreGroup_6"},
  C_nominal={1e6,1e6,1e6,1e6,1e6,1e6});
  package Medium_bop = Modelica.Media.Water.StandardWater "Working fluid";

  parameter SI.Length H = 3.4;
  parameter SI.Length L = 6.296;
  parameter SI.Velocity v=0.4772;
  parameter SI.Length d = sqrt(4*1/1000/v/Modelica.Constants.pi);

  parameter SI.MassFlowRate m_flow_steam=0.1566 "Flow rate in cycle";
  parameter SI.Pressure p_steam = 8.6e6 "Steam pressure";
  parameter SI.Temperature T_steam = SI.Conversions.from_degC(500) "Steam temperature";

  parameter SI.Pressure p_condenser = 1e4 "Condenser pressure";
  parameter SI.Efficiency eta = 0.75 "Overall turbine efficiency";
  parameter SI.Temperature T_condenser = SI.Conversions.from_degC(45.8) "Condenser saturated liquid temperature";
  parameter SI.PressureDifference dp_pump = p_steam - p_condenser;

  Fluid.Pipes.GenericPipe_MultiTransferSurface pipe_steam(
    redeclare package Medium = Medium_bop,
    m_flow_a_start=m_flow_steam,
    use_Ts_start=false,
    p_a_start=p_steam,
    use_HeatTransfer=true,
    h_a_start=Medium_bop.specificEnthalpy_pT(p_steam, T_condenser),
    h_b_start=Medium_bop.specificEnthalpy_pT(p_steam, T_steam),
    redeclare model Geometry =
        TRANSFORM.Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.StraightPipe
        (
        dimension=d,
        nV=10,
        length=L,
        surfaceArea={pipe_steam.geometry.perimeter*pipe_steam.geometry.length*
            20}),
    redeclare model HeatTransfer =
        TRANSFORM.Fluid.ClosureRelations.HeatTransfer.Models.DistributedPipe_1D_MultiTransferSurface.Alphas_TwoPhase_3Region)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,2})));

  Fluid.BoundaryConditions.MassFlowSource_T boundary(
    nPorts=1,
    m_flow=m_flow_steam,
    T=T_condenser,
    redeclare package Medium = Medium_bop)
    annotation (Placement(transformation(extent={{40,-50},{20,-30}})));
  Fluid.BoundaryConditions.Boundary_pT boundary1(
    redeclare package Medium = Medium_bop,
    p=100000,
    T=T_condenser,
    nPorts=1)
    annotation (Placement(transformation(extent={{60,2},{40,22}})));
  Fluid.Machines.SteamTurbineStodola steamTurbine(
    p_a_start(displayUnit="kPa") = p_steam,
    p_b_start(displayUnit="kPa") = p_condenser,
    T_a_start=T_steam,
    T_b_start=T_condenser,
    m_flow_start=m_flow_steam,
    redeclare model Eta_wetSteam =
        Fluid.Machines.BaseClasses.WetSteamEfficiency.eta_Constant (eta_nominal=
           eta),
    redeclare package Medium = Medium_bop)
    annotation (Placement(transformation(extent={{12,32},{32,52}})));
  Electrical.PowerConverters.Generator           generator
    annotation (Placement(transformation(extent={{42,32},{62,52}})));
  Electrical.Sources.FrequencySource boundary3(f=60)
    annotation (Placement(transformation(extent={{92,32},{72,52}})));
  Fluid.Pipes.GenericPipe_MultiTransferSurface           pipe(
    redeclare package Medium = Medium,
    m_flow_a_start=1,
    redeclare model Geometry =
        Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.StraightPipe
        (
        dimension=d,
        length=H,
        nV=10),
    redeclare model InternalHeatGen =
        Fluid.ClosureRelations.InternalVolumeHeatGeneration.Models.DistributedVolume_1D.GenericHeatGeneration
        (Q_gens=kinetics.Qs),
    redeclare model InternalTraceMassGen =
        TRANSFORM.Fluid.ClosureRelations.InternalTraceGeneration.Models.DistributedVolume_Trace_1D.GenericTraceGeneration
        (mC_gens=kinetics.mC_gens),
    T_a_start=573.15,
    T_b_start=773.15,
    p_a_start=100000)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-56,2})));
  Fluid.Pipes.GenericPipe_wWall_wTraceMass downcomer(
    redeclare package Medium = Medium,
    m_flow_a_start=1,
    use_HeatTransfer=true,
    redeclare model InternalHeatGen =
        Fluid.ClosureRelations.InternalVolumeHeatGeneration.Models.DistributedVolume_1D.GenericHeatGeneration,
    redeclare package Material =
        Media.Solids.CustomSolids.Lambda_10_d_7990_cp_500,
    counterCurrent=true,
    use_HeatTransferOuter=true,
    redeclare model InternalTraceMassGen =
        TRANSFORM.Fluid.ClosureRelations.InternalTraceGeneration.Models.DistributedVolume_Trace_1D.GenericTraceGeneration
        (mC_gens={{-kinetics.lambda_i[j]*downcomer.pipe.mCs[i, j] for j in 1:
            kinetics.nI} for i in 1:downcomer.pipe.nV}),
    redeclare model Geometry =
        Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.Pipe_Wall.StraightPipe
        (
        dimension=d,
        length=L,
        nV=10,
        th_wall=0.001,
        surfaceArea={downcomer.geometry.perimeter*downcomer.geometry.length*10}),
    T_a_start=773.15,
    T_b_start=573.15,
    T_a1_start=773.15,
    T_a2_start=773.15,
    p_a_start=100000)  annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=90,
        origin={-16,2})));

  Fluid.Sensors.TraceSubstancesTwoPort_multi traceSubstance(redeclare package
      Medium = Medium)
    annotation (Placement(transformation(extent={{-10,10},{10,-10}},
        rotation=270,
        origin={-16,-28})));
  Nuclear.ReactorKinetics.PointKinetics_Drift kinetics(
    nV=pipe.nV,
    Q_nominal=5e4*pipe.nV,
    mCs=pipe.mCs,
    rhos_input=cat(
        1,
        fill(0, 4),
        {rho_external.y},
        fill(0, 5)),
    vals_feedback=matrix(pipe.mediums.T),
    vals_feedback_reference=matrix(linspace(
        300 + 273.15,
        500 + 273.15,
        pipe.nV)))
    annotation (Placement(transformation(extent={{-96,-8},{-76,12}})));
  Fluid.Volumes.ExpansionTank_1Port expansionTank_1Port(
    redeclare package Medium = Medium,
    A=1,
    level_start=0.1,
    T_start=773.15)
    annotation (Placement(transformation(extent={{-66,56},{-46,76}})));
  Fluid.FittingsAndResistances.SpecifiedResistance resistance(redeclare package
      Medium = Medium, R=1e6) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-56,42})));
  Fluid.Machines.Pump pump_SimpleMassFlow(
    redeclare package Medium = Medium,
    m_flow_nominal=1,
    T_start=573.15,
    m_flow_start=1,
    controlType="m_flow")
    annotation (Placement(transformation(extent={{-26,-68},{-46,-48}})));
  TRANSFORM.Utilities.Visualizers.displayReal display_Q_th(val=sum(kinetics.Qs)/
        1000) annotation (Placement(transformation(extent={{-40,76},{-8,96}})));
  TRANSFORM.Utilities.Visualizers.displayReal display_Q_elec(val=generator.Q_elec
        /1000) annotation (Placement(transformation(extent={{8,76},{40,96}})));
  Modelica.Blocks.Sources.Sine sine(               amplitude=1*0.0065, freqHz=1
        /2000)
    annotation (Placement(transformation(extent={{-140,-90},{-120,-70}})));
  Modelica.Blocks.Logical.Switch rho_external
    annotation (Placement(transformation(extent={{-110,-60},{-90,-40}})));
  Modelica.Blocks.Sources.Constant const(k=0)
    annotation (Placement(transformation(extent={{-140,-30},{-120,-10}})));
  Modelica.Blocks.Logical.LessThreshold lessThreshold(threshold=1000)
    annotation (Placement(transformation(extent={{-140,-60},{-120,-40}})));
  Modelica.Blocks.Sources.Clock clock
    annotation (Placement(transformation(extent={{-170,-60},{-150,-40}})));
equation
  connect(boundary.ports[1], pipe_steam.port_a)
    annotation (Line(points={{20,-40},{0,-40},{0,-8}}, color={0,127,255}));
  connect(pipe_steam.port_b, steamTurbine.portHP)
    annotation (Line(points={{0,12},{0,48},{12,48}}, color={0,127,255}));
  connect(generator.port, boundary3.port) annotation (Line(points={{62,42},{67.1,
          42},{67.1,42},{72,42}}, color={255,0,0}));
  connect(steamTurbine.shaft_b, generator.shaft)
    annotation (Line(points={{32,42},{42,42}}, color={0,0,0}));
  connect(boundary1.ports[1], steamTurbine.portLP)
    annotation (Line(points={{40,12},{29,12},{29,32}}, color={0,127,255}));
  connect(pipe.port_b, downcomer.port_a) annotation (Line(points={{-56,12},{-56,
          22},{-16,22},{-16,12}}, color={0,127,255}));
  connect(downcomer.port_b, traceSubstance.port_a)
    annotation (Line(points={{-16,-8},{-16,-18}}, color={0,127,255}));
  connect(resistance.port_a, pipe.port_b)
    annotation (Line(points={{-56,35},{-56,12}},   color={0,127,255}));
  connect(expansionTank_1Port.port, resistance.port_b)
    annotation (Line(points={{-56,57.6},{-56,49}},   color={0,127,255}));
  connect(pump_SimpleMassFlow.port_a, traceSubstance.port_b) annotation (Line(
        points={{-26,-58},{-16,-58},{-16,-38}}, color={0,127,255}));
  connect(pump_SimpleMassFlow.port_b, pipe.port_a) annotation (Line(points={{-46,-58},
          {-56,-58},{-56,-8}},        color={0,127,255}));
  connect(downcomer.heatPorts, pipe_steam.heatPorts[:, 1])
    annotation (Line(points={{-11,2},{-5,2}}, color={191,0,0}));
  connect(const.y, rho_external.u1) annotation (Line(points={{-119,-20},{-116,
          -20},{-116,-42},{-112,-42}}, color={0,0,127}));
  connect(sine.y, rho_external.u3) annotation (Line(points={{-119,-80},{-116,
          -80},{-116,-58},{-112,-58}}, color={0,0,127}));
  connect(lessThreshold.y, rho_external.u2)
    annotation (Line(points={{-119,-50},{-112,-50}}, color={255,0,255}));
  connect(clock.y, lessThreshold.u)
    annotation (Line(points={{-149,-50},{-142,-50}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false), graphics={Text(
          extent={{-42,96},{-4,92}},
          lineColor={0,0,0},
          textString="Heat Generated [kW]"), Text(
          extent={{4,96},{46,92}},
          lineColor={0,0,0},
          textString="Electricity Generated [kW]")}),
    experiment(
      StopTime=5000,
      __Dymola_NumberOfIntervals=5000,
      __Dymola_Algorithm="Esdirk45a"));
end SimpleFLiBeLoop_withPowerConversion;
