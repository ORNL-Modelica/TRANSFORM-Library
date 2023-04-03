within TRANSFORM.HeatAndMassTransfer.DiscritizedModels.ModelicaMethod;
model Conduction_1D
  extends TRANSFORM.HeatAndMassTransfer.ClosureRelations.Geometry.ConductionIcons(
      final figure=geometry.figure);
  final parameter Integer nVs[1]=geometry.ns;
  extends TRANSFORM.HeatAndMassTransfer.Interfaces.Records.InitialConditions.DistributedVolume_solid1D(
      final ns=nVs);
  extends TRANSFORM.HeatAndMassTransfer.Interfaces.Records.EnergyDynamics;
  replaceable model Geometry =
      TRANSFORM.HeatAndMassTransfer.ClosureRelations.Geometry.Models.Plane_1D
    constrainedby TRANSFORM.HeatAndMassTransfer.ClosureRelations.Geometry.Models.PartialGeometry_1D
    "Geometry" annotation (choicesAllMatching=true);
  Geometry geometry
    annotation (Placement(transformation(extent={{-78,82},{-62,98}})));
  parameter Real nParallel = 1 "Number of parallel components";
  parameter Boolean use_HeatTransfer=false "Use external heat transfer port";
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
  Volumes.UnitVolume                      unitCell[nVs[1]](
    T_start=Ts_start,
    each energyDynamics=energyDynamics,
    d=if use_Density then fill(d, nVs[1]) else Material.density_T(unitCell.T),
    cp=if use_HeatCapacity then fill(cp, nVs[1]) else
        Material.specificHeatCapacityCp_T(unitCell.T),
    V=geometry.Vs,
    Q_gen=nFlow_Q_gen.port_n)
    annotation (Placement(transformation(extent={{-10,-30},{10,-10}})));
  Modelica.Blocks.Interfaces.RealInput Q_gen[nVs[1]](unit="W")
    annotation (Placement(transformation(extent={{-120,40},{-100,60}}),
        iconTransformation(extent={{-120,40},{-100,60}})));
  Resistances.Heat.Plane                           conductor_1[nFM_1](
    L=lengths_1FM,
    crossArea=crossAreas_1FM,
    lambda=if use_Lambda then fill(lambda, nFM_1) else
        Material.thermalConductivity_T(0.5*(conductor_1.port_a.T + conductor_1.port_b.T)))
    annotation (Placement(transformation(extent={{-10,10},{10,30}})));
  Interfaces.HeatPort_Flow port_a1 annotation (Placement(
        transformation(extent={{-110,-10},{-90,10}}), iconTransformation(extent=
           {{-110,-10},{-90,10}})));
  TRANSFORM.HeatAndMassTransfer.Interfaces.HeatPort_State port_b1 annotation (
      Placement(transformation(extent={{90,-10},{110,10}}), iconTransformation(
          extent={{90,-10},{110,10}})));
  BoundaryConditions.Parallel_Real nFlow_Q_gen[nVs[1]](each nParallel=nParallel)
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
  BoundaryConditions.Heat.ParallelFlow nFlow_a1(nParallel=nParallel)
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  BoundaryConditions.Heat.ParallelFlow nFlow_b1(nParallel=nParallel)
    annotation (Placement(transformation(extent={{80,-10},{60,10}})));
  Interfaces.HeatPort_Flow heatPort_external[nVs[1]] if use_HeatTransfer annotation (Placement(
        transformation(extent={{-90,-90},{-70,-70}}),
                                                    iconTransformation(extent={{-90,-90},
            {-70,-70}})));
  BoundaryConditions.Heat.ParallelFlow nFlow_heatPort_external[nVs[1]](each
      nParallel=nParallel)
    if use_HeatTransfer annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=45,
        origin={-60,-60})));
protected
  Modelica.Blocks.Interfaces.RealOutput crossAreas_1FM[nFM_1];
  Modelica.Blocks.Interfaces.RealOutput lengths_1FM[nFM_1];
