within TRANSFORM.HeatExchangers;
model GenericDistributed_HX
  "A (i.e., no inlet/outlet plenum considerations, etc.) generic heat exchanger with discritized fluid and wall volumes where concurrent/counter flow is specified mass flow direction."

  import TRANSFORM.Math.linspace_1D;
  import TRANSFORM.Math.fillArray_1D;
  import TRANSFORM.Math.linspaceRepeat_1D;
  import TRANSFORM.Fluid.Types.LumpedLocation;
  import Modelica.Fluid.Types.Dynamics;

  TRANSFORM.Fluid.Interfaces.FluidPort_Flow port_a_tube(redeclare package
      Medium = Medium_tube) annotation (Placement(transformation(extent={{-110,-10},
            {-90,10}}), iconTransformation(extent={{-110,-10},{-90,10}})));
  TRANSFORM.Fluid.Interfaces.FluidPort_Flow port_b_tube(redeclare package
      Medium = Medium_tube) annotation (Placement(transformation(extent={{90,-10},
            {110,10}}), iconTransformation(extent={{90,-10},{110,10}})));

  TRANSFORM.Fluid.Interfaces.FluidPort_Flow port_a_shell(redeclare package
      Medium = Medium_shell) annotation (Placement(transformation(extent={{90,36},
            {110,56}}), iconTransformation(extent={{90,36},{110,56}})));
  TRANSFORM.Fluid.Interfaces.FluidPort_Flow port_b_shell(redeclare package
      Medium = Medium_shell) annotation (Placement(transformation(extent={{-110,
            36},{-90,56}}), iconTransformation(extent={{-110,36},{-90,56}})));

  parameter Real nParallel=1 "# of identical parallel HXs";

  replaceable model Geometry =
      TRANSFORM.Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.HeatExchanger.StraightPipeHX
    constrainedby
    TRANSFORM.Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.HeatExchanger.GenericHX
    "Geometry" annotation (choicesAllMatching=true);

  Geometry geometry
    annotation (Placement(transformation(extent={{-98,82},{-82,98}})));

  replaceable package Medium_shell =
      Modelica.Media.Interfaces.PartialMedium
    "Shell side medium" annotation (choicesAllMatching=true);

  replaceable package Medium_tube = Modelica.Media.Interfaces.PartialMedium
    "Tube side medium" annotation (choicesAllMatching=true);

  replaceable package Material_tubeWall =
      TRANSFORM.Media.Interfaces.Solids.PartialAlloy
                                              "Tube wall material" annotation (
      choicesAllMatching=true);

  parameter Boolean counterCurrent=true
    "Swap shell side temperature and flux vector order";

  replaceable model FlowModel_shell =
      TRANSFORM.Fluid.ClosureRelations.PressureLoss.Models.DistributedPipe_1D.SinglePhase_Developed_2Region_NumStable
    constrainedby
    TRANSFORM.Fluid.ClosureRelations.PressureLoss.Models.DistributedPipe_1D.PartialDistributedStaggeredFlow
    "Shell side flow models (i.e., momentum, pressure loss, wall friction)"
    annotation (choicesAllMatching=true, Dialog(group="Pressure Loss"));
  replaceable model HeatTransfer_shell =
      TRANSFORM.Fluid.ClosureRelations.HeatTransfer.Models.DistributedPipe_1D_MultiTransferSurface.Ideal
    constrainedby
    TRANSFORM.Fluid.ClosureRelations.HeatTransfer.Models.DistributedPipe_1D_MultiTransferSurface.PartialHeatTransfer_setT
    "Shell side coefficient of heat transfer" annotation (choicesAllMatching=true,
      Dialog(group="Heat Transfer"));

  replaceable model FlowModel_tube =
      TRANSFORM.Fluid.ClosureRelations.PressureLoss.Models.DistributedPipe_1D.SinglePhase_Developed_2Region_NumStable
    constrainedby
    TRANSFORM.Fluid.ClosureRelations.PressureLoss.Models.DistributedPipe_1D.PartialDistributedStaggeredFlow
    "Tube side flow models (i.e., momentum, pressure loss, wall friction)"
    annotation (choicesAllMatching=true, Dialog(group="Pressure Loss"));

  replaceable model HeatTransfer_tube =
      TRANSFORM.Fluid.ClosureRelations.HeatTransfer.Models.DistributedPipe_1D_MultiTransferSurface.Ideal
    constrainedby
    TRANSFORM.Fluid.ClosureRelations.HeatTransfer.Models.DistributedPipe_1D_MultiTransferSurface.PartialHeatTransfer_setT
    "Tube side coefficient of heat transfer" annotation (choicesAllMatching=true,
      Dialog(group="Heat Transfer"));

  // Shell Initialization
  parameter SI.AbsolutePressure[geometry.nV] ps_start_shell=linspace_1D(
      p_a_start_shell,
      p_b_start_shell,
      geometry.nV) "Pressure" annotation (Dialog(tab="Shell Initialization",
        group="Start Value: Absolute Pressure"));
  parameter SI.AbsolutePressure p_a_start_shell=Medium_shell.p_default
    "Pressure at port a" annotation (Dialog(tab="Shell Initialization", group="Start Value: Absolute Pressure"));
  parameter SI.AbsolutePressure p_b_start_shell= p_a_start_shell + (if m_flow_a_start_shell > 0 then -1e3 elseif m_flow_a_start_shell < 0 then -1e3 else 0)
    "Pressure at port b" annotation (Dialog(tab="Shell Initialization", group="Start Value: Absolute Pressure"));

  parameter Boolean use_Ts_start_shell=true
    "Use T_start if true, otherwise h_start" annotation (Evaluate=true, Dialog(
        tab="Shell Initialization", group="Start Value: Temperature"));
  parameter SI.Temperature Ts_start_shell[geometry.nV]=linspace_1D(
      T_a_start_shell,
      T_b_start_shell,
      geometry.nV) "Temperature" annotation (Evaluate=true, Dialog(
      tab="Shell Initialization",
      group="Start Value: Temperature",
      enable=use_Ts_start_shell));
  parameter SI.Temperature T_a_start_shell=Medium_shell.T_default
    "Temperature at port a" annotation (Dialog(
      tab="Shell Initialization",
      group="Start Value: Temperature",
      enable=use_Ts_start_shell));
  parameter SI.Temperature T_b_start_shell=T_a_start_shell
    "Temperature at port b" annotation (Dialog(
      tab="Shell Initialization",
      group="Start Value: Temperature",
      enable=use_Ts_start_shell));

  parameter SI.SpecificEnthalpy[geometry.nV] hs_start_shell=if not
      use_Ts_start_shell then linspace_1D(
      h_a_start_shell,
      h_b_start_shell,
      geometry.nV) else {Medium_shell.specificEnthalpy_pTX(
      ps_start_shell[i],
      Ts_start_shell[i],
      Xs_start_shell[i, 1:Medium_shell.nX]) for i in 1:geometry.nV}
    "Specific enthalpy" annotation (Dialog(
      tab="Shell Initialization",
      group="Start Value: Specific Enthalpy",
      enable=not use_Ts_start_shell));
  parameter SI.SpecificEnthalpy h_a_start_shell=
      Medium_shell.specificEnthalpy_pTX(
      p_a_start_shell,
      T_a_start_shell,
      X_a_start_shell) "Specific enthalpy at port a" annotation (Dialog(
      tab="Shell Initialization",
      group="Start Value: Specific Enthalpy",
      enable=not use_Ts_start_shell));
  parameter SI.SpecificEnthalpy h_b_start_shell=
      Medium_shell.specificEnthalpy_pTX(
      p_b_start_shell,
      T_b_start_shell,
      X_b_start_shell) "Specific enthalpy at port b" annotation (Dialog(
      tab="Shell Initialization",
      group="Start Value: Specific Enthalpy",
      enable=not use_Ts_start_shell));

  parameter SI.MassFraction Xs_start_shell[geometry.nV,Medium_shell.nX]=
      linspaceRepeat_1D(
      X_a_start_shell,
      X_b_start_shell,
      geometry.nV) "Mass fraction" annotation (Dialog(
      tab="Shell Initialization",
      group="Start Value: Species Mass Fraction",
      enable=Medium_shell.nXi > 0));
  parameter SI.MassFraction X_a_start_shell[Medium_shell.nX]=Medium_shell.X_default
    "Mass fraction at port a" annotation (Dialog(tab="Shell Initialization",
        group="Start Value: Species Mass Fraction"));
  parameter SI.MassFraction X_b_start_shell[Medium_shell.nX]=X_a_start_shell
    "Mass fraction at port b" annotation (Dialog(tab="Shell Initialization",
        group="Start Value: Species Mass Fraction"));

  parameter SIadd.ExtraProperty Cs_start_shell[geometry.nV,Medium_shell.nC]=
      linspaceRepeat_1D(
      C_a_start_shell,
      C_b_start_shell,
      geometry.nV) "Mass-Specific value" annotation (Dialog(
      tab="Shell Initialization",
      group="Start Value: Trace Substances",
      enable=Medium_shell.nC > 0));
  parameter SIadd.ExtraProperty C_a_start_shell[Medium_shell.nC]=fill(0,
      Medium_shell.nC) "Mass-Specific value at port a" annotation (Dialog(tab="Shell Initialization",
        group="Start Value: Trace Substances"));
  parameter SIadd.ExtraProperty C_b_start_shell[Medium_shell.nC]=C_a_start_shell
    "Mass-Specific value at port b" annotation (Dialog(tab="Shell Initialization",
        group="Start Value: Trace Substances"));

  parameter SI.MassFlowRate[geometry.nV + 1] m_flows_start_shell=linspace(
      m_flow_a_start_shell,
      -m_flow_b_start_shell,
      geometry.nV + 1) "Mass flow rates" annotation (Evaluate=true, Dialog(tab="Shell Initialization",
        group="Start Value: Mass Flow Rate"));
  parameter SI.MassFlowRate m_flow_a_start_shell=0 "Mass flow rate at port_a"
    annotation (Dialog(tab="Shell Initialization", group="Start Value: Mass Flow Rate"));
  parameter SI.MassFlowRate m_flow_b_start_shell=-m_flow_a_start_shell
    "Mass flow rate at port_b" annotation (Dialog(tab="Shell Initialization",
        group="Start Value: Mass Flow Rate"));

  // Tube Initialization
  parameter SI.AbsolutePressure[geometry.nV] ps_start_tube=linspace_1D(
      p_a_start_tube,
      p_b_start_tube,
      geometry.nV) "Pressure" annotation (Dialog(tab="Tube Initialization",
        group="Start Value: Absolute Pressure"));
  parameter SI.AbsolutePressure p_a_start_tube=Medium_tube.p_default
    "Pressure at port a" annotation (Dialog(tab="Tube Initialization", group="Start Value: Absolute Pressure"));
  parameter SI.AbsolutePressure p_b_start_tube= p_a_start_tube + (if m_flow_a_start_tube > 0 then -1e3 elseif m_flow_a_start_tube < 0 then -1e3 else 0)
    "Pressure at port b" annotation (Dialog(tab="Tube Initialization", group="Start Value: Absolute Pressure"));

  parameter Boolean use_Ts_start_tube=true
    "Use T_start if true, otherwise h_start" annotation (Evaluate=true, Dialog(
        tab="Tube Initialization", group="Start Value: Temperature"));
  parameter SI.Temperature Ts_start_tube[geometry.nV]=linspace_1D(
      T_a_start_tube,
      T_b_start_tube,
      geometry.nV) "Temperature" annotation (Evaluate=true, Dialog(
      tab="Tube Initialization",
      group="Start Value: Temperature",
      enable=use_Ts_start_tube));
  parameter SI.Temperature T_a_start_tube=Medium_tube.T_default
    "Temperature at port a" annotation (Dialog(
      tab="Tube Initialization",
      group="Start Value: Temperature",
      enable=use_Ts_start_tube));
  parameter SI.Temperature T_b_start_tube=T_a_start_tube
    "Temperature at port b" annotation (Dialog(
      tab="Tube Initialization",
      group="Start Value: Temperature",
      enable=use_Ts_start_tube));

  parameter SI.SpecificEnthalpy[geometry.nV] hs_start_tube=if not
      use_Ts_start_tube then linspace_1D(
      h_a_start_tube,
      h_b_start_tube,
      geometry.nV) else {Medium_tube.specificEnthalpy_pTX(
      ps_start_tube[i],
      Ts_start_tube[i],
      Xs_start_tube[i, 1:Medium_tube.nX]) for i in 1:geometry.nV}
    "Specific enthalpy" annotation (Dialog(
      tab="Tube Initialization",
      group="Start Value: Specific Enthalpy",
      enable=not use_Ts_start_tube));
  parameter SI.SpecificEnthalpy h_a_start_tube=Medium_tube.specificEnthalpy_pTX(
      p_a_start_tube,
      T_a_start_tube,
      X_a_start_tube) "Specific enthalpy at port a" annotation (Dialog(
      tab="Tube Initialization",
      group="Start Value: Specific Enthalpy",
      enable=not use_Ts_start_tube));
  parameter SI.SpecificEnthalpy h_b_start_tube=Medium_tube.specificEnthalpy_pTX(
      p_b_start_tube,
      T_b_start_tube,
      X_b_start_tube) "Specific enthalpy at port b" annotation (Dialog(
      tab="Tube Initialization",
      group="Start Value: Specific Enthalpy",
      enable=not use_Ts_start_tube));

  parameter SI.MassFraction Xs_start_tube[geometry.nV,Medium_tube.nX]=
      linspaceRepeat_1D(
      X_a_start_tube,
      X_b_start_tube,
      geometry.nV) "Mass fraction" annotation (Dialog(
      tab="Tube Initialization",
      group="Start Value: Species Mass Fraction",
      enable=Medium_tube.nXi > 0));
  parameter SI.MassFraction X_a_start_tube[Medium_tube.nX]=Medium_tube.X_default
    "Mass fraction at port a" annotation (Dialog(tab="Tube Initialization",
        group="Start Value: Species Mass Fraction"));
  parameter SI.MassFraction X_b_start_tube[Medium_tube.nX]=X_a_start_tube
    "Mass fraction at port b" annotation (Dialog(tab="Tube Initialization",
        group="Start Value: Species Mass Fraction"));

  parameter SIadd.ExtraProperty Cs_start_tube[geometry.nV,Medium_tube.nC]=
      linspaceRepeat_1D(
      C_a_start_tube,
      C_b_start_tube,
      geometry.nV) "Mass-Specific value" annotation (Dialog(
      tab="Tube Initialization",
      group="Start Value: Trace Substances",
      enable=Medium_tube.nC > 0));
  parameter SIadd.ExtraProperty C_a_start_tube[Medium_tube.nC]=fill(0, Medium_tube.nC)
    "Mass-Specific value at port a" annotation (Dialog(tab="Tube Initialization",
        group="Start Value: Trace Substances"));
  parameter SIadd.ExtraProperty C_b_start_tube[Medium_tube.nC]=C_a_start_tube
    "Mass-Specific value at port b" annotation (Dialog(tab="Tube Initialization",
        group="Start Value: Trace Substances"));

  parameter SI.MassFlowRate[geometry.nV + 1] m_flows_start_tube=linspace(
      m_flow_a_start_tube,
      -m_flow_b_start_tube,
      geometry.nV + 1) "Mass flow rates" annotation (Evaluate=true, Dialog(tab="Tube Initialization",
        group="Start Value: Mass Flow Rate"));
  parameter SI.MassFlowRate m_flow_a_start_tube=0 "Mass flow rate at port_a"
    annotation (Dialog(tab="Tube Initialization", group="Start Value: Mass Flow Rate"));
  parameter SI.MassFlowRate m_flow_b_start_tube=-m_flow_a_start_tube
    "Mass flow rate at port_b" annotation (Dialog(tab="Tube Initialization",
        group="Start Value: Mass Flow Rate"));

  // Tube Wall Initialization
  parameter SI.Temperature Ts_wall_start[geometry.nR,geometry.nV]=
     linspaceRepeat_1D(
      Ts_wall_start_tubeSide,
      if counterCurrent then Modelica.Math.Vectors.reverse(
        Ts_wall_start_shellSide) else Ts_wall_start_shellSide,
      geometry.nR) "Tube wall temperature" annotation (Dialog(tab="Wall Initialization",
        group="Start Value: Temperature"));
  parameter SI.Temperature Ts_wall_start_tubeSide[geometry.nV]=
      Medium_tube.temperature_phX(
      ps_start_tube,
      hs_start_tube,
      Xs_start_tube) "Tube side wall temperature" annotation (Dialog(tab="Wall Initialization",
        group="Start Value: Temperature"));
  parameter SI.Temperature Ts_wall_start_shellSide[geometry.nV]=
      Medium_shell.temperature_phX(
      ps_start_shell,
      hs_start_shell,
      Xs_start_shell) "Shell side wall temperature" annotation (Dialog(tab="Wall Initialization",
        group="Start Value: Temperature"));

  // Advanced
  parameter Modelica.Fluid.Types.Dynamics energyDynamics[3]={Dynamics.DynamicFreeInitial,
      Dynamics.DynamicFreeInitial,Dynamics.DynamicFreeInitial}
    "Formulation of energy balances {shell,tube,tubeWall}"
    annotation (Dialog(tab="Advanced", group="Dynamics"));
  parameter Modelica.Fluid.Types.Dynamics massDynamics[2]=energyDynamics[1:2]
    "Formulation of mass balances {shell,tube}"
    annotation (Dialog(tab="Advanced", group="Dynamics"));
  parameter Dynamics traceDynamics[2]=massDynamics
    "Formulation of trace substance balances {shell,tube}"
    annotation (Dialog(tab="Advanced", group="Dynamics"));
  parameter Modelica.Fluid.Types.Dynamics momentumDynamics[2]={Dynamics.SteadyState,
      Dynamics.SteadyState} "Formulation of momentum balances {shell,tube}"
    annotation (Dialog(tab="Advanced", group="Dynamics"));

  parameter Boolean allowFlowReversal_shell=true
    "= true to allow flow reversal, false restricts to design direction (port_a -> port_b)"
    annotation (Dialog(tab="Advanced", group="Shell Side"));
  parameter Boolean exposeState_a_shell=true
    "=true, p is calculated at port_a else m_flow"
    annotation (Dialog(tab="Advanced", group="Shell Side"));
  parameter Boolean exposeState_b_shell=false
    "=true, p is calculated at port_b else m_flow"
    annotation (Dialog(tab="Advanced", group="Shell Side"));
  parameter Boolean useLumpedPressure_shell=false
    "=true to lump pressure states together"
    annotation (Dialog(tab="Advanced", group="Shell Side"), Evaluate=true);
  parameter LumpedLocation lumpPressureAt_shell=LumpedLocation.port_a
    "Location of pressure for flow calculations" annotation (Dialog(
      tab="Advanced",
      group="Shell Side",
      enable=if useLumpedPressure_shell and modelStructure_shell <>
          ModelStructure.av_vb then true else false), Evaluate=true);
  parameter Boolean useInnerPortProperties_shell=false
    "=true to take port properties for flow models from internal control volumes"
    annotation (Dialog(tab="Advanced", group="Shell Side"), Evaluate=true);

  parameter Boolean allowFlowReversal_tube=true
    "= true to allow flow reversal, false restricts to design direction (port_a -> port_b)"
    annotation (Dialog(tab="Advanced", group="Tube Side"));
  parameter Boolean exposeState_a_tube=true
    "=true, p is calculated at port_a else m_flow"
    annotation (Dialog(tab="Advanced", group="Tube Side"));
  parameter Boolean exposeState_b_tube=false
    "=true, p is calculated at port_b else m_flow"
    annotation (Dialog(tab="Advanced", group="Tube Side"));
  parameter Boolean useLumpedPressure_tube=false
    "=true to lump pressure states together"
    annotation (Dialog(tab="Advanced", group="Tube Side"), Evaluate=true);
  parameter LumpedLocation lumpPressureAt_tube=LumpedLocation.port_a
    "Location of pressure for flow calculations" annotation (Dialog(
      tab="Advanced",
      group="Tube Side",
      enable=if useLumpedPressure_tube and modelStructure_tube <>
          ModelStructure.av_vb then true else false), Evaluate=true);
  parameter Boolean useInnerPortProperties_tube=false
    "=true to take port properties for flow models from internal control volumes"
    annotation (Dialog(tab="Advanced", group="Tube Side"), Evaluate=true);
  parameter Boolean adiabaticDims[2]={false,false}
    "=true, toggle off conduction heat transfer in dimension {1,2}"
    annotation (Dialog(tab="Advanced", group="Tube Wall"));

  TRANSFORM.HeatAndMassTransfer.BoundaryConditions.Heat.CounterFlow counterFlow(
      counterCurrent=counterCurrent, n=geometry.nV) annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,10})));
  Fluid.Pipes.GenericPipe_MultiTransferSurface
                                    shell(
    redeclare package Medium = Medium_shell,
    use_HeatTransfer=true,
    redeclare model HeatTransfer = HeatTransfer_shell,
    use_Ts_start=use_Ts_start_shell,
    p_a_start=p_a_start_shell,
    p_b_start=p_b_start_shell,
    T_a_start=T_a_start_shell,
    T_b_start=T_b_start_shell,
    h_a_start=h_a_start_shell,
    h_b_start=h_b_start_shell,
    ps_start=ps_start_shell,
    hs_start=hs_start_shell,
    Ts_start=Ts_start_shell,
    nParallel=nParallel,
    Ts_wall(start=transpose(TRANSFORM.Math.fillArray_1D(Ts_wall_start_shellSide,geometry.nSurfaces_shell))),
    redeclare model FlowModel = FlowModel_shell,
    energyDynamics=energyDynamics[1],
    massDynamics=massDynamics[1],
    traceDynamics=traceDynamics[1],
    exposeState_a=exposeState_a_shell,
    exposeState_b=exposeState_b_shell,
    momentumDynamics=momentumDynamics[1],
    useInnerPortProperties=useInnerPortProperties_shell,
    useLumpedPressure=useLumpedPressure_shell,
    lumpPressureAt=lumpPressureAt_shell,
    m_flow_a_start=m_flow_a_start_shell,
    m_flow_b_start=m_flow_b_start_shell,
    m_flows_start=m_flows_start_shell,
    Xs_start=Xs_start_shell,
    Cs_start=Cs_start_shell,
    X_a_start=X_a_start_shell,
    X_b_start=X_b_start_shell,
    C_a_start=C_a_start_shell,
    C_b_start=C_b_start_shell,
    redeclare model Geometry =
        Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.GenericPipe
        (
        nV=geometry.nV,
        crossAreas=geometry.crossAreas_shell,
        perimeters=geometry.perimeters_shell,
        dlengths=geometry.dlengths_shell,
        roughnesses=geometry.roughnesses_shell,
        surfaceAreas=geometry.surfaceAreas_shell,
        dheights=geometry.dheights_shell,
        height_a=geometry.height_a_shell,
        dimensions=geometry.dimensions_shell,
        nSurfaces=geometry.nSurfaces_shell,
        angles=geometry.angles_shell),
    redeclare model InternalHeatGen = InternalHeatGen_shell,
    redeclare model InternalTraceGen = InternalTraceGen_shell)
                                       annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={0,46})));
  Fluid.Pipes.GenericPipe_MultiTransferSurface
                                    tube(
    redeclare package Medium = Medium_tube,
    use_HeatTransfer=true,
    redeclare model HeatTransfer = HeatTransfer_tube,
    use_Ts_start=use_Ts_start_tube,
    p_a_start=p_a_start_tube,
    p_b_start=p_b_start_tube,
    T_a_start=T_a_start_tube,
    T_b_start=T_b_start_tube,
    h_a_start=h_a_start_tube,
    h_b_start=h_b_start_tube,
    ps_start=ps_start_tube,
    hs_start=hs_start_tube,
    Ts_start=Ts_start_tube,
    Ts_wall(start=transpose(TRANSFORM.Math.fillArray_1D(Ts_wall_start_tubeSide,geometry.nSurfaces_tube))),
    redeclare model FlowModel = FlowModel_tube,
    nParallel=geometry.nTubes*nParallel,
    energyDynamics=energyDynamics[2],
    massDynamics=massDynamics[2],
    traceDynamics=traceDynamics[2],
    exposeState_a=exposeState_a_tube,
    exposeState_b=exposeState_b_tube,
    momentumDynamics=momentumDynamics[2],
    useInnerPortProperties=useInnerPortProperties_tube,
    useLumpedPressure=useLumpedPressure_tube,
    lumpPressureAt=lumpPressureAt_tube,
    m_flow_a_start=m_flow_a_start_tube,
    m_flow_b_start=m_flow_b_start_tube,
    m_flows_start=m_flows_start_tube,
    Xs_start=Xs_start_tube,
    Cs_start=Cs_start_tube,
    X_a_start=X_a_start_tube,
    X_b_start=X_b_start_tube,
    C_a_start=C_a_start_tube,
    C_b_start=C_b_start_tube,
    redeclare model Geometry =
        Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.GenericPipe
        (
        nV=geometry.nV,
        dimensions=geometry.dimensions_tube,
        dlengths=geometry.dlengths_tube,
        roughnesses=geometry.roughnesses_tube,
        surfaceAreas=geometry.surfaceAreas_tube,
        dheights=geometry.dheights_tube,
        height_a=geometry.height_a_tube,
        crossAreas=geometry.crossAreas_tube,
        perimeters=geometry.perimeters_tube,
        nSurfaces=geometry.nSurfaces_tube,
        angles=geometry.angles_tube),
    redeclare model InternalTraceGen = InternalTraceGen_tube,
    redeclare model InternalHeatGen = InternalHeatGen_tube)
                                      annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={0,-80})));
  TRANSFORM.HeatAndMassTransfer.DiscritizedModels.Conduction_2D tubeWall(
    nParallel=tube.nParallel,
    energyDynamics=energyDynamics[3],
    adiabaticDims=adiabaticDims,
    redeclare package Material = Material_tubeWall,
    T_a1_start=sum(Ts_wall_start_tubeSide)/size(Ts_wall_start_tubeSide, 1),
    T_b1_start=sum(Ts_wall_start_shellSide)/size(Ts_wall_start_shellSide, 1),
    T_a2_start=(Ts_wall_start_tubeSide[1] + (if counterCurrent then
        Ts_wall_start_shellSide[end] else Ts_wall_start_shellSide[1]))/2,
    T_b2_start=(Ts_wall_start_tubeSide[end] + (if counterCurrent then
        Ts_wall_start_shellSide[1] else Ts_wall_start_shellSide[end]))/2,
    Ts_start=Ts_wall_start,
    exposeState_a1=if tube.heatTransfer.flagIdeal == 1 then false else true,
    exposeState_b1=if shell.heatTransfer.flagIdeal == 1 then false else true,
    exposeState_a2=exposeState_a_tube,
    exposeState_b2=exposeState_b_tube,
    redeclare model Geometry =
        TRANSFORM.HeatAndMassTransfer.ClosureRelations.Geometry.Models.Cylinder_2D_r_z
        (
        r_inner=0.5*sum(geometry.dimensions_tube)/geometry.nV,
        r_outer=0.5*sum(geometry.dimensions_tube_outer)/geometry.nV,
        length_z=sum(geometry.dlengths_tube),
        drs=geometry.drs,
        nR=geometry.nR,
        nZ=geometry.nV,
        dzs=transpose({fill(geometry.dlengths_tube[i], geometry.nR) for i in 1:
            geometry.nV})))            annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={0,-30})));

  TRANSFORM.HeatExchangers.BaseClasses.Summary summary
    annotation (Placement(transformation(extent={{80,-100},{100,-80}})));
  TRANSFORM.HeatAndMassTransfer.BoundaryConditions.Heat.Adiabatic_multi
    adiabaticWall_a2(nPorts=geometry.nR)
    annotation (Placement(transformation(extent={{-40,-40},{-20,-20}})));
  TRANSFORM.HeatAndMassTransfer.BoundaryConditions.Heat.Adiabatic_multi
    adiabaticWall_b2(nPorts=geometry.nR)
    annotation (Placement(transformation(extent={{40,-40},{20,-20}})));
  replaceable model InternalTraceGen_tube =
      Fluid.ClosureRelations.InternalTraceGeneration.Models.DistributedVolume_Trace_1D.GenericTraceGeneration
    annotation (Dialog(group="Trace Mass Transfer"),choicesAllMatching=true);
  replaceable model InternalTraceGen_shell =
      Fluid.ClosureRelations.InternalTraceGeneration.Models.DistributedVolume_Trace_1D.GenericTraceGeneration
    annotation (Dialog(group="Trace Mass Transfer"),choicesAllMatching=true);

  replaceable model InternalHeatGen_tube =
      Fluid.ClosureRelations.InternalVolumeHeatGeneration.Models.DistributedVolume_1D.GenericHeatGeneration
      annotation (Dialog(group="Heat Transfer"),choicesAllMatching=true);
  replaceable model InternalHeatGen_shell =
      Fluid.ClosureRelations.InternalVolumeHeatGeneration.Models.DistributedVolume_1D.GenericHeatGeneration
      annotation (Dialog(group="Heat Transfer"),choicesAllMatching=true);

