within TRANSFORM.Chemistry.Thermochimica.Examples;
model EvaporatingPoolSkimmer_thermochimica
   extends TRANSFORM.Icons.Example;

  parameter Boolean use_AtomBased=false "else molar based";
  //switch MMs to avogadro's number to track for atoms in volumes.

  package Medium_salt = TRANSFORM.Media.Fluids.FLiBe.LinearFLiBe_9999Li7_pT (
        extraPropertiesNames=extraPropertiesNames_salt);

  parameter SI.Area surfaceArea = Modelica.Constants.pi*1^2;

  // Species tracked in the salt
  constant String extraPropertiesNames_salt[:]={"Li","F","Na","K","U","Pu"};
  constant Integer nC_salt=size(extraPropertiesNames_salt, 1) "Number of species";
  constant Integer atomicNumbers[nC_salt]={3,9,11,19,92,94};

  parameter SI.MolarMass MM_i_salt[nC_salt]={TRANSFORM.PeriodicTable.CalculateMolarMass(extraPropertiesNames_salt[
      i]) for i in 1:nC_salt} "Molecular weight of species";

  parameter SI.Temperature T_start_salt=550 + 273.15 "Initial temperature";

  parameter SI.AbsolutePressure p_start_gas=1e5 "Initial head space pressure";

  parameter SIadd.ExtraProperty C_start_gas[nC_salt]=zeros(nC_salt) "Mass-Specific value";

  parameter SIadd.ExtraProperty C_salt_initial[nC_salt] = {1/MM_salt*sum(moleFrac_start_salt[:].*relationMatrix_salt[i,:])
                                                                                   for i in 1:nC_salt};
  constant SIadd.Mole unit_mole = 1.0;

  constant String saltNames[:] = {"LiF","NaF","KF","UF3","UF4","PuF3"};
  constant Integer nC_saltNames=size(saltNames, 1) "Number of species";
  constant Real relationMatrix_salt[nC_salt,nC_saltNames]=
  {
  {1,0,0,0,0,0},
  {1,1,1,3,4,3},
  {0,1,0,0,0,0},
  {0,0,1,0,0,0},
  {0,0,0,1,1,0},
  {0,0,0,0,0,1}}
     "Element (row) to species (column) molar relation matrix";

   parameter SI.MoleFraction moleFrac_start_salt[nC_saltNames] = {0.4185,0.1035,0.378,0.0001,0.0099,0.09};
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
    amplitude=-5e5,
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
        extent={{-10,36},{10,56}},
        rotation=180,
        origin={0,12})));
  Modelica.Blocks.Sources.RealExpression m_flow_pump_PFL(y=data_PHX.m_flow_tube/(1 - x_bypass.y))
    annotation (Placement(transformation(extent={{44,56},{24,76}})));
  Modelica.Blocks.Sources.Constant x_bypass(k=0.1)
    annotation (Placement(transformation(extent={{-98,58},{-78,78}})));
  TRANSFORM.Examples.MoltenSaltReactor.Data.data_PHX
                data_PHX
    annotation (Placement(transformation(extent={{-62,62},{-42,82}})));
equation
  connect(pump_PFL.port_b, volumeSalt.port_a) annotation (Line(points={{10,38},{14,38},{14,-28},{7,-28}}, color={0,127,255}));
  connect(volumeSalt.port_b, skimmer.port_a) annotation (Line(points={{-7,-28},{-58,-28},{-58,-20},{
          -64,-20},{-64,-6}},                                                                                color={0,127,255}));
  connect(m_flow_pump_PFL.y, pump_PFL.in_m_flow) annotation (Line(points={{23,66},{0,66},{0,45.3}}, color={0,0,127}));
  connect(skimmer.port_b, pump_PFL.port_a) annotation (Line(points={{-44,-6},{-16,-6},{-16,38},{-10,
          38}},                                                                                             color={0,127,255}));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    experiment(
      StopTime=10000,
      __Dymola_NumberOfIntervals=5000,
      __Dymola_Algorithm="Dassl"));
end EvaporatingPoolSkimmer_thermochimica;
