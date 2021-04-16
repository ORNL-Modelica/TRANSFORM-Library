within TRANSFORM.Chemistry.Thermochimica.Examples;
model EvaporatingPool_thermochimica
   extends TRANSFORM.Icons.Example;

  parameter Boolean use_AtomBased=false "else molar based";
  //switch MMs to avogadro's number to track for atoms in volumes.

  package Medium_salt = TRANSFORM.Media.Fluids.FLiBe.LinearFLiBe_9999Li7_pT (
        extraPropertiesNames=extraPropertiesNames_salt);
  package Medium_gas = Modelica.Media.IdealGases.SingleGases.N2 (
        extraPropertiesNames=extraPropertiesNames_salt, C_nominal=fill(1, nC_salt));


  parameter SI.Area surfaceArea = Modelica.Constants.pi*1^2;

  // Species tracked in the salt
  constant String extraPropertiesNames_salt[:]={"Li","F","Na","K","Cs"};
  constant Integer nC_salt=size(extraPropertiesNames_salt, 1) "Number of species";
  constant Integer atomicNumbers[nC_salt]={3,9,11,19,55};

  // Species tracked in the gas
  constant String extraPropertiesNames_gas[:]={"Li","LiF","Na","NaF","F2Na2","F3Na3","K","KF","K2F2","Cs"};
  constant Integer nC_gas=size(extraPropertiesNames_gas, 1) "Number of species";
  constant Integer speciesIndex[nC_gas]={1,2,3,4,5,6,7,8,9,10};

  // Method to relate gas species to salt species
  constant Real relationMatrix[nC_salt,nC_gas]=
  {
  {1,1,0,0,0,0,0,0,0,0},
  {0,1,0,1,2,3,0,1,2,0},
  {0,0,1,1,2,3,0,0,0,0},
  {0,0,0,0,0,0,1,1,2,0},
  {0,0,0,0,0,0,0,0,0,1}}
    "Element (row) to species (column) molar relation matrix";

  parameter SI.MolarMass MM_i_salt[nC_salt]={TRANSFORM.PeriodicTable.CalculateMolarMass(extraPropertiesNames_salt[
      i]) for i in 1:nC_salt} "Molecular weight of species";

    parameter SI.MolarMass MM_i_gas[nC_gas]={TRANSFORM.PeriodicTable.CalculateMolarMass(extraPropertiesNames_gas[
  i]) for i in 1:nC_gas} "Molecular weight of species";

  parameter SI.Temperature T_start_gas=500 + 273.15 "Initial temperature";

  parameter SI.Temperature T_start_salt=500 + 273.15 "Initial temperature";

  parameter SI.AbsolutePressure p_start_gas=1e5 "Initial head space pressure";

  parameter SIadd.ExtraProperty C_start_gas[nC_salt]=zeros(nC_salt) "Mass-Specific value";

  parameter SIadd.ExtraProperty C_salt_initial[nC_salt] = {1/MM_salt*sum(moleFrac_start_salt[:].*relationMatrix_salt[i,:])
                                                                                   for i in 1:nC_salt};
  constant SIadd.Mole unit_mole = 1.0;

  constant String saltNames[:] = {"LiF","NaF","KF","Cs","F2"};
  constant Integer nC_saltNames=size(saltNames, 1) "Number of species";
    constant Real relationMatrix_salt[nC_salt,nC_saltNames]=
  {
  {1,0,0,0,0},
  {1,1,1,0,2},
  {0,1,0,0,0},
  {0,0,1,0,0},
  {0,0,0,1,0}}
    "Element (row) to species (column) molar relation matrix";

  parameter SI.MoleFraction moleFrac_start_salt[nC_saltNames] = {0.4185,0.1035,0.378,0.1,0};
  parameter SI.MolarMass MM_salt = TRANSFORM.PeriodicTable.CalculateMolarMass_MoleFractionBased(saltNames,moleFrac_start_salt);

  parameter SI.Volume V_salt = 10;
  parameter SI.Density rho = Medium_salt.density_pT(p_start_gas,T_start_salt);
