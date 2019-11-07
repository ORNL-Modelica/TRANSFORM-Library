within TRANSFORM.Fluid.Machines.Examples;
model TurbineTypeCompare
  "Compares the result of the two phase and single phase turbines for a simple case (should give identical results)"
  extends TRANSFORM.Icons.Example;
  replaceable package Medium=Modelica.Media.Water.StandardWater;
  parameter Modelica.SIunits.Pressure inletPressure = 10e6;
  parameter Modelica.SIunits.Temperature inletTemperature = 1000;
  parameter Modelica.SIunits.Pressure outletPressure = 8e6;
  parameter Modelica.SIunits.Temperature outletTemperature = 964.7;
  parameter Modelica.SIunits.MassFlowRate massFlowRate=10;
  parameter Real efficiency = 0.75;

  Turbine_SinglePhase_Stodola                          turbine_singlePhase(
    redeclare package Medium = Medium,
    p_a_start=inletPressure,
    p_b_start=outletPressure,
    T_a_start=inletTemperature,
    T_b_start=outletTemperature,
    m_flow_start=massFlowRate,
    T_nominal=inletTemperature,
    eta_is=efficiency,
    p_outlet_nominal=outletPressure)
    annotation (Placement(transformation(extent={{-30,-50},{-10,-30}})));
  SteamTurbine                          turbine_twoPhase(
    redeclare package Medium = Medium,
    p_b_start=outletPressure,
    T_b_start=outletTemperature,
    T_nominal=inletTemperature,
    redeclare model Eta_wetSteam = BaseClasses.WetSteamEfficiency.eta_Constant
        (eta_nominal=efficiency),
    p_a_start=inletPressure,
    T_a_start=inletTemperature,
    m_flow_start=massFlowRate,
    p_outlet_nominal=outletPressure)
    annotation (Placement(transformation(extent={{-30,30},{-10,50}})));
  BoundaryConditions.Boundary_pT                 inlet_twoPhase(
    redeclare package Medium = Medium,
    p=inletPressure,
    T=inletTemperature,
    nPorts=1)
    annotation (Placement(transformation(extent={{-140,36},{-120,56}})));
  BoundaryConditions.Boundary_pT                 outlet_singlePhase(
    redeclare package Medium = Medium,
    p=outletPressure,
    T=outletTemperature,
    nPorts=1)
    annotation (Placement(transformation(extent={{140,-44},{120,-24}})));
  BoundaryConditions.Boundary_pT                 inlet_singlePhase(
    redeclare package Medium = Medium,
    p=inletPressure,
    T=inletTemperature,
    nPorts=1)
    annotation (Placement(transformation(extent={{-140,-44},{-120,-24}})));
  BoundaryConditions.Boundary_pT                 outlet_twoPhase(
    redeclare package Medium = Medium,
    p=outletPressure,
    T=outletTemperature,
    nPorts=1)
    annotation (Placement(transformation(extent={{140,36},{120,56}})));
  Electrical.PowerConverters.Generator_Basic           generator
    annotation (Placement(transformation(extent={{-4,-44},{4,-36}})));
  Electrical.PowerConverters.Generator_Basic           generator1
    annotation (Placement(transformation(extent={{-4,36},{4,44}})));
  Sensors.PressureTemperature                 sensor_Inlet_onePhase(
    redeclare package Medium = Medium,
    precision=3,
    redeclare function iconUnit =
        Units.Conversions.Functions.Pressure_Pa.to_MPa,
    precision2=3,
    redeclare function iconUnit2 =
        Units.Conversions.Functions.Temperature_K.to_K)           annotation (
      Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=0,
        origin={-60,-44})));
  Sensors.PressureTemperature                 sensor_outlet_onePhase(
    redeclare package Medium = Medium,
    precision=3,
    redeclare function iconUnit =
        Units.Conversions.Functions.Pressure_Pa.to_MPa,
    precision2=3,
    redeclare function iconUnit2 =
        Units.Conversions.Functions.Temperature_K.to_K)           annotation (
      Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=0,
        origin={20,-44})));
  Sensors.PressureTemperature                 sensor_Inlet_twoPhase(
    redeclare package Medium = Medium,
    precision=3,
    redeclare function iconUnit =
        Units.Conversions.Functions.Pressure_Pa.to_MPa,
    precision2=3,
    redeclare function iconUnit2 =
        Units.Conversions.Functions.Temperature_K.to_K)           annotation (
      Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=0,
        origin={-60,36})));
  Sensors.PressureTemperature                 sensor_Outlet_twoPhase(
    redeclare package Medium = Medium,
    precision=3,
    redeclare function iconUnit =
        Units.Conversions.Functions.Pressure_Pa.to_MPa,
    precision2=3,
    redeclare function iconUnit2 =
        Units.Conversions.Functions.Temperature_K.to_K)           annotation (
      Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=0,
        origin={20,36})));
  FittingsAndResistances.SpecifiedResistance                 resistanceInletTwoPhase(
      redeclare package Medium = Medium, R=1) annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-90,46})));
  FittingsAndResistances.SpecifiedResistance                 resistanceOutletOnePhase(
      redeclare package Medium = Medium, R=1) annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={90,-34})));
  FittingsAndResistances.SpecifiedResistance                 resistanceInletOnePhase(
      redeclare package Medium = Medium, R=1) annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-90,-34})));
  FittingsAndResistances.SpecifiedResistance                 resistanceOutletTwoPhase(
      redeclare package Medium = Medium, R=1) annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={90,46})));
  Sensors.MassFlowRate                 sensor_m_flow_twoPhase(
    redeclare package Medium = Medium,
    precision=3,
    redeclare function iconUnit =
        Units.Conversions.Functions.MassFlowRate_kg_s.to_kg_s)
    annotation (Placement(transformation(extent={{40,36},{60,56}})));
  Sensors.MassFlowRate sensor_m_flow_onePhase(
    redeclare package Medium = Medium,
    precision=3,
    redeclare function iconUnit =
        Units.Conversions.Functions.MassFlowRate_kg_s.to_kg_s)
    annotation (Placement(transformation(extent={{40,-44},{60,-24}})));
