within TRANSFORM.HeatAndMassTransfer.Examples.ExamplesFrom_IncroperaAndDeWitt;
model Example_8_6_UninsulatedDuctwithMass
  "Example 8.6 Uninsulated Duct pp. 516-518"
  import TRANSFORM;
  extends Icons.Example;

  TRANSFORM.HeatAndMassTransfer.DiscritizedModels.HMTransfer_2D pipe(
    redeclare model Geometry =
        TRANSFORM.HeatAndMassTransfer.ClosureRelations.Geometry.Models.Cylinder_2D_r_z
        (
        nR=nNodes_1.k,
        nZ=nNodes_2.k,
        r_inner=0.5*D.y,
        length_z=L.y,
        r_outer=0.5*D.y + th.y),
    T_a1_start=0.5*(Tin.k + Tout.k),
    T_b1_start=Tambient.k,
    T_a2_start=Tin.k,
    T_b2_start=Tout.k,
    exposeState_b1=true,
    exposeState_b2=true,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyStateInitial,
    redeclare model DiffusionCoeff =
        TRANSFORM.Media.ClosureModels.MassDiffusionCoefficient.Models.GenericCoefficient
        (D_ab0=1e-2),
    redeclare package Material = TRANSFORM.Media.Solids.SS316)
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={0,0})));
  Modelica.Blocks.Sources.Constant alpha_ambient(each k=6)
    "heat transfer coefficient"
    annotation (Placement(transformation(extent={{-54,84},{-46,92}})));
  Modelica.Blocks.Sources.Constant th(each k=0.001) "thickness"
    annotation (Placement(transformation(extent={{-100,70},{-92,78}})));
  Modelica.Blocks.Sources.Constant m_flows(each k=0.05) "mass flow rate"
    annotation (Placement(transformation(extent={{-68,84},{-60,92}})));
  Modelica.Blocks.Sources.Constant Tin(k=
        TRANSFORM.Units.Conversions.Functions.Temperature_K.from_degC(103))
    "inlet temperature"
    annotation (Placement(transformation(extent={{-84,84},{-76,92}})));
  Modelica.Blocks.Sources.Constant Tambient(k=
        TRANSFORM.Units.Conversions.Functions.Temperature_K.from_degC(0))
    "ambient temperature"
    annotation (Placement(transformation(extent={{-84,56},{-76,64}})));
  Modelica.Blocks.Sources.Constant D(k=0.15) "diameter"
    annotation (Placement(transformation(extent={{-100,84},{-92,92}})));
  Modelica.Blocks.Sources.IntegerConstant nNodes_1(k=2)
    annotation (Placement(transformation(extent={{-26,84},{-18,92}})));
  TRANSFORM.HeatAndMassTransfer.BoundaryConditions.Heat.Temperature fluid[
    nNodes_2.k](each use_port=true) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,-50})));
  TRANSFORM.HeatAndMassTransfer.Resistances.Heat.ConvectionMedia innerSide(
    n=nNodes_2.k,
    dimensions=fill(D.y, innerSide.n),
    crossAreas=fill(Ac.y, innerSide.n),
    dlengths=pipe.geometry.dlengths_2[1, :],
    surfaceAreas=pipe.geometry.crossAreas_1[1, :],
    redeclare package Medium = ThermoPower.Media.Air,
    roughnesses=fill(0, innerSide.n),
    redeclare model HeatTransferCoeff =
        TRANSFORM.HeatAndMassTransfer.ClosureRelations.HeatTransfer.Models.Nus_SinglePhase_2Region,
    m_flows=fill(m_flows.y, innerSide.n)) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={0,-24})));

  Modelica.Blocks.Sources.IntegerConstant nNodes_2(k=10)
    annotation (Placement(transformation(extent={{-12,84},{-4,92}})));
  Modelica.Blocks.Sources.Constant Tout(k=
        TRANSFORM.Units.Conversions.Functions.Temperature_K.from_degC(77))
    "outlet temperature"
    annotation (Placement(transformation(extent={{-84,70},{-76,78}})));
  TRANSFORM.HeatAndMassTransfer.Resistances.Heat.Convection outerSide[nNodes_2.k](
     each alpha=alpha_ambient.y, surfaceArea=pipe.geometry.crossAreas_1[end, :])
    annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={0,30})));
  TRANSFORM.HeatAndMassTransfer.BoundaryConditions.Heat.Adiabatic outlet[
    nNodes_1.k] annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={30,0})));
  TRANSFORM.HeatAndMassTransfer.BoundaryConditions.Heat.Adiabatic inlet[
    nNodes_1.k] annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={-30,0})));
  Modelica.Blocks.Sources.RealExpression Ac(y=0.25*Modelica.Constants.pi*D.y^2)
    "cross sectional flow area"
    annotation (Placement(transformation(extent={{-100,30},{-80,52}})));
  TRANSFORM.HeatAndMassTransfer.BoundaryConditions.Heat.Temperature ambient[
    nNodes_2.k](each use_port=true) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={0,50})));
  Modelica.Blocks.Sources.Constant L(each k=5) "pipe length"
    annotation (Placement(transformation(extent={{-100,56},{-92,64}})));
  Modelica.Blocks.Sources.RealExpression Q_loss(y=sum(outerSide.port_a.Q_flow))
    "total flow rate to ambient"
    annotation (Placement(transformation(extent={{-100,-11},{-80,11}})));
  Utilities.Visualizers.displayReal display_Q_loss(use_port=true)
    annotation (Placement(transformation(extent={{-68,-10},{-48,10}})));
  Modelica.Blocks.Sources.RealExpression T_L(y=
        TRANSFORM.Units.Conversions.Functions.Temperature_K.to_degC(outerSide[
        end].port_a.T)) "Temperature at x = L"
    annotation (Placement(transformation(extent={{-100,-31},{-80,-9}})));
  Utilities.Visualizers.displayReal display_T_L(use_port=true)
    annotation (Placement(transformation(extent={{-68,-30},{-48,-10}})));
  Modelica.Blocks.Sources.RealExpression Q_flux_L(y=outerSide[end].port_a.Q_flow
        /pipe.geometry.crossAreas_1[end, end])
    "Heat flux at outer surface at x = L"
    annotation (Placement(transformation(extent={{-100,-51},{-80,-29}})));
  Utilities.Visualizers.displayReal display_Q_flux_L(use_port=true)
    annotation (Placement(transformation(extent={{-68,-50},{-48,-30}})));
  Modelica.Blocks.Sources.RealExpression T_ambient[nNodes_2.k](each y=Tambient.y)
    annotation (Placement(transformation(extent={{30,50},{10,72}})));
  Modelica.Blocks.Sources.RealExpression T_fluid[nNodes_2.k](y=linspace(
        Tin.y,
        Tout.y,
        nNodes_2.k))
    annotation (Placement(transformation(extent={{30,-72},{10,-50}})));
  TRANSFORM.HeatAndMassTransfer.Resistances.Mass.ConvectionMedia innerSideM(
    dlengths=pipe.geometry.dlengths_2[1, :],
    surfaceAreas=pipe.geometry.crossAreas_1[1, :],
    redeclare package Medium = ThermoPower.Media.Air,
    Ts_wall=fluid.port.T,
    m_flows=fill(m_flows.y, innerSideM.n),
    dimensions=fill(D.y, innerSideM.n),
    crossAreas=fill(Ac.y, innerSideM.n),
    roughnesses=fill(0, innerSide.n),
    n=nNodes_2.k) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-20,-24})));
  TRANSFORM.HeatAndMassTransfer.BoundaryConditions.Mass.AdiabaticMass inletM[
    nNodes_1.k] annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={-30,20})));
  TRANSFORM.HeatAndMassTransfer.BoundaryConditions.Mass.AdiabaticMass outletM[
    nNodes_1.k] annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={30,20})));
  TRANSFORM.HeatAndMassTransfer.Resistances.Mass.Convection outerSideM[
                                                                      nNodes_2.k](
                                 surfaceArea=pipe.geometry.crossAreas_1[end, :], each
      alphaM=alphaM_ambient.y)
    annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={-28,48})));
  TRANSFORM.HeatAndMassTransfer.BoundaryConditions.Mass.Concentration ambientM[
    nNodes_2.k](each use_port=true) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-28,70})));
  TRANSFORM.HeatAndMassTransfer.BoundaryConditions.Mass.Concentration fluidM[
    nNodes_2.k](each use_port=true) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-20,-50})));
  Modelica.Blocks.Sources.RealExpression C_fluid[nNodes_2.k](y=linspace(
        Cin.y,
        Cout.y,
        nNodes_2.k))
    annotation (Placement(transformation(extent={{10,-88},{-10,-66}})));
  Modelica.Blocks.Sources.Constant Cin(k=1) "inlet concentration"
    annotation (Placement(transformation(extent={{76,-56},{84,-48}})));
  Modelica.Blocks.Sources.Constant Cout(k=2) "outlet concentration"
    annotation (Placement(transformation(extent={{76,-70},{84,-62}})));
  Modelica.Blocks.Sources.RealExpression C_ambient[nNodes_2.k](each y=Cambient.y)
    annotation (Placement(transformation(extent={{30,66},{10,88}})));
  Modelica.Blocks.Sources.Constant Cambient(k=0) "ambient concentration"
    annotation (Placement(transformation(extent={{76,-84},{84,-76}})));
  Modelica.Blocks.Sources.Constant alphaM_ambient[1](each k=6)
    "mass transfer coefficient"
    annotation (Placement(transformation(extent={{90,-56},{98,-48}})));
  TRANSFORM.Utilities.ErrorAnalysis.UnitTests unitTests(n=2, x={pipe.portM_a1[5].C[
        1],pipe.portM_b1[5].C[1]})
    annotation (Placement(transformation(extent={{80,80},{100,100}})));
