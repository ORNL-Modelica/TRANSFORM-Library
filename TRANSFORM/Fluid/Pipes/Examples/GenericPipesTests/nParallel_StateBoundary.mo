within TRANSFORM.Fluid.Pipes.Examples.GenericPipesTests;
model nParallel_StateBoundary
  import TRANSFORM;

  extends TRANSFORM.Icons.Example;

  package Medium=Modelica.Media.Water.StandardWater(extraPropertiesNames={"Tritium"});

  GenericPipe pipe_single(energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyStateInitial,
    redeclare package Medium = Medium,
    use_HeatTransfer=true,
    redeclare model Geometry =
        TRANSFORM.Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.StraightPipe
        (                                                                 nV=10,
          dimension=0.01),
    use_TraceMassTransfer=true,
    redeclare model HeatTransfer =
        TRANSFORM.Fluid.ClosureRelations.HeatTransfer.Models.DistributedPipe_1D.Alphas
        ( alpha0=1000),
    redeclare model TraceMassTransfer =
        TRANSFORM.Fluid.ClosureRelations.MassTransfer.Models.DistributedPipe_TraceMass_1D.AlphasM
        (                                               redeclare model
          DiffusionCoeff =
            TRANSFORM.Media.ClosureModels.MassDiffusionCoefficient.Models.GenericCoefficient
            (D_ab0=1), alphaM0=fill(1, Medium.nC)))
    annotation (Placement(transformation(extent={{-10,10},{10,30}})));
  Utilities.Visualizers.displayReal boundaryQ_p(val=pipe_single.port_a.p)
    annotation (Placement(transformation(extent={{-52,84},{-32,104}})));
  Utilities.Visualizers.displayReal boundaryT_p(val=pipe_single.port_b.p)
    annotation (Placement(transformation(extent={{30,84},{50,104}})));
  TRANSFORM.Fluid.BoundaryConditions.MassFlowSource_h boundaryM(
    nPorts=1,
    m_flow=1,
    h=1e5,
    C=fill(0.1, Medium.nC),
    redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{-40,10},{-20,30}})));
  TRANSFORM.Fluid.BoundaryConditions.Boundary_ph boundaryP(
    nPorts=1,
    p=100000,
    redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{40,10},{20,30}})));
  Utilities.Visualizers.displayReal conduction_2_m_flow(val=pipe_single.m_flows[
        2], precision=2)
            annotation (Placement(transformation(extent={{-26,48},{-6,68}})));
  Utilities.Visualizers.displayReal conduction_8_m_flow(val=pipe_single.m_flows[
        8], precision=2)
            annotation (Placement(transformation(extent={{4,48},{24,68}})));
  Utilities.Visualizers.displayReal conduction_2_p(val=pipe_single.mediums[2].p)
    annotation (Placement(transformation(extent={{-26,84},{-6,104}})));
  Utilities.Visualizers.displayReal conduction_8_p(val=pipe_single.mediums[8].p)
    annotation (Placement(transformation(extent={{4,84},{24,104}})));
  Utilities.Visualizers.displayReal boundaryM_m_flow(val=pipe_single.port_a.m_flow,
      precision=2)
    annotation (Placement(transformation(extent={{-52,48},{-32,68}})));
  Utilities.Visualizers.displayReal boundaryT_m_flow(val=pipe_single.port_b.m_flow,
      precision=2)
    annotation (Placement(transformation(extent={{30,48},{50,68}})));
  Utilities.Visualizers.displayReal boundaryM_C(precision=2, val=pipe_single.port_a.m_flow
        *pipe_single.port_a.C_outflow[1])
            annotation (Placement(transformation(extent={{-52,60},{-32,80}})));
  Utilities.Visualizers.displayReal boundaryC_C(precision=2, val=pipe_single.port_a.m_flow
        *pipe_single.port_b.C_outflow[1])
    annotation (Placement(transformation(extent={{30,60},{50,80}})));
  Utilities.Visualizers.displayReal boundaryM_n_flow1(val=pipe_single.port_a.m_flow
        *pipe_single.port_a.h_outflow)
    annotation (Placement(transformation(extent={{-52,72},{-32,92}})));
  Utilities.Visualizers.displayReal boundaryC_n_flow1(val=pipe_single.port_a.m_flow
        *pipe_single.port_b.h_outflow)
    annotation (Placement(transformation(extent={{30,72},{50,92}})));
  HeatAndMassTransfer.BoundaryConditions.Heat.Temperature boundaryQ_external(T=
        615.518)
    annotation (Placement(transformation(extent={{30,30},{10,50}})));
  HeatAndMassTransfer.BoundaryConditions.Mass.Concentration boundaryTM_external(
      C=fill(231.3, Medium.nC))
    annotation (Placement(transformation(extent={{-28,30},{-8,50}})));
  GenericPipe pipe_nParallel(
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyStateInitial,
    redeclare package Medium = Medium,
    use_HeatTransfer=true,
    redeclare model Geometry =
        TRANSFORM.Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.StraightPipe
        (                                                                 nV=10,
          dimension=0.01),
    use_TraceMassTransfer=true,
    nParallel=10,
    redeclare model HeatTransfer =
        TRANSFORM.Fluid.ClosureRelations.HeatTransfer.Models.DistributedPipe_1D.Alphas
        ( alpha0=1000),
    redeclare model TraceMassTransfer =
        TRANSFORM.Fluid.ClosureRelations.MassTransfer.Models.DistributedPipe_TraceMass_1D.AlphasM
        (                                               redeclare model
          DiffusionCoeff =
            TRANSFORM.Media.ClosureModels.MassDiffusionCoefficient.Models.GenericCoefficient
            (D_ab0=1), alphaM0=fill(1, Medium.nC)))
    annotation (Placement(transformation(extent={{-8,-90},{12,-70}})));
  Utilities.Visualizers.displayReal boundaryQ_p1(val=pipe_nParallel.port_a.p)
    annotation (Placement(transformation(extent={{-50,-16},{-30,4}})));
  Utilities.Visualizers.displayReal boundaryT_p1(val=pipe_nParallel.port_b.p)
    annotation (Placement(transformation(extent={{32,-16},{52,4}})));
  TRANSFORM.Fluid.BoundaryConditions.MassFlowSource_h boundaryM1(
    nPorts=1,
    m_flow=1,
    h=1e5,
    C=fill(0.1, Medium.nC),
    redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{-38,-90},{-18,-70}})));
  TRANSFORM.Fluid.BoundaryConditions.Boundary_ph boundaryP1(
    nPorts=1,
    redeclare package Medium = Medium,
    p=100000) annotation (Placement(transformation(extent={{42,-90},{22,-70}})));
  Utilities.Visualizers.displayReal conduction_2_m_flow1(val=pipe_nParallel.m_flows[
        2], precision=2)
    annotation (Placement(transformation(extent={{-24,-52},{-4,-32}})));
  Utilities.Visualizers.displayReal conduction_8_m_flow1(val=pipe_nParallel.m_flows[
        8], precision=2)
    annotation (Placement(transformation(extent={{6,-52},{26,-32}})));
  Utilities.Visualizers.displayReal conduction_2_p1(val=pipe_nParallel.mediums[
        2].p) annotation (Placement(transformation(extent={{-24,-16},{-4,4}})));
  Utilities.Visualizers.displayReal conduction_8_p1(val=pipe_nParallel.mediums[
        8].p) annotation (Placement(transformation(extent={{6,-16},{26,4}})));
  Utilities.Visualizers.displayReal boundaryM_m_flow1(val=pipe_nParallel.port_a.m_flow,
      precision=2)
    annotation (Placement(transformation(extent={{-50,-52},{-30,-32}})));
  Utilities.Visualizers.displayReal boundaryT_m_flow1(val=pipe_nParallel.port_b.m_flow,
      precision=2)
    annotation (Placement(transformation(extent={{32,-52},{52,-32}})));
  Utilities.Visualizers.displayReal boundaryM_C1(precision=2, val=pipe_single.port_a.m_flow
        *pipe_nParallel.port_a.C_outflow[1])
    annotation (Placement(transformation(extent={{-50,-40},{-30,-20}})));
  Utilities.Visualizers.displayReal boundaryC_C1(precision=2, val=pipe_single.port_a.m_flow
        *pipe_nParallel.port_b.C_outflow[1])
    annotation (Placement(transformation(extent={{32,-40},{52,-20}})));
  Utilities.Visualizers.displayReal boundaryM_n_flow2(val=pipe_single.port_a.m_flow
        *pipe_nParallel.port_a.h_outflow)
    annotation (Placement(transformation(extent={{-50,-28},{-30,-8}})));
  Utilities.Visualizers.displayReal boundaryC_n_flow2(val=pipe_single.port_a.m_flow
        *pipe_nParallel.port_b.h_outflow)
    annotation (Placement(transformation(extent={{32,-28},{52,-8}})));
  HeatAndMassTransfer.BoundaryConditions.Heat.Temperature boundaryQ_external1(T=
       329.0645)
    annotation (Placement(transformation(extent={{32,-70},{12,-50}})));
  HeatAndMassTransfer.BoundaryConditions.Mass.Concentration
    boundaryTM_external1(C=fill(202.639, Medium.nC))
    annotation (Placement(transformation(extent={{-26,-70},{-6,-50}})));
  Utilities.Visualizers.displayReal boundaryM_m_flow2(precision=2, val=
        pipe_single.massPorts[4].n_flow[1])
    annotation (Placement(transformation(extent={{50,6},{70,26}})));
  Utilities.Visualizers.displayReal boundaryM_C2(val=pipe_single.massPorts[4].C[
        1]) annotation (Placement(transformation(extent={{50,18},{70,38}})));
  Utilities.Visualizers.displayReal conduction_2_C2(val=pipe_single.heatPorts[4].T)
    annotation (Placement(transformation(extent={{76,18},{96,38}})));
  Utilities.Visualizers.displayReal conduction_2_m_flow2(val=pipe_single.heatPorts[
        4].Q_flow)
            annotation (Placement(transformation(extent={{76,6},{96,26}})));
  Utilities.Visualizers.displayReal boundaryM_m_flow3(precision=2, val=
        pipe_nParallel.massPorts[4].n_flow[1])
    annotation (Placement(transformation(extent={{50,-94},{70,-74}})));
  Utilities.Visualizers.displayReal boundaryM_C3(val=pipe_nParallel.massPorts[4].C[
        1]) annotation (Placement(transformation(extent={{50,-82},{70,-62}})));
  Utilities.Visualizers.displayReal conduction_2_C3(val=pipe_nParallel.heatPorts[
        4].T)
    annotation (Placement(transformation(extent={{76,-82},{96,-62}})));
  Utilities.Visualizers.displayReal conduction_2_m_flow3(val=pipe_nParallel.heatPorts[
        4].Q_flow)
            annotation (Placement(transformation(extent={{76,-94},{96,-74}})));
  Utilities.Visualizers.displayReal conduction_2_C(precision=2, val=pipe_single.mC_flows[
        2, 1])
    annotation (Placement(transformation(extent={{-26,60},{-6,80}})));
  Utilities.Visualizers.displayReal conduction_8_C(precision=2, val=pipe_single.mC_flows[
        8, 1])
    annotation (Placement(transformation(extent={{4,60},{24,80}})));
  Utilities.Visualizers.displayReal conduction_2_n_flow1(val=pipe_single.H_flows[
        2])
    annotation (Placement(transformation(extent={{-26,72},{-6,92}})));
  Utilities.Visualizers.displayReal conduction_8_n_flow1(val=pipe_single.H_flows[
        8])
    annotation (Placement(transformation(extent={{4,72},{24,92}})));
  Utilities.Visualizers.displayReal conduction_2_C1(precision=2, val=
        pipe_nParallel.mC_flows[2, 1])
    annotation (Placement(transformation(extent={{-24,-40},{-4,-20}})));
  Utilities.Visualizers.displayReal conduction_8_C1(precision=2, val=
        pipe_nParallel.mC_flows[8, 1])
    annotation (Placement(transformation(extent={{6,-40},{26,-20}})));
  Utilities.Visualizers.displayReal conduction_2_n_flow2(val=pipe_nParallel.H_flows[
        2]) annotation (Placement(transformation(extent={{-24,-28},{-4,-8}})));
  Utilities.Visualizers.displayReal conduction_8_n_flow2(val=pipe_nParallel.H_flows[
        8]) annotation (Placement(transformation(extent={{6,-28},{26,-8}})));
  TRANSFORM.Utilities.ErrorAnalysis.UnitTests unitTests(n=4, x={pipe_single.massPorts[
        4].C[1],pipe_nParallel.massPorts[4].C[1],pipe_single.heatPorts[4].T,
        pipe_nParallel.heatPorts[4].T})
    annotation (Placement(transformation(extent={{80,80},{100,100}})));
