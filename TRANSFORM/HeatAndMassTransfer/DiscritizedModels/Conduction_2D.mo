within TRANSFORM.HeatAndMassTransfer.DiscritizedModels;
model Conduction_2D "2-D Conduction Models"
  import TRANSFORM.Math.linspace_2Dedge;
  BaseClasses.Dimensions_2.Summary summary(
    T_effective=sum(materials.T .* ms/sum(ms)),
    T_max=max(materials.T),
    lambda_effective=sum(Material.thermalConductivity(materials.state) .* ms/
        sum(ms)))
    annotation (Placement(transformation(extent={{80,-100},{100,-80}})));
  extends
    TRANSFORM.HeatAndMassTransfer.ClosureRelations.Geometry.ConductionIcons(
      final figure=geometry.figure);
  extends
    TRANSFORM.HeatAndMassTransfer.DiscritizedModels.BaseClasses.Dimensions_2.PartialDistributedVolume(
    final Vs=geometry.Vs,
    final nVs=geometry.ns,
    Ts_start=linspace_2Dedge(
        T_a1_start,
        T_b1_start,
        T_a2_start,
        T_b2_start,
        nVs[1],
        nVs[2],
        {exposeState_b2,exposeState_a1,exposeState_a2,exposeState_b1}));
  // Initialization
  parameter SI.Temperature T_a1_start=Material.T_reference
    "Temperature at port a1"
    annotation (Dialog(tab="Initialization", group="Start Value: Temperature"));
  parameter SI.Temperature T_b1_start=T_a1_start "Temperature at port b1"
    annotation (Dialog(tab="Initialization", group="Start Value: Temperature"));
  parameter SI.Temperature T_a2_start=Material.T_reference
    "Temperature at port a2"
    annotation (Dialog(tab="Initialization", group="Start Value: Temperature"));
  parameter SI.Temperature T_b2_start=T_a2_start "Temperature at port b2"
    annotation (Dialog(tab="Initialization", group="Start Value: Temperature"));
  parameter Real nParallel=1 "Number of parallel components";
  // Advanced
  parameter Boolean exposeState_a1=true
    "=true, T is calculated at port_a1 else Q_flow" annotation (Dialog(group=
          "Model Structure", tab="Advanced"));
  parameter Boolean exposeState_b1=false
    "=true, T is calculated at port_b1 else Q_flow" annotation (Dialog(group=
          "Model Structure", tab="Advanced"));
  final parameter Integer nFM_1=if exposeState_a1 and exposeState_b1 then nVs[1]
       - 1 else if not exposeState_a1 and not exposeState_b1 then nVs[1] + 1
       else nVs[1] "number of flow models";
  parameter Boolean exposeState_a2=true
    "=true, T is calculated at port_a2 else Q_flow" annotation (Dialog(group=
          "Model Structure", tab="Advanced"));
  parameter Boolean exposeState_b2=false
    "=true, T is calculated at port_b2 else Q_flow" annotation (Dialog(group=
          "Model Structure", tab="Advanced"));
  final parameter Integer nFM_2=if exposeState_a2 and exposeState_b2 then nVs[2]
       - 1 else if not exposeState_a2 and not exposeState_b2 then nVs[2] + 1
       else nVs[2] "number of flow models";
  replaceable model Geometry =
      TRANSFORM.HeatAndMassTransfer.ClosureRelations.Geometry.Models.Plane_2D
    constrainedby
    TRANSFORM.HeatAndMassTransfer.ClosureRelations.Geometry.Models.PartialGeometry_2D
    "Geometry" annotation (Dialog(group="Geometry"),choicesAllMatching=true);
  Geometry geometry
    annotation (Placement(transformation(extent={{-78,82},{-62,98}})));
  parameter Boolean adiabaticDims[2]={false,false}
    "=true, toggle off conduction heat transfer in dimension {1,2}"
    annotation (Dialog(group="Heat Transfer"));
  replaceable model ConductionModel =
      TRANSFORM.HeatAndMassTransfer.DiscritizedModels.BaseClasses.Dimensions_2.ForwardDifference_1O
    constrainedby
    TRANSFORM.HeatAndMassTransfer.DiscritizedModels.BaseClasses.Dimensions_2.PartialDistributedFlow
    "Diffusive heat transfer" annotation (Dialog(group="Heat Transfer"),
      choicesAllMatching=true);
  ConductionModel conductionModel(
    redeclare final package Material = Material,
    final nVs=nVs,
    final nFM_1=nFM_1,
    final nFM_2=nFM_2,
    final adiabaticDims=adiabaticDims,
    final crossAreas_1=crossAreas_1FM,
    final crossAreas_2=crossAreas_2FM,
    final lengths_1=lengths_1FM,
    final lengths_2=lengths_2FM,
    final states_1=statesFM_1,
    final states_2=statesFM_2) "Conduction Model" annotation (Placement(
        transformation(extent={{-58,82},{-42,98}}, rotation=0)));
  replaceable model InternalHeatModel =
      TRANSFORM.HeatAndMassTransfer.DiscritizedModels.BaseClasses.Dimensions_2.GenericHeatGeneration
    constrainedby
    TRANSFORM.HeatAndMassTransfer.DiscritizedModels.BaseClasses.Dimensions_2.PartialInternalHeatGeneration
    "Internal heat generation" annotation (Dialog(group="Heat Transfer"),
      choicesAllMatching=true);
  InternalHeatModel internalHeatModel(
    redeclare final package Material = Material,
    final nVs=nVs,
    final Vs=geometry.Vs,
    final crossAreas_1=geometry.crossAreas_1,
    final crossAreas_2=geometry.crossAreas_2,
    final lengths_1=geometry.dlengths_1,
    final lengths_2=geometry.dlengths_2,
    final states=materials.state) "Internal heat generation model" annotation (
      Placement(transformation(extent={{-38,82},{-22,98}}, rotation=0)));
  Interfaces.HeatPort_Flow port_a1[nVs[2]] annotation (Placement(transformation(
          extent={{-110,-10},{-90,10}}), iconTransformation(extent={{-110,-10},
            {-90,10}})));
  Interfaces.HeatPort_Flow                                  port_b1[nVs[2]]
    annotation (Placement(transformation(extent={{90,-10},{110,10}}),
        iconTransformation(extent={{90,-10},{110,10}})));
  Interfaces.HeatPort_Flow port_a2[nVs[1]] annotation (Placement(transformation(
          extent={{-10,-110},{10,-90}}), iconTransformation(extent={{-10,-110},
            {10,-90}})));
  Interfaces.HeatPort_Flow                                  port_b2[nVs[1]]
    annotation (Placement(transformation(extent={{-10,90},{10,110}}),
        iconTransformation(extent={{-10,90},{10,110}})));
  Interfaces.HeatPort_State port_external[nVs[1],nVs[2]]
    "External heat transfer in non-discritized dimension" annotation (Placement(
        transformation(extent={{-90,-90},{-70,-70}}), iconTransformation(extent=
           {{-90,-90},{-70,-70}})));
  SI.HeatFlowRate Q_flows_1[nVs[1] + 1,nVs[2]]
    "Heat flow rates across segment boundaries";
  SI.HeatFlowRate Q_flows_2[nVs[1],nVs[2] + 1]
    "Heat flow rates across segment boundaries";
  Material.ThermodynamicState state_a1[nVs[2]]
    "state defined by volume outside port_a1";
  Material.ThermodynamicState state_b1[nVs[2]]
    "state defined by volume outside port_b1";
  Material.ThermodynamicState state_a2[nVs[1]]
    "state defined by volume outside port_a2";
  Material.ThermodynamicState state_b2[nVs[1]]
    "state defined by volume outside port_b2";
  parameter Boolean showName = true annotation(Dialog(tab="Visualization"));