equation
  connect(pipe.port_b2, outlet.port)
    annotation (Line(points={{10,0},{15,0},{20,0}}, color={191,0,0}));
  connect(innerSide.port_a, pipe.port_a1)
    annotation (Line(points={{0,-17},{0,-10}}, color={191,0,0}));
  connect(outerSide.port_a, pipe.port_b1)
    annotation (Line(points={{0,23},{0,23},{0,10}}, color={191,0,0}));
  connect(inlet.port, pipe.port_a2)
    annotation (Line(points={{-20,0},{-15,0},{-10,0}}, color={191,0,0}));
  connect(ambient.port, outerSide.port_b)
    annotation (Line(points={{0,40},{0,37}}, color={191,0,0}));
  connect(fluid.port, innerSide.port_b)
    annotation (Line(points={{0,-40},{0,-31}}, color={191,0,0}));
  connect(Q_loss.y, display_Q_loss.u)
    annotation (Line(points={{-79,0},{-75.5,0},{-69.5,0}}, color={0,0,127}));
  connect(T_L.y, display_T_L.u)
    annotation (Line(points={{-79,-20},{-69.5,-20}}, color={0,0,127}));
  connect(Q_flux_L.y, display_Q_flux_L.u)
    annotation (Line(points={{-79,-40},{-69.5,-40}}, color={0,0,127}));
  connect(T_fluid.y, fluid.T_ext)
    annotation (Line(points={{9,-61},{0,-61},{0,-54}}, color={0,0,127}));
  connect(T_ambient.y, ambient.T_ext)
    annotation (Line(points={{9,61},{0,61},{0,54}}, color={0,0,127}));
  connect(C_fluid.y, fluidM.C_ext[1])
    annotation (Line(points={{-11,-77},{-20,-77},{-20,-54}}, color={0,0,127}));
  connect(C_ambient.y, ambientM.C_ext[1])
    annotation (Line(points={{9,77},{-28,77},{-28,74}}, color={0,0,127}));
  connect(ambientM.port, outerSideM.port_b) annotation (Line(
      points={{-28,60},{-28,55}},
      color={0,140,72},
      thickness=0.5));
  connect(outerSideM.port_a, pipe.portM_b1) annotation (Line(
      points={{-28,41},{-28,34},{-10,34},{-10,10},{-4,10}},
      color={0,140,72},
      thickness=0.5));
  connect(inletM.port, pipe.portM_a2) annotation (Line(
      points={{-20,20},{-16,20},{-16,4},{-9.8,4}},
      color={0,140,72},
      thickness=0.5));
  connect(outletM.port, pipe.portM_b2) annotation (Line(
      points={{20,20},{14,20},{14,4},{10,4}},
      color={0,140,72},
      thickness=0.5));
  connect(innerSideM.port_b, fluidM.port) annotation (Line(
      points={{-20,-31},{-20,-35.5},{-20,-40}},
      color={0,140,72},
      thickness=0.5));
  connect(innerSideM.port_a, pipe.portM_a1) annotation (Line(
      points={{-20,-17},{-20,-14},{-4,-14},{-4,-10}},
      color={0,140,72},
      thickness=0.5));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(__Dymola_NumberOfIntervals=100));
end Example_8_6_UninsulatedDuctwithMass;
