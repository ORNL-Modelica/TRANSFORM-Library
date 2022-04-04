within TRANSFORM.HeatAndMassTransfer.DiscritizedModels.ModelicaMethod;
model Conduction_123D
  extends
    TRANSFORM.HeatAndMassTransfer.ClosureRelations.Geometry.ConductionIcons(
      final figure=geometry.figure);
  final parameter Integer nVs[3]=geometry.ns;
  extends
    TRANSFORM.HeatAndMassTransfer.Interfaces.Records.InitialConditions.DistributedVolume_solid3D(
      final ns=nVs);
  extends TRANSFORM.HeatAndMassTransfer.Interfaces.Records.EnergyDynamics;
  replaceable model Geometry =
      TRANSFORM.HeatAndMassTransfer.ClosureRelations.Geometry.Models.Plane_3D
    constrainedby TRANSFORM.HeatAndMassTransfer.ClosureRelations.Geometry.Models.PartialGeometry_3D
    "Geometry" annotation (choicesAllMatching=true);
  Geometry geometry
    annotation (Placement(transformation(extent={{-78,82},{-62,98}})));
  parameter Real nParallel = 1 "Number of parallel components";
  parameter Boolean use_dim1 = true "=false then conduction in dimension-1 is neglected" annotation(choices(checkBox=true));
  parameter Boolean use_dim2 = false "=false then conduction in dimension-2 is neglected" annotation(choices(checkBox=true));
  parameter Boolean use_dim3 = false "=false then conduction in dimension-3 is neglected" annotation(choices(checkBox=true));
  /* Advanced Tab */
  parameter Boolean use_Density = false "=true to use uniform input thermal conductivity" annotation(Dialog(tab="Advanced"));
   input SI.Density d = 1 "Density" annotation (Dialog(group="Inputs",tab="Advanced",enable=use_Density));
  parameter Boolean use_HeatCapacity = false "=true to use uniform input thermal conductivity" annotation(Dialog(tab="Advanced"));
   input SI.SpecificHeatCapacity cp = 1 "Specific heat capacity"
     annotation (Dialog(group="Inputs",tab="Advanced",enable=use_HeatCapacity));
  parameter Boolean use_Lambda = false "=true to use uniform input thermal conductivity" annotation(Dialog(tab="Advanced"));
   input SI.ThermalConductivity lambda = 1 "Thermal conductivity"
      annotation (Dialog(group="Inputs",tab="Advanced",enable=use_Lambda));
  parameter Boolean exposeState_a1=true
    "=true, T is calculated at port_a1 else Q_flow" annotation(Dialog(group="Model Structure",tab="Advanced"),choices(checkBox=true));
  parameter Boolean exposeState_b1=false
    "=true, T is calculated at port_b1 else Q_flow" annotation(Dialog(group="Model Structure",tab="Advanced"),choices(checkBox=true));
  final parameter Integer nFM_1=if exposeState_a1 and exposeState_b1 then nVs[1]
       - 1 else if not exposeState_a1 and not exposeState_b1 then nVs[1] + 1
       else nVs[1] "number of flow models";
  parameter Boolean exposeState_a2=true
    "=true, T is calculated at port_a2 else Q_flow" annotation(Dialog(group="Model Structure",tab="Advanced"),choices(checkBox=true));
  parameter Boolean exposeState_b2=false
    "=true, T is calculated at port_b2 else Q_flow" annotation(Dialog(group="Model Structure",tab="Advanced"),choices(checkBox=true));
  final parameter Integer nFM_2=if exposeState_a2 and exposeState_b2 then nVs[2]
       - 1 else if not exposeState_a2 and not exposeState_b2 then nVs[2] + 1
       else nVs[2] "number of flow models";
  parameter Boolean exposeState_a3=true
    "=true, T is calculated at port_a3 else Q_flow" annotation(Dialog(group="Model Structure",tab="Advanced"),choices(checkBox=true));
  parameter Boolean exposeState_b3=false
    "=true, T is calculated at port_b3 else Q_flow" annotation(Dialog(group="Model Structure",tab="Advanced"),choices(checkBox=true));
  final parameter Integer nFM_3=if exposeState_a3 and exposeState_b3 then nVs[3]
       - 1 else if not exposeState_a3 and not exposeState_b3 then nVs[3] + 1
       else nVs[3] "number of flow models";
  Volumes.UnitVolume                      unitCell[nVs[1],nVs[2],nVs[3]](
    T_start=Ts_start,
    each energyDynamics=energyDynamics,
    d=if use_Density then fill(
        d,
        nVs[1],
        nVs[2],
        nVs[3]) else Material.density_T(unitCell.T),
    cp=if use_HeatCapacity then fill(
        cp,
        nVs[1],
        nVs[2],
        nVs[3]) else Material.specificHeatCapacityCp_T(unitCell.T),
    V=geometry.Vs,
    Q_gen=nFlow_Q_gen.port_n)
    annotation (Placement(transformation(extent={{-10,-30},{10,-10}})));
  Modelica.Blocks.Interfaces.RealInput Q_gen[nVs[1],nVs[2],nVs[3]](unit="W")
    annotation (Placement(transformation(extent={{-120,40},{-100,60}}),
        iconTransformation(extent={{-120,40},{-100,60}})));
  Resistances.Heat.Plane                           conductor_1[nFM_1,nVs[2],nVs[
    3]](lambda=if use_Lambda then fill(
        lambda,
        nFM_1,
        nVs[2],
        nVs[3]) else Material.thermalConductivity_T(0.5*(conductor_1.port_a.T +
        conductor_1.port_b.T)),
    L=lengths_1FM,
    crossArea=crossAreas_1FM)
 if use_dim1 annotation (Placement(transformation(extent={{-40,10},{-20,30}})));
  Resistances.Heat.Plane                           conductor_2[nVs[1],nFM_2,nVs[
    3]](lambda=if use_Lambda then fill(
        lambda,
        nVs[1],
        nFM_2,
        nVs[3]) else Material.thermalConductivity_T(0.5*(conductor_2.port_a.T +
        conductor_2.port_b.T)),
    L=lengths_2FM,
    crossArea=crossAreas_2FM)
 if use_dim2 annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,20})));
  Resistances.Heat.Plane                           conductor_3[nVs[1],nVs[2],
    nFM_3](lambda=if use_Lambda then fill(
        lambda,
        nVs[1],
        nVs[2],
        nFM_3) else Material.thermalConductivity_T(0.5*(conductor_3.port_a.T +
        conductor_3.port_b.T)),
    L=lengths_3FM,
    crossArea=crossAreas_3FM)
 if use_dim3 annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=45,
        origin={30,20})));
  Interfaces.HeatPort_Flow port_a1[nVs[2],nVs[3]] if use_dim1 annotation (Placement(
        transformation(extent={{-110,-10},{-90,10}}), iconTransformation(extent=
           {{-110,-10},{-90,10}})));
  TRANSFORM.HeatAndMassTransfer.Interfaces.HeatPort_State port_b1[nVs[2],nVs[3]]
        if use_dim1 annotation (Placement(transformation(extent={{90,-10},{110,
            10}}), iconTransformation(extent={{90,-10},{110,10}})));
  Interfaces.HeatPort_Flow port_a2[nVs[1],nVs[3]] if use_dim2
    annotation (Placement(transformation(extent={{-10,-110},{10,-90}}),
        iconTransformation(extent={{-10,-110},{10,-90}})));
  TRANSFORM.HeatAndMassTransfer.Interfaces.HeatPort_State port_b2[nVs[1],nVs[3]]
        if use_dim2 annotation (Placement(transformation(extent={{-10,90},{10,
            110}}), iconTransformation(extent={{-10,90},{10,110}})));
  Interfaces.HeatPort_Flow port_a3[nVs[1],nVs[2]] if use_dim3
    annotation (Placement(transformation(extent={{-90,-90},{-70,-70}}),
        iconTransformation(extent={{-90,-90},{-70,-70}})));
  TRANSFORM.HeatAndMassTransfer.Interfaces.HeatPort_State port_b3[nVs[1],nVs[2]]
        if use_dim3 annotation (Placement(transformation(extent={{70,70},{90,90}}),
        iconTransformation(extent={{70,70},{90,90}})));
  BoundaryConditions.Parallel_Real nFlow_Q_gen[nVs[1],nVs[2],nVs[3]](each
      nParallel=nParallel)
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
  BoundaryConditions.Heat.ParallelFlow nFlow_a1[nVs[2],nVs[3]](each nParallel=
        nParallel)                                                       if use_dim1
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  BoundaryConditions.Heat.ParallelFlow nFlow_b1[nVs[2],nVs[3]](each nParallel=
        nParallel)                                                       if use_dim1
    annotation (Placement(transformation(extent={{80,-10},{60,10}})));
  BoundaryConditions.Heat.ParallelFlow nFlow_a2[nVs[1],nVs[3]](each nParallel=
        nParallel)                                                       if use_dim2
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,-70})));
  BoundaryConditions.Heat.ParallelFlow nFlow_b2[nVs[1],nVs[3]](each nParallel=
        nParallel)                                                       if use_dim2
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={0,70})));
  BoundaryConditions.Heat.ParallelFlow nFlow_a3[nVs[1],nVs[2]](each nParallel=
        nParallel)                                                       if use_dim3
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=45,
        origin={-60,-60})));
  BoundaryConditions.Heat.ParallelFlow nFlow_b3[nVs[1],nVs[2]](each nParallel=
        nParallel)                                                       if use_dim3
    annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=45,
        origin={60,62})));
