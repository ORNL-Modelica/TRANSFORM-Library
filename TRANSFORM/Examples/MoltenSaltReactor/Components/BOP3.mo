within TRANSFORM.Examples.MoltenSaltReactor.Components;
model BOP3
  replaceable package Medium_BOP = Modelica.Media.Water.StandardWater constrainedby Modelica.Media.Interfaces.PartialMedium;
  Data.data_SHX data_SHX
    annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
  Fluid.Volumes.MixingVolume steamMixer(
    redeclare model Geometry =
        Fluid.ClosureRelations.Geometry.Models.LumpedVolume.GenericVolume (V=1),
    redeclare package Medium = Medium_BOP,
    nPorts_b=1,
    p_start=data_SHX.p_outlet_tube,
    T_start=data_SHX.T_outlet_tube,
    nPorts_a=1)
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));
  Data.data_BOP data_BOP
    annotation (Placement(transformation(extent={{-80,80},{-60,100}})));
  Fluid.Volumes.IdealCondenser condenser1(
    V_liquid_start=5,
    redeclare package Medium = Medium_BOP,
    p=data_BOP.p_outlet_LP)
    annotation (Placement(transformation(extent={{20,-22},{40,-2}})));
  Fluid.Machines.Pump_SimpleMassFlow pump_BOP(m_flow_nominal=2*3*data_SHX.m_flow_tube,
      redeclare package Medium = Medium_BOP)
    annotation (Placement(transformation(extent={{-30,-50},{-50,-30}})));
  Fluid.Volumes.MixingVolume FWH(
    use_HeatPort=true,
    nPorts_b=1,
    nPorts_a=1,
    redeclare package Medium = Medium_BOP)
    annotation (Placement(transformation(extent={{0,-50},{-20,-30}})));
  HeatAndMassTransfer.BoundaryConditions.Heat.Temperature FWH_returnTemp(T=
        data_SHX.T_inlet_tube)
    annotation (Placement(transformation(extent={{-36,-70},{-16,-50}})));
  Fluid.Machines.SteamTurbine steamTurbine_HP(
    redeclare package Medium = Medium_BOP,
    p_a_start=data_SHX.p_outlet_tube,
    T_a_start=data_SHX.T_outlet_tube,
    m_flow_start=2*3*data_SHX.m_flow_shell,
    p_b_start=data_BOP.p_outlet_HP)
    annotation (Placement(transformation(extent={{-34,14},{-14,34}})));
  Fluid.Volumes.MixingVolume HP_vol(
    nPorts_a=1,
    p_start=steamTurbine_HP.p_b_start,
    T_start=steamTurbine_HP.T_b_start,
    redeclare package Medium = Medium_BOP,
    redeclare model Geometry =
        Fluid.ClosureRelations.Geometry.Models.LumpedVolume.GenericVolume (V=1),
    nPorts_b=1)
    annotation (Placement(transformation(extent={{-20,-10},{0,10}})));
  Fluid.Machines.SteamTurbine steamTurbine_LP(
    redeclare package Medium = Medium_BOP,
    T_a_start=data_SHX.T_outlet_tube,
    m_flow_start=2*3*data_SHX.m_flow_shell,
    p_a_start=steamTurbine_HP.p_b_start,
    p_b_start=data_BOP.p_outlet_LP)
    annotation (Placement(transformation(extent={{-2,14},{18,34}})));
  Electrical.Sources.FrequencySource boundary6(f=60)
    annotation (Placement(transformation(extent={{100,14},{80,34}})));
  Electrical.PowerConverters.Generator generator1
    annotation (Placement(transformation(extent={{54,14},{74,34}})));
  Modelica.Mechanics.Rotational.Sensors.PowerSensor powerSensor1
    annotation (Placement(transformation(extent={{28,34},{48,14}})));
  Fluid.BoundaryConditions.Boundary_pT boundary(
    redeclare package Medium = Medium_BOP,
    p=data_SHX.p_inlet_tube,
    T=data_SHX.T_inlet_tube,
    nPorts=1) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-80,-78})));
  Fluid.FittingsAndResistances.SpecifiedResistance resistance(redeclare package Medium =
               Medium_BOP, R=1e8) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-80,-54})));
  Fluid.Interfaces.FluidPort_Flow port_a(redeclare package Medium = Medium_BOP)
    annotation (Placement(transformation(extent={{-110,-50},{-90,-30}}),
        iconTransformation(extent={{-110,-50},{-90,-30}})));
  Fluid.Interfaces.FluidPort_State port_b(redeclare package Medium = Medium_BOP)
    annotation (Placement(transformation(extent={{-110,10},{-90,30}}),
        iconTransformation(extent={{-110,30},{-90,50}})));
equation
  connect(FWH_returnTemp.port, FWH.heatPort)
    annotation (Line(points={{-16,-60},{-10,-60},{-10,-46}}, color={191,0,0}));
  connect(FWH.port_b[1], pump_BOP.port_a)
    annotation (Line(points={{-16,-40},{-30,-40}}, color={0,127,255}));
  connect(condenser1.port_b, FWH.port_a[1])
    annotation (Line(points={{30,-20},{30,-40},{-4,-40}}, color={0,127,255}));
  connect(powerSensor1.flange_b, generator1.shaft)
    annotation (Line(points={{48,24},{54,24}}, color={0,0,0}));
  connect(generator1.port, boundary6.port)
    annotation (Line(points={{74,24},{80,24}}, color={255,0,0}));
  connect(steamTurbine_LP.shaft_b, powerSensor1.flange_a)
    annotation (Line(points={{18,24},{28,24}}, color={0,0,0}));
  connect(steamMixer.port_b[1], steamTurbine_HP.portHP)
    annotation (Line(points={{-44,30},{-34,30}}, color={0,127,255}));
  connect(HP_vol.port_a[1], steamTurbine_HP.portLP)
    annotation (Line(points={{-16,0},{-16,14},{-17,14}}, color={0,127,255}));
  connect(HP_vol.port_b[1], steamTurbine_LP.portHP)
    annotation (Line(points={{-4,0},{-4,30},{-2,30}}, color={0,127,255}));
  connect(steamTurbine_HP.shaft_b, steamTurbine_LP.shaft_a)
    annotation (Line(points={{-14,24},{-2,24}}, color={0,0,0}));
  connect(steamTurbine_LP.portLP, condenser1.port_a) annotation (Line(points={{
          15,14},{14,14},{14,6},{23,6},{23,-5}}, color={0,127,255}));
  connect(resistance.port_b, boundary.ports[1])
    annotation (Line(points={{-80,-61},{-80,-68}}, color={0,127,255}));
  connect(pump_BOP.port_b, port_a)
    annotation (Line(points={{-50,-40},{-100,-40}}, color={0,127,255}));
  connect(resistance.port_a, port_a) annotation (Line(points={{-80,-47},{-80,-40},
          {-100,-40}}, color={0,127,255}));
  connect(steamMixer.port_a[1], port_b) annotation (Line(points={{-56,30},{-80,30},
          {-80,20},{-100,20}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(StopTime=5000, __Dymola_NumberOfIntervals=5000));
end BOP3;
