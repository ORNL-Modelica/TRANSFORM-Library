within TRANSFORM.Fluid.Examples;
model RankineCycle
  extends TRANSFORM.Icons.Example;
  package Medium = Modelica.Media.Water.StandardWater "Working fluid";
  parameter SI.MassFlowRate m_flow = 100 "Flow rate in cycle";
  parameter SI.Pressure p_steam = 8.6e6 "Steam pressure";
  parameter SI.Temperature T_steam = Modelica.Units.Conversions.from_degC(
                                                              500) "Steam temperature";
  parameter SI.Pressure p_condenser = 1e4 "Condenser pressure";
  parameter SI.PressureDifference dp_pump = p_steam - p_condenser;
  Modelica.Mechanics.Rotational.Sensors.PowerSensor powerSensor
    annotation (Placement(transformation(extent={{24,50},{44,30}})));
  Electrical.Sources.FrequencySource boundary(f=60)
    annotation (Placement(transformation(extent={{96,30},{76,50}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature Thot_setPoint(T=773.15)
    annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=90,
        origin={-60,-14})));
  inner System          system
    annotation (Placement(transformation(extent={{60,80},{80,100}})));
  Machines.SteamTurbine steamTurbine(
    m_flow_start=100,
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    p_a_start=p_steam,
    p_b_start=p_condenser,
    T_a_start=T_steam)
    annotation (Placement(transformation(extent={{0,30},{20,50}})));
  Volumes.IdealCondenser condenser(redeclare package Medium =
        Modelica.Media.Water.StandardWater, p(displayUnit="Pa") = p_condenser)
    annotation (Placement(transformation(extent={{50,-28},{70,-8}})));
  Modelica.Fluid.Vessels.ClosedVolume boiler(
    use_portsData=false,
    use_HeatTransfer=true,
    V=0.001,
    nPorts=3,
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    p_start=p_steam,
    T_start=T_steam)
                    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-60,8})));
  Machines.Pump pump(
    redeclare model FlowChar =
        TRANSFORM.Fluid.ClosureRelations.PumpCharacteristics.Models.Head.PerformanceCurve
        (V_flow_curve={0,0.1,2*0.1}, head_curve={1000,500,0}),
    m_flow_nominal=m_flow,
    use_T_start=false,
    m_flow_start=m_flow,
    h_start=191.8e3,
    V=0,
    redeclare model EfficiencyChar =
        TRANSFORM.Fluid.ClosureRelations.PumpCharacteristics.Models.Efficiency.Constant
        (eta_constant=0.8),
    p_a_start=p_condenser,
    controlType="pressure",
    exposeState_a=false,
    exposeState_b=true,
    dp_nominal=dp_pump,
    redeclare package Medium = Modelica.Media.Water.StandardWater)
    annotation (Placement(transformation(extent={{10,-84},{-10,-64}})));
  Electrical.PowerConverters.Generator generator
    annotation (Placement(transformation(extent={{50,30},{70,50}})));
  TRANSFORM.Fluid.Sensors.SpecificEnthalpy specificEnthalpy_out(redeclare
      package Medium = Modelica.Media.Water.StandardWater)
    annotation (Placement(transformation(extent={{-90,40},{-70,60}})));
  TRANSFORM.Fluid.Sensors.SpecificEnthalpy specificEnthalpy_in(redeclare
      package Medium =
               Modelica.Media.Water.StandardWater)
    annotation (Placement(transformation(extent={{-90,-67},{-70,-47}})));
  TRANSFORM.Fluid.Sensors.MassFlowRate massFlowRate(redeclare package Medium =
        Modelica.Media.Water.StandardWater)        annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-40,-50})));
SI.Power Q_totalTh "Total thermal power";
SI.Efficiency eta_overall "Overall Rankine efficiency";
  Utilities.ErrorAnalysis.UnitTests unitTests(
    n=1,
    printResult=false,
    x={pump.medium.p})
    annotation (Placement(transformation(extent={{80,80},{100,100}})));
equation
  Q_totalTh = massFlowRate.m_flow*(specificEnthalpy_out.h_out - specificEnthalpy_in.h_out);
  eta_overall =boundary.port.W/Q_totalTh;
  connect(steamTurbine.shaft_b, powerSensor.flange_a)
    annotation (Line(points={{20,40},{20,40},{24,40}}, color={0,0,0}));
  connect(steamTurbine.portLP, condenser.port_a)
    annotation (Line(points={{20,46},{20,-11},{53,-11}},
                                                       color={0,127,255}));
  connect(Thot_setPoint.port, boiler.heatPort)
    annotation (Line(points={{-60,-8},{-60,-2}}, color={191,0,0}));
  connect(powerSensor.flange_b, generator.shaft)
    annotation (Line(points={{44,40},{44,40},{50,40}}, color={0,0,0}));
  connect(generator.port, boundary.port)
    annotation (Line(points={{70,40},{76,40},{76,40}},       color={255,0,0}));
  connect(massFlowRate.port_b, boiler.ports[1]) annotation (Line(points={{-40,-40},
          {-40,-40},{-40,4},{-40,5.33333},{-50,5.33333}}, color={0,127,255}));
  connect(specificEnthalpy_out.port, boiler.ports[2])
    annotation (Line(points={{-80,40},{-50,40},{-50,8}}, color={0,127,255}));
  connect(steamTurbine.portHP, boiler.ports[3]) annotation (Line(points={{0,46},{
          -42,46},{-42,10.6667},{-50,10.6667}},  color={0,127,255}));
  connect(pump.port_b, massFlowRate.port_a) annotation (Line(points={{-10,-74},{
          -40,-74},{-40,-60}}, color={0,127,255}));
  connect(pump.port_a, condenser.port_b)
    annotation (Line(points={{10,-74},{60,-74},{60,-26}}, color={0,127,255}));
  connect(specificEnthalpy_in.port, massFlowRate.port_a) annotation (Line(
        points={{-80,-67},{-80,-74},{-40,-74},{-40,-60}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end RankineCycle;
