within TRANSFORM.Fluid.Pipes;
model GenericPipe_MultiTransferSurface
  import TRANSFORM.Math.linspace_1D;
  import TRANSFORM.Math.linspaceRepeat_1D;
  import TRANSFORM.Fluid.Types.LumpedLocation;
  import Modelica.Fluid.Types.Dynamics;
  import TRANSFORM;

  outer TRANSFORM.Fluid.SystemTF systemTF;

  BaseClasses.Summary summary(
    T_effective=sum(mediums.T .* ms/sum(ms)),
    T_max=max(mediums.T),
    xpos_norm=summary.xpos/sum(geometry.dlengths),
    xpos=cat(
        1,
        {0.5*geometry.dlengths[1]},
        {sum(geometry.dlengths[1:i - 1]) + 0.5*geometry.dlengths[i] for i in 2:
          nV - 1},
        {sum(geometry.dlengths) - 0.5*geometry.dlengths[nV]}))
    "cat(1, {if exposeState_a then 0 else 0.5*geometry.dlengths[1]}, {sum(geometry.dlengths[1:i - 1]) + 0.5*geometry.dlengths[i] for i in 2:nV - 1}, {if exposeState_b then sum(geometry.dlengths) else sum(geometry.dlengths) - 0.5*geometry.dlengths[nV]})"
    annotation (Placement(transformation(extent={{80,-100},{100,-80}})));

  parameter Boolean allowFlowReversal = true
    "= true to allow flow reversal, false restricts to design direction (port_a -> port_b)"
    annotation(Dialog(tab="Advanced"), Evaluate=true);

  Interfaces.FluidPort_Flow port_a(redeclare package Medium = Medium,m_flow(min=if allowFlowReversal then -Modelica.Constants.inf else 0)) annotation (Placement(
        transformation(extent={{-110,-10},{-90,10}}), iconTransformation(extent={{-110,-10},{-90,
            10}})));
  Interfaces.FluidPort_Flow    port_b(redeclare package Medium = Medium,m_flow(max=if allowFlowReversal then +Modelica.Constants.inf else 0)) annotation (
      Placement(transformation(extent={{90,-10},{110,10}}), iconTransformation(extent={{90,-10},
            {110,10}})));

  parameter Real nParallel=1 "Number of parallel components";

  //extends TRANSFORM.Fluid.Pipes.ClosureModels.Geometry.PipeIcons(final figure=geometry.figure);

  extends BaseClasses.PartialDistributedVolume(
    final Vs=geometry.Vs,
    final nV= geometry.nV,
    ps_start=linspace_1D(
        p_a_start,
        p_b_start,nV),
    Ts_start=linspace_1D(
        T_a_start,
        T_b_start,nV),
    hs_start=if not use_Ts_start then linspace_1D(
        h_a_start,
        h_b_start,nV)
             else {Medium.specificEnthalpy_pTX(
        ps_start[i],
        Ts_start[i],
        Xs_start[i, 1:Medium.nX]) for i in 1:nV},
    Xs_start=linspaceRepeat_1D(
        X_a_start,
        X_b_start,nV),
    Cs_start=linspaceRepeat_1D(
        C_a_start,
        C_b_start,nV));

  /* Initialization Tab*/
  parameter SI.AbsolutePressure p_a_start = Medium.p_default "Pressure at port a"
    annotation (Dialog(tab="Initialization", group="Start Value: Absolute Pressure"));
  parameter SI.AbsolutePressure p_b_start=p_a_start + (if m_flow_a_start > 0 then -1e3 elseif m_flow_a_start < 0 then -1e3 else 0) "Pressure at port b"
    annotation (Dialog(tab="Initialization", group="Start Value: Absolute Pressure"));

  parameter SI.Temperature T_a_start=Medium.T_default "Temperature at port a" annotation (
      Dialog(
      tab="Initialization",
      group="Start Value: Temperature",
      enable=use_Ts_start));
  parameter SI.Temperature T_b_start=T_a_start "Temperature at port b" annotation (Dialog(
      tab="Initialization",
      group="Start Value: Temperature",
      enable=use_Ts_start));

  parameter SI.SpecificEnthalpy h_a_start=Medium.specificEnthalpy_pTX(
      p_a_start,
      T_a_start,
      X_a_start) "Specific enthalpy at port a" annotation (Dialog(
      tab="Initialization",
      group="Start Value: Specific Enthalpy",
      enable=not use_Ts_start));
  parameter SI.SpecificEnthalpy h_b_start=Medium.specificEnthalpy_pTX(
      p_b_start,
      T_b_start,
      X_b_start) "Specific enthalpy at port b" annotation (Dialog(
      tab="Initialization",
      group="Start Value: Specific Enthalpy",
      enable=not use_Ts_start));

  parameter SI.MassFraction X_a_start[Medium.nX]=Medium.X_default
    "Mass fraction at port a"
    annotation (Dialog(tab="Initialization", group="Start Value: Species Mass Fraction"));
  parameter SI.MassFraction X_b_start[Medium.nX]=X_a_start
    "Mass fraction at port b"
    annotation (Dialog(tab="Initialization", group="Start Value: Species Mass Fraction"));

  parameter SIadd.ExtraProperty C_a_start[Medium.nC]=fill(0, Medium.nC)
    "Mass-Specific value at port a"
    annotation (Dialog(tab="Initialization", group="Start Value: Trace Substances"));
  parameter SIadd.ExtraProperty C_b_start[Medium.nC]=C_a_start
    "Mass-Specific value at port b"
    annotation (Dialog(tab="Initialization", group="Start Value: Trace Substances"));

  parameter SI.MassFlowRate m_flow_a_start = 0 "Mass flow rate at port_a"
    annotation (Dialog(tab="Initialization", group="Start Value: Mass Flow Rate"));
  parameter SI.MassFlowRate m_flow_b_start=-m_flow_a_start "Mass flow rate at port_b"
    annotation (Dialog(tab="Initialization", group="Start Value: Mass Flow Rate"));
  parameter SI.MassFlowRate[nV + 1] m_flows_start=linspace(
      m_flow_a_start,
      -m_flow_b_start,
      nV + 1) "Mass flow rates" annotation (Evaluate=true, Dialog(tab="Initialization", group=
         "Start Value: Mass Flow Rate"));

  // Geometry Model
  replaceable model Geometry =
      TRANSFORM.Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.StraightPipe
    constrainedby
    TRANSFORM.Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.GenericPipe
                                                                          "Geometry"
    annotation (Dialog(group="Geometry"),choicesAllMatching=true);

  Geometry geometry annotation (Placement(transformation(extent={{-78,82},{-62,98}})));

  // Flow Model
  replaceable model FlowModel =
      TRANSFORM.Fluid.ClosureRelations.PressureLoss.Models.DistributedPipe_1D.SinglePhase_Developed_2Region_NumStable
                                                     constrainedby
    TRANSFORM.Fluid.ClosureRelations.PressureLoss.Models.DistributedPipe_1D.PartialDistributedStaggeredFlow
                                                "Flow models (i.e., momentum, pressure loss, wall friction)" annotation (Dialog(
        group="Pressure Loss"), choicesAllMatching=true);

  FlowModel flowModel(
    redeclare final package Medium = Medium,
    final nFM=nFM,
    final momentumDynamics=momentumDynamics,
    final dimensions=dimensionsFM,
    final crossAreas=crossAreasFM,
    final perimeters=perimetersFM,
    final dlengths=dlengthsFM,
    final roughnesses=roughnessesFM,
    final dheights=dheightsFM,
    final states=statesFM,
    final vs=vsFM,
    final dps_start=dps_start,
    final m_flows_start=m_flowsFM_start,
    final g_n=g_n,
    final Ts_wall = Ts_wallFM,
    final allowFlowReversal=allowFlowReversal) "Conduction Model"
    annotation (Placement(transformation(extent={{-58,82},{-42,98}}, rotation=0)));

  // Heat Transfer Model
  parameter Boolean use_HeatTransfer=false "= true to use the HeatTransfer model"
    annotation (Dialog(group="Heat Transfer"));

  replaceable model HeatTransfer =
      TRANSFORM.Fluid.ClosureRelations.HeatTransfer.Models.DistributedPipe_1D_MultiTransferSurface.Ideal
    constrainedby
    TRANSFORM.Fluid.ClosureRelations.HeatTransfer.Models.DistributedPipe_1D_MultiTransferSurface.PartialHeatTransfer_setT
    "Coefficient of heat transfer" annotation (Dialog(group="Heat Transfer", enable=
          use_HeatTransfer), choicesAllMatching=true);

  HeatTransfer heatTransfer(
    final nParallel=nParallel,
    redeclare each package Medium = Medium,
    nHT=nV,
    nSurfaces=geometry.nSurfaces,
    states=mediums.state,
    vs=vs,
    dlengths=geometry.dlengths,
    roughnesses=geometry.roughnesses,
    surfaceAreas=geometry.surfaceAreas,
    crossAreas=geometry.crossAreas,
    dimensions=geometry.dimensions,
    Ts_start=Ts_start) annotation (Placement(
        transformation(
        extent={{-8,-8},{8,8}},
        rotation=0,
        origin={-20,60})));

  // Internal Heat Generation Model
  replaceable model InternalHeatGen =
      TRANSFORM.Fluid.ClosureRelations.InternalVolumeHeatGeneration.Models.DistributedVolume_1D.GenericHeatGeneration
                                                     constrainedby
    TRANSFORM.Fluid.ClosureRelations.InternalVolumeHeatGeneration.Models.DistributedVolume_1D.PartialInternalHeatGeneration
                                                "Internal heat generation" annotation (Dialog(
        group="Heat Transfer"), choicesAllMatching=true);

  InternalHeatGen internalHeatGen(
    redeclare final package Medium = Medium,
    final nV=nV,
    final Vs=geometry.Vs,
    final dimensions=geometry.dimensions,
    final crossAreas=geometry.crossAreas,
    final dlengths=geometry.dlengths,
    final states=mediums.state)
    annotation (Placement(transformation(extent={{-38,82},{-22,98}}, rotation=0)));

  // Trace Mass Transfer Model
  parameter Boolean use_TraceMassTransfer=false "= true to use the TraceMassTransfer model"
    annotation (Dialog(group="Trace Mass Transfer"));

  replaceable model TraceMassTransfer =
      TRANSFORM.Fluid.ClosureRelations.MassTransfer.Models.DistributedPipe_TraceMass_1D_MultiTransferSurface.Ideal
    constrainedby
    TRANSFORM.Fluid.ClosureRelations.MassTransfer.Models.DistributedPipe_TraceMass_1D_MultiTransferSurface.PartialMassTransfer_setC
    "Trace Substance mass transfer" annotation (Dialog(group="Trace Mass Transfer", enable=
          use_TraceMassTransfer), choicesAllMatching=true);

  TraceMassTransfer traceMassTransfer(
    final nParallel=nParallel,
    redeclare package Medium = Medium,
    nMT=nV,
    nSurfaces=geometry.nSurfaces,
    states=mediums.state,
    vs=vs,
    dlengths=geometry.dlengths,
    roughnesses=geometry.roughnesses,
    surfaceAreas=geometry.surfaceAreas,
    crossAreas=geometry.crossAreas,
    dimensions=geometry.dimensions,
    CsM_start=Cs_start,
    CsM_fluid=Cs,
    Ts_wall=Ts_wall) annotation (Placement(transformation(
        extent={{-8,-8},{8,8}},
        rotation=0,
        origin={-60,60})));

  // Internal Trace Substance Generation Model
  replaceable model InternalTraceGen =
      TRANSFORM.Fluid.ClosureRelations.InternalTraceGeneration.Models.DistributedVolume_Trace_1D.GenericTraceGeneration
                                                     constrainedby
    TRANSFORM.Fluid.ClosureRelations.InternalTraceGeneration.Models.DistributedVolume_Trace_1D.PartialInternalTraceGeneration
                                                "Internal trace mass generation" annotation (Dialog(
        group="Trace Mass Transfer"), choicesAllMatching=true);

  InternalTraceGen internalTraceGen(
    redeclare final package Medium = Medium,
    final nV=nV,
    final Cs = Cs,
    final Vs=geometry.Vs,
    final dimensions=geometry.dimensions,
    final crossAreas=geometry.crossAreas,
    final dlengths=geometry.dlengths,
    final states=mediums.state)
    annotation (Placement(transformation(extent={{-18,82},{-2,98}},  rotation=0)));

  // Assumptions
  parameter Boolean exposeState_a=true "=true, p is calculated at port_a else m_flow"
    annotation (Dialog(group="Model Structure", tab="Advanced"));
  parameter Boolean exposeState_b=false "=true, p is calculated at port_b else m_flow"
    annotation (Dialog(group="Model Structure", tab="Advanced"));

  // Initialization
  parameter Modelica.Fluid.Types.Dynamics momentumDynamics=Dynamics.SteadyState
    "Formulation of momentum balances"
    annotation (Evaluate=true, Dialog(tab="Advanced", group="Dynamics"));

  // Advanced
  input SI.Acceleration g_n=Modelica.Constants.g_n "Gravitational acceleration"
    annotation (Dialog(tab="Advanced", group="Input Variables"));

  parameter Boolean useInnerPortProperties=false
    "=true to take port properties for flow models from internal control volumes"
    annotation (Dialog(tab="Advanced"), Evaluate=true);
  parameter Boolean useLumpedPressure=false "=true to lump pressure states together"
    annotation (Dialog(tab="Advanced"), Evaluate=true);
  parameter LumpedLocation lumpPressureAt=LumpedLocation.port_a
    "Location of pressure for flow calculations" annotation (Dialog(tab="Advanced", enable=
          if useLumpedPressure and not (exposeState_a and exposeState_b) then true else false));

  final parameter Integer nFM=if useLumpedPressure then nFMLumped else nFMDistributed
    "number of flow models in flowModel";

  final parameter Integer nFMDistributed=if not exposeState_a and not exposeState_b then nV +
      1 else if (not exposeState_a and exposeState_b) or (exposeState_a and not exposeState_b)
       then nV else nV - 1;

  final parameter Integer nFMLumped=if not exposeState_a and not exposeState_b then 2 else 1;

  final parameter Integer iLumped=integer(nV/2) + 1
    "Index of control volume with representative state if useLumpedPressure"
    annotation (Evaluate=true);

  // Initialization for Closure Models
  final parameter SI.PressureDifference dp_start=p_a_start - p_b_start;
  final parameter SI.PressureDifference[nFM] dps_start=if useLumpedPressure then if not
      exposeState_a and not exposeState_b then cat(
      1,
      {dp_start/2},
      {dp_start/2}) else {dp_start} else if not exposeState_a and not exposeState_b then
      if nV == 1 then cat(
      1,
      {dp_start/2},
      {dp_start/2}) else cat(
      1,
      {dp_start/(nV + 1)},
      {ps_start[i] - ps_start[i + 1] for i in 1:nV - 1},
      {dp_start/(nV + 1)}) elseif not exposeState_a and exposeState_b then if nV == 1 then {
      dp_start} else cat(
      1,
      {dp_start/nV},
      {ps_start[i] - ps_start[i + 1] for i in 1:nV - 1}) elseif exposeState_a and not
      exposeState_b then if nV == 1 then {dp_start} else cat(
      1,
      {ps_start[i] - ps_start[i + 1] for i in 1:nV - 1},
      {dp_start/nV}) else {ps_start[i] - ps_start[i + 1] for i in 1:nV - 1};

  final parameter SI.MassFlowRate[nFM] m_flowsFM_start=if useLumpedPressure then if
      lumpPressureAt == LumpedLocation.port_a then if not exposeState_a and not exposeState_b
       then cat(
      1,
      {m_flows_start[1]},
      {m_flows_start[1]})/nParallel else {m_flows_start[1]}/nParallel else if not
      exposeState_a and not exposeState_b then cat(
      1,
      {m_flows_start[nV + 1]},
      {m_flows_start[nV + 1]})/nParallel else {m_flows_start[nV + 1]}/nParallel else if not
      exposeState_a and not exposeState_b then m_flows_start/nParallel elseif not
      exposeState_a and exposeState_b then {m_flows_start[i] for i in 1:nV}/nParallel elseif
      exposeState_a and not exposeState_b then {m_flows_start[i] for i in 2:nV + 1}/nParallel
       else {m_flows_start[i] for i in 2:nV}/nParallel;

  final parameter SI.Temperature[nFM + 1] Ts_wallFM_start=if useLumpedPressure then if not
      exposeState_a and not exposeState_b then cat(
      1,
      {T_a_start},
      {0.5*(T_a_start + T_b_start)},
      {T_b_start}) else cat(
      1,
      {T_a_start},
      {T_b_start}) else if not exposeState_a and not exposeState_b then if nV == 1 then cat(
      1,
      {T_a_start},
      {0.5*(T_a_start + T_b_start)},
      {T_b_start}) else cat(
      1,
      {T_a_start},
      {Ts_start[i] for i in 1:nV},
      {T_b_start}) elseif not exposeState_a and exposeState_b then if nV == 1 then cat(
      1,
      {T_a_start},
      {T_b_start}) else cat(
      1,
      {T_a_start},
      {Ts_start[i] for i in 1:nV}) elseif exposeState_a and not exposeState_b then if nV == 1
       then cat(
      1,
      {T_a_start},
      {T_b_start}) else cat(
      1,
      {Ts_start[i] for i in 1:nV},
      {T_b_start}) else {Ts_start[i] for i in 1:nV};

  Medium.ThermodynamicState state_a "state defined by volume outside port_a";
  Medium.ThermodynamicState state_b "state defined by volume outside port_b";

  // Flow quantities
  SI.MassFlowRate m_flows[nV + 1] "Mass flow rates across segment boundaries";
  SI.HeatFlowRate H_flows[nV + 1] "Enthalpy flow rates across segment boundaries";
  SI.MassFlowRate[nV + 1,Medium.nXi] mXi_flows
    "Species mass flow rates across segment boundaries";
  SIadd.ExtraPropertyFlowRate mC_flows[nV + 1,Medium.nC]
    "Trace substance flow rates across segment boundaries";

  SI.Velocity[nV] vs={0.5*(m_flows[i] + m_flows[i + 1])/mediums[i].d/geometry.crossAreas[i]
      for i in 1:nV} "mean velocities in flow segments";

  SI.Temperature[nV,geometry.nSurfaces] Ts_wall(start=transpose(TRANSFORM.Math.fillArray_1D(Ts_start,geometry.nSurfaces)))
    "use_HeatTransfer = true then wall temperature else bulk medium temperature";

  SI.Power[nV] Wb_flows "Mechanical power, p*der(V) etc.";

  HeatAndMassTransfer.Interfaces.HeatPort_Flow heatPorts[nV,geometry.nSurfaces] if
                                                                use_HeatTransfer
    annotation (Placement(transformation(extent={{-10,50},{10,70}}),
        iconTransformation(extent={{-10,40},{10,60}})));
  HeatAndMassTransfer.Interfaces.MolePort_Flow massPorts[nV,geometry.nSurfaces](
     each nC=traceMassTransfer.nC) if                                                         use_TraceMassTransfer
    annotation (Placement(transformation(extent={{-50,50},{-30,70}}),
        iconTransformation(extent={{-50,40},{-30,60}})));

  // Visualization
  parameter Boolean showName = true annotation(Dialog(tab="Visualization"));
  parameter Boolean showDesignFlowDirection = true annotation(Dialog(tab="Visualization"));

  extends TRANSFORM.Utilities.Visualizers.IconColorMap(showColors=systemTF.showColors, val_min=systemTF.val_min,val_max=systemTF.val_max, val=summary.T_effective);

