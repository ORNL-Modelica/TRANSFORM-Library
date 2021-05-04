within TRANSFORM.Chemistry.Thermochimica.Examples;
model OffgasAndSkimmer_thermochimica
   extends TRANSFORM.Icons.Example;

  parameter Boolean use_AtomBased=false "else molar based";
  //switch MMs to avogadro's number to track for atoms in volumes.

  package Medium_salt = TRANSFORM.Media.Fluids.FLiBe.LinearFLiBe_9999Li7_pT (
        extraPropertiesNames=extraPropertiesNames_salt);
  package Medium_gas = Modelica.Media.IdealGases.SingleGases.N2 (
        extraPropertiesNames=extraPropertiesNames_salt, C_nominal=fill(1, nC_salt));

  parameter SI.Temperature T_start_gas=500 + 273.15 "Initial temperature";
  // Species tracked in the gas
  constant String extraPropertiesNames_gas[:]={"Li","LiF","Na","NaF","F2Na2","F3Na3","K","KF","K2F2","Cs","U","FU","F2U","UF3","UF4","Pu","PuF","PuF2","PuF3","F4Pu","PuF6"};
  constant Integer nC_gas=size(extraPropertiesNames_gas, 1) "Number of species";
  constant Integer speciesIndex[nC_gas]={1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21};

  // Method to relate gas species to salt species
  constant Real relationMatrix[nC_salt,nC_gas]=
  {
  {1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
  {0,1,0,1,2,3,0,1,2,0,0,1,2,3,4,0,1,2,3,4,6},
  {0,0,1,1,2,3,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
  {0,0,0,0,0,0,1,1,2,0,0,0,0,0,0,0,0,0,0,0,0},
  {0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0},
  {0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,0},
  {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1}}
    "Element (row) to species (column) molar relation matrix";

  parameter SI.Area surfaceArea = Modelica.Constants.pi*1^2;

  // Species tracked in the salt
  constant String extraPropertiesNames_salt[:]={"Li","F","Na","K","Cs","U","Pu"};
  constant Integer nC_salt=size(extraPropertiesNames_salt, 1) "Number of species";

  parameter SI.MolarMass MM_i_salt[nC_salt]={TRANSFORM.PeriodicTable.CalculateMolarMass(extraPropertiesNames_salt[
      i]) for i in 1:nC_salt} "Molecular weight of species";

  parameter SI.Temperature T_start_salt=550 + 273.15 "Initial temperature";

  parameter SI.AbsolutePressure p_start_gas=1e5 "Initial head space pressure";

  parameter SIadd.ExtraProperty C_start_gas[nC_salt]=zeros(nC_salt) "Mass-Specific value";

  parameter SIadd.ExtraProperty C_salt_initial[nC_salt] = {1/MM_salt*sum(moleFrac_start_salt[:].*relationMatrix_salt[i,:])
                                                                                   for i in 1:nC_salt};
  constant SIadd.Mole unit_mole = 1.0;

  constant String saltNames[:] = {"LiF","NaF","KF","Cs","UF3","UF4","PuF3"};
  constant Integer nC_saltNames=size(saltNames, 1) "Number of species";
  constant Real relationMatrix_salt[nC_salt,nC_saltNames]=
  {
  {1,0,0,0,0,0,0},
  {1,1,1,0,3,4,3},
  {0,1,0,0,0,0,0},
  {0,0,1,0,0,0,0},
  {0,0,0,1,0,0,0},
  {0,0,0,0,1,1,0},
  {0,0,0,0,0,0,1}}
     "Element (row) to species (column) molar relation matrix";

   parameter SI.MoleFraction moleFrac_start_salt[nC_saltNames] = {0.42,0.10,0.37,0.01,0.0001,0.0099,0.09};
  parameter SI.MolarMass MM_salt = TRANSFORM.PeriodicTable.CalculateMolarMass_MoleFractionBased(saltNames,moleFrac_start_salt);

  parameter SI.Volume V_salt = 10;
  parameter SI.Density rho = Medium_salt.density_pT(p_start_gas,T_start_salt);

  Real totalM[nC_salt] = skimmer.m_skimmed + volumeSalt.C*volumeSalt.m;

  Modelica.Blocks.Sources.RealExpression p_gas(y=p_start_gas)
    annotation (Placement(transformation(extent={{-100,30},{-80,50}})));
  Modelica.Blocks.Sources.RealExpression alpha(y=5)
    annotation (Placement(transformation(extent={{-100,10},{-80,30}})));
  Modelica.Blocks.Sources.RealExpression alphaM[nC_salt](y=fill(0.001, nC_salt))
    annotation (Placement(transformation(extent={{-100,-10},{-80,10}})));
  Modelica.Blocks.Sources.RealExpression length(y=1)
    annotation (Placement(transformation(extent={{-100,-50},{-80,-30}})));
  Modelica.Blocks.Sources.Pulse saltHeatInput(
    amplitude=-0e5,
    period=9500,
    startTime=500) annotation (Placement(transformation(extent={{-98,-82},{-78,-62}})));

  TRANSFORM.Chemistry.Thermochimica.Models.ThermochimicaSkimmer skimmer(
    redeclare package Medium = Medium_salt,
    showName=false,
    C_start=C_salt_initial,
    C_input=volumeSalt.C)
                        annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-54,-6})));

  Fluid.Machines.Pump_SimpleMassFlow pump_PFL(
    redeclare package Medium = Medium_salt,
    m_flow_nominal=2*3*data_PHX.m_flow_tube,
    use_input=true)
    annotation (Placement(transformation(extent={{-10,28},{10,48}})));
  Fluid.Volumes.ExpansionTank volumeSalt(
    redeclare package Medium = Medium_salt,
    A=surfaceArea,
    level_start=V_salt/surfaceArea,
    h_start=volumeSalt.Medium.specificEnthalpy_pT(volumeSalt.p_start, T_start_salt),
    C_start=C_salt_initial,
    use_HeatPort=true,
    Q_gen=saltHeatInput.y,
    use_TraceMassPort=true,
    p_start=p_start_gas)
    annotation (Placement(transformation(
        extent={{10,36},{-10,56}},
        rotation=0,
        origin={-10,-88})));
  Modelica.Blocks.Sources.RealExpression m_flow_pump_PFL(y=data_PHX.m_flow_tube/(1 - x_bypass.y))
    annotation (Placement(transformation(extent={{44,56},{24,76}})));
  Modelica.Blocks.Sources.Constant x_bypass(k=0.1)
    annotation (Placement(transformation(extent={{-98,58},{-78,78}})));
  TRANSFORM.Examples.MoltenSaltReactor.Data.data_PHX
                data_PHX
    annotation (Placement(transformation(extent={{-62,62},{-42,82}})));
  Models.ThermochimicaOffgas offgas(redeclare package Medium = Medium_salt,
    T=volumeSalt.Medium.temperature(volumeSalt.state_liquid),
    p=volumeSalt.Medium.pressure(volumeSalt.state_liquid),
    extraPropertiesNames_gas=extraPropertiesNames_gas,
    nC_gas=nC_gas,
    speciesIndex=speciesIndex,
    relationMatrix=relationMatrix,showName=false) annotation (Placement(transformation(extent={{-30,-88},{-10,-68}})));
  Fluid.BoundaryConditions.MassFlowSource_T           boundary_gas(
    showName=false,
    redeclare package Medium = Medium_gas,
    T=T_start_gas,
    nPorts=1) annotation (Placement(transformation(extent={{44,-42},{64,-22}})));
  HeatAndMassTransfer.Resistances.Heat.Convection           convection(
    showName=false,
    surfaceArea=surfaceArea,
    alpha=alpha.y)                            annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={20,-64})));
  HeatAndMassTransfer.Resistances.Mass.Convection           convection_mass(
    showName=false,
    nC=nC_salt,
    surfaceArea=surfaceArea,
    alphaM=alphaM.y) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={20,-86})));
  Fluid.Volumes.SimpleVolume_1Port           headSpace(
    showName=false,
    redeclare package Medium = Medium_gas,
    p_start=p_start_gas,
    T_start=T_start_gas,
    C_start=C_start_gas,
    redeclare model Geometry = Fluid.ClosureRelations.Geometry.Models.LumpedVolume.Cylinder (length=length.y, crossArea=surfaceArea),
    use_HeatPort=true,
    use_TraceMassPort=true,
    MMs=if use_AtomBased then fill(Modelica.Constants.N_A, nC_salt) else fill(1.0, nC_salt))
                  annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={66,-74})));