equation
  connect(turbine_twoPhase.shaft_b,generator1. shaft) annotation (Line(points={{-10,40},
          {-4.04,40},{-4.04,39.96}},        color={0,0,0}));
  connect(turbine_singlePhase.shaft_b,generator. shaft) annotation (Line(points={{-10,-40},
          {-8,-40},{-8,-40.04},{-4.04,-40.04}},          color={0,0,0}));
  connect(resistanceOutletTwoPhase.port_b,outlet_twoPhase. ports[1])
    annotation (Line(points={{97,46},{120,46}},  color={0,127,255}));
  connect(inlet_twoPhase.ports[1],resistanceInletTwoPhase. port_a)
    annotation (Line(points={{-120,46},{-97,46}},color={0,127,255}));
  connect(resistanceInletTwoPhase.port_b,turbine_twoPhase. portHP)
    annotation (Line(points={{-83,46},{-30,46}},color={0,127,255}));
  connect(inlet_singlePhase.ports[1],resistanceInletOnePhase. port_a)
    annotation (Line(points={{-120,-34},{-97,-34}},color={0,127,255}));
  connect(resistanceInletOnePhase.port_b,turbine_singlePhase. port_a)
    annotation (Line(points={{-83,-34},{-30,-34}},color={0,127,255}));
  connect(resistanceOutletOnePhase.port_b,outlet_singlePhase. ports[1])
    annotation (Line(points={{97,-34},{120,-34}},  color={0,127,255}));
  connect(resistanceInletOnePhase.port_b,sensor_Inlet_onePhase. port)
    annotation (Line(points={{-83,-34},{-60,-34}},
                                                 color={0,127,255}));
  connect(turbine_singlePhase.port_b,sensor_outlet_onePhase. port)
    annotation (Line(points={{-10,-34},{20,-34}},color={0,127,255}));
  connect(turbine_twoPhase.portLP,sensor_Outlet_twoPhase. port)
    annotation (Line(points={{-10,46},{20,46}},color={0,127,255}));
  connect(resistanceInletTwoPhase.port_b,sensor_Inlet_twoPhase. port)
    annotation (Line(points={{-83,46},{-60,46}},
                                               color={0,127,255}));
  connect(turbine_twoPhase.portLP,sensor_m_flow_twoPhase. port_a)
    annotation (Line(points={{-10,46},{40,46}},color={0,127,255}));
  connect(sensor_m_flow_twoPhase.port_b,resistanceOutletTwoPhase. port_a)
    annotation (Line(points={{60,46},{83,46}},   color={0,127,255}));
  connect(turbine_singlePhase.port_b, sensor_m_flow_onePhase.port_a)
    annotation (Line(points={{-10,-34},{40,-34}}, color={0,127,255}));
  connect(sensor_m_flow_onePhase.port_b, resistanceOutletOnePhase.port_a)
    annotation (Line(points={{60,-34},{83,-34}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-210,-120},
            {210,120}})),                                        Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-210,-120},{210,120}})));
end TurbineTypeCompare;