//   parameter Boolean connectDim_1 = true "=false to remove automatic connection based on closed geometry" annotation(Dialog(tab="Advanced"));
//   parameter Boolean connectDim_2 = true "=false to remove automatic connection based on closed geometry" annotation(Dialog(tab="Advanced"));
protected
  Material.ThermodynamicState statesFM_1[nFM_1 + 1,nVs[2]];
  Material.ThermodynamicState statesFM_2[nVs[1],nFM_2 + 1];
  SI.Area crossAreas_1FM[nFM_1,nVs[2]];
  SI.Area crossAreas_2FM[nVs[1],nFM_2];
  SI.Length lengths_1FM[nFM_1,nVs[2]];
  SI.Length lengths_2FM[nVs[1],nFM_2];
equation
  for i in 1:nVs[1] loop
    for j in 1:nVs[2] loop
      Ubs[i, j] = Q_flows_1[i, j] - Q_flows_1[i + 1, j] + Q_flows_2[i, j]
         - Q_flows_2[i, j + 1] + (internalHeatModel.Q_flows[i, j] + port_external[i, j].Q_flow)
        /nParallel;
    end for;
  end for;
  // Boundary Conditions
  port_a1.Q_flow = nParallel*(Q_flows_1[1, :]);
  port_b1.Q_flow = nParallel*(-Q_flows_1[nVs[1] + 1, :]);
  port_a2.Q_flow = nParallel*(Q_flows_2[:, 1]);
  port_b2.Q_flow = nParallel*(-Q_flows_2[:, nVs[2] + 1]);
  port_external.T = materials.T;
  state_a1 = Material.setState_T(port_a1.T);
  state_b1 = Material.setState_T(port_b1.T);
  state_a2 = Material.setState_T(port_a2.T);
  state_b2 = Material.setState_T(port_b2.T);