equation
  connect(pipe_single.port_a, boundaryM.ports[1]) annotation (Line(
      points={{-10,20},{-15,20},{-20,20}},
      color={0,127,255},
      thickness=0.5));
  connect(pipe_single.port_b, boundaryP.ports[1]) annotation (Line(
      points={{10,20},{20,20}},
      color={0,127,255},
      thickness=0.5));
  connect(boundaryTM_external.port, pipe_single.massPorts[4]) annotation (Line(
      points={{-8,40},{-4,40},{-4,25}},
      color={0,140,72},
      thickness=0.5));
  connect(boundaryQ_external.port, pipe_single.heatPorts[4]) annotation (Line(
      points={{10,40},{6,40},{0,40},{0,25}},
      color={191,0,0},
      thickness=0.5));
  connect(pipe_nParallel.port_a, boundaryM1.ports[1]) annotation (Line(
      points={{-8,-80},{-13,-80},{-18,-80}},
      color={0,127,255},
      thickness=0.5));
  connect(pipe_nParallel.port_b, boundaryP1.ports[1]) annotation (Line(
      points={{12,-80},{22,-80}},
      color={0,127,255},
      thickness=0.5));
  connect(boundaryTM_external1.port, pipe_nParallel.massPorts[4]) annotation (
      Line(
      points={{-6,-60},{-2,-60},{-2,-75}},
      color={0,140,72},
      thickness=0.5));
  connect(boundaryQ_external1.port, pipe_nParallel.heatPorts[4]) annotation (
      Line(
      points={{12,-60},{8,-60},{2,-60},{2,-75}},
      color={191,0,0},
      thickness=0.5));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false), graphics={
        Line(
          points={{-100,0},{100,0}},
          color={0,0,0},
          thickness=1),
        Text(
          extent={{-29.5,9.5},{29.5,-9.5}},
          lineColor={0,0,0},
          lineThickness=1,
          origin={-89.5,50.5},
          rotation=90,
          textString="Single Pipe"),
        Text(
          extent={{56,96},{80,90}},
          lineColor={0,0,0},
          lineThickness=1,
          textString="Pressure [Pa]"),
        Text(
          extent={{54,60},{80,54}},
          lineColor={0,0,0},
          lineThickness=1,
          textString="Mass Flow Rate [kg/s]"),
        Text(
          extent={{58,-4},{82,-10}},
          lineColor={0,0,0},
          lineThickness=1,
          textString="Pressure [Pa]"),
        Text(
          extent={{56,-40},{82,-46}},
          lineColor={0,0,0},
          lineThickness=1,
          textString="Mass Flow Rate [kg/s]"),
        Text(
          extent={{-29.5,9.5},{29.5,-9.5}},
          lineColor={0,0,0},
          lineThickness=1,
          origin={-89.5,-49.5},
          rotation=90,
          textString="10 identical parallel pipes"),
        Text(
          extent={{54,72},{92,66}},
          lineColor={0,0,0},
          lineThickness=1,
          textString="Trace Mass Flow Rate [kg/s]"),
        Text(
          extent={{54,84},{82,78}},
          lineColor={0,0,0},
          lineThickness=1,
          textString="Enthalpy Flow Rate [W]"),
        Text(
          extent={{56,-28},{94,-34}},
          lineColor={0,0,0},
          lineThickness=1,
          textString="Trace Mass Flow Rate [kg/s]"),
        Text(
          extent={{56,-16},{84,-22}},
          lineColor={0,0,0},
          lineThickness=1,
          textString="Enthalpy Flow Rate [W]")}),
    experiment(__Dymola_NumberOfIntervals=100));
end nParallel_StateBoundary;
