within TRANSFORM.HeatAndMassTransfer.Examples;
model nParallel_Test
  extends TRANSFORM.Icons.Example;
  DiscritizedModels.HMTransfer_1D conduction_single(
    redeclare model Geometry =
        TRANSFORM.HeatAndMassTransfer.ClosureRelations.Geometry.Models.Plane_1D
        ( nX=10),
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyStateInitial,
    redeclare model DiffusionCoeff =
        TRANSFORM.Media.ClosureModels.MassDiffusionCoefficient.Models.GenericCoefficient
        (D_ab0=0.01),
    redeclare package Material = Media.Solids.SS316)
    annotation (Placement(transformation(extent={{-10,48},{10,68}})));
  Utilities.Visualizers.displayReal boundaryQ_T(val=boundaryQ.port.T)
    annotation (Placement(transformation(extent={{-52,84},{-32,104}})));
  Utilities.Visualizers.displayReal boundaryT_T(val=boundaryT.port.T)
    annotation (Placement(transformation(extent={{30,84},{50,104}})));
  BoundaryConditions.Heat.HeatFlow boundaryQ(Q_flow=1000)
    annotation (Placement(transformation(extent={{-40,48},{-20,68}})));
  BoundaryConditions.Heat.Temperature boundaryT
    annotation (Placement(transformation(extent={{40,48},{20,68}})));
  Utilities.Visualizers.displayReal conduction_2_Q_flow(val=conduction_single.Q_flows_1
        [2]) annotation (Placement(transformation(extent={{-26,68},{-6,88}})));
  Utilities.Visualizers.displayReal conduction_8_Q_flow(val=conduction_single.Q_flows_1
        [8]) annotation (Placement(transformation(extent={{4,68},{24,88}})));
  Utilities.Visualizers.displayReal conduction_2_T(val=conduction_single.materials[
        2].T) annotation (Placement(transformation(extent={{-26,84},{-6,104}})));
  Utilities.Visualizers.displayReal conduction_8_T(val=conduction_single.materials[
        8].T) annotation (Placement(transformation(extent={{4,84},{24,104}})));
  Utilities.Visualizers.displayReal boundaryQ_Q_flow(val=boundaryQ.port.Q_flow)
    annotation (Placement(transformation(extent={{-52,68},{-32,88}})));
  Utilities.Visualizers.displayReal boundaryT_Q_flow(val=boundaryT.port.Q_flow)
    annotation (Placement(transformation(extent={{30,68},{50,88}})));
  DiscritizedModels.HMTransfer_1D conduction_nParallel(
    redeclare model Geometry =
        TRANSFORM.HeatAndMassTransfer.ClosureRelations.Geometry.Models.Plane_1D
        ( nX=10),
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyStateInitial,
    nParallel=10,
    redeclare model DiffusionCoeff =
        TRANSFORM.Media.ClosureModels.MassDiffusionCoefficient.Models.GenericCoefficient
        (D_ab0=0.01),
    redeclare package Material = Media.Solids.SS316)
    annotation (Placement(transformation(extent={{-10,-54},{10,-34}})));
  Utilities.Visualizers.displayReal boundaryQ_T1(val=boundaryQ1.port.T)
    annotation (Placement(transformation(extent={{-52,-18},{-32,2}})));
  Utilities.Visualizers.displayReal boundaryT_T1(val=boundaryT1.port.T)
    annotation (Placement(transformation(extent={{30,-18},{50,2}})));
  BoundaryConditions.Heat.HeatFlow boundaryQ1(Q_flow=1000)
    annotation (Placement(transformation(extent={{-40,-54},{-20,-34}})));
  BoundaryConditions.Heat.Temperature boundaryT1
    annotation (Placement(transformation(extent={{40,-54},{20,-34}})));
  Utilities.Visualizers.displayReal conduction_2_Q_flow1(val=
        conduction_nParallel.Q_flows_1[2])
    annotation (Placement(transformation(extent={{-26,-34},{-6,-14}})));
  Utilities.Visualizers.displayReal conduction_8_Q_flow1(val=
        conduction_nParallel.Q_flows_1[8])
    annotation (Placement(transformation(extent={{4,-34},{24,-14}})));
  Utilities.Visualizers.displayReal conduction_2_T1(val=conduction_nParallel.materials[
        2].T) annotation (Placement(transformation(extent={{-26,-18},{-6,2}})));
  Utilities.Visualizers.displayReal conduction_8_T1(val=conduction_nParallel.materials[
        8].T) annotation (Placement(transformation(extent={{4,-18},{24,2}})));
  Utilities.Visualizers.displayReal boundaryQ_Q_flow1(val=boundaryQ1.port.Q_flow)
    annotation (Placement(transformation(extent={{-52,-34},{-32,-14}})));
  Utilities.Visualizers.displayReal boundaryT_Q_flow1(val=boundaryT1.port.Q_flow)
    annotation (Placement(transformation(extent={{30,-34},{50,-14}})));
  BoundaryConditions.Mass.MassFlow boundaryM(n_flow=fill(1, boundaryM.nC))
    annotation (Placement(transformation(extent={{-40,28},{-20,48}})));
  BoundaryConditions.Mass.Concentration boundaryC
    annotation (Placement(transformation(extent={{40,28},{20,48}})));
  Utilities.Visualizers.displayReal boundaryM_C(val=boundaryM.port.C[1],
      precision=1)
    annotation (Placement(transformation(extent={{-52,14},{-32,34}})));
  Utilities.Visualizers.displayReal boundaryC_C(val=boundaryC.port.C[1],
      precision=1)
    annotation (Placement(transformation(extent={{30,14},{50,34}})));
  Utilities.Visualizers.displayReal conduction_2_n_flow(val=conduction_single.nC_flows_1
        [2, 1], precision=1)
    annotation (Placement(transformation(extent={{-26,-2},{-6,18}})));
  Utilities.Visualizers.displayReal conduction_8_n_flow(val=conduction_single.nC_flows_1
        [8, 1], precision=1)
    annotation (Placement(transformation(extent={{4,-2},{24,18}})));
  Utilities.Visualizers.displayReal conduction_2_C(val=conduction_single.Cs[2, 1],
      precision=1)
    annotation (Placement(transformation(extent={{-26,14},{-6,34}})));
  Utilities.Visualizers.displayReal conduction_8_C(val=conduction_single.Cs[8, 1],
      precision=1)
    annotation (Placement(transformation(extent={{4,14},{24,34}})));
  Utilities.Visualizers.displayReal boundaryM_n_flow(val=boundaryM.port.n_flow[1],
      precision=1)
    annotation (Placement(transformation(extent={{-52,-2},{-32,18}})));
  Utilities.Visualizers.displayReal boundaryC_n_flow(val=boundaryC.port.n_flow[1],
      precision=1)
    annotation (Placement(transformation(extent={{30,-2},{50,18}})));
  Utilities.Visualizers.displayReal boundaryM_C1(val=boundaryM1.port.C[1],
      precision=1)
    annotation (Placement(transformation(extent={{-52,-88},{-32,-68}})));
  Utilities.Visualizers.displayReal boundaryC_C1(val=boundaryC1.port.C[1],
      precision=1)
    annotation (Placement(transformation(extent={{30,-88},{50,-68}})));
  Utilities.Visualizers.displayReal conduction_2_n_flow1(val=
        conduction_nParallel.nC_flows_1[2, 1], precision=2)
    annotation (Placement(transformation(extent={{-26,-104},{-6,-84}})));
  Utilities.Visualizers.displayReal conduction_8_n_flow1(val=
        conduction_nParallel.nC_flows_1[8, 1], precision=2)
    annotation (Placement(transformation(extent={{4,-104},{24,-84}})));
  Utilities.Visualizers.displayReal conduction_2_C1(val=conduction_nParallel.Cs[
        2, 1], precision=1)
    annotation (Placement(transformation(extent={{-26,-88},{-6,-68}})));
  Utilities.Visualizers.displayReal conduction_8_C1(val=conduction_nParallel.Cs[
        8, 1], precision=1)
    annotation (Placement(transformation(extent={{4,-88},{24,-68}})));
  Utilities.Visualizers.displayReal boundaryM_n_flow1(val=boundaryM1.port.n_flow[
        1], precision=1)
    annotation (Placement(transformation(extent={{-52,-104},{-32,-84}})));
  Utilities.Visualizers.displayReal boundaryC_n_flow1(val=boundaryC1.port.n_flow[
        1], precision=1)
    annotation (Placement(transformation(extent={{30,-104},{50,-84}})));
  BoundaryConditions.Mass.MassFlow boundaryM1(n_flow=fill(1, boundaryM1.nC))
    annotation (Placement(transformation(extent={{-40,-74},{-20,-54}})));
  BoundaryConditions.Mass.Concentration boundaryC1
    annotation (Placement(transformation(extent={{40,-74},{20,-54}})));
  BoundaryConditions.Heat.HeatFlow boundaryQ_exterior(Q_flow=100)
    annotation (Placement(transformation(extent={{-62,40},{-42,60}})));
  BoundaryConditions.Heat.HeatFlow boundaryQ_exterior1(Q_flow=100)
    annotation (Placement(transformation(extent={{-60,-62},{-40,-42}})));
  BoundaryConditions.Mass.MassFlow boundaryM_exterior(n_flow=fill(0.1,
        boundaryM.nC))
    annotation (Placement(transformation(extent={{-76,20},{-56,40}})));
  BoundaryConditions.Mass.MassFlow boundaryM_exterior1(n_flow=fill(0.1,
        boundaryM1.nC))
    annotation (Placement(transformation(extent={{-76,-82},{-56,-62}})));
  Utilities.ErrorAnalysis.UnitTests unitTests(n=8, x={boundaryQ_Q_flow.val,
        conduction_2_Q_flow.val,boundaryQ_Q_flow1.val,conduction_2_Q_flow1.val,
        boundaryM_n_flow.val,conduction_2_n_flow.val,boundaryM_n_flow1.val,
        conduction_2_n_flow1.val})
    annotation (Placement(transformation(extent={{80,80},{100,100}})));