equation
  connect(pump_PFL.port_b, volumeSalt.port_a) annotation (Line(points={{10,38},{14,38},{14,-48},{-3,-48}},color={0,127,255}));
  connect(volumeSalt.port_b, skimmer.port_a) annotation (Line(points={{-17,-48},{-70,-48},{-70,-6},{-64,-6}},color={0,127,255}));
  connect(m_flow_pump_PFL.y, pump_PFL.in_m_flow) annotation (Line(points={{23,66},{0,66},{0,45.3}}, color={0,0,127}));
  connect(skimmer.port_b, pump_PFL.port_a) annotation (Line(points={{-44,-6},{-16,-6},{-16,38},{-10,
          38}},                                                                                             color={0,127,255}));
  connect(offgas.mass_port_a, volumeSalt.traceMassPort)
    annotation (Line(points={{-27,-83},{-34,-83},{-34,-58},{-14,-58},{-14,-49.6}}, color={0,140,72}));
  connect(offgas.mass_port_b, convection_mass.port_a)
    annotation (Line(points={{-13,-83},{4,-83},{4,-86},{13,-86}}, color={0,140,72}));
  connect(convection_mass.port_b, headSpace.traceMassPort)
    annotation (Line(points={{27,-86},{50,-86},{50,-78},{62,-78}}, color={0,140,72}));
  connect(convection.port_b, headSpace.heatPort) annotation (Line(points={{27,-64},{50,-64},{50,-74},{60,-74}}, color={191,0,0}));
  connect(headSpace.port, boundary_gas.ports[1])
    annotation (Line(points={{66,-68},{66,-46},{68,-46},{68,-32},{64,-32}}, color={0,127,255}));
  connect(volumeSalt.heatPort, convection.port_a) annotation (Line(points={{-10,-50.4},{-10,-64},{13,-64}}, color={191,0,0}));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    experiment(
      StopTime=10000,
      __Dymola_NumberOfIntervals=5000,
      __Dymola_Algorithm="Dassl"));
end OffgasAndSkimmer_thermochimica;
