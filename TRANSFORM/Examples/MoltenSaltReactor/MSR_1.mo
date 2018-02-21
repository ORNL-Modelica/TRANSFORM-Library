within TRANSFORM.Examples.MoltenSaltReactor;
model MSR_1

  package Medium_PFL =
      TRANSFORM.Media.Fluids.FLiBe.LinearFLiBe_12Th_05U_pT                  "Primary fuel loop medium";
  package Medium_PCL = TRANSFORM.Media.Fluids.FLiBe.LinearFLiBe_pT "Primary coolant loop medium";

  Data.data_PHX data_PHX
    annotation (Placement(transformation(extent={{-122,122},{-102,142}})));
  Data.data_RCTR data_RCTR
    annotation (Placement(transformation(extent={{-142,122},{-122,142}})));
  Data.data_PUMP data_PUMP
    annotation (Placement(transformation(extent={{-142,102},{-122,122}})));
  Data.data_SHX data_SHX
    annotation (Placement(transformation(extent={{-102,122},{-82,142}})));
  Data.data_PIPING data_PIPING
    annotation (Placement(transformation(extent={{-122,102},{-102,122}})));
  Fluid.Pipes.GenericPipe_MultiTransferSurface fuelCell(
    nParallel=data_RCTR.nFcells,
    redeclare model Geometry =
        TRANSFORM.Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.StraightPipe
        (
        crossArea=data_RCTR.crossArea_f,
        perimeter=data_RCTR.perimeter_f,
        length=data_RCTR.length_cells,
        angle=1.5707963267949,
        nV=10),
    redeclare model HeatTransfer =
        Fluid.ClosureRelations.HeatTransfer.Models.DistributedPipe_1D_MultiTransferSurface.Nus_SinglePhase_2Region,
    T_a_start=data_PHX.T_outlet_tube,
    T_b_start=data_PHX.T_inlet_tube,
    exposeState_b=true,
    p_a_start=data_PHX.p_inlet_tube + 100,
    m_flow_a_start=data_RCTR.m_flow,
    redeclare package Medium = Medium_PFL,
    use_HeatTransfer=true)           annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,0})));

  Fluid.BoundaryConditions.Boundary_pT boundary(
    p=data_PHX.p_inlet_tube,
    T=data_PHX.T_inlet_tube,
    nPorts=1,
    redeclare package Medium = Medium_PFL)
                             annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={48,124})));
  Fluid.BoundaryConditions.MassFlowSource_T boundary1(
    T=data_PHX.T_inlet_tube,
    m_flow=data_RCTR.m_flow,
    nPorts=1,
    redeclare package Medium = Medium_PFL)
                              annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={82,-124})));
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
        angle=1.5707963267949))
               annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,60})));

  Fluid.Volumes.MixingVolume plenum_upper(
    redeclare model Geometry =
        Fluid.ClosureRelations.Geometry.Models.LumpedVolume.Cylinder (
        length=data_RCTR.length_plenum,
        crossArea=data_RCTR.crossArea_plenum,
        angle=1.5707963267949),
    p_start=data_PHX.p_inlet_tube,
    T_start=data_PHX.T_inlet_tube,
    nPorts_b=1,
    nPorts_a=1,
    redeclare package Medium = Medium_PFL) annotation (Placement(transformation(
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
        angle=1.5707963267949,
        nSurfaces=2))    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,-60})));

  Fluid.FittingsAndResistances.SpecifiedResistance resistance_fuelCell_outlet(R=
       1, redeclare package Medium = Medium_PFL)
          annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,30})));
  Fluid.Volumes.MixingVolume plenum_lower(
    p_start=data_PHX.p_inlet_tube,
    T_start=data_PHX.T_inlet_tube,
    nPorts_a=1,
    nPorts_b=1,
    redeclare package Medium = Medium_PFL,
    redeclare model Geometry =
        Fluid.ClosureRelations.Geometry.Models.LumpedVolume.Cylinder (
        length=data_RCTR.length_plenum,
        crossArea=data_RCTR.crossArea_plenum,
        angle=1.5707963267949)) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,-90})));
  Fluid.FittingsAndResistances.SpecifiedResistance resistance_fuelCell_inlet(R=1,
      redeclare package Medium = Medium_PFL)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,-30})));
  Fluid.FittingsAndResistances.SpecifiedResistance resistance_fuelCell_inlet1(R=1,
      redeclare package Medium = Medium_PFL)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,112})));
  HeatAndMassTransfer.DiscritizedModels.Conduction_2D fuelCellG(
    redeclare package Material = Media.Solids.Graphite.Graphite_0,
    T_a1_start=data_PHX.T_outlet_tube,
    T_b1_start=data_PHX.T_outlet_tube,
    T_a2_start=data_PHX.T_inlet_tube,
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
    exposeState_b1=true) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={-30,0})));
  HeatAndMassTransfer.BoundaryConditions.Heat.Adiabatic_multi
    fuelCellG_centerline_bc(nPorts=fuelCell.nV)
    annotation (Placement(transformation(extent={{-68,-10},{-48,10}})));
  HeatAndMassTransfer.BoundaryConditions.Heat.Adiabatic_multi
    fuelCellG_upper_bc(nPorts=fuelCellG.geometry.nX) annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-30,30})));
  HeatAndMassTransfer.BoundaryConditions.Heat.Adiabatic_multi
    fuelCellG_lower_bc(nPorts=fuelCellG.geometry.nX) annotation (Placement(
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
        angle_theta=0.5235987755983)) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={-30,60})));
  HeatAndMassTransfer.BoundaryConditions.Heat.Adiabatic_multi
    reflA_upperG_upper_bc(nPorts=reflA_upperG.geometry.nR) annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-30,90})));
  HeatAndMassTransfer.BoundaryConditions.Heat.Adiabatic_multi
    reflA_upperG_lower_bc(nPorts=reflA_upperG.geometry.nR) annotation (
      Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=270,
        origin={-30,30})));
  HeatAndMassTransfer.DiscritizedModels.Conduction_2D reflA_lowerG(
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
        r_inner=data_RCTR.rs_ring_edge_inner[6],
        r_outer=data_RCTR.rs_ring_edge_outer[6],
        length_z=data_RCTR.length_reflA,
        nZ=reflA_lower.nV,
        angle_theta=0.5235987755983)) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={-30,-60})));
  HeatAndMassTransfer.BoundaryConditions.Heat.Adiabatic_multi
    reflA_lowerG_upper_bc(nPorts=reflA_lowerG.geometry.nR) annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-30,-30})));
  HeatAndMassTransfer.BoundaryConditions.Heat.Adiabatic_multi
    reflA_lowerG_lower_bc(nPorts=reflA_lowerG.geometry.nR) annotation (
      Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=270,
        origin={-30,-90})));
  Nuclear.ReactorKinetics.PointKinetics_Drift kinetics
    annotation (Placement(transformation(extent={{-124,-10},{-104,10}})));