equation
  connect(boundaryQ.port, conduction_single.port_a1) annotation (Line(
      points={{-20,58},{-15,58},{-10,58}},
      color={191,0,0},
      thickness=0.5));
  connect(conduction_single.port_b1, boundaryT.port) annotation (Line(
      points={{10,58},{15,58},{20,58}},
      color={191,0,0},
      thickness=0.5));
  connect(boundaryQ1.port, conduction_nParallel.port_a1) annotation (Line(
      points={{-20,-44},{-20,-44},{-10,-44}},
      color={191,0,0},
      thickness=0.5));
  connect(conduction_nParallel.port_b1, boundaryT1.port) annotation (Line(
      points={{10,-44},{10,-44},{20,-44}},
      color={191,0,0},
      thickness=0.5));
  connect(boundaryM.port, conduction_single.portM_a1) annotation (Line(
      points={{-20,38},{-14,38},{-14,54},{-10,54}},
      color={0,140,72},
      thickness=0.5));
  connect(boundaryC.port, conduction_single.portM_b1) annotation (Line(
      points={{20,38},{14,38},{14,54},{10,54}},
      color={0,140,72},
      thickness=0.5));
  connect(boundaryM1.port, conduction_nParallel.portM_a1) annotation (Line(
      points={{-20,-64},{-18,-64},{-14,-64},{-14,-48},{-10,-48}},
      color={0,140,72},
      thickness=0.5));
  connect(boundaryC1.port, conduction_nParallel.portM_b1) annotation (Line(
      points={{20,-64},{14,-64},{14,-48},{10,-48}},
      color={0,140,72},
      thickness=0.5));
  connect(boundaryQ_exterior.port, conduction_single.port_external[2])
    annotation (Line(
      points={{-42,50},{-32,50},{-8,50}},
      color={191,0,0},
      thickness=0.5));
  connect(boundaryQ_exterior1.port, conduction_nParallel.port_external[2])
    annotation (Line(
      points={{-40,-52},{-34,-52},{-8,-52}},
      color={191,0,0},
      thickness=0.5));
  connect(boundaryM_exterior.port, conduction_single.portM_external[2])
    annotation (Line(
      points={{-56,30},{-32,30},{-6,30},{-6,48}},
      color={0,140,72},
      thickness=0.5));
  connect(boundaryM_exterior1.port, conduction_nParallel.portM_external[2])
    annotation (Line(
      points={{-56,-72},{-6,-72},{-6,-54}},
      color={0,140,72},
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
          textString="Single Conduction Element",
          origin={-89.5,50.5},
          rotation=90),
        Text(
          extent={{-30,10},{30,-10}},
          lineColor={0,0,0},
          lineThickness=1,
          origin={-90,-50},
          rotation=90,
          textString="10 identical parallel
conduction elements"),
        Text(
          extent={{56,96},{80,90}},
          lineColor={0,0,0},
          lineThickness=1,
          textString="Temperature [K]"),
        Text(
          extent={{54,80},{80,74}},
          lineColor={0,0,0},
          lineThickness=1,
          textString="Heat Flow Rate [W]"),
        Text(
          extent={{54,10},{82,4}},
          lineColor={0,0,0},
          lineThickness=1,
          textString="Mole Flow Rate [mol/s]"),
        Text(
          extent={{54,26},{82,20}},
          lineColor={0,0,0},
          lineThickness=1,
          textString="Concentration [mol/m3]"),
        Text(
          extent={{54,-22},{80,-28}},
          lineColor={0,0,0},
          lineThickness=1,
          textString="Heat Flow Rate [W]"),
        Text(
          extent={{56,-6},{80,-12}},
          lineColor={0,0,0},
          lineThickness=1,
          textString="Temperature [K]"),
        Text(
          extent={{52,-92},{80,-98}},
          lineColor={0,0,0},
          lineThickness=1,
          textString="Mole Flow Rate [mol/s]"),
        Text(
          extent={{52,-76},{80,-82}},
          lineColor={0,0,0},
          lineThickness=1,
          textString="Concentration [mol/m3]")}),
    experiment(__Dymola_NumberOfIntervals=100));
end nParallel_Test;
