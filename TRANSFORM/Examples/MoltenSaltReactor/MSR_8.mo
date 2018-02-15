within TRANSFORM.Examples.MoltenSaltReactor;
model MSR_8
  import TRANSFORM;

  package Medium_PFL = TRANSFORM.Media.Fluids.FLiBe.LinearFLiBe_12Th_05U_pT (
  extraPropertiesNames=data_traceSubstances.extraPropertiesNames,
  C_nominal=data_traceSubstances.C_nominal) "Primary fuel loop medium";

  package Medium_PCL = TRANSFORM.Media.Fluids.FLiBe.LinearFLiBe_pT (
  extraPropertiesNames={"Tritium"},
  C_nominal={1e6}) "Primary coolant loop medium";

  package Medium_OffGas = Modelica.Media.IdealGases.SingleGases.He (
  extraPropertiesNames=fill("dummy",2),
  C_nominal=fill(1e6,Medium_OffGas.nC));
  //Errors when attempted to be specific using: {data_traceSubstances.extraPropertiesNames[iOG[i]] for i in 1:nC_OG};

  parameter Integer nOG = Medium_OffGas.nC "# of trace substances in off-gas";
  parameter Integer iOG_FP[nOG] = {2,3};
  parameter Integer iOG[nOG] = {2,3}+fill(data_traceSubstances.precursorGroups.nC, 2) "Index array of substances sent to off-gas system";

  parameter Integer toggleStaticHead = 0 "=1 to turn on, =0 to turn off";

  SI.Power Qt_total = sum(kinetics.Qs) "Total thermal power output (from primary fission)";

  SI.Temperature Ts[10] = fuelCell.mediums.T;

  SI.Temperature Tst[10] = PHX.tube.mediums.T;
  SI.Temperature Tss[10] = PHX.shell.mediums.T;

  SI.Temperature Ts_loop[1+reflA_lower.nV+fuelCell.nV+reflA_upper.nV+1+pipeToPHX_PFL.nV+PHX.tube.nV+pipeFromPHX_PFL.nV+1] = cat(1,{plenum_lower.medium.T},reflA_lower.mediums.T,fuelCell.mediums.T,reflA_upper.mediums.T,
  {plenum_upper.medium.T},pipeToPHX_PFL.mediums.T,PHX.tube.mediums.T,pipeFromPHX_PFL.mediums.T,{tee_inlet.medium.T});

  // Trace Substance Calculations: PFL
  SI.MassFlowRate[data_traceSubstances.nC] mC_gen_tee_inlet = {-data_traceSubstances.lambdas[j]*tee_inlet.mC[j] + mC_gen_tee_inlet_PtoD[j] for j in 1:data_traceSubstances.nC};
  SI.MassFlowRate[data_traceSubstances.nC] mC_gen_plenum_lower = {-data_traceSubstances.lambdas[j]*plenum_lower.mC[j] + mC_gen_plenum_lower_PtoD[j] for j in 1:data_traceSubstances.nC};
  SI.MassFlowRate[reflA_lower.nV,data_traceSubstances.nC] mC_gens_reflA_lower = {{-data_traceSubstances.lambdas[j]*reflA_lower.mCs[i, j]*reflA_lower.nParallel + mC_gens_reflA_lower_PtoD[i,j] for j in 1:data_traceSubstances.nC} for i in 1:reflA_lower.nV};
  SI.MassFlowRate[fuelCell.nV,data_traceSubstances.nC] mC_gens_fuelCell = cat(2, kinetics.mC_gens, kinetics.mC_gens_FP);
  SI.MassFlowRate[fuelCell.nV,data_traceSubstances.nC] mC_gens_reflR = {{-data_traceSubstances.lambdas[j]*reflR.mCs[i, j]*reflR.nParallel + mC_gens_reflR_PtoD[i,j] for j in 1:data_traceSubstances.nC} for i in 1:reflR.nV};
  SI.MassFlowRate[reflA_upper.nV,data_traceSubstances.nC] mC_gens_reflA_upper = {{-data_traceSubstances.lambdas[j]*reflA_upper.mCs[i, j]*reflA_upper.nParallel + mC_gens_reflA_upper_PtoD[i,j] for j in 1:data_traceSubstances.nC} for i in 1:reflA_upper.nV};
  SI.MassFlowRate[data_traceSubstances.nC] mC_gen_plenum_upper = {-data_traceSubstances.lambdas[j]*plenum_upper.mC[j] + mC_gen_plenum_upper_PtoD[j] for j in 1:data_traceSubstances.nC};
  SI.MassFlowRate[data_traceSubstances.nC] mC_gen_pumpBowl_PFL={-data_traceSubstances.lambdas[j]*pumpBowl_PFL.mC[j]*3 + mC_flows_fromOG[j] + mC_gen_pumpBowl_PFL_PtoD[j] for j in 1:data_traceSubstances.nC};
  SI.MassFlowRate[pipeToPHX_PFL.nV,data_traceSubstances.nC] mC_gens_pipeToPHX_PFL = {{-data_traceSubstances.lambdas[j]*pipeToPHX_PFL.mCs[i, j]*pipeToPHX_PFL.nParallel + mC_gens_pipeToPHX_PFL_PtoD[i,j] for j in 1:data_traceSubstances.nC} for i in 1:pipeToPHX_PFL.nV};
  SI.MassFlowRate[PHX.tube.nV,data_traceSubstances.nC] mC_gens_PHX_tube = {{-data_traceSubstances.lambdas[j]*PHX.tube.mCs[i, j]*PHX.tube.nParallel + mC_gens_PHX_tube_PtoD[i,j] for j in 1:data_traceSubstances.nC} for i in 1:PHX.tube.nV};
  SI.MassFlowRate[pipeFromPHX_PFL.nV,data_traceSubstances.nC] mC_gens_pipeFromPHX_PFL = {{-data_traceSubstances.lambdas[j]*pipeFromPHX_PFL.mCs[i, j]*pipeFromPHX_PFL.nParallel + mC_gens_pipeFromPHX_PFL_PtoD[i,j] for j in 1:data_traceSubstances.nC} for i in 1:pipeFromPHX_PFL.nV};

  // Trace Substances Parent->Daughter contribution
  SI.MassFlowRate[data_traceSubstances.nC] mC_gen_tee_inlet_PtoD =  {(if (j>=data_traceSubstances.iFP[1] and j<= data_traceSubstances.iFP[2]) then sum(data_traceSubstances.fissionProducts.lambdas.*tee_inlet.mC[data_traceSubstances.iFP[1]:data_traceSubstances.iFP[2]].*data_traceSubstances.fissionProducts.parents[j-data_traceSubstances.iFP[1]+1,:]) else 0) for j in 1:data_traceSubstances.nC};
  SI.MassFlowRate[data_traceSubstances.nC] mC_gen_plenum_lower_PtoD= {(if (j>=data_traceSubstances.iFP[1] and j<= data_traceSubstances.iFP[2]) then sum(data_traceSubstances.fissionProducts.lambdas.*plenum_lower.mC[data_traceSubstances.iFP[1]:data_traceSubstances.iFP[2]].*data_traceSubstances.fissionProducts.parents[j-data_traceSubstances.iFP[1]+1,:]) else 0) for j in 1:data_traceSubstances.nC};
  SI.MassFlowRate[reflA_lower.nV,data_traceSubstances.nC] mC_gens_reflA_lower_PtoD = {{(if (j>=data_traceSubstances.iFP[1] and j<= data_traceSubstances.iFP[2]) then sum(data_traceSubstances.fissionProducts.lambdas.*reflA_lower.mCs[i,data_traceSubstances.iFP[1]:data_traceSubstances.iFP[2]].*data_traceSubstances.fissionProducts.parents[j-data_traceSubstances.iFP[1]+1,:]) else 0) for j in 1:data_traceSubstances.nC} for i in 1:reflA_lower.nV};
  SI.MassFlowRate[fuelCell.nV,data_traceSubstances.nC] mC_gens_fuelCell_PtoD = {{(if (j>=data_traceSubstances.iFP[1] and j<= data_traceSubstances.iFP[2]) then sum(data_traceSubstances.fissionProducts.lambdas.*fuelCell.mCs[i,data_traceSubstances.iFP[1]:data_traceSubstances.iFP[2]].*data_traceSubstances.fissionProducts.parents[j-data_traceSubstances.iFP[1]+1,:]) else 0) for j in 1:data_traceSubstances.nC} for i in 1:fuelCell.nV};
  SI.MassFlowRate[fuelCell.nV,data_traceSubstances.nC] mC_gens_reflR_PtoD= {{(if (j>=data_traceSubstances.iFP[1] and j<= data_traceSubstances.iFP[2]) then sum(data_traceSubstances.fissionProducts.lambdas.*reflR.mCs[i,data_traceSubstances.iFP[1]:data_traceSubstances.iFP[2]].*data_traceSubstances.fissionProducts.parents[j-data_traceSubstances.iFP[1]+1,:]) else 0) for j in 1:data_traceSubstances.nC} for i in 1:reflR.nV};
  SI.MassFlowRate[reflA_upper.nV,data_traceSubstances.nC] mC_gens_reflA_upper_PtoD= {{(if (j>=data_traceSubstances.iFP[1] and j<= data_traceSubstances.iFP[2]) then sum(data_traceSubstances.fissionProducts.lambdas.*reflA_upper.mCs[i,data_traceSubstances.iFP[1]:data_traceSubstances.iFP[2]].*data_traceSubstances.fissionProducts.parents[j-data_traceSubstances.iFP[1]+1,:]) else 0) for j in 1:data_traceSubstances.nC} for i in 1:reflA_upper.nV};
  SI.MassFlowRate[data_traceSubstances.nC] mC_gen_plenum_upper_PtoD= {(if (j>=data_traceSubstances.iFP[1] and j<= data_traceSubstances.iFP[2]) then sum(data_traceSubstances.fissionProducts.lambdas.*plenum_upper.mC[data_traceSubstances.iFP[1]:data_traceSubstances.iFP[2]].*data_traceSubstances.fissionProducts.parents[j-data_traceSubstances.iFP[1]+1,:]) else 0) for j in 1:data_traceSubstances.nC};
  SI.MassFlowRate[data_traceSubstances.nC] mC_gen_pumpBowl_PFL_PtoD={(if (j>=data_traceSubstances.iFP[1] and j<= data_traceSubstances.iFP[2]) then sum(data_traceSubstances.fissionProducts.lambdas.*pumpBowl_PFL.mC[data_traceSubstances.iFP[1]:data_traceSubstances.iFP[2]].*data_traceSubstances.fissionProducts.parents[j-data_traceSubstances.iFP[1]+1,:]) else 0) for j in 1:data_traceSubstances.nC};
  SI.MassFlowRate[pipeToPHX_PFL.nV,data_traceSubstances.nC] mC_gens_pipeToPHX_PFL_PtoD = {{(if (j>=data_traceSubstances.iFP[1] and j<= data_traceSubstances.iFP[2]) then sum(data_traceSubstances.fissionProducts.lambdas.*pipeToPHX_PFL.mCs[i,data_traceSubstances.iFP[1]:data_traceSubstances.iFP[2]].*data_traceSubstances.fissionProducts.parents[j-data_traceSubstances.iFP[1]+1,:]) else 0) for j in 1:data_traceSubstances.nC} for i in 1:pipeToPHX_PFL.nV};
  SI.MassFlowRate[PHX.tube.nV,data_traceSubstances.nC] mC_gens_PHX_tube_PtoD = {{(if (j>=data_traceSubstances.iFP[1] and j<= data_traceSubstances.iFP[2]) then sum(data_traceSubstances.fissionProducts.lambdas.*PHX.tube.mCs[i,data_traceSubstances.iFP[1]:data_traceSubstances.iFP[2]].*data_traceSubstances.fissionProducts.parents[j-data_traceSubstances.iFP[1]+1,:]) else 0) for j in 1:data_traceSubstances.nC} for i in 1:PHX.tube.nV};
  SI.MassFlowRate[pipeFromPHX_PFL.nV,data_traceSubstances.nC] mC_gens_pipeFromPHX_PFL_PtoD = {{(if (j>=data_traceSubstances.iFP[1] and j<= data_traceSubstances.iFP[2]) then sum(data_traceSubstances.fissionProducts.lambdas.*pipeFromPHX_PFL.mCs[i,data_traceSubstances.iFP[1]:data_traceSubstances.iFP[2]].*data_traceSubstances.fissionProducts.parents[j-data_traceSubstances.iFP[1]+1,:]) else 0) for j in 1:data_traceSubstances.nC} for i in 1:pipeFromPHX_PFL.nV};

  // TraceSubstance Calculations: Off-Gas and Drain Tank
  SI.MassFlowRate m_flow_toDrainTank = data_OFFGAS.V_flow_sep_salt_total*Medium_PFL.density_ph(pump_PFL.port_b.p, pump_PFL.port_b.h_outflow) "Mass flow rate of salt to drain tank (+)";
  SI.MassFlowRate[nOG] mC_gen_drainTank_gas={-data_traceSubstances.lambdas[iOG[j]]*drainTank_gas.mC[j] + mC_gen_drainTank_gas_PtoD[j] for j in 1:nOG};
  SI.MassFlowRate[data_traceSubstances.nC] mC_gen_drainTank_liquid=-data_traceSubstances.lambdas.*drainTank_liquid.mC + mC_gen_drainTank_liquid_PtoD;
  SI.MassFlowRate[data_traceSubstances.nC] mC_flows_fromOG;

  // Trace Substances Parent->Daughter contribution:  Off-Gas and Drain Tank
  SI.MassFlowRate[nOG] mC_gen_drainTank_gas_PtoD =  {sum({data_traceSubstances.fissionProducts.lambdas[iOG_FP[i]].*drainTank_gas.mC[i].*data_traceSubstances.fissionProducts.parents[j,iOG_FP[i]] for i in 1:nOG}) for j in 1:nOG};
  SI.MassFlowRate[data_traceSubstances.nC] mC_gen_drainTank_liquid_PtoD =  {(if (j>=data_traceSubstances.iFP[1] and j<= data_traceSubstances.iFP[2]) then sum(data_traceSubstances.fissionProducts.lambdas.*drainTank_liquid.mC[data_traceSubstances.iFP[1]:data_traceSubstances.iFP[2]].*data_traceSubstances.fissionProducts.parents[j-data_traceSubstances.iFP[1]+1,:]) else 0) for j in 1:data_traceSubstances.nC};


  TRANSFORM.Fluid.BoundaryConditions.Boundary_pT boundary_OffGas_sink(
    redeclare package Medium = Medium_OffGas,
    nPorts=2,
    T=data_OFFGAS.T_carbon,
    p=data_OFFGAS.p_sep_ref,
    use_p_in=true)
    annotation (Placement(transformation(extent={{-170,20},{-190,40}})));

  Data.data_PHX data_PHX
    annotation (Placement(transformation(extent={{290,100},{310,120}})));
  Data.data_RCTR data_RCTR
    annotation (Placement(transformation(extent={{260,100},{280,120}})));
  Data.data_PUMP data_PUMP
    annotation (Placement(transformation(extent={{320,120},{340,140}})));
  Data.data_SHX data_SHX
    annotation (Placement(transformation(extent={{320,100},{340,120}})));
  Data.data_PIPING data_PIPING
    annotation (Placement(transformation(extent={{260,80},{280,100}})));
  Fluid.Pipes.GenericPipe_MultiTransferSurface fuelCell(
    nParallel=data_RCTR.nFcells,
    redeclare model HeatTransfer =
        Fluid.ClosureRelations.HeatTransfer.Models.DistributedPipe_1D_MultiTransferSurface.Nus_SinglePhase_2Region,
    T_a_start=data_PHX.T_outlet_tube,
    T_b_start=data_PHX.T_inlet_tube,
    exposeState_b=true,
    p_a_start=data_PHX.p_inlet_tube + 100,
    redeclare package Medium = Medium_PFL,
    use_HeatTransfer=true,
    redeclare model Geometry =
        TRANSFORM.Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.StraightPipe
        (
        crossArea=data_RCTR.crossArea_f,
        perimeter=data_RCTR.perimeter_f,
        length=data_RCTR.length_cells,
        nV=10,
        angle=toggleStaticHead*90),
    showName=systemTF.showName,
    m_flow_a_start=0.95*data_RCTR.m_flow,
    redeclare model InternalHeatGen =
        TRANSFORM.Fluid.ClosureRelations.InternalVolumeHeatGeneration.Models.DistributedVolume_1D.GenericHeatGeneration
        (Q_gens=kinetics.Qs + kinetics.Qs_FP),
    redeclare model InternalTraceMassGen =
        TRANSFORM.Fluid.ClosureRelations.InternalMassGeneration.Models.DistributedVolume_TraceMass_1D.GenericMassGeneration
        (mC_gens=mC_gens_fuelCell))
    "frac*data_RCTR.Q_nominal/fuelCell.nV; mC_gens_fuelCell"
                                     annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,0})));

  Fluid.Pipes.GenericPipe_MultiTransferSurface reflA_upper(
    m_flow_a_start=data_RCTR.m_flow,
    p_a_start=data_PHX.p_inlet_tube + 50,
    T_a_start=data_PHX.T_inlet_tube,
    redeclare package Medium = Medium_PFL,
    use_HeatTransfer=true,
    redeclare model HeatTransfer =
        Fluid.ClosureRelations.HeatTransfer.Models.DistributedPipe_1D_MultiTransferSurface.Nus_SinglePhase_2Region,
    redeclare model Geometry =
        Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.StraightPipe
        (
        crossArea=data_RCTR.crossArea_reflA_ring,
        perimeter=data_RCTR.perimeter_reflA_ring,
        length=data_RCTR.length_reflA,
        nV=2,
        nSurfaces=2,
        surfaceArea={0.5*reflA_upper.geometry.perimeter*reflA_upper.geometry.length,
            0.5*reflA_upper.geometry.perimeter*reflA_upper.geometry.length},
        angle=toggleStaticHead*90),
    showName=systemTF.showName,
    redeclare model InternalTraceMassGen =
        TRANSFORM.Fluid.ClosureRelations.InternalMassGeneration.Models.DistributedVolume_TraceMass_1D.GenericMassGeneration
        (mC_gens=mC_gens_reflA_upper))
               annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,60})));

  Fluid.Volumes.MixingVolume plenum_upper(
    p_start=data_PHX.p_inlet_tube,
    T_start=data_PHX.T_inlet_tube,
    nPorts_b=1,
    nPorts_a=1,
    redeclare package Medium = Medium_PFL,
    redeclare model Geometry =
        Fluid.ClosureRelations.Geometry.Models.LumpedVolume.Cylinder (
        length=data_RCTR.length_plenum,
        crossArea=data_RCTR.crossArea_plenum,
        angle=toggleStaticHead*90),
    showName=systemTF.showName,
    mC_gen=mC_gen_plenum_upper)            annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,90})));
  Fluid.Pipes.GenericPipe_MultiTransferSurface reflA_lower(
    m_flow_a_start=data_RCTR.m_flow,
    p_a_start=data_PHX.p_inlet_tube + 150,
    T_a_start=data_PHX.T_outlet_tube,
    exposeState_a=false,
    exposeState_b=true,
    redeclare package Medium = Medium_PFL,
    use_HeatTransfer=true,
    redeclare model HeatTransfer =
        Fluid.ClosureRelations.HeatTransfer.Models.DistributedPipe_1D_MultiTransferSurface.Nus_SinglePhase_2Region,
    redeclare model Geometry =
        Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.StraightPipe
        (
        crossArea=data_RCTR.crossArea_reflA_ring,
        perimeter=data_RCTR.perimeter_reflA_ring,
        length=data_RCTR.length_reflA,
        nV=2,
        surfaceArea={0.5*reflA_lower.geometry.perimeter*reflA_lower.geometry.length,
            0.5*reflA_lower.geometry.perimeter*reflA_lower.geometry.length},
        nSurfaces=2,
        angle=toggleStaticHead*90),
    showName=systemTF.showName,
    redeclare model InternalTraceMassGen =
        TRANSFORM.Fluid.ClosureRelations.InternalMassGeneration.Models.DistributedVolume_TraceMass_1D.GenericMassGeneration
        (mC_gens=mC_gens_reflA_lower))
                         annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,-60})));

  Fluid.FittingsAndResistances.SpecifiedResistance resistance_fuelCell_outlet(
          redeclare package Medium = Medium_PFL, R=1,
    showName=systemTF.showName)
          annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,30})));
  Fluid.Volumes.MixingVolume plenum_lower(
    nPorts_b=1,
    redeclare package Medium = Medium_PFL,
    nPorts_a=1,
    p_start=data_PHX.p_inlet_tube + 150,
    redeclare model Geometry =
        Fluid.ClosureRelations.Geometry.Models.LumpedVolume.Cylinder (
        length=data_RCTR.length_plenum,
        crossArea=data_RCTR.crossArea_plenum,
        angle=toggleStaticHead*90),
    T_start=data_PHX.T_outlet_tube,
    showName=systemTF.showName,
    mC_gen=mC_gen_plenum_lower)          annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,-90})));
  Fluid.FittingsAndResistances.SpecifiedResistance resistance_fuelCell_inlet(
      redeclare package Medium = Medium_PFL, R=1,
    showName=systemTF.showName)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,-30})));
  Fluid.FittingsAndResistances.SpecifiedResistance resistance_toPump_PFL(
      redeclare package Medium = Medium_PFL, R=1,
    showName=systemTF.showName)              annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,112})));
  HeatAndMassTransfer.DiscritizedModels.Conduction_2D fuelCellG(
    redeclare package Material = Media.Solids.Graphite.Graphite_0,
    T_b2_start=data_PHX.T_inlet_tube,
    nParallel=2*data_RCTR.nfG*data_RCTR.nFcells,
    redeclare model Geometry =
        TRANSFORM.HeatAndMassTransfer.ClosureRelations.Geometry.Models.Plane_2D
        (
        nX=5,
        nY=fuelCell.nV,
        length_x=0.5*data_RCTR.width_fG,
        length_y=data_RCTR.length_cells,
        length_z=data_RCTR.length_fG),
    exposeState_b2=true,
    exposeState_b1=true,
    T_a1_start=0.5*(data_PHX.T_outlet_tube + data_PHX.T_outlet_tube),
    T_b1_start=0.5*(data_PHX.T_outlet_tube + data_PHX.T_outlet_tube) + 50,
    T_a2_start=data_PHX.T_outlet_tube,
    showName=systemTF.showName)
                         annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={-30,0})));
  HeatAndMassTransfer.BoundaryConditions.Heat.Adiabatic_multi
    fuelCellG_centerline_bc(nPorts=fuelCell.nV, showName=systemTF.showName)
    annotation (Placement(transformation(extent={{-68,-10},{-48,10}})));
  HeatAndMassTransfer.BoundaryConditions.Heat.Adiabatic_multi
    fuelCellG_upper_bc(nPorts=fuelCellG.geometry.nX, showName=systemTF.showName)
                                                     annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-30,30})));
  HeatAndMassTransfer.BoundaryConditions.Heat.Adiabatic_multi
    fuelCellG_lower_bc(nPorts=fuelCellG.geometry.nX, showName=systemTF.showName)
                                                     annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=270,
        origin={-30,-30})));
  HeatAndMassTransfer.DiscritizedModels.Conduction_2D reflA_upperG(
    redeclare package Material = Media.Solids.Graphite.Graphite_0,
    T_a2_start=data_PHX.T_inlet_tube,
    T_b2_start=data_PHX.T_inlet_tube,
    exposeState_b2=true,
    exposeState_b1=true,
    T_a1_start=data_PHX.T_inlet_tube,
    T_b1_start=data_PHX.T_inlet_tube,
    nParallel=data_RCTR.n_reflA_ringG,
    redeclare model Geometry =
        HeatAndMassTransfer.ClosureRelations.Geometry.Models.Cylinder_2D_r_z (
        nR=5,
        nZ=reflA_upper.nV,
        r_inner=data_RCTR.rs_ring_edge_inner[6],
        r_outer=data_RCTR.rs_ring_edge_outer[6],
        length_z=data_RCTR.length_reflA,
        angle_theta=0.5235987755983),
    showName=systemTF.showName)       annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={-30,60})));
  HeatAndMassTransfer.BoundaryConditions.Heat.Adiabatic_multi
    reflA_upperG_upper_bc(nPorts=reflA_upperG.geometry.nR, showName=systemTF.showName)
                                                           annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-30,90})));
  HeatAndMassTransfer.BoundaryConditions.Heat.Adiabatic_multi
    reflA_upperG_lower_bc(nPorts=reflA_upperG.geometry.nR, showName=systemTF.showName)
                                                           annotation (
      Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=270,
        origin={-30,30})));
  HeatAndMassTransfer.DiscritizedModels.Conduction_2D reflA_lowerG(
    redeclare package Material = Media.Solids.Graphite.Graphite_0,
    exposeState_b2=true,
    exposeState_b1=true,
    nParallel=data_RCTR.n_reflA_ringG,
    redeclare model Geometry =
        HeatAndMassTransfer.ClosureRelations.Geometry.Models.Cylinder_2D_r_z (
        nR=5,
        r_inner=data_RCTR.rs_ring_edge_inner[6],
        r_outer=data_RCTR.rs_ring_edge_outer[6],
        length_z=data_RCTR.length_reflA,
        nZ=reflA_lower.nV,
        angle_theta=0.5235987755983),
    T_a1_start=data_PHX.T_outlet_tube,
    T_b1_start=data_PHX.T_outlet_tube,
    T_a2_start=data_PHX.T_outlet_tube,
    T_b2_start=data_PHX.T_outlet_tube,
    showName=systemTF.showName)       annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={-30,-60})));
  HeatAndMassTransfer.BoundaryConditions.Heat.Adiabatic_multi
    reflA_lowerG_upper_bc(nPorts=reflA_lowerG.geometry.nR, showName=systemTF.showName)
                                                           annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-30,-30})));
  HeatAndMassTransfer.BoundaryConditions.Heat.Adiabatic_multi
    reflA_lowerG_lower_bc(nPorts=reflA_lowerG.geometry.nR, showName=systemTF.showName)
                                                           annotation (
      Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=270,
        origin={-30,-90})));
  Fluid.FittingsAndResistances.SpecifiedResistance resistance_teeTOplenum(
      redeclare package Medium = Medium_PFL, R=1,
    showName=systemTF.showName)              annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,-110})));
  Fluid.Volumes.MixingVolume tee_inlet(
    nPorts_b=1,
    T_start=data_PHX.T_outlet_tube,
    redeclare package Medium = Medium_PFL,
    p_start=data_PHX.p_inlet_tube + 200,
    redeclare model Geometry =
        Fluid.ClosureRelations.Geometry.Models.LumpedVolume.Cylinder (
        length=data_RCTR.length_tee_inlet,
        crossArea=data_RCTR.crossArea_tee_inlet,
        angle=toggleStaticHead*90),
    nPorts_a=1,
    showName=systemTF.showName,
    mC_gen=mC_gen_tee_inlet)             annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,-130})));
  Fluid.Pipes.GenericPipe_MultiTransferSurface pipeFromPHX_PFL(
    nParallel=3,
    T_a_start=data_PHX.T_outlet_tube,
    redeclare package Medium = Medium_PFL,
    p_a_start=data_PHX.p_inlet_tube + 250,
    redeclare model Geometry =
        Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.StraightPipe
        (
        length=data_PIPING.length_PHXToRCTR,
        nV=10,
        dimension=data_PIPING.D_PFL,
        dheight=toggleStaticHead*data_PIPING.height_PHXToRCTR),
    m_flow_a_start=2*3*data_PHX.m_flow_tube,
    showName=systemTF.showName,
    redeclare model InternalTraceMassGen =
        TRANSFORM.Fluid.ClosureRelations.InternalMassGeneration.Models.DistributedVolume_TraceMass_1D.GenericMassGeneration
        (mC_gens=mC_gens_pipeFromPHX_PFL))
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=90,
        origin={160,-70})));
  HeatExchangers.GenericDistributed_HX PHX(
    redeclare package Medium_shell = Medium_PCL,
    redeclare package Medium_tube = Medium_PFL,
    redeclare package Material_tubeWall = Media.Solids.AlloyN,
    p_a_start_shell=data_PHX.p_inlet_shell,
    T_a_start_shell=data_PHX.T_inlet_shell,
    T_b_start_shell=data_PHX.T_outlet_shell,
    p_a_start_tube=data_PHX.p_inlet_tube,
    T_a_start_tube=data_PHX.T_inlet_tube,
    T_b_start_tube=data_PHX.T_outlet_tube,
    redeclare model Geometry =
        Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.HeatExchanger.ShellAndTubeHX
        (
        D_o_shell=data_PHX.D_shell_inner,
        nV=10,
        nTubes=data_PHX.nTubes,
        nR=3,
        length_shell=data_PHX.length_tube,
        th_wall=data_PHX.th_tube,
        dimension_tube=data_PHX.D_tube_inner,
        length_tube=data_PHX.length_tube),
    nParallel=2*3,
    m_flow_a_start_shell=2*3*data_PHX.m_flow_shell,
    m_flow_a_start_tube=2*3*data_PHX.m_flow_tube,
    redeclare model HeatTransfer_tube =
        Fluid.ClosureRelations.HeatTransfer.Models.DistributedPipe_1D.Nus_SinglePhase_2Region,
    redeclare model HeatTransfer_shell =
        Fluid.ClosureRelations.HeatTransfer.Models.DistributedPipe_1D.FlowAcrossTubeBundles_Grimison
        (
        D=data_PHX.D_tube_outer,
        S_T=data_PHX.pitch_tube,
        S_L=data_PHX.pitch_tube,
        CF=fill(0.44, PHX.shell.heatTransfer.nHT)),
    redeclare model InternalTraceMassGen_tube =
        TRANSFORM.Fluid.ClosureRelations.InternalMassGeneration.Models.DistributedVolume_TraceMass_1D.GenericMassGeneration
        (mC_gens=mC_gens_PHX_tube))        annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=90,
        origin={160,0})));

  Fluid.Pipes.GenericPipe_MultiTransferSurface pipeToPHX_PFL(
    nParallel=3,
    redeclare package Medium = Medium_PFL,
    p_a_start=data_PHX.p_inlet_tube + 350,
    T_a_start=data_PHX.T_inlet_tube,
    redeclare model Geometry =
        Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.StraightPipe
        (
        nV=10,
        dimension=data_PIPING.D_PFL,
        length=data_PIPING.length_pumpToPHX,
        dheight=toggleStaticHead*data_PIPING.height_pumpToPHX),
    m_flow_a_start=2*3*data_PHX.m_flow_tube,
    showName=systemTF.showName,
    redeclare model InternalTraceMassGen =
        TRANSFORM.Fluid.ClosureRelations.InternalMassGeneration.Models.DistributedVolume_TraceMass_1D.GenericMassGeneration
        (mC_gens=mC_gens_pipeToPHX_PFL))                        annotation (
      Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={160,70})));
  Fluid.Machines.Pump_SimpleMassFlow pump_PFL(redeclare package Medium =
        Medium_PFL,
    use_input=true,
    m_flow_nominal=2*3*data_PHX.m_flow_tube)
    annotation (Placement(transformation(extent={{40,118},{60,138}})));
  Fluid.Volumes.ExpansionTank pumpBowl_PFL(
    redeclare package Medium = Medium_PFL,
    level_start=data_RCTR.level_pumpbowlnominal,
    showName=systemTF.showName,
    h_start=pumpBowl_PFL.Medium.specificEnthalpy_pT(pumpBowl_PFL.p_start,
        data_PHX.T_inlet_tube),
    A=3*data_RCTR.crossArea_pumpbowl,
    mC_gen=mC_gen_pumpBowl_PFL)
    annotation (Placement(transformation(extent={{10,124},{30,144}})));

  UserInteraction.Outputs.SpatialPlot2 spatialPlot2_1(
    x1=PHX.tube.summary.xpos_norm,
    y1={PHX.tube.mediums[i].T for i in 1:PHX.geometry.nV},
    x2=if PHX.counterCurrent == true then Modelica.Math.Vectors.reverse(PHX.shell.summary.xpos_norm)
         else PHX.shell.summary.xpos_norm,
    y2={PHX.shell.mediums[i].T for i in 1:PHX.geometry.nV},
    minY1=min({data_PHX.T_inlet_tube,data_PHX.T_inlet_shell,data_PHX.T_outlet_tube,
        data_PHX.T_outlet_shell}),
    maxY1=max({data_PHX.T_inlet_tube,data_PHX.T_inlet_shell,data_PHX.T_outlet_tube,
        data_PHX.T_outlet_shell}))
    annotation (Placement(transformation(extent={{194,-122},{244,-78}})));
  inner TRANSFORM.Fluid.SystemTF systemTF(showName=false)
    annotation (Placement(transformation(extent={{200,120},{220,140}})));
  TRANSFORM.Nuclear.ReactorKinetics.PointKinetics_Drift kinetics(
    nV=fuelCell.nV,
    Q_nominal=data_RCTR.Q_nominal,
    vals_feedback=fuelCell.mediums.T,
    vals_feedback_reference=linspace(
        data_RCTR.T_inlet_core,
        data_RCTR.T_outlet_core,
        fuelCell.nV),
    specifyPower=true,
    lambda_i=data_traceSubstances.precursorGroups.lambdas,
    nC=data_traceSubstances.fissionProducts.nC,
    mCs=fuelCell.mCs[:, data_traceSubstances.iPG[1]:data_traceSubstances.iPG[2]]
        *fuelCell.nParallel,
    nT=data_traceSubstances.fissionProducts.nT,
    nFS=2,
    lambda_FP=data_traceSubstances.fissionProducts.lambdas,
    fissionYield=data_traceSubstances.fissionProducts.fissionYield,
    fissionSource={0.6,0.4},
    w_FP_decay=data_traceSubstances.fissionProducts.w_decay,
    mCs_FP=fuelCell.mCs[:, data_traceSubstances.iFP[1]:data_traceSubstances.iFP[
        2]]*fuelCell.nParallel)
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  TRANSFORM.Examples.MoltenSaltReactor.Data.data_traceSubstances
    data_traceSubstances(redeclare record FissionProducts =
        TRANSFORM.Examples.MoltenSaltReactor.Data.FissionProducts.fissionProducts_test)
    annotation (Placement(transformation(extent={{260,120},{280,140}})));
  TRANSFORM.Fluid.Pipes.GenericPipe_MultiTransferSurface
                                               pipeFromPHX_PCL(
    nParallel=3,
    showName=systemTF.showName,
    redeclare package Medium = Medium_PCL,
    p_a_start=data_PHX.p_inlet_shell - 50,
    T_a_start=data_PHX.T_outlet_shell,
    m_flow_a_start=2*3*data_PHX.m_flow_shell,
    redeclare model Geometry =
        TRANSFORM.Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.StraightPipe
        (
        nV=10,
        dimension=data_PIPING.D_PCL,
        length=data_PIPING.length_PHXsToPump,
        dheight=toggleStaticHead*data_PIPING.height_PHXsToPump))
    annotation (Placement(transformation(extent={{10,10},{-10,-10}},
        rotation=180,
        origin={190,40})));
  TRANSFORM.Fluid.Volumes.ExpansionTank pumpBowl_PCL(
    level_start=data_RCTR.level_pumpbowlnominal,
    showName=systemTF.showName,
    redeclare package Medium = Medium_PCL,
    A=3*data_RCTR.crossArea_pumpbowl,
    h_start=pumpBowl_PCL.Medium.specificEnthalpy_pT(pumpBowl_PCL.p_start,
        data_SHX.T_outlet_shell))
    annotation (Placement(transformation(extent={{210,36},{230,56}})));
  TRANSFORM.Fluid.Machines.Pump_SimpleMassFlow pump_PCL(redeclare package
      Medium = Medium_PCL, m_flow_nominal=2*3*data_PHX.m_flow_shell)
    annotation (Placement(transformation(extent={{240,30},{260,50}})));
  TRANSFORM.Fluid.Pipes.GenericPipe_MultiTransferSurface pipeToSHX_PCL(
    nParallel=3,
    showName=systemTF.showName,
    redeclare package Medium = Medium_PCL,
    T_a_start=data_PHX.T_outlet_shell,
    m_flow_a_start=2*3*data_PHX.m_flow_shell,
    redeclare model Geometry =
        TRANSFORM.Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.StraightPipe
        (
        nV=10,
        dimension=data_PIPING.D_PCL,
        length=data_PIPING.length_pumpToSHX,
        dheight=toggleStaticHead*data_PIPING.height_pumpToSHX),
    p_a_start=data_PHX.p_inlet_shell + 300) annotation (Placement(
        transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={280,40})));
  TRANSFORM.Fluid.Pipes.GenericPipe_MultiTransferSurface
                                               pipeToPHX_PCL(
    showName=systemTF.showName,
    redeclare package Medium = Medium_PCL,
    m_flow_a_start=2*3*data_PHX.m_flow_shell,
    p_a_start=data_PHX.p_inlet_shell + 50,
    T_a_start=data_PHX.T_inlet_shell,
    redeclare model Geometry =
        TRANSFORM.Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.StraightPipe
        (
        nV=10,
        dimension=data_PIPING.D_PCL,
        length=data_PIPING.length_SHXToPHX,
        dheight=toggleStaticHead*data_PIPING.height_SHXToPHX),
    nParallel=3)                                                annotation (
      Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={230,-40})));
  TRANSFORM.Fluid.BoundaryConditions.MassFlowSource_T
                                            boundary4(
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    m_flow=2*3*data_SHX.m_flow_tube,
    T=data_SHX.T_inlet_tube,
    nPorts=1)                 annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={330,-40})));
  TRANSFORM.HeatExchangers.GenericDistributed_HX SHX(
    redeclare package Medium_shell = Medium_PCL,
    redeclare package Material_tubeWall = TRANSFORM.Media.Solids.AlloyN,
    nParallel=2*3,
    redeclare model HeatTransfer_tube =
        TRANSFORM.Fluid.ClosureRelations.HeatTransfer.Models.DistributedPipe_1D.Nus_SinglePhase_2Region,
    redeclare package Medium_tube = Modelica.Media.Water.StandardWater,
    redeclare model Geometry =
        TRANSFORM.Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.HeatExchanger.ShellAndTubeHX
        (
        nV=10,
        nR=3,
        D_o_shell=data_SHX.D_shell_inner,
        nTubes=data_SHX.nTubes,
        length_shell=data_SHX.length_tube,
        dimension_tube=data_SHX.D_tube_inner,
        length_tube=data_SHX.length_tube,
        th_wall=data_SHX.th_tube),
    p_a_start_shell=data_SHX.p_inlet_shell,
    T_a_start_shell=data_SHX.T_inlet_shell,
    T_b_start_shell=data_SHX.T_outlet_shell,
    m_flow_a_start_shell=2*3*data_SHX.m_flow_shell,
    p_a_start_tube=data_SHX.p_inlet_tube,
    T_a_start_tube=data_SHX.T_inlet_tube,
    T_b_start_tube=data_SHX.T_outlet_tube,
    m_flow_a_start_tube=2*3*data_SHX.m_flow_tube,
    redeclare model HeatTransfer_shell =
        TRANSFORM.Fluid.ClosureRelations.HeatTransfer.Models.DistributedPipe_1D.FlowAcrossTubeBundles_Grimison
        (
        D=data_SHX.D_tube_outer,
        S_T=data_SHX.pitch_tube,
        S_L=data_SHX.pitch_tube,
        CF=fill(0.44, SHX.shell.heatTransfer.nHT)))
                                                  annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={300,0})));

  TRANSFORM.Fluid.BoundaryConditions.Boundary_pT
                                       boundary1(
    p=data_SHX.p_outlet_tube,
    T=data_SHX.T_outlet_tube,
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    nPorts=1)                annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={330,40})));
  UserInteraction.Outputs.SpatialPlot2 spatialPlot2_2(
    x1=SHX.tube.summary.xpos_norm,
    y1={SHX.tube.mediums[i].T for i in 1:SHX.geometry.nV},
    x2=if SHX.counterCurrent == true then Modelica.Math.Vectors.reverse(SHX.shell.summary.xpos_norm)
         else SHX.shell.summary.xpos_norm,
    y2={SHX.shell.mediums[i].T for i in 1:SHX.geometry.nV},
    minY1=min({data_SHX.T_inlet_tube,data_SHX.T_inlet_shell,data_SHX.T_outlet_tube,
        data_SHX.T_outlet_shell}),
    maxY1=max({data_SHX.T_inlet_tube,data_SHX.T_inlet_shell,data_SHX.T_outlet_tube,
        data_SHX.T_outlet_shell}))
    annotation (Placement(transformation(extent={{256,-122},{306,-78}})));
  TRANSFORM.Fluid.BoundaryConditions.MassFlowSource_T boundary_OffGas_source(
    T=data_OFFGAS.T_sep_ref,
    redeclare package Medium = Medium_OffGas,
    m_flow=data_OFFGAS.m_flow_He_adsorber,
    use_m_flow_in=true,
    use_T_in=true,
    nPorts=1,
    use_C_in=false)
    annotation (Placement(transformation(extent={{-310,98},{-290,118}})));
  TRANSFORM.Fluid.TraceComponents.TraceDecayAdsorberBed adsorberBed(
    iC=2,
    nV=10,
    redeclare package Medium = Medium_OffGas,
    Qs_decay=fill(1e5, Medium_OffGas.nC),
    d_adsorber=data_OFFGAS.d_carbon,
    cp_adsorber=data_OFFGAS.cp_carbon,
    tau_res=data_OFFGAS.delay_charcoalBed,
    R=data_OFFGAS.dp_carbon/data_OFFGAS.m_flow_He_adsorber,
    use_HeatPort=true,
    lambdas={data_traceSubstances.lambdas[iOG[i]] for i in 1:nOG},
    T_a_start=data_OFFGAS.T_carbon,
    showName=systemTF.showName)
    annotation (Placement(transformation(extent={{-230,-30},{-210,-10}})));
  TRANSFORM.Examples.MoltenSaltReactor.Data.data_OFFGAS
                   data_OFFGAS
    annotation (Placement(transformation(extent={{290,120},{310,140}})));
  Modelica.Blocks.Sources.RealExpression boundary_OffGas_m_flow(y=data_OFFGAS.m_flow_He_adsorber)
    annotation (Placement(transformation(extent={{-350,116},{-330,136}})));
  Modelica.Blocks.Sources.RealExpression boundary_OffGas_T(y=data_OFFGAS.T_sep_ref)
    annotation (Placement(transformation(extent={{-350,102},{-330,122}})));
  TRANSFORM.HeatAndMassTransfer.BoundaryConditions.Heat.Temperature_multi boundary_thermal_adsorberBed(nPorts=
        adsorberBed.nV, T=fill(data_OFFGAS.T_carbon_wall, adsorberBed.nV),
    showName=systemTF.showName)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-220,10})));
  TRANSFORM.Fluid.Volumes.MixingVolume drainTank_gas(
    use_HeatPort=true,
    redeclare package Medium = Medium_OffGas,
    redeclare model Geometry =
        TRANSFORM.Fluid.ClosureRelations.Geometry.Models.LumpedVolume.GenericVolume
        (V=data_OFFGAS.delay_drainTank*data_OFFGAS.m_flow_sep_He_total/
            Medium_OffGas.density_pT(data_OFFGAS.p_drainTank, data_OFFGAS.T_drainTank)),
    T_start=data_OFFGAS.T_drainTank,
    p_start=data_OFFGAS.p_drainTank,
    mC_gen=mC_gen_drainTank_gas,
    nPorts_b=2,
    nPorts_a=1,
    showName=systemTF.showName)
    annotation (Placement(transformation(extent={{-260,-10},{-240,-30}})));

  TRANSFORM.HeatAndMassTransfer.BoundaryConditions.Heat.Temperature boundary_thermal_drainTank_gas(T=
        data_OFFGAS.T_drainTank, showName=systemTF.showName)
                                 annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-250,10})));
  TRANSFORM.Fluid.Volumes.ExpansionTank drainTank_liquid(
    redeclare package Medium = Medium_PFL,
    p_surface=drainTank_gas.medium.p,
    h_start=pumpBowl_PFL.h_start,
    p_start=drainTank_gas.p_start,
    mC_gen=mC_gen_drainTank_liquid,
    use_HeatPort=true,
    A=data_OFFGAS.crossArea_drainTank_inner,
    level_start=0.20,
    showName=systemTF.showName)
    annotation (Placement(transformation(extent={{-260,-64},{-240,-44}})));
  TRANSFORM.Fluid.FittingsAndResistances.SpecifiedResistance resistance_fromDrainTank(
    redeclare package Medium = Medium_PFL,
    R=1,
    showName=systemTF.showName) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-220,-60})));
  TRANSFORM.HeatAndMassTransfer.BoundaryConditions.Heat.Temperature boundary_thermal_drainTank_liquid(T=
        data_OFFGAS.T_drainTank, showName=systemTF.showName)
                                 annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=270,
        origin={-250,-90})));
  TRANSFORM.Fluid.Machines.Pump_SimpleMassFlow pump_drainTank(redeclare package
      Medium = Medium_PFL, use_input=true)
    annotation (Placement(transformation(extent={{-200,-70},{-180,-50}})));
  TRANSFORM.Controls.TankLevelControl drainTankLevelControl(
    level=drainTank_liquid.level,
    level_min=0.2,
    level_max=0.4,
    drainRate_active=2*m_flow_toDrainTank,
    drainRate_nonActive=0.5*m_flow_toDrainTank)
    annotation (Placement(transformation(extent={{-208,-48},{-200,-40}})));
  TRANSFORM.Fluid.Machines.Pump_SimpleMassFlow pump_OffGas_bypass(use_input=true,
      redeclare package Medium = Medium_OffGas)
    annotation (Placement(transformation(extent={{-230,20},{-210,40}})));
  TRANSFORM.Fluid.Machines.Pump_SimpleMassFlow pump_OffGas_adsorberBed(use_input=
       true, redeclare package Medium = Medium_OffGas)
    annotation (Placement(transformation(extent={{-200,-30},{-180,-10}})));
  Modelica.Blocks.Sources.RealExpression m_flow_OffGas_bypass(y=
        boundary_OffGas_m_flow.y - m_flow_OffGas_adsorberBed.y)
    annotation (Placement(transformation(extent={{-252,30},{-232,50}})));
  Modelica.Blocks.Sources.RealExpression m_flow_OffGas_adsorberBed(y=
        data_OFFGAS.frac_gasSplit*boundary_OffGas_m_flow.y)
    annotation (Placement(transformation(extent={{-164,-10},{-184,10}})));
  TRANSFORM.Fluid.TraceComponents.TraceSeparator traceSeparator(m_flow_sepFluid=
       m_flow_toDrainTank, iSep=iOG,
    redeclare package Medium = Medium_PFL,
    redeclare package Medium_carrier = Medium_OffGas,
    showName=systemTF.showName)      annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=90,
        origin={-270,90})));
  TRANSFORM.Fluid.Machines.Pump_SimpleMassFlow pump_bypass(redeclare package
      Medium = Medium_PFL, use_input=true)
    annotation (Placement(transformation(extent={{-238,102},{-258,122}})));
  Modelica.Blocks.Sources.RealExpression m_flow_pump_bypass(y=x_bypass.y*abs(
        pump_PFL.port_a.m_flow))
    annotation (Placement(transformation(extent={{-278,116},{-258,136}})));
  Modelica.Blocks.Sources.RealExpression boundary_fromPump_PFL_bypass_p(y=
        pumpBowl_PFL.p)
    annotation (Placement(transformation(extent={{-142,28},{-162,48}})));
  Modelica.Blocks.Sources.RealExpression m_flow_pump_PFL(y=2*3*data_PHX.m_flow_tube
        /(1 - x_bypass.y))
    annotation (Placement(transformation(extent={{76,132},{56,152}})));
  Modelica.Blocks.Sources.Constant x_bypass(k=0.1)
    annotation (Placement(transformation(extent={{180,90},{200,110}})));
  TRANSFORM.Fluid.Pipes.GenericPipe_MultiTransferSurface reflR(
    redeclare model HeatTransfer =
        TRANSFORM.Fluid.ClosureRelations.HeatTransfer.Models.DistributedPipe_1D_MultiTransferSurface.Nus_SinglePhase_2Region,
    T_a_start=data_PHX.T_outlet_tube,
    exposeState_b=true,
    p_a_start=data_PHX.p_inlet_tube + 100,
    redeclare package Medium = Medium_PFL,
    use_HeatTransfer=true,
    showName=systemTF.showName,
    nParallel=data_RCTR.nRegions,
    redeclare model Geometry =
        TRANSFORM.Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.StraightPipe
        (
        nV=10,
        angle=toggleStaticHead*90,
        crossArea=data_RCTR.crossArea_reflR,
        perimeter=data_RCTR.perimeter_reflR,
        length=data_RCTR.length_reflR),
    m_flow_a_start=0.05*data_RCTR.m_flow,
    redeclare model InternalTraceMassGen =
        TRANSFORM.Fluid.ClosureRelations.InternalMassGeneration.Models.DistributedVolume_TraceMass_1D.GenericMassGeneration
        (mC_gens=mC_gens_reflR))          annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={20,0})));

  TRANSFORM.HeatAndMassTransfer.DiscritizedModels.Conduction_2D reflRG(
    redeclare package Material = TRANSFORM.Media.Solids.Graphite.Graphite_0,
    exposeState_b2=true,
    exposeState_b1=true,
    T_a1_start=0.5*(data_PHX.T_outlet_tube + data_PHX.T_outlet_tube),
    T_a2_start=data_PHX.T_outlet_tube,
    showName=systemTF.showName,
    nParallel=2*data_RCTR.nRegions*data_RCTR.n_reflR_blockG,
    T_b1_start=0.5*(data_PHX.T_outlet_tube + data_PHX.T_outlet_tube),
    T_b2_start=data_PHX.T_outlet_tube,
    redeclare model Geometry =
        TRANSFORM.HeatAndMassTransfer.ClosureRelations.Geometry.Models.Plane_2D
        (
        nX=5,
        nY=fuelCell.nV,
        length_x=0.5*data_RCTR.width_reflR_blockG,
        length_y=data_RCTR.length_reflR_blockG,
        length_z=data_RCTR.length_reflR)) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={50,0})));
  TRANSFORM.HeatAndMassTransfer.BoundaryConditions.Heat.Adiabatic_multi reflRG_lower_bc(showName=
        systemTF.showName, nPorts=reflRG.geometry.nX) annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=270,
        origin={50,-30})));
  TRANSFORM.HeatAndMassTransfer.BoundaryConditions.Heat.Adiabatic_multi reflRG_centerline_bc(showName=
        systemTF.showName, nPorts=reflR.nV)
    annotation (Placement(transformation(extent={{88,-10},{68,10}})));
  TRANSFORM.HeatAndMassTransfer.BoundaryConditions.Heat.Adiabatic_multi reflRG_upper_bc(showName=
        systemTF.showName, nPorts=reflRG.geometry.nX) annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={50,30})));
  TRANSFORM.Fluid.FittingsAndResistances.SpecifiedResistance resistance_reflR_inlet(
    redeclare package Medium = Medium_PFL,
    R=1,
    showName=systemTF.showName) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={20,-30})));
  TRANSFORM.Fluid.FittingsAndResistances.SpecifiedResistance resistance_reflR_outlet(
    redeclare package Medium = Medium_PFL,
    R=1,
    showName=systemTF.showName) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={20,30})));