// Auto-connection requires a change of geometry from inputs to parameters... e.g. x = alpha*x_start
//   for j in 1:nVs[2] loop
//     if geometry.closedDim_1[j] and connectDim_1 then
//       connect(port_b1[j], port_a1[j]) annotation (Line(points={{100,0},{40,0},{40,
//               0},{-100,0}}, color={191,0,0}));
//     end if;
//   end for;
//
//   for i in 1:nVs[1] loop
//     if geometry.closedDim_2[i] and connectDim_2 then
//       connect(port_b2[i], port_a2[i]) annotation (Line(points={{0,100},{40,100},
//               {40,-100},{0,-100}}, color={191,0,0}));
//     end if;
//   end for;
  /*##########################################################################*/
  /*                    Dimension-1 Flow Model Definitions                    */
  /*##########################################################################*/
  if exposeState_a1 and exposeState_b1 then
    assert(nVs[1] > 1,
      "nVs[1] must be > 1 if exposeState_a1 and exposeState_b1 = true");
  end if;
  for j in 1:nVs[2] loop
    if exposeState_a1 and exposeState_b1 then
      /************************************************************************/
      /*             1.a Model Structure (true, true) (i.e., v_v)             */
      /************************************************************************/
      //nFM_1 = nVs[1]-1
      // Connections
      Q_flows_1[2:nVs[1], j] = conductionModel.Q_flows_1[1:nVs[1] - 1, j];
      /* Boundary Ports */
      // Left Boundary
      port_a1[j].T = materials[1, j].T;
      // Right Boundary
      port_b1[j].T = materials[nVs[1], j].T;
      /* State Variables */
      for i in 1:nFM_1 + 1 loop
        statesFM_1[i, j] = materials[i, j].state;
      end for;
      /* Geometry Variables */
      for i in 1:nFM_1 loop
        crossAreas_1FM[i, j] = geometry.crossAreas_1[i + 1, j];
      end for;
      if nFM_1 == 1 then
        lengths_1FM[1, j] = geometry.dlengths_1[1, j] + geometry.dlengths_1[2,
          j];
      else
        lengths_1FM[1, j] = geometry.dlengths_1[1, j] + 0.5*geometry.dlengths_1
          [2, j];
        for i in 2:nFM_1 - 1 loop
          lengths_1FM[i, j] = 0.5*(geometry.dlengths_1[i, j] + geometry.dlengths_1
            [i + 1, j]);
        end for;
        lengths_1FM[nFM_1, j] = 0.5*geometry.dlengths_1[nFM_1, j] + geometry.dlengths_1
          [nFM_1 + 1, j];
      end if;
    elseif exposeState_a1 and not exposeState_b1 then
      /************************************************************************/
      /*             1.b Model Structure (true, false) (i.e., v_)             */
      /************************************************************************/
      //nFM_1 = nVs[1]
      // Connections
      Q_flows_1[2:nVs[1] + 1, j] = conductionModel.Q_flows_1[1:nVs[1], j];
      /* Boundary Ports */
      // Left Boundary
      port_a1[j].T = materials[1, j].T;
      // Right Boundary - set by connecting model
      /* State Variables */
      for i in 1:nFM_1 loop
        statesFM_1[i, j] = materials[i, j].state;
      end for;
      statesFM_1[nFM_1 + 1, j] = state_b1[j];
      /* Geometry Variables */
      for i in 1:nFM_1 loop
        crossAreas_1FM[i, j] = geometry.crossAreas_1[i + 1, j];
      end for;
     if geometry.closedDim_1[j] then
      if nFM_1 == 1 then
        lengths_1FM[1, j] = geometry.dlengths_1[1, j];
      else
        for i in 1:nFM_1 - 1 loop
          lengths_1FM[i, j] = 0.5*(geometry.dlengths_1[i, j] + geometry.dlengths_1
            [i + 1, j]);
        end for;
        lengths_1FM[nFM_1, j] = geometry.dlengths_1[nFM_1, j];
      end if;
     else
      if nFM_1 == 1 then
        lengths_1FM[1, j] = geometry.dlengths_1[1, j];
      else
        lengths_1FM[1, j] = geometry.dlengths_1[1, j] + 0.5*geometry.dlengths_1
          [2, j];
        for i in 2:nFM_1 - 1 loop
          lengths_1FM[i, j] = 0.5*(geometry.dlengths_1[i, j] + geometry.dlengths_1
            [i + 1, j]);
        end for;
        lengths_1FM[nFM_1, j] = 0.5*geometry.dlengths_1[nFM_1, j];
      end if;
     end if;
    elseif not exposeState_a1 and exposeState_b1 then
      /************************************************************************/
      /*             1.c Model Structure (false, true) (i.e., _v)             */
      /************************************************************************/
      //nFM_1 = nVs[1]
      // Connections
      Q_flows_1[1:nVs[1], j] = conductionModel.Q_flows_1[1:nVs[1], j];
      /* Boundary Ports */
      // Left Boundary - set by connecting model
      // Right Boundary
      port_b1[j].T = materials[nVs[1], j].T;
      /* State Variables */
      statesFM_1[1, j] = state_a1[j];
      for i in 2:nFM_1 + 1 loop
        statesFM_1[i, j] = materials[i - 1, j].state;
      end for;
      /* Geometry Variables */
      for i in 1:nFM_1 loop
        crossAreas_1FM[i, j] = geometry.crossAreas_1[i, j];
      end for;
     if geometry.closedDim_1[j] then
      if nFM_1 == 1 then
        lengths_1FM[1, j] = geometry.dlengths_1[1, j];
      else
        lengths_1FM[1, j] = 0.5*geometry.dlengths_1[1, j];
        for i in 2:nFM_1 loop
          lengths_1FM[i, j] = 0.5*(geometry.dlengths_1[i - 1, j] + geometry.dlengths_1
            [i, j]);
        end for;
      end if;
     else
      if nFM_1 == 1 then
        lengths_1FM[1, j] = geometry.dlengths_1[1, j];
      else
        lengths_1FM[1, j] = 0.5*geometry.dlengths_1[1, j];
        for i in 2:nFM_1 - 1 loop
          lengths_1FM[i, j] = 0.5*(geometry.dlengths_1[i - 1, j] + geometry.dlengths_1
            [i, j]);
        end for;
        lengths_1FM[nFM_1, j] = 0.5*geometry.dlengths_1[nFM_1 - 1, j] +
          geometry.dlengths_1[nFM_1, j];
      end if;
     end if;
    elseif not exposeState_a1 and not exposeState_b1 then
      /************************************************************************/
      /*            1.d Model Structure (false, false) (i.e., _v_)            */
      /************************************************************************/
      //nFM_1 = nVs[1]+1;
      // Connections
      Q_flows_1[1:nVs[1] + 1, j] = conductionModel.Q_flows_1[1:nVs[1] + 1, j];
      /* Boundary Ports */
      // Left Boundary - set by connecting model
      // Right Boundary - set by connecting model
      /* State Variables */
      statesFM_1[1, j] = state_a1[j];
      for i in 2:nFM_1 loop
        statesFM_1[i, j] = materials[i - 1, j].state;
      end for;
      statesFM_1[nFM_1 + 1, j] = state_b1[j];
      /* Geometry Variables */
      for i in 1:nFM_1 loop
        crossAreas_1FM[i, j] = geometry.crossAreas_1[i, j];
      end for;
      lengths_1FM[1, j] = 0.5*geometry.dlengths_1[1, j];
      for i in 2:nFM_1 - 1 loop
        lengths_1FM[i, j] = 0.5*(geometry.dlengths_1[i - 1, j] + geometry.dlengths_1
          [i, j]);
      end for;
      lengths_1FM[nFM_1, j] = 0.5*geometry.dlengths_1[nFM_1 - 1, j];
    else
      assert(false, "Unknown model structure");
    end if;
  end for;
  /*##########################################################################*/
  /*                    Dimension-2 Flow Model Definitions                    */
  /*##########################################################################*/
  if exposeState_a2 and exposeState_b2 then
    assert(nVs[2] > 1,
      "nVs[2] must be > 1 if exposeState_a2 and exposeState_b2 = true");
  end if;
  for i in 1:nVs[1] loop
    if exposeState_a2 and exposeState_b2 then
      /************************************************************************/
      /*             2.a Model Structure (true, true) (i.e., v_v)             */
      /************************************************************************/
      //nFM_2 = nVs[2]-1
      // Connections
      Q_flows_2[i, 2:nVs[2]] = conductionModel.Q_flows_2[i, 1:nVs[2] - 1];
      /* Boundary Ports */
      // Bottom Boundary
      port_a2[i].T = materials[i, 1].T;
      // Top Boundary
      port_b2[i].T = materials[i, nVs[2]].T;
      /* State Variables */
      for j in 1:nFM_2 + 1 loop
        statesFM_2[i, j] = materials[i, j].state;
      end for;
      /* Geometry Variables */
      for j in 1:nFM_2 loop
        crossAreas_2FM[i, j] = geometry.crossAreas_2[i, j + 1];
      end for;
      if nFM_2 == 1 then
        lengths_2FM[i, 1] = geometry.dlengths_2[i, 1] + geometry.dlengths_2[i,
          2];
      else
        lengths_2FM[i, 1] = geometry.dlengths_2[i, 1] + 0.5*geometry.dlengths_2
          [i, 2];
        for j in 2:nFM_2 - 1 loop
          lengths_2FM[i, j] = 0.5*(geometry.dlengths_2[i, j] + geometry.dlengths_2
            [i, j + 1]);
        end for;
        lengths_2FM[i, nFM_2] = 0.5*geometry.dlengths_2[i, nFM_2] + geometry.dlengths_2
          [i, nFM_2 + 1];
      end if;
    elseif exposeState_a2 and not exposeState_b2 then
      /************************************************************************/
      /*             2.b Model Structure (true, false) (i.e., v_)             */
      /************************************************************************/
      //nFM_2 = nVs[2]
      // Connections
      Q_flows_2[i, 2:nVs[2] + 1] = conductionModel.Q_flows_2[i, 1:nVs[2]];
      /* Boundary Ports */
      // Bottom Boundary
      port_a2[i].T = materials[i, 1].T;
      // Top Boundary - set by connecting model
      /* State Variables */
      for j in 1:nFM_2 loop
        statesFM_2[i, j] = materials[i, j].state;
      end for;
      statesFM_2[i, nFM_2 + 1] = state_b2[i];
      /* Geometry Variables */
      for j in 1:nFM_2 loop
        crossAreas_2FM[i, j] = geometry.crossAreas_2[i, j + 1];
      end for;
     if geometry.closedDim_2[i] then
      if nFM_2 == 1 then
        lengths_2FM[i, 1] = geometry.dlengths_2[i, 1];
      else
        for j in 1:nFM_2 - 1 loop
          lengths_2FM[i, j] = 0.5*(geometry.dlengths_2[i, j] + geometry.dlengths_2
            [i, j + 1]);
        end for;
        lengths_2FM[i, nFM_2] = geometry.dlengths_2[i, nFM_2];
      end if;
     else
      if nFM_2 == 1 then
        lengths_2FM[i, 1] = geometry.dlengths_2[i, 1];
      else
        lengths_2FM[i, 1] = geometry.dlengths_2[i, 1] + 0.5*geometry.dlengths_2
          [i, 2];
        for j in 2:nFM_2 - 1 loop
          lengths_2FM[i, j] = 0.5*(geometry.dlengths_2[i, j] + geometry.dlengths_2
            [i, j + 1]);
        end for;
        lengths_2FM[i, nFM_2] = 0.5*geometry.dlengths_2[i, nFM_2];
      end if;
     end if;
    elseif not exposeState_a2 and exposeState_b2 then
      /************************************************************************/
      /*             2.c Model Structure (false, true) (i.e., _v)             */
      /************************************************************************/
      //nFM_2 = nVs[2]
      // Connections
      Q_flows_2[i, 1:nVs[2]] = conductionModel.Q_flows_2[i, 1:nVs[2]];
      /* Boundary Ports */
      // Bottom Boundary - set by connecting model
      // Top Boundary
      port_b2[i].T = materials[i, nVs[2]].T;
      /* State Variables */
      statesFM_2[i, 1] = state_a2[i];
      for j in 2:nFM_2 + 1 loop
        statesFM_2[i, j] = materials[i, j - 1].state;
      end for;
      /* Geometry Variables */
      for j in 1:nFM_2 loop
        crossAreas_2FM[i, j] = geometry.crossAreas_2[i, j];
      end for;
     if geometry.closedDim_2[i] then
      if nFM_2 == 1 then
        lengths_2FM[i, 1] = geometry.dlengths_2[i, 1];
      else
        lengths_2FM[i, 1] = geometry.dlengths_2[i, 1];
        for j in 2:nFM_2 loop
          lengths_2FM[i, j] = 0.5*(geometry.dlengths_2[i, j - 1] + geometry.dlengths_2
            [i, j]);
        end for;
      end if;
     else
      if nFM_2 == 1 then
        lengths_2FM[i, 1] = geometry.dlengths_2[i, 1];
      else
        lengths_2FM[i, 1] = 0.5*geometry.dlengths_2[i, 1];
        for j in 2:nFM_2 - 1 loop
          lengths_2FM[i, j] = 0.5*(geometry.dlengths_2[i, j - 1] + geometry.dlengths_2
            [i, j]);
        end for;
        lengths_2FM[i, nFM_2] = 0.5*geometry.dlengths_2[i, nFM_2 - 1] +
          geometry.dlengths_2[i, nFM_2];
      end if;
     end if;
    elseif not exposeState_a2 and not exposeState_b2 then
      /************************************************************************/
      /*            2.d Model Structure (false, false) (i.e., _v_)            */
      /************************************************************************/
      //nFM_2 = nVs[2]+1;
      // Connections
      Q_flows_2[i, 1:nVs[2] + 1] = conductionModel.Q_flows_2[i, 1:nVs[2] + 1];
      /* Boundary Ports */
      // Bottom Boundary - set by connecting model
      // Top Boundary - set by connecting model
      /* State Variables */
      statesFM_2[i, 1] = state_a2[i];
      for j in 2:nFM_2 loop
        statesFM_2[i, j] = materials[i, j - 1].state;
      end for;
      statesFM_2[i, nFM_2 + 1] = state_b2[i];
      /* Geometry Variables */
      for j in 1:nFM_2 loop
        crossAreas_2FM[i, j] = geometry.crossAreas_2[i, j];
      end for;
      lengths_2FM[i, 1] = 0.5*geometry.dlengths_2[i, 1];
      for j in 2:nFM_2 - 1 loop
        lengths_2FM[i, j] = 0.5*(geometry.dlengths_2[i, j - 1] + geometry.dlengths_2
          [i, j]);
      end for;
      lengths_2FM[i, nFM_2] = 0.5*geometry.dlengths_2[i, nFM_2 - 1];
    else
      assert(false, "Unknown model structure");
    end if;
  end for;
  annotation (
    defaultComponentName="conduction",
    Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Text(
          extent={{-84,12},{84,-12}},
          textString="%name",
          lineColor={0,0,255},
          visible=showName),
        Ellipse(
          extent={{-92,30},{-108,-30}},
          lineColor={191,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          visible=exposeState_a1),
        Ellipse(
          extent={{8,30},{-8,-30}},
          lineColor={191,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          visible=exposeState_a2,
          origin={0,-100},
          rotation=90),
        Ellipse(
          extent={{108,28},{92,-32}},
          lineColor={191,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          visible=exposeState_b1),
        Ellipse(
          extent={{8,30},{-8,-30}},
          lineColor={191,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          visible=exposeState_b2,
          origin={0,100},
          rotation=90)}),
    Diagram(coordinateSystem(preserveAspectRatio=false)));
end Conduction_2D;
