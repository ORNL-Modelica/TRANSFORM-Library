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

  // NOTE: Should this be salt or gas density?
  // mol/m3 fluid basis
  parameter SI.Concentration Cmolar_start_interface_gas[nC_salt]={headSpace.p_start*
      sum(TRANSFORM.Units.Conversions.Functions.Pressure_Pa.from_atm(
      partialPressureThermochimica_start[:].*relationMatrix[i,:]))/(Modelica.Constants.R*T_start_gas)
      for i in 1:nC_salt};

  SI.Concentration Cmolar_interface_gas[nC_salt](start=Cmolar_start_interface_gas)=
       {headSpace.medium.p*
    sum(TRANSFORM.Units.Conversions.Functions.Pressure_Pa.from_atm(partialPressureThermochimica[
    :].*relationMatrix[i,:]))/(Modelica.Constants.R*headSpace.medium.T) for i in 1:nC_salt};

  SI.Mass massC_released_gas[nC_salt] = headSpace.mC.*MM_i_salt*unit_mole*(if use_AtomBased then 1/Modelica.Constants.N_A else 1.0) "Mass of released gas species";
  SI.Mass massC_released_element[nC_salt] = headSpace.mC.*MM_i_salt*unit_mole*(if use_AtomBased then 1/Modelica.Constants.N_A else 1.0) "Mass of released element species";
  Real partialPressureThermochimica[nC_gas] = TRANSFORM.Chemistry.Thermochimica.Functions.RunAndGetMoleFraction(T_start_salt,p_start_gas/1e5,C_salt,atomicNumbers,speciesIndex) "Thermochimica-derived partial pressures";
  // parameter Real partialPressureThermochimica_start[nC_gas] = {1.9223796692112284E-009,4.7448009723068141E-011,2.6103184719810731E-003,1.0134830341333010E-011,2.0746589335375881E-012,7.7649191787908018E-016,3.9001757479873951E-002,3.4194313235742790E-009,2.4432891475408866E-010,0.13758085275506246} "Copied from Thermochimica";
  parameter Real C_salt_initial[nC_salt] = {(moleFrac_start_salt[:]*relationMatrix_salt[i,:]) for i in 1:nC_salt};
  parameter Real partialPressureThermochimica_start[nC_gas] = TRANSFORM.Chemistry.Thermochimica.Functions.RunAndGetMoleFraction(T_start_salt,p_start_gas/1e5,C_salt_initial,atomicNumbers,speciesIndex) "Thermochimica-derived initial partial pressures";
  Real F_surplus = (2*C_salt[2] - sum(C_salt))/C_salt[2];
  Real c_der[nC_salt];

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
  SIadd.Mole C_salt[nC_salt];

  SI.Pressure p[nC_gas] = TRANSFORM.Units.Conversions.Functions.Pressure_Pa.from_atm(partialPressureThermochimica);
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
  Modelica.Blocks.Sources.Pulse          saltTemperature(
    amplitude=100,
    period=9500,
    offset=T_start_salt,
    startTime=500)
    annotation (Placement(transformation(extent={{-98,-82},{-78,-62}})));
  TRANSFORM.HeatAndMassTransfer.Resistances.Mass.Convection convection_mass(
    showName=false,
    nC=nC_salt,
    surfaceArea=surfaceArea,
    alphaM=alphaM.y) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={50,22})));
  TRANSFORM.HeatAndMassTransfer.BoundaryConditions.Mass.Concentration boundary(
    showName=false,
      nC=nC_salt, use_port=true) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={50,-4})));
  Modelica.Blocks.Sources.RealExpression BC_concentration[nC_salt](y=
        Cmolar_interface_gas)
    annotation (Placement(transformation(extent={{20,-60},{40,-40}})));

  Fluid.Volumes.ExpansionTank_1Port volumeSalt(
    redeclare package Medium = Medium_salt,
    A=surfaceArea,
    p_surface=headSpace.port.p,
    p_start=p_start_gas,
    level_start=V_salt/surfaceArea,
    use_T_start=false,
    T_start=T_start_salt,
    h_start=volumeSalt.Medium.specificEnthalpy_pT(volumeSalt.p_start,
        T_start_salt),
    use_HeatPort=true,
    use_TraceMassPort=true,
    MMs=MM_i_salt)
    annotation (Placement(transformation(extent={{-10,-30},{10,-10}})));
  Fluid.BoundaryConditions.MassFlowSource_T           boundary_salt(
    showName=false,
    redeclare package Medium = Medium_salt,
    T=T_start_salt,
    nPorts=1) annotation (Placement(transformation(extent={{-60,-50},{-40,-30}})));
initial equation
        for i in 1:nC_salt loop
          C_salt[i]=V_salt*rho/MM_salt*sum(moleFrac_start_salt[:].*relationMatrix_salt[i,:]);
          c_der[i]=-convection_mass.port_a.n_flow[i];
        end for;

equation
        when {F_surplus>0.001,F_surplus<-0.001} then
          for i in 1:nC_salt loop
            c_der[i] =-convection_mass.port_a.n_flow[i];
          end for;
        end when;
        for i in 1:nC_salt loop
          der(C_salt[i]) = c_der[i];
        end for;
  connect(boundary_gas.ports[1], headSpace.port)
    annotation (Line(points={{-40,40},{14,40}}, color={0,127,255}));
  connect(headSpace.heatPort, convection.port_b)
    annotation (Line(points={{20,34},{20,27}}, color={191,0,0}));
  connect(boundary.port, convection_mass.port_a)
    annotation (Line(points={{50,6},{50,15}}, color={0,140,72}));
  connect(BC_concentration.y, boundary.C_ext)
    annotation (Line(points={{41,-50},{50,-50},{50,-8}},  color={0,0,127}));
  connect(headSpace.traceMassPort, convection_mass.port_b)
    annotation (Line(points={{24,36},{50,36},{50,29}}, color={0,140,72}));
  connect(volumeSalt.heatPort, convection.port_a)
    annotation (Line(points={{8.4,-20},{20,-20},{20,13}}, color={191,0,0}));
  connect(boundary_salt.ports[1], volumeSalt.port)
    annotation (Line(points={{-40,-40},{0,-40},{0,-28.4}}, color={0,127,255}));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    experiment(
      StopTime=75,
      __Dymola_NumberOfIntervals=500,
      __Dymola_Algorithm="Dassl"));
end EvaporatingPool_thermochimica;