equation
  // Dimension-1 Section
  if exposeState_a1 and exposeState_b1 then
    assert(nVs[1] > 1, "nVs[1] must be > 1 if exposeState_a1 and exposeState_b1 = true");
  end if;
  if exposeState_a1 and exposeState_b1 then
    //nFM = nV-1
    // Connections
    connect(nFlow_a1.port_n, unitCell[1].port);
    for i in 1:nFM_1 loop
      connect(unitCell[i].port, conductor_1[i].port_a);
    end for;
    for i in 1:nFM_1 loop
      connect(conductor_1[i].port_b, unitCell[i + 1].port);
    end for;
    connect(unitCell[nFM_1 + 1].port, nFlow_b1.port_n);
    // Variables
    for i in 1:nFM_1 loop
      crossAreas_1FM[i] = geometry.crossAreas_1[i + 1];
    end for;
    if nFM_1 == 1 then
      lengths_1FM[1] = geometry.dlengths_1[1] + geometry.dlengths_1[2];
    else
      lengths_1FM[1] = geometry.dlengths_1[1] + 0.5*geometry.dlengths_1[2];
      for i in 2:nFM_1 - 1 loop
        lengths_1FM[i] = 0.5*(geometry.dlengths_1[i] + geometry.dlengths_1
          [i + 1]);
      end for;
      lengths_1FM[nFM_1] = 0.5*geometry.dlengths_1[nFM_1] + geometry.dlengths_1
        [nFM_1 + 1];
    end if;
  elseif exposeState_a1 and not exposeState_b1 then
    //nFM = nV
    // Connections
    connect(nFlow_a1.port_n, unitCell[1].port);
    for i in 1:nFM_1 loop
      connect(unitCell[i].port, conductor_1[i].port_a);
    end for;
    for i in 1:nFM_1 - 1 loop
      connect(conductor_1[i].port_b, unitCell[i + 1].port);
    end for;
    connect(conductor_1[nFM_1].port_b, nFlow_b1.port_n);
    // Variables
    for i in 1:nFM_1 loop
      crossAreas_1FM[i] = geometry.crossAreas_1[i + 1];
    end for;
    if nFM_1 == 1 then
      lengths_1FM[1] = geometry.dlengths_1[1];
    else
      lengths_1FM[1] = geometry.dlengths_1[1] + 0.5*geometry.dlengths_1[2];
      for i in 2:nFM_1 - 1 loop
        lengths_1FM[i] = 0.5*(geometry.dlengths_1[i] + geometry.dlengths_1
          [i + 1]);
      end for;
      lengths_1FM[nFM_1] = 0.5*geometry.dlengths_1[nFM_1];
    end if;
  elseif not exposeState_a1 and exposeState_b1 then
    //nFM = nV
    // Connections
    connect(nFlow_a1.port_n, conductor_1[1].port_a);
    for i in 1:nFM_1 - 1 loop
      connect(unitCell[i].port, conductor_1[i + 1].port_a);
    end for;
    for i in 1:nFM_1 loop
      connect(conductor_1[i].port_b, unitCell[i].port);
    end for;
    connect(unitCell[nFM_1].port, nFlow_b1.port_n);
    // Variables
    for i in 1:nFM_1 loop
      crossAreas_1FM[i] = geometry.crossAreas_1[i];
    end for;
    if nFM_1 == 1 then
      lengths_1FM[1] = geometry.dlengths_1[1];
    else
      lengths_1FM[1] = 0.5*geometry.dlengths_1[1];
      for i in 2:nFM_1 - 1 loop
        lengths_1FM[i] = 0.5*(geometry.dlengths_1[i - 1] + geometry.dlengths_1
          [i]);
      end for;
      lengths_1FM[nFM_1] = 0.5*geometry.dlengths_1[nFM_1 - 1] + geometry.dlengths_1
        [nFM_1];
    end if;
  elseif not exposeState_a1 and not exposeState_b1 then
    //nFM = nV+1;
    // Connections
    connect(nFlow_a1.port_n, conductor_1[1].port_a);
    for i in 1:nFM_1 - 1 loop
      connect(unitCell[i].port, conductor_1[i + 1].port_a);
    end for;
    for i in 1:nFM_1 - 1 loop
      connect(conductor_1[i].port_b, unitCell[i].port);
    end for;
    connect(conductor_1[nFM_1].port_b, nFlow_b1.port_n);
    // Variables
    for i in 1:nFM_1 loop
      crossAreas_1FM[i] = geometry.crossAreas_1[i];
    end for;
    lengths_1FM[1] = 0.5*geometry.dlengths_1[1];
    for i in 2:nFM_1 - 1 loop
      lengths_1FM[i] = 0.5*(geometry.dlengths_1[i - 1] + geometry.dlengths_1
        [i]);
    end for;
    lengths_1FM[nFM_1] = 0.5*geometry.dlengths_1[nFM_1 - 1];
  else
    assert(false, "Unknown model structure");
  end if;
  connect(port_a1, nFlow_a1.port_1)
    annotation (Line(points={{-100,0},{-80,0}}, color={191,0,0}));
  connect(port_b1,nFlow_b1.port_1)
    annotation (Line(points={{100,0},{90,0},{80,0}}, color={191,0,0}));
  connect(Q_gen, nFlow_Q_gen.port_1)
    annotation (Line(points={{-110,50},{-96,50},{-80,50}}, color={0,0,127}));
  connect(heatPort_external, nFlow_heatPort_external.port_1) annotation (Line(
        points={{-80,-80},{-67.0711,-80},{-67.0711,-67.0711}}, color={191,0,0}));
  connect(nFlow_heatPort_external.port_n, unitCell.port) annotation (Line(
        points={{-52.9289,-52.9289},{-52.9289,-30},{0,-30}}, color={191,0,0}));
  annotation (defaultComponentName="wall",
        Icon(coordinateSystem(preserveAspectRatio=false),
          graphics={
          Ellipse(
            extent={{-92,30},{-108,-30}},
            lineColor={215,215,215},
            fillColor={0,0,0},
            fillPattern=FillPattern.Forward,
            visible=exposeState_a1),
          Ellipse(
            extent={{108,28},{92,-32}},
            lineColor={215,215,215},
            fillColor={0,0,0},
            fillPattern=FillPattern.Forward,
            visible=exposeState_b1),
          Ellipse(
            extent={{8.94975,29.8492},{-8.94975,-29.8492}},
            lineColor={215,215,215},
            fillColor={0,0,0},
            fillPattern=FillPattern.Backward,
            origin={-79.2218,-79.435},
            rotation=45,
            visible=use_HeatTransfer)}),
          Diagram(coordinateSystem(
            preserveAspectRatio=false)));
end Conduction_1D;
