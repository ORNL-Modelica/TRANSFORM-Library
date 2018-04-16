within TRANSFORM.HeatAndMassTransfer.DiscritizedModels;
model Conduction_1D "1-D Conduction Models"
  import TRANSFORM.Math.linspace_1D;

  BaseClasses.Dimensions_1.Summary summary(
    T_effective=sum(materials.T .* ms/sum(ms)),
    T_max=max(materials.T),
    lambda_effective=sum(Material.thermalConductivity(materials.state) .* ms/
        sum(ms)))
    annotation (Placement(transformation(extent={{80,-100},{100,-80}})));

  extends
    TRANSFORM.HeatAndMassTransfer.ClosureRelations.Geometry.ConductionIcons(
      final figure=geometry.figure);

  extends
    TRANSFORM.HeatAndMassTransfer.DiscritizedModels.BaseClasses.Dimensions_1.PartialDistributedVolume(
    final Vs=geometry.Vs,
    final nVs=geometry.ns,
    Ts_start=linspace_1D(
        T_a1_start,
        T_b1_start,
        nVs[1]));

  // Initialization
  parameter SI.Temperature T_a1_start=Material.T_reference
    "Temperature at port a1"
    annotation (Dialog(tab="Initialization", group="Start Value: Temperature"));
  parameter SI.Temperature T_b1_start=T_a1_start "Temperature at port b1"
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

  replaceable model Geometry =
      TRANSFORM.HeatAndMassTransfer.ClosureRelations.Geometry.Models.Plane_1D
    constrainedby
    TRANSFORM.HeatAndMassTransfer.ClosureRelations.Geometry.Models.PartialGeometry_1D
    "Geometry" annotation (Dialog(group="Geometry"),choicesAllMatching=true);

  Geometry geometry
    annotation (Placement(transformation(extent={{-78,82},{-62,98}})));

  replaceable model ConductionModel =
      TRANSFORM.HeatAndMassTransfer.DiscritizedModels.BaseClasses.Dimensions_1.ForwardDifference_1O
    constrainedby
    TRANSFORM.HeatAndMassTransfer.DiscritizedModels.BaseClasses.Dimensions_1.PartialDistributedFlow
    "Diffusive heat transfer" annotation (Dialog(group="Heat Transfer"),
      choicesAllMatching=true);

  ConductionModel conductionModel(
    redeclare final package Material = Material,
    final nVs=nVs,
    final nFM_1=nFM_1,
    final crossAreas_1=crossAreas_1FM,
    final lengths_1=lengths_1FM,
    final states_1=statesFM_1) "Conduction Model" annotation (Placement(
        transformation(extent={{-58,82},{-42,98}}, rotation=0)));

  replaceable model InternalHeatModel =
      TRANSFORM.HeatAndMassTransfer.DiscritizedModels.BaseClasses.Dimensions_1.GenericHeatGeneration
    constrainedby
    TRANSFORM.HeatAndMassTransfer.DiscritizedModels.BaseClasses.Dimensions_1.PartialInternalHeatGeneration
    "Internal heat generation" annotation (Dialog(group="Heat Transfer"),
      choicesAllMatching=true);

  InternalHeatModel internalHeatModel(
    redeclare final package Material = Material,
    final nVs=nVs,
    final Vs=geometry.Vs,
    final crossAreas_1=geometry.crossAreas_1,
    final lengths_1=geometry.dlengths_1,
    final states=materials.state) "Internal heat generation model" annotation (
      Placement(transformation(extent={{-38,82},{-22,98}}, rotation=0)));

  Interfaces.HeatPort_Flow port_a1 annotation (Placement(transformation(extent=
            {{-110,-10},{-90,10}}), iconTransformation(extent={{-110,-10},{-90,
            10}})));
  Interfaces.HeatPort_Flow                                  port_b1 annotation (
     Placement(transformation(extent={{90,-10},{110,10}}), iconTransformation(
          extent={{90,-10},{110,10}})));

  Interfaces.HeatPort_State port_external[nVs[1]]
    "External heat transfer in non-discritized dimensions" annotation (
      Placement(transformation(extent={{-90,-90},{-70,-70}}),
        iconTransformation(extent={{-90,-90},{-70,-70}})));

  SI.HeatFlowRate H_flows_1[nVs[1] + 1]
    "Enthalpy flow rates across segment boundaries";
  SI.HeatFlowRate Q_flows_1[nVs[1] + 1]
    "Heat flow rates across segment boundaries";

  Material.ThermodynamicState state_a1
    "state defined by volume outside port_a1";
  Material.ThermodynamicState state_b1
    "state defined by volume outside port_b1";
  input SI.Velocity velocity_1=0 "Velocity of material through control volumes"
    annotation (Dialog(group="Inputs"));

  parameter Boolean showName = true annotation(Dialog(tab="Visualization"));