//   SIadd.Mole C_salt[nC_salt];

  TRANSFORM.Fluid.Volumes.SimpleVolume_1Port headSpace(
    showName=false,
    redeclare package Medium = Medium_gas,
    p_start=p_start_gas,
    T_start=T_start_gas,
    C_start=C_start_gas,
    redeclare model Geometry =
        TRANSFORM.Fluid.ClosureRelations.Geometry.Models.LumpedVolume.Cylinder (
         length=length.y, crossArea=surfaceArea),
    use_HeatPort=true,
    use_TraceMassPort=true,
    MMs=if use_AtomBased then fill(Modelica.Constants.N_A, nC_salt) else fill(1.0,
        nC_salt)) annotation (Placement(transformation(extent={{10,30},{30,50}})));
  TRANSFORM.Fluid.BoundaryConditions.MassFlowSource_T boundary_gas(
    showName=false,
    redeclare package Medium = Medium_gas,
    T=T_start_gas,
    nPorts=1) annotation (Placement(transformation(extent={{-60,30},{-40,50}})));

  Modelica.Blocks.Sources.RealExpression p_gas(y=p_start_gas)
    annotation (Placement(transformation(extent={{-100,30},{-80,50}})));
  Modelica.Blocks.Sources.RealExpression alpha(y=5)
    annotation (Placement(transformation(extent={{-100,10},{-80,30}})));
  Modelica.Blocks.Sources.RealExpression alphaM[nC_salt](y=fill(0.001, nC_salt))
    annotation (Placement(transformation(extent={{-100,-10},{-80,10}})));
  Modelica.Blocks.Sources.RealExpression length(y=1)
    annotation (Placement(transformation(extent={{-100,-50},{-80,-30}})));
  TRANSFORM.HeatAndMassTransfer.Resistances.Heat.Convection convection(
    showName=false,
      surfaceArea=surfaceArea, alpha=alpha.y) annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={20,20})));
  Modelica.Blocks.Sources.Pulse saltHeatInput(
    amplitude=8e6,
    period=9500,
    startTime=500) annotation (Placement(transformation(extent={{-98,-82},{-78,-62}})));
  TRANSFORM.HeatAndMassTransfer.Resistances.Mass.Convection convection_mass(
    showName=false,
    nC=nC_salt,
    surfaceArea=surfaceArea,
    alphaM=alphaM.y) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={50,22})));


  TRANSFORM.Chemistry.Thermochimica.Models.ThermochimicaOffgas offgas(
    T=volumeSalt.Medium.temperature(volumeSalt.state_liquid),
    p=volumeSalt.Medium.pressure(volumeSalt.state_liquid),
    showName=false,
    nC=nC_salt) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={40,-34})));

  Fluid.Volumes.ExpansionTank_1Port volumeSalt(
    redeclare package Medium = Medium_salt,
    A=surfaceArea,
    level_start=V_salt/surfaceArea,
    use_T_start=false,
    T_start=T_start_salt,
    h_start=volumeSalt.Medium.specificEnthalpy_pT(volumeSalt.p_start,
        T_start_salt),
    C_start=C_salt_initial,
    use_HeatPort=true,
    Q_gen=saltHeatInput.y,
    use_TraceMassPort=true,
    p_start=p_start_gas,
    p_surface=headSpace.port.p)
    annotation (Placement(transformation(extent={{-10,-30},{10,-10}})));
  Fluid.BoundaryConditions.MassFlowSource_T           boundary_salt(
    showName=false,
    redeclare package Medium = Medium_salt,
    T=T_start_salt,
    nPorts=1) annotation (Placement(transformation(extent={{-60,-50},{-40,-30}})));
equation
  connect(boundary_gas.ports[1], headSpace.port)
    annotation (Line(points={{-40,40},{14,40}}, color={0,127,255}));
  connect(headSpace.heatPort, convection.port_b)
    annotation (Line(points={{20,34},{20,27}}, color={191,0,0}));
  connect(headSpace.traceMassPort, convection_mass.port_b)
    annotation (Line(points={{24,36},{50,36},{50,29}}, color={0,140,72}));
  connect(boundary_salt.ports[1], volumeSalt.port)
    annotation (Line(points={{-40,-40},{0,-40},{0,-28.4}}, color={0,127,255}));
  connect(volumeSalt.traceMassPort, offgas.mass_port_a)
    annotation (Line(points={{6,-26},{6,-39},{33,-39}},           color={0,140,72}));
  connect(convection_mass.port_a, offgas.mass_port_b) annotation (Line(points={{50,15},{50,-20},{54,-20},{54,-39},{47,-39}},
                                                                                                           color={0,140,72}));
  connect(volumeSalt.heatPort, convection.port_a) annotation (Line(points={{8.4,-20},{20,-20},{20,13}}, color={191,0,0}));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    experiment(
      StopTime=20000,
      __Dymola_NumberOfIntervals=10000,
      __Dymola_Algorithm="Dassl"));
end EvaporatingPool_thermochimica;