algorithm

   mC_flows_fromOG :=zeros(data_traceSubstances.nC);
   for i in 1:data_traceSubstances.nC loop
     for j in 1:nOG loop
       if i == iOG[j] then
         mC_flows_fromOG[i] :=abs(pump_OffGas_bypass.port_b.m_flow) .*pump_OffGas_bypass.port_b.C_outflow[j]
         +abs(pump_OffGas_adsorberBed.port_b.m_flow) .*pump_OffGas_adsorberBed.port_b.C_outflow[j];
       end if;
     end for;
   end for;

equation
  connect(resistance_fuelCell_outlet.port_a, fuelCell.port_b)
    annotation (Line(points={{0,23},{0,10},{4.44089e-16,10}},
                                           color={0,127,255}));
  connect(reflA_upper.port_a, resistance_fuelCell_outlet.port_b)
    annotation (Line(points={{0,50},{0,37}}, color={0,127,255}));
  connect(plenum_lower.port_b[1], reflA_lower.port_a) annotation (Line(points={{
          4.44089e-16,-84},{4.44089e-16,-70},{-6.66134e-16,-70}}, color={0,127,255}));
  connect(reflA_lower.port_b, resistance_fuelCell_inlet.port_a)
    annotation (Line(points={{0,-50},{0,-37}}, color={0,127,255}));
  connect(resistance_fuelCell_inlet.port_b, fuelCell.port_a)
    annotation (Line(points={{0,-23},{0,-10}}, color={0,127,255}));
  connect(reflA_upper.port_b, plenum_upper.port_a[1])
    annotation (Line(points={{0,70},{0,84}}, color={0,127,255}));
  connect(resistance_toPump_PFL.port_a, plenum_upper.port_b[1]) annotation (
      Line(points={{-4.44089e-16,105},{-4.44089e-16,100.5},{3.33067e-16,100.5},{
          3.33067e-16,96}}, color={0,127,255}));
  connect(fuelCellG.port_a1, fuelCell.heatPorts[:, 1])
    annotation (Line(points={{-20,0},{-5,0}}, color={191,0,0}));
  connect(fuelCellG_centerline_bc.port, fuelCellG.port_b1)
    annotation (Line(points={{-48,0},{-40,0}}, color={191,0,0}));
  connect(fuelCellG_lower_bc.port, fuelCellG.port_a2)
    annotation (Line(points={{-30,-20},{-30,-10}}, color={191,0,0}));
  connect(fuelCellG_upper_bc.port, fuelCellG.port_b2)
    annotation (Line(points={{-30,20},{-30,10}}, color={191,0,0}));
  connect(reflA_upperG_lower_bc.port, reflA_upperG.port_a2)
    annotation (Line(points={{-30,40},{-30,50}}, color={191,0,0}));
  connect(reflA_upperG_upper_bc.port, reflA_upperG.port_b2)
    annotation (Line(points={{-30,80},{-30,70}}, color={191,0,0}));
  connect(reflA_upperG.port_a1, reflA_upper.heatPorts[:, 1])
    annotation (Line(points={{-20,60},{-5,60}}, color={191,0,0}));
  connect(reflA_lowerG_lower_bc.port, reflA_lowerG.port_a2)
    annotation (Line(points={{-30,-80},{-30,-70}}, color={191,0,0}));
  connect(reflA_lowerG_upper_bc.port, reflA_lowerG.port_b2)
    annotation (Line(points={{-30,-40},{-30,-50}}, color={191,0,0}));
  connect(reflA_lowerG.port_a1, reflA_lower.heatPorts[:, 1])
    annotation (Line(points={{-20,-60},{-5,-60}}, color={191,0,0}));
  connect(reflA_upperG.port_b1, reflA_upper.heatPorts[:, 2]) annotation (Line(
        points={{-40,60},{-44,60},{-44,64},{-12,64},{-12,60},{-5,60}}, color={191,
          0,0}));
  connect(reflA_lowerG.port_b1, reflA_lower.heatPorts[:, 2]) annotation (Line(
        points={{-40,-60},{-44,-60},{-44,-56},{-12,-56},{-12,-60},{-5,-60}},
        color={191,0,0}));
  connect(plenum_lower.port_a[1], resistance_teeTOplenum.port_b)
    annotation (Line(points={{0,-96},{0,-103}}, color={0,127,255}));
  connect(resistance_teeTOplenum.port_a, tee_inlet.port_b[1])
    annotation (Line(points={{0,-117},{0,-124}}, color={0,127,255}));
  connect(pipeToPHX_PFL.port_b, PHX.port_a_tube)
    annotation (Line(points={{160,60},{160,10}},
                                               color={0,127,255}));
  connect(pump_PFL.port_b, pipeToPHX_PFL.port_a)
    annotation (Line(points={{60,128},{160,128},{160,80}},
                                                         color={0,127,255}));
  connect(pump_PFL.port_a, pumpBowl_PFL.port_b)
    annotation (Line(points={{40,128},{34,128},{34,128},{27,128}},
                                                 color={0,127,255}));
  connect(pumpBowl_PFL.port_a, resistance_toPump_PFL.port_b)
    annotation (Line(points={{13,128},{0,128},{0,119}}, color={0,127,255}));
  connect(pipeFromPHX_PFL.port_a, PHX.port_b_tube)
    annotation (Line(points={{160,-60},{160,-10}},
                                                 color={0,127,255}));
  connect(pipeFromPHX_PFL.port_b, tee_inlet.port_a[1]) annotation (Line(points={{160,-80},
          {160,-140},{-4.44089e-16,-140},{-4.44089e-16,-136}},
                                                 color={0,127,255}));
  connect(PHX.port_b_shell, pipeFromPHX_PCL.port_a) annotation (Line(points={{164.6,
          10},{164,10},{164,40},{180,40}},
                                         color={0,127,255}));
  connect(pipeFromPHX_PCL.port_b, pumpBowl_PCL.port_a)
    annotation (Line(points={{200,40},{213,40}}, color={0,127,255}));
  connect(pumpBowl_PCL.port_b, pump_PCL.port_a)
    annotation (Line(points={{227,40},{240,40}}, color={0,127,255}));
  connect(pump_PCL.port_b, pipeToSHX_PCL.port_a)
    annotation (Line(points={{260,40},{270,40}}, color={0,127,255}));
  connect(pipeToPHX_PCL.port_a, SHX.port_b_shell) annotation (Line(points={{240,-40},
          {295.4,-40},{295.4,-10}},      color={0,127,255}));
  connect(pipeToSHX_PCL.port_b, SHX.port_a_shell) annotation (Line(points={{290,40},
          {295.4,40},{295.4,10}},     color={0,127,255}));
  connect(boundary1.ports[1], SHX.port_b_tube)
    annotation (Line(points={{320,40},{300,40},{300,10}}, color={0,127,255}));
  connect(SHX.port_a_tube, boundary4.ports[1]) annotation (Line(points={{300,-10},
          {300,-40},{320,-40}}, color={0,127,255}));
  connect(pipeToPHX_PCL.port_b, PHX.port_a_shell) annotation (Line(points={{220,-40},
          {164.6,-40},{164.6,-10}},    color={0,127,255}));
  connect(boundary_OffGas_T.y, boundary_OffGas_source.T_in) annotation (Line(
        points={{-329,112},{-312,112}},                       color={0,0,127}));
  connect(boundary_OffGas_m_flow.y, boundary_OffGas_source.m_flow_in)
    annotation (Line(points={{-329,126},{-320,126},{-320,116},{-310,116}},
                                                                         color={
          0,0,127}));
  connect(boundary_thermal_adsorberBed.port, adsorberBed.heatPorts)
    annotation (Line(points={{-220,0},{-220,-15}},color={191,0,0}));
  connect(boundary_thermal_drainTank_gas.port, drainTank_gas.heatPort)
    annotation (Line(points={{-250,0},{-250,-14}},color={191,0,0}));
  connect(drainTank_liquid.port_b, resistance_fromDrainTank.port_a)
    annotation (Line(points={{-243,-60},{-227,-60}}, color={0,127,255}));
  connect(resistance_fromDrainTank.port_b, pump_drainTank.port_a)
    annotation (Line(points={{-213,-60},{-200,-60}}, color={0,127,255}));
  connect(drainTankLevelControl.y, pump_drainTank.in_m_flow) annotation (Line(
        points={{-199.6,-44},{-190,-44},{-190,-52.7}}, color={0,0,127}));
  connect(adsorberBed.port_b, pump_OffGas_adsorberBed.port_a)
    annotation (Line(points={{-210,-20},{-200,-20}},
                                                 color={0,127,255}));
  connect(m_flow_OffGas_bypass.y, pump_OffGas_bypass.in_m_flow) annotation (
      Line(points={{-231,40},{-220,40},{-220,37.3}}, color={0,0,127}));
  connect(m_flow_OffGas_adsorberBed.y, pump_OffGas_adsorberBed.in_m_flow)
    annotation (Line(points={{-185,0},{-190,0},{-190,-12.7}}, color={0,0,127}));
  connect(boundary_OffGas_source.ports[1], traceSeparator.port_a_carrier)
    annotation (Line(points={{-290,108},{-276,108},{-276,100}},        color={0,
          127,255}));
  connect(m_flow_pump_bypass.y, pump_bypass.in_m_flow) annotation (Line(points={{-257,
          126},{-248,126},{-248,119.3}},        color={0,0,127}));
  connect(adsorberBed.port_a, drainTank_gas.port_b[1]) annotation (Line(points={{-230,
          -20},{-238,-20},{-238,-19.5},{-244,-19.5}},       color={0,127,255}));
  connect(pump_bypass.port_b, traceSeparator.port_a) annotation (Line(points={{-258,
          112},{-264,112},{-264,100}}, color={0,127,255}));
  connect(boundary_thermal_drainTank_liquid.port, drainTank_liquid.heatPort)
    annotation (Line(points={{-250,-80},{-250,-62.4}}, color={191,0,0}));
  connect(traceSeparator.port_sepFluid, drainTank_liquid.port_a) annotation (
      Line(points={{-270,80},{-270,-60},{-257,-60}},           color={0,127,255}));
  connect(traceSeparator.port_b_carrier, drainTank_gas.port_a[1]) annotation (
      Line(points={{-276,80},{-276,-20},{-256,-20}}, color={0,127,255}));
  connect(pump_OffGas_bypass.port_a, drainTank_gas.port_b[2]) annotation (Line(
        points={{-230,30},{-238,30},{-238,-20.5},{-244,-20.5}}, color={0,127,255}));
  connect(pump_OffGas_bypass.port_b, boundary_OffGas_sink.ports[1]) annotation (
     Line(points={{-210,30},{-200,30},{-200,32},{-190,32}}, color={0,127,255}));
  connect(pump_OffGas_adsorberBed.port_b, boundary_OffGas_sink.ports[2])
    annotation (Line(points={{-180,-20},{-158,-20},{-158,16},{-198,16},{-198,28},
          {-190,28}}, color={0,127,255}));
  connect(boundary_fromPump_PFL_bypass_p.y, boundary_OffGas_sink.p_in)
    annotation (Line(points={{-163,38},{-168,38}},                     color={0,
          0,127}));
  connect(traceSeparator.port_b, pumpBowl_PFL.port_a) annotation (Line(points={{-264,80},
          {-264,70},{-140,70},{-140,128},{13,128}},
        color={0,127,255}));
  connect(pump_drainTank.port_b, pumpBowl_PFL.port_a) annotation (Line(points={{-180,
          -60},{-140,-60},{-140,128},{13,128}},
                 color={0,127,255}));
  connect(pump_bypass.port_a, pipeToPHX_PFL.port_a) annotation (Line(points={{-238,
          112},{-230,112},{-230,150},{160,150},{160,80}},      color={0,127,255}));
  connect(m_flow_pump_PFL.y, pump_PFL.in_m_flow)
    annotation (Line(points={{55,142},{50,142},{50,135.3}}, color={0,0,127}));
  connect(resistance_reflR_outlet.port_b, reflA_upper.port_a) annotation (Line(
        points={{20,37},{20,46},{0,46},{0,50}}, color={0,127,255}));
  connect(reflR.port_a, resistance_reflR_inlet.port_b)
    annotation (Line(points={{20,-10},{20,-23}}, color={0,127,255}));
  connect(resistance_reflR_inlet.port_a, reflA_lower.port_b) annotation (Line(
        points={{20,-37},{20,-46},{0,-46},{0,-50}}, color={0,127,255}));
  connect(resistance_reflR_outlet.port_a, reflR.port_b)
    annotation (Line(points={{20,23},{20,10}}, color={0,127,255}));
  connect(reflRG.port_a1, reflR.heatPorts[:, 1])
    annotation (Line(points={{40,0},{25,0}}, color={191,0,0}));
  connect(reflRG.port_a2, reflRG_lower_bc.port)
    annotation (Line(points={{50,-10},{50,-20}}, color={191,0,0}));
  connect(reflRG.port_b1, reflRG_centerline_bc.port)
    annotation (Line(points={{60,0},{68,0}}, color={191,0,0}));
  connect(reflRG.port_b2, reflRG_upper_bc.port)
    annotation (Line(points={{50,10},{50,20}}, color={191,0,0}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-360,-150},
            {340,150}})),                                        Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-360,-150},{340,150}})),
    experiment(StopTime=5000, __Dymola_NumberOfIntervals=5000));
end MSR_8;