protected
  HeatAndMassTransfer.Interfaces.HeatPort_State[nV,geometry.nSurfaces] heatPorts_int;

  Medium.ThermodynamicState[nFM + 1] statesFM "state vector for flowModel model";
  SI.Temperature[nFM + 1] Ts_wallFM(start=Ts_wallFM_start)
    "Mean wall temperatures of heat transfer surface";

  SI.Velocity[nFM + 1] vsFM "Mean velocities in flow segments";
  SI.Length dlengthsFM[nFM] "Lengths of flow segments";
  SI.Length[nFM] dheightsFM "Differences in heights between flow segments";
  SI.Length[nFM + 1] dimensionsFM "Hydraulic diameters of flow segments";
  SI.Area[nFM + 1] crossAreasFM "Cross flow areas of flow segments";
  SI.Length[nFM + 1] perimetersFM "Wetted perimeters of flow segments";
  SI.Height[nFM + 1] roughnessesFM "Average heights of surface asperities";

  SIadd.ExtraPropertyFlowRate mC_flows_traceMassTransferSum[nV,Medium.nC] = {{sum(traceMassTransfer.mC_flows[i,:,k]) for k in 1:Medium.nC} for i in 1:nV};

equation

  // Source/sink terms for balance equations
  for i in 1:nV loop
    mbs[i] = m_flows[i] - m_flows[i + 1];
    Ubs[i] = Wb_flows[i] + H_flows[i] - H_flows[i + 1] + sum(heatTransfer.Q_flows[i,:]) + internalHeatGen.Q_flows[i]/nParallel;
    mXibs[i, :] = mXi_flows[i, :] - mXi_flows[i + 1, :];
    mCbs[i, :] =mC_flows [i, :] -mC_flows [i + 1, :] + mC_flows_traceMassTransferSum[i,:] + internalTraceGen.mC_flows[i, :]/nParallel;
  end for;

  // Heat Transfer connections
  connect(heatPorts_int,heatTransfer.heatPorts);
  connect(heatTransfer.heatPorts, heatPorts)
    annotation (Line(points={{-12,60},{0,60},{0,60}}, color={191,0,0}));

  if not use_HeatTransfer then
    for i in 1:geometry.nSurfaces loop
      for j in 1:nV loop
        Ts_wall[j, i] = mediums[j].T;
      end for;
    end for;
  else
    for i in 1:geometry.nSurfaces loop
      for j in 1:nV loop
        Ts_wall[j, i] = heatPorts_int[j, i].T;
      end for;
    end for;
  end if;

  // Trace Mass Transfer connections
  connect(traceMassTransfer.massPorts, massPorts)
    annotation (Line(points={{-52,60},{-40,60}},          color={0,140,72}));

  // Boundary Conditions
  port_a.m_flow/nParallel = m_flows[1];
  port_b.m_flow/nParallel =-m_flows[nV + 1];
  port_a.h_outflow = mediums[1].h;
  port_b.h_outflow = mediums[nV].h;
  port_a.Xi_outflow = mediums[1].Xi;
  port_b.Xi_outflow = mediums[nV].Xi;
  port_a.C_outflow = Cs[1, :];
  port_b.C_outflow = Cs[nV, :];

  if useInnerPortProperties and nV > 0 then
    state_a = Medium.setState_phX(
      port_a.p,
      mediums[1].h,
      mediums[1].Xi);
    state_b = Medium.setState_phX(
      port_b.p,
      mediums[nV].h,
      mediums[nV].Xi);
  else
    state_a = Medium.setState_phX(
      port_a.p,
      inStream(port_a.h_outflow),
      inStream(port_a.Xi_outflow));
    state_b = Medium.setState_phX(
      port_b.p,
      inStream(port_b.h_outflow),
      inStream(port_b.Xi_outflow));
  end if;

  // Distributed flow quantities, upwind discretization
  H_flows[1] = semiLinear(
    port_a.m_flow,
    inStream(port_a.h_outflow),
    mediums[1].h)/nParallel;
  mXi_flows[1, :] = semiLinear(
    port_a.m_flow,
    inStream(port_a.Xi_outflow),
    mediums[1].Xi)/nParallel;
  mC_flows[1, :] = semiLinear(
    port_a.m_flow,
    inStream(port_a.C_outflow),
    Cs[1, :])/nParallel;
  for i in 2:nV loop
    H_flows[i] = semiLinear(
      m_flows[i],
      mediums[i - 1].h,
      mediums[i].h);
    mXi_flows[i, :] = semiLinear(
      m_flows[i],
      mediums[i - 1].Xi,
      mediums[i].Xi);
    mC_flows[i, :] = semiLinear(
      m_flows[i],
      Cs[i - 1, :],
      Cs[i, :]);
  end for;
  H_flows[nV + 1] = -semiLinear(
    port_b.m_flow,
    inStream(port_b.h_outflow),
    mediums[nV].h)/nParallel;
  mXi_flows[nV + 1, :] = -semiLinear(
    port_b.m_flow,
    inStream(port_b.Xi_outflow),
    mediums[nV].Xi)/nParallel;
  mC_flows[nV + 1, :] = -semiLinear(
    port_b.m_flow,
    inStream(port_b.C_outflow),
    Cs[nV, :])/nParallel;

  // Wb_flow = v*A*dpdx + v*F_fric
  //         = v*A*dpdx + v*A*flowModel.dp_fg - v*A*dp_grav
   if nV == 1 or useLumpedPressure then
     Wb_flows = geometry.dxs*((vs*geometry.dxs)*(geometry.crossAreas*geometry.dxs)*((port_b.p - port_a.p) + sum(flowModel.dps_fg) - g_n*(geometry.dheights*mediums.d)));
   else
     if exposeState_a and exposeState_b or exposeState_a and not exposeState_b then
       Wb_flows[2:nV - 1] = {vs[i]*geometry.crossAreas[i]*((mediums[i + 1].p - mediums[i - 1].p)/2 + (flowModel.dps_fg[i - 1] + flowModel.dps_fg[i])/2 - g_n*geometry.dheights[i]*mediums[i].d) for i in 2:nV - 1};
    else
       Wb_flows[2:nV - 1] = {vs[i]*geometry.crossAreas[i]*((mediums[i + 1].p - mediums[i - 1].p)/2 + (flowModel.dps_fg[i] + flowModel.dps_fg[i + 1])/2 - g_n*geometry.dheights[i]*mediums[i].d) for i in 2:nV - 1};
     end if;
     if exposeState_a and exposeState_b then
       Wb_flows[1] = vs[1]*geometry.crossAreas[1]*((mediums[2].p - mediums[1].p)/2 + flowModel.dps_fg[1]/2 - g_n*geometry.dheights[1]*mediums[1].d);
       Wb_flows[nV] = vs[nV]*geometry.crossAreas[nV]*((mediums[nV].p - mediums[nV - 1].p)/2 + flowModel.dps_fg[nV - 1]/2 - g_n*geometry.dheights[nV]*mediums[nV].d);
     elseif exposeState_a and not exposeState_b then
       Wb_flows[1] = vs[1]*geometry.crossAreas[1]*((mediums[2].p - mediums[1].p)/2 + flowModel.dps_fg[1]/2 - g_n*geometry.dheights[1]*mediums[1].d);
       Wb_flows[nV] = vs[nV]*geometry.crossAreas[nV]*((port_b.p - mediums[nV - 1].p)/1.5 + flowModel.dps_fg[nV - 1]/2 + flowModel.dps_fg[nV] - g_n*geometry.dheights[nV]*mediums[nV].d);
     elseif not exposeState_a and exposeState_b then
       Wb_flows[1] = vs[1]*geometry.crossAreas[1]*((mediums[2].p - port_a.p)/1.5 + flowModel.dps_fg[1] + flowModel.dps_fg[2]/2 - g_n*geometry.dheights[1]*mediums[1].d);
       Wb_flows[nV] = vs[nV]*geometry.crossAreas[nV]*((mediums[nV].p - mediums[nV - 1].p)/2 + flowModel.dps_fg[nV]/2 - g_n*geometry.dheights[nV]*mediums[nV].d);
     elseif not exposeState_a and not exposeState_b then
       Wb_flows[1] = vs[1]*geometry.crossAreas[1]*((mediums[2].p - port_a.p)/1.5 + flowModel.dps_fg[1] + flowModel.dps_fg[2]/2 - g_n*geometry.dheights[1]*mediums[1].d);
       Wb_flows[nV] = vs[nV]*geometry.crossAreas[nV]*((port_b.p - mediums[nV - 1].p)/1.5 + flowModel.dps_fg[nV]/2 + flowModel.dps_fg[nV + 1] - g_n*geometry.dheights[nV]*mediums[nV].d);
     else
       assert(false, "Unknown model structure");
     end if;
   end if;

  /*##########################################################################*/
  /*                    Dimension-1 Flow Model Definitions                    */
  /*##########################################################################*/
  if exposeState_a and exposeState_b then
    assert(nV > 1, "nV must be > 1 if exposeState_a and exposeState_b = true");
  end if;

  /************************************************************************/
  /*                      Lumped Pressure Model                           */
  /************************************************************************/
  if useLumpedPressure then
    if not (exposeState_a and exposeState_b) then
      // all pressures are equal
      if lumpPressureAt == LumpedLocation.port_a then
        fill(mediums[1].p, nV - 1) = mediums[2:nV].p;
      elseif lumpPressureAt == LumpedLocation.port_b then
        fill(mediums[nV].p, nV - 1) = mediums[1:nV - 1].p;
      else
        assert(false, "Unknown lumped pressure location");
      end if;
    elseif nV > 2 then
      // need two pressures
      fill(mediums[1].p, iLumped - 2) = mediums[2:iLumped - 1].p;
      fill(mediums[nV].p, nV - iLumped) = mediums[iLumped:nV - 1].p;
    end if;
    if exposeState_a and exposeState_b then
      m_flows[iLumped] =flowModel.m_flows[1];
      port_a.p = mediums[1].p;
      port_b.p = mediums[nV].p;
      statesFM[1] = mediums[1].state;
      statesFM[2] = mediums[nV].state;
      vsFM[1] = vs[1:iLumped - 1]*geometry.dlengths[1:iLumped - 1]/sum(geometry.dlengths[1:
        iLumped - 1]);
      vsFM[2] =vs[iLumped:nV]*geometry.dlengths[iLumped:nV]/sum(geometry.dlengths[iLumped:
        nV]);
      Ts_wallFM[1] = sum(Ts_wall[1,:])/geometry.nSurfaces;
      Ts_wallFM[2] =sum(Ts_wall[nV,:])/geometry.nSurfaces;
    elseif exposeState_a and not exposeState_b then
      m_flows[nV + 1] = flowModel.m_flows[1];
      port_a.p = mediums[1].p;
      statesFM[1] = mediums[iLumped].state;
      statesFM[2] = state_b;
      vsFM[1] = vs*geometry.dlengths/sum(geometry.dlengths);
      vsFM[2] =m_flows[nV + 1]/Medium.density(state_b)/geometry.crossAreas[nV];
      Ts_wallFM[1] = sum(Ts_wall[iLumped,:])/geometry.nSurfaces;
      Ts_wallFM[2] =sum(Ts_wall[nV,:])/geometry.nSurfaces;
    elseif not exposeState_a and exposeState_b then
      m_flows[1] =flowModel.m_flows[1];
      port_b.p = mediums[nV].p;
      statesFM[1] = state_a;
      statesFM[2] = mediums[iLumped].state;
      vsFM[1] = m_flows[1]/Medium.density(state_a)/geometry.crossAreas[1];
      vsFM[2] = vs*geometry.dlengths/sum(geometry.dlengths);
      Ts_wallFM[1] = sum(Ts_wall[1,:])/geometry.nSurfaces;
      Ts_wallFM[2] = sum(Ts_wall[iLumped,:])/geometry.nSurfaces;
    elseif not exposeState_a and not exposeState_b then
      m_flows[1] =flowModel.m_flows[1];
      m_flows[nV + 1] = flowModel.m_flows[2];
      statesFM[1] = state_a;
      statesFM[2] = mediums[iLumped].state;
      statesFM[3] = state_b;
      vsFM[1] = m_flows[1]/Medium.density(state_a)/geometry.crossAreas[1];
      vsFM[2] = vs*geometry.dlengths/sum(geometry.dlengths);
      vsFM[3] =m_flows[nV + 1]/Medium.density(state_b)/geometry.crossAreas[nV];
      Ts_wallFM[1] = sum(Ts_wall[1,:])/geometry.nSurfaces;
      Ts_wallFM[2] = sum(Ts_wall[iLumped,:])/geometry.nSurfaces;
      Ts_wallFM[3] =sum(Ts_wall[nV,:])/geometry.nSurfaces;
    else
      assert(false, "Unknown model structure");
    end if;

    // Geometry
    if not (not exposeState_a and not exposeState_b) then
      dlengthsFM[1] = sum(geometry.dlengths);
      dheightsFM[1] = sum(geometry.dheights);
      if nV == 1 then
        dimensionsFM[1:2] = {geometry.dimensions[1], geometry.dimensions[1]};
        crossAreasFM[1:2] = {geometry.crossAreas[1],geometry.crossAreas[1]};
        perimetersFM[1:2] = {geometry.perimeters[1], geometry.perimeters[1]};
        roughnessesFM[1:2] = {geometry.roughnesses[1],geometry.roughnesses[1]};
      else
        // nV > 1
        dimensionsFM[1:2] ={sum(geometry.dimensions[1:iLumped - 1])/(iLumped - 1),sum(
          geometry.dimensions[iLumped:nV])/(nV - iLumped + 1)};
        crossAreasFM[1:2] ={sum(geometry.crossAreas[1:iLumped - 1])/(iLumped - 1),sum(
          geometry.crossAreas[iLumped:nV])/(nV - iLumped + 1)};
        perimetersFM[1:2] ={sum(geometry.perimeters[1:iLumped - 1])/(iLumped - 1),sum(
          geometry.perimeters[iLumped:nV])/(nV - iLumped + 1)};
        roughnessesFM[1:2] ={sum(geometry.roughnesses[1:iLumped - 1])/(iLumped - 1),sum(
          geometry.roughnesses[iLumped:nV])/(nV - iLumped + 1)};
      end if;
    else
      if nV == 1 then
        dlengthsFM[1:2] = {geometry.dlengths[1]/2,geometry.dlengths[1]/2};
        dheightsFM[1:2] = {geometry.dheights[1]/2,geometry.dheights[1]/2};
        dimensionsFM[1:3] = {geometry.dimensions[1], geometry.dimensions[1], geometry.dimensions[1]};
        crossAreasFM[1:3] = {geometry.crossAreas[1],geometry.crossAreas[1],geometry.crossAreas[
          1]};
        perimetersFM[1:3] = {geometry.perimeters[1], geometry.perimeters[1], geometry.perimeters[1]};
        roughnessesFM[1:3] = {geometry.roughnesses[1],geometry.roughnesses[1],geometry.roughnesses[
          1]};
      else
        // nV > 1
        dlengthsFM[1:2] = {sum(geometry.dlengths[1:iLumped - 1]),sum(geometry.dlengths[
          iLumped:nV])};
        dheightsFM[1:2] = {sum(geometry.dheights[1:iLumped - 1]),sum(geometry.dheights[
          iLumped:nV])};
        dimensionsFM[1:3] ={sum(geometry.dimensions[1:iLumped - 1])/(iLumped - 1),sum(
          geometry.dimensions)/nV,sum(geometry.dimensions[iLumped:nV])/(nV - iLumped + 1)};
        crossAreasFM[1:3] ={sum(geometry.crossAreas[1:iLumped - 1])/(iLumped - 1),sum(
          geometry.crossAreas)/nV,sum(geometry.crossAreas[iLumped:nV])/(nV - iLumped + 1)};
        perimetersFM[1:3] ={sum(geometry.perimeters[1:iLumped - 1])/(iLumped - 1),sum(
          geometry.perimeters)/nV,sum(geometry.perimeters[iLumped:nV])/(nV - iLumped + 1)};
        roughnessesFM[1:3] ={sum(geometry.roughnesses[1:iLumped - 1])/(iLumped - 1),sum(
          geometry.roughnesses)/nV,sum(geometry.roughnesses[iLumped:nV])/(nV - iLumped + 1)};
      end if;
    end if;
  else
    if exposeState_a and exposeState_b then
      /************************************************************************/
      /*             1.a Model Structure (true, true) (i.e., v_v)             */
      /************************************************************************/
      //nFM = nV-1

      // Connections
      m_flows[2:nV] = flowModel.m_flows[1:nV - 1];

      /* Boundary Ports */
      // Left Boundary
      port_a.p = mediums[1].p;
      // Right Boundary
      port_b.p = mediums[nV].p;

      /* State Variables */
      for i in 1:nFM + 1 loop
        statesFM[i] = mediums[i].state;
        vsFM[i] = vs[i];
        Ts_wallFM[i] = sum(Ts_wall[i,:])/geometry.nSurfaces;
      end for;

      /* Geometry Variables */
      for i in 1:nFM + 1 loop
        crossAreasFM[i] = geometry.crossAreas[i];
        dimensionsFM[i] = geometry.dimensions[i];
        perimetersFM[i] = geometry.perimeters[i];
        roughnessesFM[i] = geometry.roughnesses[i];
      end for;

      if nFM == 1 then
        dlengthsFM[1] = geometry.dlengths[1] + geometry.dlengths[2];
        dheightsFM[1] = geometry.dheights[1] + geometry.dheights[2];
      else
        dlengthsFM[1] = geometry.dlengths[1] + 0.5*geometry.dlengths[2];
        dheightsFM[1] = geometry.dheights[1] + 0.5*geometry.dheights[2];
        for i in 2:nFM - 1 loop
          dlengthsFM[i] = 0.5*(geometry.dlengths[i] + geometry.dlengths[i + 1]);
          dheightsFM[i] = 0.5*(geometry.dheights[i] + geometry.dheights[i + 1]);
        end for;
        dlengthsFM[nFM] = 0.5*geometry.dlengths[nFM] + geometry.dlengths[nFM + 1];
        dheightsFM[nFM] = 0.5*geometry.dheights[nFM] + geometry.dheights[nFM + 1];
      end if;

    elseif exposeState_a and not exposeState_b then
      /************************************************************************/
      /*             1.b Model Structure (true, false) (i.e., v_)             */
      /************************************************************************/

      //nFM = nV

      // Connections
      m_flows[2:nV + 1] = flowModel.m_flows[1:nV];

      /* Boundary Ports */
      // Left Boundary
      port_a.p = mediums[1].p;
      // Right Boundary - set by connecting model

      /* State Variables */
      for i in 1:nFM loop
        statesFM[i] = mediums[i].state;
        vsFM[i] = vs[i];
        Ts_wallFM[i] = sum(Ts_wall[i,:])/geometry.nSurfaces;
      end for;
      statesFM[nFM + 1] = state_b;
      vsFM[nFM + 1] = m_flows[nFM + 1]/Medium.density(state_b)/geometry.crossAreas[nV];
      Ts_wallFM[nFM + 1] =sum(Ts_wall[nV,:])/geometry.nSurfaces;

      /* Geometry Variables */
      for i in 1:nFM loop
        crossAreasFM[i] = geometry.crossAreas[i];
        dimensionsFM[i] = geometry.dimensions[i];
        perimetersFM[i] = geometry.perimeters[i];
        roughnessesFM[i] = geometry.roughnesses[i];
      end for;
      crossAreasFM[nFM + 1] = geometry.crossAreas[nV];
      dimensionsFM[nFM + 1] = geometry.dimensions[nV];
      perimetersFM[nFM + 1] = geometry.perimeters[nV];
      roughnessesFM[nFM + 1] = geometry.roughnesses[nV];

      if nFM == 1 then
        dlengthsFM[1] = geometry.dlengths[1];
        dheightsFM[1] = geometry.dheights[1];
      else
        dlengthsFM[1] = geometry.dlengths[1] + 0.5*geometry.dlengths[2];
        dheightsFM[1] = geometry.dheights[1] + 0.5*geometry.dheights[2];
        for i in 2:nFM - 1 loop
          dlengthsFM[i] = 0.5*(geometry.dlengths[i] + geometry.dlengths[i + 1]);
          dheightsFM[i] = 0.5*(geometry.dheights[i] + geometry.dheights[i + 1]);
        end for;
        dlengthsFM[nFM] = 0.5*geometry.dlengths[nFM];
        dheightsFM[nFM] = 0.5*geometry.dheights[nFM];
      end if;

    elseif not exposeState_a and exposeState_b then
      /************************************************************************/
      /*             1.c Model Structure (false, true) (i.e., _v)             */
      /************************************************************************/

      //nFM = nV

      // Connections
      m_flows[1:nV] = flowModel.m_flows[1:nV];

      /* Boundary Ports */
      // Left Boundary - set by connecting model
      // Right Boundary
      port_b.p = mediums[nV].p;

      /* State Variables */
      statesFM[1] = state_a;
      vsFM[1] = m_flows[1]/Medium.density(state_a)/geometry.crossAreas[1];
      Ts_wallFM[1] = sum(Ts_wall[1,:])/geometry.nSurfaces;
      for i in 2:nFM + 1 loop
        statesFM[i] = mediums[i - 1].state;
        vsFM[i] = vs[i - 1];
        Ts_wallFM[i] = sum(Ts_wall[i - 1,:])/geometry.nSurfaces;
      end for;

      /* Geometry Variables */
      crossAreasFM[1] = geometry.crossAreas[1];
      dimensionsFM[1] = geometry.dimensions[1];
      perimetersFM[1] = geometry.perimeters[1];
      roughnessesFM[1] = geometry.roughnesses[1];
      for i in 2:nFM + 1 loop
        crossAreasFM[i] = geometry.crossAreas[i - 1];
        dimensionsFM[i] = geometry.dimensions[i - 1];
        perimetersFM[i] = geometry.perimeters[i - 1];
        roughnessesFM[i] = geometry.roughnesses[i - 1];
      end for;

      if nFM == 1 then
        dlengthsFM[1] = geometry.dlengths[1];
        dheightsFM[1] = geometry.dheights[1];
      else
        dlengthsFM[1] = 0.5*geometry.dlengths[1];
        dheightsFM[1] = 0.5*geometry.dheights[1];
        for i in 2:nFM - 1 loop
          dlengthsFM[i] = 0.5*(geometry.dlengths[i - 1] + geometry.dlengths[i]);
          dheightsFM[i] = 0.5*(geometry.dheights[i - 1] + geometry.dheights[i]);
        end for;
        dlengthsFM[nFM] = 0.5*geometry.dlengths[nFM - 1] + geometry.dlengths[nFM];
        dheightsFM[nFM] = 0.5*geometry.dheights[nFM - 1] + geometry.dheights[nFM];
      end if;

    elseif not exposeState_a and not exposeState_b then
      /************************************************************************/
      /*            1.d Model Structure (false, false) (i.e., _v_)            */
      /************************************************************************/

      //nFM = nV+1;

      // Connections
      m_flows[1:nV + 1] = flowModel.m_flows[1:nV + 1];

      /* Boundary Ports */
      // Left Boundary - set by connecting model
      // Right Boundary - set by connecting model

      /* State Variables */
      statesFM[1] = state_a;
      vsFM[1] = m_flows[1]/Medium.density(state_a)/geometry.crossAreas[1];
      Ts_wallFM[1] = sum(Ts_wall[1,:])/geometry.nSurfaces;
      for i in 2:nFM loop
        statesFM[i] = mediums[i - 1].state;
        vsFM[i] = vs[i - 1];
        Ts_wallFM[i] = sum(Ts_wall[i - 1,:])/geometry.nSurfaces;
      end for;
      statesFM[nFM + 1] = state_b;
      vsFM[nFM + 1] = m_flows[nFM]/Medium.density(state_b)/geometry.crossAreas[nV];
      Ts_wallFM[nFM + 1] =sum(Ts_wall[nV,:])/geometry.nSurfaces;

      /* Geometry Variables */
      crossAreasFM[1] = geometry.crossAreas[1];
      dimensionsFM[1] = geometry.dimensions[1];
      perimetersFM[1] = geometry.perimeters[1];
      roughnessesFM[1] = geometry.roughnesses[1];
      for i in 2:nFM loop
        crossAreasFM[i] = geometry.crossAreas[i - 1];
        dimensionsFM[i] = geometry.dimensions[i - 1];
        perimetersFM[i] = geometry.perimeters[i - 1];
        roughnessesFM[i] = geometry.roughnesses[i - 1];
      end for;
      crossAreasFM[nFM + 1] = geometry.crossAreas[nV];
      dimensionsFM[nFM + 1] = geometry.dimensions[nV];
      perimetersFM[nFM + 1] = geometry.perimeters[nV];
      roughnessesFM[nFM + 1] = geometry.roughnesses[nV];

      dlengthsFM[1] = 0.5*geometry.dlengths[1];
      dheightsFM[1] = 0.5*geometry.dheights[1];
      for i in 2:nFM - 1 loop
        dlengthsFM[i] = 0.5*(geometry.dlengths[i - 1] + geometry.dlengths[i]);
        dheightsFM[i] = 0.5*(geometry.dheights[i - 1] + geometry.dheights[i]);
      end for;
      dlengthsFM[nFM] = 0.5*geometry.dlengths[nFM - 1];
      dheightsFM[nFM] = 0.5*geometry.dheights[nFM - 1];

    else
      assert(false, "Unknown model structure");
    end if;
  end if;

  annotation (
    defaultComponentName="pipe",
    Documentation(info="<html>
<p>Base model for distributed flow models. The total volume is split into nV segments along the flow path. The default value is nV=2. </p>
<p>The following boundary flow and source terms are part of the mass, energy, species, and trace balances and must be specified in an extending class: </p>
<ul>
<li>Qb_flows[nV], heat flow term, e.g., conductive heat flows across segment boundaries</li>
<li>Wb_flows[nV], work term</li>
<li>Hb_flows[nV], enthalpy flow</li>
<li>mb_flows[nV], mass flow</li>
<li>mbXi_flows[nV], substance mass flow</li>
<li>mbC_flows[nV], trace substance mass flow</li>
</ul>
<p>Wall temperature is passed to the flow model as it is needed for some cases. When use_HeatTransfer = false, the wall temperature is assumed to be equal to the medium temperature.</p>
<p><span style=\"font-family: MS Shell Dlg 2;\">It provides the complete balance equations for one-dimensional fluid flow as formulated in <a href=\"modelica://Modelica.Fluid.UsersGuide.ComponentDefinition.BalanceEquations\">UsersGuide.ComponentDefinition.BalanceEquations</a>. </span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">This generic model offers a large number of combinations of possible parameter settings. In order to reduce model complexity, consider defining and/or using a tailored model for the application at hand, such as <a href=\"modelica://Modelica.Fluid.Examples.HeatExchanger.HeatExchangerSimulation\">HeatExchanger</a>.</span></p>
<p>In reality this model is not a partial model BUT it is listed as such so different applications of this model will be generated with proper applications of the parameters, icons, etc. </p>
<h4>Mass and Energy balances</h4>
<p>The mass and energy balances are inherited from <a href=\"modelica://Modelica.Fluid.Interfaces.PartialDistributedVolume\">Interfaces.PartialDistributedVolume</a>. One total mass and one energy balance is formed across each segment according to the finite volume approach. Substance mass balances are added if the medium contains more than one component. </p>
<p>An extending model needs to define the geometry and the difference in heights between the flow segments (static head).</p>
<h4>Momentum balance</h4>
<p>The momentum balance is determined by the <code><b>FlowModel</b></code> component, which can be replaced with any model extended from <a href=\"modelica://Modelica.Fluid.Pipes.BaseClasses.FlowModels.PartialStaggeredFlowModel\">BaseClasses.FlowModels.PartialStaggeredFlowModel</a>. The default setting is <a href=\"modelica://Modelica.Fluid.Pipes.BaseClasses.FlowModels.DetailedPipeFlow\">DetailedPipeFlow</a>. </p>
<p>This considers </p>
<ul>
<li>pressure drop due to friction and other dissipative losses, and</li>
<li>gravity effects for non-horizontal devices.</li>
<li>variation of flow velocity along the flow path, which occur due to changes in the cross sectional area or the fluid density, provided that <code>flowModel.use_Ib_flows</code> is true. </li>
</ul>
<h4>Model Structure</h4>
<p>The momentum balances are formulated across the segment boundaries along the flow path according to the staggered grid approach. The configurable <code><b>modelStructure</b></code> determines the formulation of the boundary conditions at <code>port_a</code> and <code>port_b</code>. The options include (default: av_vb): </p>
<ul>
<li><code>av_vb</code>: Symmetric setting with nV-1 momentum balances between nV flow segments. The ports <code>port_a</code> and <code>port_b</code> expose the first and the last thermodynamic state, respectively. Connecting two or more flow devices therefore may result in high-index DAEs for the pressures of connected flow segments. </li>
<li><code>a_v_b</code>: Alternative symmetric setting with nV+1 momentum balances across nV flow segments. Half momentum balances are placed between <code>port_a</code> and the first flow segment as well as between the last flow segment and <code>port_b</code>. Connecting two or more flow devices therefore results in algebraic pressures at the ports. The specification of good start values for the port pressures is essential for the solution of large nonlinear equation systems.</li>
<li><code>av_b</code>: Asymmetric setting with nV momentum balances, one between nth volume and <code>port_b</code>, potential pressure state at <code>port_a</code></li>
<li><code>a_vb</code>: Asymmetric setting with nV momentum balance, one between first volume and <code>port_a</code>, potential pressure state at <code>port_b</code></li>
</ul>
<p>When connecting two components, e.g., two pipes, the momentum balance across the connection point reduces to </p>
<pre>pipe1.port_b.p = pipe2.port_a.p</pre>
<p>This is only true if the flow velocity remains the same on each side of the connection. Consider using a fitting for any significant change in diameter or fluid density, if the resulting effects, such as change in kinetic energy, cannot be neglected. This also allows for taking into account friction losses with respect to the actual geometry of the connection point. </p>
<p><span style=\"font-family: MS Shell Dlg 2;\">The model treats the partial differential equations with the finite volume method and a staggered grid scheme for momentum balances. The default value is nV=2. This results in two lumped mass and energy balances and one lumped momentum balance across the model. </span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Note that this generally leads to high-index DAEs for pressure states if this model are directly connected to each other, or generally to models with storage exposing a thermodynamic state through the port. This may not be valid if the model is connected to a model with non-differentiable pressure, like a Sources.Boundary_pT with prescribed jumping pressure. The </span><code>modelStructure</code><span style=\"font-family: MS Shell Dlg 2;\"> can be configured as appropriate in such situations, in order to place a momentum balance between a pressure state of the pipe and a non-differentiable boundary condition. </span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">The default </span><code>modelStructure</code><span style=\"font-family: MS Shell Dlg 2;\"> is </span><code>av_vb</code><span style=\"font-family: MS Shell Dlg 2;\"> (see Advanced tab). The simplest possible alternative symmetric configuration, avoiding potential high-index DAEs at the cost of the potential introduction of nonlinear equation systems, is obtained with the setting </span><code>nV=1, modelStructure=a_v_b</code><span style=\"font-family: MS Shell Dlg 2;\">. Depending on the configured model structure, the first and the last segment, or the flow path length of the first and the last momentum balance, are of half size.</span></p>
<h4>Heat Transfer Structure</h4>
<p><span style=\"font-family: MS Shell Dlg 2;\">The </span><code>HeatTransfer</code><span style=\"font-family: MS Shell Dlg 2;\"> component specifies the source term </span><code>Qb_flows</code><span style=\"font-family: MS Shell Dlg 2;\"> of the energy balance. The default component uses a constant coefficient for the heat transfer between the bulk flow and the segment boundaries exposed through the </span><code>heatPorts</code><span style=\"font-family: MS Shell Dlg 2;\">. The </span><code>HeatTransfer</code><span style=\"font-family: MS Shell Dlg 2;\"> model is replaceable and can be exchanged with any model extended from <a href=\"TRANSFORM.Fluid.Pipes.BaseClasses.HeatTransfer.PartialFlowHeatTransfer\">TRANSFORM.Fluid.Pipes.BaseClasses.HeatTransfer.PartialFlowHeatTransfer</a>. </span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">The intended use is for complex networks of pipes and other flow devices, like valves. See, e.g., </span></p>
<ul>
<li><span style=\"font-family: MS Shell Dlg 2;\"><a href=\"modelica://Modelica.Fluid.Examples.BranchingDynamicPipes\">Examples.BranchingDynamicPipes</a>, or </span></li>
<li><span style=\"font-family: MS Shell Dlg 2;\"><a href=\"modelica://Modelica.Fluid.Examples.IncompressibleFluidNetwork\">Examples.IncompressibleFluidNetwork</a>.</span></li>
</ul>
</html>", revisions="<html>
<ul>
<li><i>5 Dec 2008</i>
    by Michael Wetter:<br>
       Modified mass balance for trace substances. With the new formulation, the trace substances masses <code>mC</code> are stored
       in the same way as the species <code>mXi</code>.</li>
<li><i>Dec 2008</i>
    by R&uuml;diger Franke:<br>
       Derived model from original DistributedPipe models
    <ul>
    <li>moved mass and energy balances to PartialDistributedVolume</li>
    <li>introduced replaceable pressure loss models</li>
    <li>combined all model structures and lumped pressure into one model</li>
    <li>new ModelStructure av_vb, replacing former avb</li>
    </ul></li>
<li><i>04 Mar 2006</i>
    by Katrin Pr&ouml;l&szlig;:<br>
       Model added to the Fluid library</li>
</ul>
</html>"),
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,100}}),
        graphics={
        Ellipse(
          extent={{-92,30},{-108,-30}},
          lineColor={0,127,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          visible=exposeState_a),
        Ellipse(
          extent={{108,30},{92,-30}},
          lineColor={0,127,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          visible=exposeState_b),
         Rectangle(
          extent={{-90,40},{90,-40}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor=DynamicSelect({0,127,255}, if showColors then dynColor else {0,127,255})),
        Ellipse(
          extent={{-65,5},{-55,-5}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Line(
          points={{30,40},{30,-40}},
          color={0,0,0},
          pattern=LinePattern.Dash),
        Line(
          points={{-30,40},{-30,-40}},
          color={0,0,0},
          pattern=LinePattern.Dash),
        Ellipse(
          extent={{-5,5},{5,-5}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{55,5},{65,-5}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-149,-68},{151,-108}},
          lineColor={0,0,255},
          textString="%name",
          visible=DynamicSelect(true,showName)),
        Polygon(
          points={{20,-45},{60,-60},{20,-75},{20,-45}},
          lineColor={0,128,255},
          smooth=Smooth.None,
          fillColor={0,128,255},
          fillPattern=FillPattern.Solid,
          visible=DynamicSelect(true,showDesignFlowDirection)),
        Polygon(
          points={{20,-50},{50,-60},{20,-70},{20,-50}},
          lineColor={255,255,255},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          visible=DynamicSelect(true,showDesignFlowDirection)),
        Line(
          points={{55,-60},{-60,-60}},
          color={0,128,255},
          smooth=Smooth.None,
          visible=DynamicSelect(true,showDesignFlowDirection)),
        Ellipse(
          extent={{12,30},{-12,-30}},
          lineColor={0,140,72},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          origin={-40,50},
          rotation=-90,
          visible=DynamicSelect(true,if use_TraceMassTransfer then (if traceMassTransfer.flagIdeal == 1 then true else false) else false)),
        Ellipse(
          extent={{12,30},{-12,-30}},
          lineColor={191,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          origin={0,50},
          rotation=-90,
          visible=DynamicSelect(true,if use_HeatTransfer then (if heatTransfer.flagIdeal == 1 then true else false) else false))}),
    Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,100}})));
end GenericPipe_MultiTransferSurface;