protected
  Modelica.Blocks.Interfaces.RealOutput crossAreas_1FM[nFM_1,nVs[2],nVs[3]];
  Modelica.Blocks.Interfaces.RealOutput lengths_1FM[nFM_1,nVs[2],nVs[3]];
  Modelica.Blocks.Interfaces.RealOutput crossAreas_2FM[nVs[1],nFM_2,nVs[3]];
  Modelica.Blocks.Interfaces.RealOutput lengths_2FM[nVs[1],nFM_2,nVs[3]];
  Modelica.Blocks.Interfaces.RealOutput crossAreas_3FM[nVs[1],nVs[2],nFM_3];
  Modelica.Blocks.Interfaces.RealOutput lengths_3FM[nVs[1],nVs[2],nFM_3];
equation
  // Dimension-1 Section
  if exposeState_a1 and exposeState_b1 then
    assert(nVs[1] > 1, "nVs[1] must be > 1 if exposeState_a1 and exposeState_b1 = true");
  end if;
  for j in 1:nVs[2] loop
    for k in 1:nVs[3] loop
      if exposeState_a1 and exposeState_b1 then
        //nFM = nV-1
        // Connections
        connect(nFlow_a1[j,k].port_n, unitCell[1, j, k].port);
        for i in 1:nFM_1 loop
          connect(unitCell[i, j, k].port, conductor_1[i, j, k].port_a);
        end for;
        for i in 1:nFM_1 loop
          connect(conductor_1[i, j, k].port_b, unitCell[i + 1, j, k].port);
        end for;
        connect(unitCell[nFM_1 + 1, j, k].port, nFlow_b1[j,k].port_n);
        // Variables
        for i in 1:nFM_1 loop
          crossAreas_1FM[i, j, k] = geometry.crossAreas_1[i + 1, j, k];
        end for;
        if nFM_1 == 1 then
          lengths_1FM[1, j, k] = geometry.dlengths_1[1, j, k] + geometry.dlengths_1
            [2, j, k];
        else
          lengths_1FM[1, j, k] = geometry.dlengths_1[1, j, k] + 0.5*
            geometry.dlengths_1[2, j, k];
          for i in 2:nFM_1 - 1 loop
            lengths_1FM[i, j, k] = 0.5*(geometry.dlengths_1[i, j, k] +
              geometry.dlengths_1[i + 1, j, k]);
          end for;
          lengths_1FM[nFM_1, j, k] = 0.5*geometry.dlengths_1[nFM_1, j, k]
             + geometry.dlengths_1[nFM_1 + 1, j, k];
        end if;
      elseif exposeState_a1 and not exposeState_b1 then
        //nFM = nV
        // Connections
        connect(nFlow_a1[j,k].port_n, unitCell[1, j, k].port);
        for i in 1:nFM_1 loop
          connect(unitCell[i, j, k].port, conductor_1[i, j, k].port_a);
        end for;
        for i in 1:nFM_1-1 loop
          connect(conductor_1[i, j, k].port_b, unitCell[i + 1, j, k].port);
        end for;
        connect(conductor_1[nFM_1, j, k].port_b, nFlow_b1[j,k].port_n);
        // Variables
        for i in 1:nFM_1 loop
          crossAreas_1FM[i, j, k] = geometry.crossAreas_1[i + 1, j, k];
        end for;
        if nFM_1 == 1 then
          lengths_1FM[1, j, k] = geometry.dlengths_1[1, j, k];
        else
          lengths_1FM[1, j, k] = geometry.dlengths_1[1, j, k] + 0.5*
            geometry.dlengths_1[2, j, k];
          for i in 2:nFM_1 - 1 loop
            lengths_1FM[i, j, k] = 0.5*(geometry.dlengths_1[i, j, k] +
              geometry.dlengths_1[i + 1, j, k]);
          end for;
          lengths_1FM[nFM_1, j, k] = 0.5*geometry.dlengths_1[nFM_1, j, k];
        end if;
      elseif not exposeState_a1 and exposeState_b1 then
        //nFM = nV
        // Connections
        connect(nFlow_a1[j,k].port_n, conductor_1[1, j, k].port_a);
        for i in 1:nFM_1-1 loop
          connect(unitCell[i, j, k].port, conductor_1[i + 1, j, k].port_a);
        end for;
        for i in 1:nFM_1 loop
          connect(conductor_1[i, j, k].port_b, unitCell[i, j, k].port);
        end for;
        connect(unitCell[nFM_1, j, k].port, nFlow_b1[j,k].port_n);
        // Variables
        for i in 1:nFM_1 loop
          crossAreas_1FM[i, j, k] = geometry.crossAreas_1[i, j, k];
        end for;
        if nFM_1 == 1 then
          lengths_1FM[1, j, k] = geometry.dlengths_1[1, j, k];
        else
          lengths_1FM[1, j, k] = 0.5*geometry.dlengths_1[1, j, k];
          for i in 2:nFM_1 - 1 loop
            lengths_1FM[i, j, k] = 0.5*(geometry.dlengths_1[i - 1, j, k] +
              geometry.dlengths_1[i, j, k]);
          end for;
          lengths_1FM[nFM_1, j, k] = 0.5*geometry.dlengths_1[nFM_1 - 1,
            j, k] + geometry.dlengths_1[nFM_1, j, k];
        end if;
      elseif not exposeState_a1 and not exposeState_b1 then
        //nFM = nV+1;
        // Connections
        connect(nFlow_a1[j,k].port_n, conductor_1[1, j, k].port_a);
        for i in 1:nFM_1-1 loop
          connect(unitCell[i, j, k].port, conductor_1[i + 1, j, k].port_a);
        end for;
        for i in 1:nFM_1-1 loop
          connect(conductor_1[i, j, k].port_b, unitCell[i, j, k].port);
        end for;
        connect(conductor_1[nFM_1, j, k].port_b, nFlow_b1[j,k].port_n);
        // Variables
        for i in 1:nFM_1 loop
          crossAreas_1FM[i, j, k] = geometry.crossAreas_1[i, j, k];
        end for;
        lengths_1FM[1, j, k] = 0.5*geometry.dlengths_1[1, j, k];
        for i in 2:nFM_1 - 1 loop
          lengths_1FM[i, j, k] = 0.5*(geometry.dlengths_1[i - 1, j, k] +
            geometry.dlengths_1[i, j, k]);
        end for;
        lengths_1FM[nFM_1, j, k] = 0.5*geometry.dlengths_1[nFM_1 - 1, j,
          k];
      else
        assert(false, "Unknown model structure");
      end if;
    end for;
  end for;
   // Dimension-2 Section
  if exposeState_a2 and exposeState_b2 then
    assert(nVs[2] > 1, "nVs[2] must be > 1 if exposeState_a2 and exposeState_b2 = true");
  end if;
  for i in 1:nVs[1] loop
    for k in 1:nVs[3] loop
      if exposeState_a2 and exposeState_b2 then
        //nFM = nV-1
        // Connections
        connect(nFlow_a2[i,k].port_n, unitCell[i, 1, k].port);
        for j in 1:nFM_2 loop
          connect(unitCell[i, j, k].port, conductor_2[i, j, k].port_a);
        end for;
        for j in 1:nFM_2 loop
          connect(conductor_2[i, j, k].port_b, unitCell[i, j+1, k].port);
        end for;
        connect(unitCell[i, nFM_2+1, k].port, nFlow_b2[i,k].port_n);
        // Variables
        for j in 1:nFM_2 loop
          crossAreas_2FM[i, j, k] = geometry.crossAreas_2[i, j+1, k];
        end for;
        if nFM_2 == 1 then
          lengths_2FM[i, 1, k] = geometry.dlengths_2[i, 1, k] + geometry.dlengths_2
            [i, 2, k];
        else
          lengths_2FM[i, 1, k] = geometry.dlengths_2[i, 1, k] + 0.5*
            geometry.dlengths_2[i, 2, k];
          for j in 2:nFM_2 - 1 loop
            lengths_2FM[i, j, k] = 0.5*(geometry.dlengths_2[i, j, k] +
              geometry.dlengths_2[i, j+1, k]);
          end for;
          lengths_2FM[i, nFM_2, k] = 0.5*geometry.dlengths_2[i, nFM_2, k]
             + geometry.dlengths_2[i, nFM_2 + 1, k];
        end if;
      elseif exposeState_a2 and not exposeState_b2 then
        //nFM = nV
        // Connections
        connect(nFlow_a2[i,k].port_n, unitCell[i, 1, k].port);
        for j in 1:nFM_2 loop
          connect(unitCell[i, j, k].port, conductor_2[i, j, k].port_a);
        end for;
        for j in 1:nFM_2-1 loop
          connect(conductor_2[i, j, k].port_b, unitCell[i, j+1, k].port);
        end for;
        connect(conductor_2[i, nFM_2, k].port_b, nFlow_b2[i,k].port_n);
        // Variables
        for j in 1:nFM_2 loop
          crossAreas_2FM[i, j, k] = geometry.crossAreas_2[i, j+1, k];
        end for;
        if nFM_2 == 1 then
          lengths_2FM[i, 1, k] = geometry.dlengths_2[i, 1, k];
        else
          lengths_2FM[i, 1, k] = geometry.dlengths_2[i, 1, k] + 0.5*
            geometry.dlengths_2[i, 2, k];
          for j in 2:nFM_2 - 1 loop
            lengths_2FM[i, j, k] = 0.5*(geometry.dlengths_2[i, j, k] +
              geometry.dlengths_2[i, j+1, k]);
          end for;
          lengths_2FM[i, nFM_2, k] = 0.5*geometry.dlengths_2[i, nFM_2, k];
        end if;
      elseif not exposeState_a2 and exposeState_b2 then
        //nFM = nV
        // Connections
        connect(nFlow_a2[i,k].port_n, conductor_2[i, 1, k].port_a);
        for j in 1:nFM_2-1 loop
          connect(unitCell[i, j, k].port, conductor_2[i, j+1, k].port_a);
        end for;
        for j in 1:nFM_2 loop
          connect(conductor_2[i, j, k].port_b, unitCell[i, j, k].port);
        end for;
        connect(unitCell[i, nFM_2, k].port, nFlow_b2[i,k].port_n);
        // Variables
        for j in 1:nFM_2 loop
          crossAreas_2FM[i, j, k] = geometry.crossAreas_2[i, j, k];
        end for;
        if nFM_2 == 1 then
          lengths_2FM[i, 1, k] = geometry.dlengths_2[i, 1, k];
        else
          lengths_2FM[i, 1, k] = 0.5*geometry.dlengths_2[i, 1, k];
          for j in 2:nFM_2 - 1 loop
            lengths_2FM[i, j, k] = 0.5*(geometry.dlengths_2[i, j-1, k] +
              geometry.dlengths_2[i, j, k]);
          end for;
          lengths_2FM[i, nFM_2, k] = 0.5*geometry.dlengths_2[i,
            nFM_2 - 1, k] + geometry.dlengths_2[i, nFM_2, k];
        end if;
      elseif not exposeState_a2 and not exposeState_b2 then
        //nFM = nV+1;
        // Connections
        connect(nFlow_a2[i,k].port_n, conductor_2[i, 1, k].port_a);
        for j in 1:nFM_2-1 loop
          connect(unitCell[i, j, k].port, conductor_2[i, j+1, k].port_a);
        end for;
        for j in 1:nFM_2-1 loop
          connect(conductor_2[i, j, k].port_b, unitCell[i, j, k].port);
        end for;
        connect(conductor_2[i, nFM_2, k].port_b, nFlow_b2[i,k].port_n);
        // Variables
        for j in 1:nFM_2 loop
          crossAreas_2FM[i, j, k] = geometry.crossAreas_2[i, j, k];
        end for;
        lengths_2FM[i, 1, k] = 0.5*geometry.dlengths_2[i, 1, k];
        for j in 2:nFM_2 - 1 loop
          lengths_2FM[i, j, k] = 0.5*(geometry.dlengths_2[i, j-1, k] +
            geometry.dlengths_2[i, j, k]);
        end for;
        lengths_2FM[i, nFM_2, k] = 0.5*geometry.dlengths_2[i, nFM_2 - 1,
          k];
      else
        assert(false, "Unknown model structure");
      end if;
    end for;
  end for;
   // Dimension-3 Section
  if exposeState_a3 and exposeState_b3 then
    assert(nVs[3] > 1, "nVs[3] must be > 1 if exposeState_a3 and exposeState_b3 = true");
  end if;
  for i in 1:nVs[1] loop
    for j in 1:nVs[2] loop
      if exposeState_a3 and exposeState_b3 then
        //nFM = nV-1
        // Connections
        connect(nFlow_a3[i,j].port_n, unitCell[i, j, 1].port);
        for k in 1:nFM_3 loop
          connect(unitCell[i, j, k].port, conductor_3[i, j, k].port_a);
        end for;
        for k in 1:nFM_3 loop
          connect(conductor_3[i, j, k].port_b, unitCell[i, j, k+1].port);
        end for;
        connect(unitCell[i, j, nFM_3+1].port, nFlow_b3[i,j].port_n);
        // Variables
        for k in 1:nFM_3 loop
          crossAreas_3FM[i, j, k] = geometry.crossAreas_3[i, j, k+1];
        end for;
        if nFM_3 == 1 then
          lengths_3FM[i, j, 1] = geometry.dlengths_3[i, j, 1] + geometry.dlengths_3
            [i, j, 2];
        else
          lengths_3FM[i, j, 1] = geometry.dlengths_3[i, j, 1] + 0.5*
            geometry.dlengths_3[i, j, 2];
          for k in 2:nFM_3 - 1 loop
            lengths_3FM[i, j, k] = 0.5*(geometry.dlengths_3[i, j, k] +
              geometry.dlengths_3[i, j, k+1]);
          end for;
          lengths_3FM[i, j, nFM_3] = 0.5*geometry.dlengths_3[i, j, nFM_3]
             + geometry.dlengths_3[i, j, nFM_3 + 1];
        end if;
      elseif exposeState_a3 and not exposeState_b3 then
        //nFM = nV
        // Connections
        connect(nFlow_a3[i,j].port_n, unitCell[i, j, 1].port);
        for k in 1:nFM_3 loop
          connect(unitCell[i, j, k].port, conductor_3[i, j, k].port_a);
        end for;
        for k in 1:nFM_3-1 loop
          connect(conductor_3[i, j, k].port_b, unitCell[i, j, k+1].port);
        end for;
        connect(conductor_3[i, j, nFM_3].port_b, nFlow_b3[i,j].port_n);
        // Variables
        for k in 1:nFM_3 loop
          crossAreas_3FM[i, j, k] = geometry.crossAreas_3[i, j, k+1];
        end for;
        if nFM_3 == 1 then
          lengths_3FM[i, j, 1] = geometry.dlengths_3[i, j, 1];
        else
          lengths_3FM[i, j, 1] = geometry.dlengths_3[i, j, 1] + 0.5*
            geometry.dlengths_3[i, j, 2];
          for k in 2:nFM_3 - 1 loop
            lengths_3FM[i, j, k] = 0.5*(geometry.dlengths_3[i, j, k] +
              geometry.dlengths_3[i, j, k+1]);
          end for;
          lengths_3FM[i, j, nFM_3] = 0.5*geometry.dlengths_3[i, j, nFM_3];
        end if;
      elseif not exposeState_a3 and exposeState_b3 then
        //nFM = nV
        // Connections
        connect(nFlow_a3[i,j].port_n, conductor_3[i, j, 1].port_a);
        for k in 1:nFM_3-1 loop
          connect(unitCell[i, j, k].port, conductor_3[i, j, k+1].port_a);
        end for;
        for k in 1:nFM_3 loop
          connect(conductor_3[i, j, k].port_b, unitCell[i, j, k].port);
        end for;
        connect(unitCell[i, j, nFM_3].port, nFlow_b3[i,j].port_n);
        // Variables
        for k in 1:nFM_3 loop
          crossAreas_3FM[i, j, k] = geometry.crossAreas_3[i, j, k];
        end for;
        if nFM_3 == 1 then
          lengths_3FM[i, j, 1] = geometry.dlengths_3[i, j, 1];
        else
          lengths_3FM[i, j, 1] = 0.5*geometry.dlengths_3[i, j, 1];
          for k in 2:nFM_3 - 1 loop
            lengths_3FM[i, j, k] = 0.5*(geometry.dlengths_3[i, j, k-1] +
              geometry.dlengths_3[i, j, k]);
          end for;
          lengths_3FM[i, j, nFM_3] = 0.5*geometry.dlengths_3[i,
            j, nFM_3 - 1] + geometry.dlengths_3[i, j, nFM_3];
        end if;
      elseif not exposeState_a3 and not exposeState_b3 then
        //nFM = nV+1;
        // Connections
        connect(nFlow_a3[i,j].port_n, conductor_3[i, j, 1].port_a);
        for k in 1:nFM_3-1 loop
          connect(unitCell[i, j, k].port, conductor_3[i, j, k+1].port_a);
        end for;
        for k in 1:nFM_3-1 loop
          connect(conductor_3[i, j, k].port_b, unitCell[i, j, k].port);
        end for;
        connect(conductor_3[i, j, nFM_3].port_b, nFlow_b3[i,j].port_n);
        // Variables
        for k in 1:nFM_3 loop
          crossAreas_3FM[i, j, k] = geometry.crossAreas_3[i, j, k];
        end for;
        lengths_3FM[i, j, 1] = 0.5*geometry.dlengths_3[i, j, 1];
        for k in 2:nFM_3 - 1 loop
          lengths_3FM[i, j, k] = 0.5*(geometry.dlengths_3[i, j, k-1] +
            geometry.dlengths_3[i, j, k]);
        end for;
        lengths_3FM[i, j, nFM_3] = 0.5*geometry.dlengths_3[i, j,
          nFM_3 - 1];
      else
        assert(false, "Unknown model structure");
      end if;
    end for;
  end for;
  connect(port_a1, nFlow_a1.port_1)
    annotation (Line(points={{-100,0},{-80,0}},         color={191,0,0}));
  connect(port_b1, nFlow_b1.port_1)
    annotation (Line(points={{100,0},{80,0},{80,0}}, color={191,0,0}));
  connect(port_a2, nFlow_a2.port_1)
    annotation (Line(points={{0,-100},{0,-100},{0,-80}}, color={191,0,0}));
  connect(port_b2, nFlow_b2.port_1)
    annotation (Line(points={{0,100},{0,100},{0,80}}, color={191,0,0}));
  connect(Q_gen, nFlow_Q_gen.port_1)
    annotation (Line(points={{-110,50},{-95,50},{-80,50}}, color={0,0,127}));
  connect(port_a3, nFlow_a3.port_1) annotation (Line(points={{-80,-80},{
          -67.0711,-80},{-67.0711,-67.0711}},
                                     color={191,0,0}));
  connect(port_b3, nFlow_b3.port_1) annotation (Line(points={{80,80},{67.0711,
          80},{67.0711,69.0711}},
                              color={191,0,0}));
  annotation (defaultComponentName="wall",
        Icon(coordinateSystem(preserveAspectRatio=false),
          graphics={
            Ellipse(
            extent={{-92,30},{-108,-30}},
            lineColor={215,215,215},
            fillColor={0,0,0},
            fillPattern=FillPattern.Forward,
            visible=exposeState_a1 and use_dim1),
            Ellipse(
            extent={{108,28},{92,-32}},
            lineColor={215,215,215},
            fillColor={0,0,0},
            fillPattern=FillPattern.Forward,
            visible=exposeState_b1 and use_dim1),
        Ellipse(
          extent={{-30,-92},{30,-108}},
          lineColor={215,215,215},
          fillColor={0,0,0},
          fillPattern=FillPattern.Forward,
          visible=exposeState_a2 and use_dim2),
        Ellipse(
          extent={{-30,108},{30,92}},
          lineColor={215,215,215},
          fillColor={0,0,0},
          fillPattern=FillPattern.Forward,
          visible=exposeState_b2 and use_dim2),
        Ellipse(
          extent={{8.94975,29.8492},{-8.94975,-29.8492}},
          lineColor={215,215,215},
          fillColor={0,0,0},
          fillPattern=FillPattern.Backward,
          origin={-79.2218,-79.435},
          rotation=45,
          visible=exposeState_a3 and use_dim3),
            Ellipse(
          extent={{8.94971,29.8492},{-8.94971,-29.8492}},
          lineColor={215,215,215},
          fillColor={0,0,0},
          fillPattern=FillPattern.Backward,
          origin={79.2218,79.435},
          rotation=45,
          visible=exposeState_b3 and use_dim3)}),
          Diagram(coordinateSystem(
            preserveAspectRatio=false)));
end Conduction_123D;