protected
  Material.ThermodynamicState statesFM_1[nFM_1 + 1];

  SI.Area crossAreas_1FM[nFM_1];

  SI.Length lengths_1FM[nFM_1];

equation

  for i in 1:nVs[1] loop
    Ubs[i] = H_flows_1[i] - H_flows_1[i + 1] + Q_flows_1[i] - Q_flows_1[i + 1] + (internalHeatModel.Q_flows[i] + port_external[i].Q_flow)/
      nParallel;
  end for;

  // Boundary Conditions
  port_a1.Q_flow = nParallel*(Q_flows_1[1] + H_flows_1[1]);
  port_b1.Q_flow = nParallel*(-Q_flows_1[nVs[1] + 1] - H_flows_1[nVs[1] + 1]);

  port_external.T = materials.T;

  // Distributed flow quantities, upwind discretization
  H_flows_1[1] = semiLinear(
    velocity_1*materials[1].d*geometry.crossAreas_1[1],
    Material.specificEnthalpy(state_a1),
    materials[1].h);
  for i in 2:nVs[1] loop
    H_flows_1[i] = semiLinear(
      velocity_1*materials[i - 1].d*geometry.crossAreas_1[i],
      materials[i - 1].h,
      materials[i].h);
  end for;
  H_flows_1[nVs[1] + 1] = semiLinear(
    velocity_1*materials[nVs[1]].d*geometry.crossAreas_1[nVs[1] + 1],
    materials[nVs[1]].h,
    Material.specificEnthalpy(state_b1));

  state_a1 = Material.setState_T(port_a1.T);
  state_b1 = Material.setState_T(port_b1.T);

  /*##########################################################################*/
  /*                    Dimension-1 Flow Model Definitions                    */
  /*##########################################################################*/
  if exposeState_a1 and exposeState_b1 then
    assert(nVs[1] > 1,
      "nVs[1] must be > 1 if exposeState_a1 and exposeState_b1 = true");
  end if;

  if exposeState_a1 and exposeState_b1 then
    /************************************************************************/
    /*             1.a Model Structure (true, true) (i.e., v_v)             */
    /************************************************************************/
    //nFM_1 = nVs[1]-1

    // Connections
    Q_flows_1[2:nVs[1]] = conductionModel.Q_flows_1[1:nVs[1] - 1];

    /* Boundary Ports */
    // Left Boundary
    port_a1.T = materials[1].T;
    // Right Boundary
    port_b1.T = materials[nVs[1]].T;

    /* State Variables */
    for i in 1:nFM_1 + 1 loop
      statesFM_1[i] = materials[i].state;
    end for;

    /* Geometry Variables */
    for i in 1:nFM_1 loop
      crossAreas_1FM[i] = geometry.crossAreas_1[i + 1];
    end for;

    if nFM_1 == 1 then
      lengths_1FM[1] = geometry.dlengths_1[1] + geometry.dlengths_1[2];
    else
      lengths_1FM[1] = geometry.dlengths_1[1] + 0.5*geometry.dlengths_1[2];
      for i in 2:nFM_1 - 1 loop
        lengths_1FM[i] = 0.5*(geometry.dlengths_1[i] + geometry.dlengths_1[i +
          1]);
      end for;
      lengths_1FM[nFM_1] = 0.5*geometry.dlengths_1[nFM_1] + geometry.dlengths_1
        [nFM_1 + 1];
    end if;

  elseif exposeState_a1 and not exposeState_b1 then
    /************************************************************************/
    /*             1.b Model Structure (true, false) (i.e., v_)             */
    /************************************************************************/

    //nFM_1 = nVs[1]

    // Connections
    Q_flows_1[2:nVs[1] + 1] = conductionModel.Q_flows_1[1:nVs[1]];

    /* Boundary Ports */
    // Left Boundary
    port_a1.T = materials[1].T;
    // Right Boundary - set by connecting model

    /* State Variables */
    for i in 1:nFM_1 loop
      statesFM_1[i] = materials[i].state;
    end for;
    statesFM_1[nFM_1 + 1] = state_b1;

    /* Geometry Variables */
    for i in 1:nFM_1 loop
      crossAreas_1FM[i] = geometry.crossAreas_1[i + 1];
    end for;

    if nFM_1 == 1 then
      lengths_1FM[1] = geometry.dlengths_1[1];
    else
      lengths_1FM[1] = geometry.dlengths_1[1] + 0.5*geometry.dlengths_1[2];
      for i in 2:nFM_1 - 1 loop
        lengths_1FM[i] = 0.5*(geometry.dlengths_1[i] + geometry.dlengths_1[i +
          1]);
      end for;
      lengths_1FM[nFM_1] = 0.5*geometry.dlengths_1[nFM_1];
    end if;

  elseif not exposeState_a1 and exposeState_b1 then
    /************************************************************************/
    /*             1.c Model Structure (false, true) (i.e., _v)             */
    /************************************************************************/

    //nFM_1 = nVs[1]

    // Connections
    Q_flows_1[1:nVs[1]] = conductionModel.Q_flows_1[1:nVs[1]];

    /* Boundary Ports */
    // Left Boundary - set by connecting model
    // Right Boundary
    port_b1.T = materials[nVs[1]].T;

    /* State Variables */
    statesFM_1[1] = state_a1;
    for i in 2:nFM_1 + 1 loop
      statesFM_1[i] = materials[i - 1].state;
    end for;

    /* Geometry Variables */
    for i in 1:nFM_1 loop
      crossAreas_1FM[i] = geometry.crossAreas_1[i];
    end for;

    if nFM_1 == 1 then
      lengths_1FM[1] = geometry.dlengths_1[1];
    else
      lengths_1FM[1] = 0.5*geometry.dlengths_1[1];
      for i in 2:nFM_1 - 1 loop
        lengths_1FM[i] = 0.5*(geometry.dlengths_1[i - 1] + geometry.dlengths_1[
          i]);
      end for;
      lengths_1FM[nFM_1] = 0.5*geometry.dlengths_1[nFM_1 - 1] + geometry.dlengths_1
        [nFM_1];
    end if;

  elseif not exposeState_a1 and not exposeState_b1 then
    /************************************************************************/
    /*            1.d Model Structure (false, false) (i.e., _v_)            */
    /************************************************************************/

    //nFM_1 = nVs[1]+1;

    // Connections
    Q_flows_1[1:nVs[1] + 1] = conductionModel.Q_flows_1[1:nVs[1] + 1];

    /* Boundary Ports */
    // Left Boundary - set by connecting model
    // Right Boundary - set by connecting model

    /* State Variables */
    statesFM_1[1] = state_a1;
    for i in 2:nFM_1 loop
      statesFM_1[i] = materials[i - 1].state;
    end for;
    statesFM_1[nFM_1 + 1] = state_b1;

    /* Geometry Variables */
    for i in 1:nFM_1 loop
      crossAreas_1FM[i] = geometry.crossAreas_1[i];
    end for;

    lengths_1FM[1] = 0.5*geometry.dlengths_1[1];
    for i in 2:nFM_1 - 1 loop
      lengths_1FM[i] = 0.5*(geometry.dlengths_1[i - 1] + geometry.dlengths_1[i]);
    end for;
    lengths_1FM[nFM_1] = 0.5*geometry.dlengths_1[nFM_1 - 1];

  else
    assert(false, "Unknown model structure");
  end if;

  annotation (
    defaultComponentName="conduction",
    Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Ellipse(
          extent={{-92,30},{-108,-30}},
          lineColor={191,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          visible=exposeState_a1),
        Text(
          extent={{-140,132},{140,92}},
          textString="%name",
          lineColor={0,0,255},
          visible=showName),
        Ellipse(
          extent={{108,30},{92,-30}},
          lineColor={191,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          visible=exposeState_b1)}),
    Diagram(coordinateSystem(preserveAspectRatio=false)));
end Conduction_1D;