equation
  connect(resistance_fuelCell_outlet.port_a, fuelCell.port_b)
    annotation (Line(points={{0,23},{0,10},{4.44089e-16,10}},
                                           color={0,127,255}));
  connect(reflA_upper.port_a, resistance_fuelCell_outlet.port_b)
    annotation (Line(points={{0,50},{0,37}}, color={0,127,255}));
  connect(boundary1.ports[1], plenum_lower.port_a[1]) annotation (Line(points={
          {72,-124},{-4.44089e-16,-124},{-4.44089e-16,-96}}, color={0,127,255}));
  connect(plenum_lower.port_b[1], reflA_lower.port_a) annotation (Line(points={
          {4.44089e-16,-84},{4.44089e-16,-70},{-6.66134e-16,-70}}, color={0,127,
          255}));
  connect(reflA_lower.port_b, resistance_fuelCell_inlet.port_a)
    annotation (Line(points={{0,-50},{0,-37}}, color={0,127,255}));
  connect(resistance_fuelCell_inlet.port_b, fuelCell.port_a)
    annotation (Line(points={{0,-23},{0,-10}}, color={0,127,255}));
  connect(reflA_upper.port_b, plenum_upper.port_a[1])
    annotation (Line(points={{0,70},{0,84}}, color={0,127,255}));
  connect(boundary.ports[1], resistance_fuelCell_inlet1.port_b) annotation (
      Line(points={{38,124},{0,124},{4.44089e-16,119}}, color={0,127,255}));
  connect(resistance_fuelCell_inlet1.port_a, plenum_upper.port_b[1])
    annotation (Line(points={{-4.44089e-16,105},{-4.44089e-16,100.5},{0,100.5},
          {0,96}}, color={0,127,255}));
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
        points={{-40,60},{-44,60},{-44,64},{-12,64},{-12,60},{-5,60}}, color={
          191,0,0}));
  connect(reflA_lowerG.port_b1, reflA_lower.heatPorts[:, 2]) annotation (Line(
        points={{-40,-60},{-44,-60},{-44,-56},{-12,-56},{-12,-60},{-5,-60}},
        color={191,0,0}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}})),                                        Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-150,-150},{150,150}})),
    experiment(StopTime=5000, __Dymola_NumberOfIntervals=5000));
end MSR_1;