equation

  //    SI.TemperatureDifference DT_lm "Log mean temperature difference";
  //    SI.ThermalConductance UA "Overall heat transfer conductance";
  //
  //    SI.CoefficientOfHeatTransfer U_shell "Overall heat transfer coefficient - shell side";
  //    SI.CoefficientOfHeatTransfer U_tube "Overall heat transfer coefficient - tube side";
  //
  //    SI.CoefficientOfHeatTransfer alphaAvg_shell "Average shell side heat transfer coefficient";
  //    SI.ThermalResistance R_shell;
  //
  //    SI.CoefficientOfHeatTransfer alphaAvg_tube;
  //    SI.ThermalResistance R_tube;

  //   alphaAvg_shell = sum(shell.heatTransfer.alphas)/geometry.nV;
  //   R_shell = 1/(alphaAvg_shell*sum(shell.surfaceAreas));
  //
  //   alphaAvg_tube = sum(tube.heatTransfer.alphas)/geometry.nV;
  //   R_tube = 1/(alphaAvg_tube*sum(tube.surfaceAreas));
  //
  //   DT_lm = SMR160.Models.Fluid.HeatExchangers.Utilities.Functions.LMTD(
  //             T_hi=shell.mediums[1].T,
  //             T_ho=shell.mediums[geometry.nV].T,
  //             T_ci=tube.mediums[1].T,
  //             T_co=tube.mediums[geometry.nV].T,
  //             counterCurrent=counterCurrent);
  //
  //   UA = SMR160.Models.Fluid.HeatExchangers.Utilities.Functions.UA(
  //             n=3,
  //             isSeries={true,true,true},
  //             R=[R_tube; 1e-6; R_shell]);
  //
  //   U_shell = UA/sum(shell.surfaceAreas);
  //   U_tube = UA/sum(tube.surfaceAreas);

  connect(shell.port_a, port_a_shell) annotation (Line(
      points={{10,46},{70,46},{100,46}},
      color={0,127,255},
      thickness=0.5));
  connect(port_b_shell, shell.port_b)
    annotation (Line(points={{-100,46},{-55,46},{-10,46}}, color={0,127,255}));
  connect(port_a_tube, tube.port_a) annotation (Line(points={{-100,0},{-60,0},{-60,
          -80},{-10,-80}}, color={0,127,255}));
  connect(tube.port_b, port_b_tube) annotation (Line(points={{10,-80},{60,-80},{
          60,0},{100,0}}, color={0,127,255}));
  connect(shell.heatPorts[:,1], counterFlow.port_b)
    annotation (Line(points={{0,41},{0,20}}, color={191,0,0}));
  connect(tubeWall.port_b1, counterFlow.port_a)
    annotation (Line(points={{0,-20},{0,-10},{0,0}}, color={191,0,0}));
  connect(tube.heatPorts[:,1], tubeWall.port_a1)
    annotation (Line(points={{0,-75},{0,-57.5},{0,-40}}, color={191,0,0}));
  connect(adiabaticWall_a2.port, tubeWall.port_a2)
    annotation (Line(points={{-20,-30},{-15,-30},{-10,-30}}, color={191,0,0}));
  connect(tubeWall.port_b2, adiabaticWall_b2.port)
    annotation (Line(points={{10,-30},{15,-30},{20,-30}}, color={191,0,0}));
  annotation (
    defaultComponentName="STHX",
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}})),
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
        graphics={
        Ellipse(
          extent={{10,28.5},{-10,-28.5}},
          lineColor={0,127,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          visible=exposeState_b_shell,
          origin={-100,45.5},
          rotation=360),
        Ellipse(
          extent={{10,28.5},{-10,-28.5}},
          lineColor={0,127,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          visible=exposeState_a_shell,
          origin={100,45.5},
          rotation=0),
        Rectangle(
          extent={{-90,2},{90,-2}},
          lineColor={0,0,0},
          fillColor={95,95,95},
          fillPattern=FillPattern.Forward,
          origin={0,-28},
          rotation=360),
        Rectangle(
          extent={{-90,16},{90,-16}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={0,63,125},
          origin={0,46},
          rotation=360),
        Rectangle(
          extent={{-90,26},{90,-26}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={0,128,255},
          origin={0,0},
          rotation=360),
        Rectangle(
          extent={{-90,16},{90,-16}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={0,63,125},
          origin={0,-46},
          rotation=360),
        Rectangle(
          extent={{-90,2},{90,-2}},
          lineColor={0,0,0},
          fillColor={95,95,95},
          fillPattern=FillPattern.Forward,
          origin={0,28},
          rotation=360),
        Polygon(
          points={{-6,12},{20,0},{-6,-10},{-6,12}},
          lineColor={0,128,255},
          smooth=Smooth.None,
          fillColor={0,63,255},
          fillPattern=FillPattern.Solid,
          origin={38,0},
          rotation=360),
        Line(
          points={{45,0},{-45,0}},
          color={0,63,255},
          smooth=Smooth.None,
          origin={-13,0},
          rotation=360),
        Polygon(
          points={{6,11},{-20,-1},{6,-11},{6,11}},
          lineColor={0,128,255},
          smooth=Smooth.None,
          fillColor={0,128,255},
          fillPattern=FillPattern.Solid,
          origin={-40,46},
          rotation=360),
        Line(
          points={{45,0},{-45,0}},
          color={0,128,255},
          smooth=Smooth.None,
          origin={11,45},
          rotation=360),
        Line(
          points={{45,0},{-45,0}},
          color={0,128,255},
          smooth=Smooth.None,
          origin={11,-47},
          rotation=360),
        Ellipse(
          extent={{10,28.5},{-10,-28.5}},
          lineColor={0,127,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          visible=exposeState_a_tube,
          origin={-100,-0.5},
          rotation=0),
        Polygon(
          points={{6,11},{-20,-1},{6,-11},{6,11}},
          lineColor={0,128,255},
          smooth=Smooth.None,
          fillColor={0,128,255},
          fillPattern=FillPattern.Solid,
          origin={-40,-46},
          rotation=360),
        Ellipse(
          extent={{10,28.5},{-10,-28.5}},
          lineColor={0,127,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          visible=exposeState_b_tube,
          origin={100,-0.5},
          rotation=360)}),
    Documentation(info="<html>
<p>A generic heat exchanger for any relatively simple general purpose heat transfer process.</p>
<p><br>- Currently the nodes on the shell and tube side must be equal. The lengths do not however there are no geometry checks to ensure reasonable user input.</p>
<p>- The wall is currently fixed as a 2D cylinder but may be generalized in the future to allow user to select wall geometry. The 2D cyclinder though does not require the tubes/shell to be cylinders but will potentially impact the results depending on what thermal resistance dominates.</p>
</html>"));
end GenericDistributed_HX;
