within TRANSFORM.Fluid.Machines.Examples.SteamTurbineStodolaTests;
model RankineCycle_Example8_1
  "Example 8.1 from Intro to Chemical Engineering"
  import TRANSFORM;
  extends Modelica.Icons.Example;

  package Medium = Modelica.Media.Water.StandardWater "Working fluid";
  parameter SI.MassFlowRate m_flow = 59.02 "Flow rate in cycle";
  parameter SI.Pressure p_steam = 8.6e6 "Steam pressure";
  parameter SI.Temperature T_steam = SI.Conversions.from_degC(500) "Steam temperature";

  parameter SI.Pressure p_condenser = 1e4 "Condenser pressure";
  parameter SI.Efficiency eta = 0.75 "Overall turbine efficiency";
  parameter SI.Temperature T_condenser = SI.Conversions.from_degC(45.8) "Condenser saturated liquid temperature";
  parameter SI.Efficiency eta_example = 0.2961 "Rankine cycle efficiency";
  parameter SI.PressureDifference dp_pump = p_steam - p_condenser;

  inner TRANSFORM.Fluid.System
                        system
    annotation (Placement(transformation(extent={{60,80},{80,100}})));
  TRANSFORM.Fluid.Machines.SteamTurbineStodola steamTurbine(
    p_a_start(displayUnit="kPa") = p_steam,
    p_b_start(displayUnit="kPa") = p_condenser,
    T_a_start=T_steam,
    T_b_start=T_condenser,
    m_flow_start=m_flow,
    redeclare package Medium = Medium,
    redeclare model Eta_wetSteam =
        TRANSFORM.Fluid.Machines.BaseClasses.WetSteamEfficiency.eta_Constant (
         eta_nominal=eta))
    annotation (Placement(transformation(extent={{-10,22},{10,42}})));

  TRANSFORM.Fluid.Volumes.IdealCondenser condenser(p(displayUnit="Pa")=
      p_condenser, redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{26,-32},{46,-12}})));
  Modelica.Fluid.Vessels.ClosedVolume boiler(
    use_portsData=false,
    use_HeatTransfer=true,
    V=0.001,
    nPorts=3,
    p_start=p_steam,
    T_start=T_steam,
    redeclare package Medium = Medium)
                    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-60,0})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature Thot_setPoint(T=T_steam)
    annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=90,
        origin={-60,-22})));
  TRANSFORM.Fluid.Sensors.MassFlowRate massFlowRate(redeclare package Medium =
        Medium)                                    annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-40,-58})));
  TRANSFORM.Fluid.Sensors.SpecificEnthalpy specificEnthalpy_in(redeclare
      package Medium =
               Medium)
    annotation (Placement(transformation(extent={{-90,-75},{-70,-55}})));
  TRANSFORM.Fluid.Sensors.SpecificEnthalpy specificEnthalpy_out(redeclare
      package Medium = Medium)
    annotation (Placement(transformation(extent={{-90,32},{-70,52}})));
  TRANSFORM.Electrical.PowerConverters.Generator generator
    annotation (Placement(transformation(extent={{20,22},{40,42}})));
  Electrical.Sources.FrequencySource boundary(f=60)
    annotation (Placement(transformation(extent={{80,22},{60,42}})));

  SI.SpecificEnthalpy h_boiler = specificEnthalpy_out.h_out - specificEnthalpy_in.h_out "Total boiler enthalpy input";
  SI.Power Q_boiler "Total boiler thermal power input";

  SI.Efficiency eta_overall "Overall Rankine efficiency";

  TRANSFORM.Utilities.ErrorAnalysis.UnitTests unitTests(x={eta_overall},
      x_reference={eta_example})
    annotation (Placement(transformation(extent={{80,80},{100,100}})));
  TRANSFORM.Fluid.Machines.Pump pump(
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
    dp_nominal=dp_pump)
    annotation (Placement(transformation(extent={{10,-90},{-10,-70}})));
equation

  Q_boiler = massFlowRate.m_flow*h_boiler;
  eta_overall =boundary.port.W/Q_boiler;

  connect(massFlowRate.port_b, boiler.ports[1]) annotation (Line(points={{-40,-48},
          {-42,-48},{-42,-4},{-42,-2.66667},{-50,-2.66667}}, color={0,127,255}));
  connect(Thot_setPoint.port, boiler.heatPort)
    annotation (Line(points={{-60,-16},{-60,-10}}, color={191,0,0}));
  connect(specificEnthalpy_out.port, boiler.ports[2]) annotation (Line(points={{
          -80,32},{-50,32},{-50,-4.44089e-016}}, color={0,127,255}));
  connect(steamTurbine.portHP, boiler.ports[3]) annotation (Line(points={{-10,38},
          {-42,38},{-42,2.66667},{-50,2.66667}}, color={0,127,255}));
  connect(steamTurbine.portLP, condenser.port_a) annotation (Line(points={{7,22},
          {6,22},{6,-4},{6,-6},{29,-6},{29,-12}}, color={0,127,255}));
  connect(generator.port, boundary.port)
    annotation (Line(points={{40.2,32.2},{40.2,32},{60,32}},
                                                       color={255,0,0}));
  connect(steamTurbine.shaft_b, generator.shaft)
    annotation (Line(points={{10,32},{20,32}}, color={0,0,0}));
  connect(pump.port_a, condenser.port_b)
    annotation (Line(points={{10,-80},{36,-80},{36,-32}}, color={0,127,255}));
  connect(pump.port_b, massFlowRate.port_a) annotation (Line(points={{-10,-80},{
          -26,-80},{-40,-80},{-40,-68}}, color={0,127,255}));
  connect(specificEnthalpy_in.port, massFlowRate.port_a) annotation (Line(
        points={{-80,-75},{-80,-80},{-40,-80},{-40,-68}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(__Dymola_NumberOfIntervals=10),
    Documentation(info="<html>
<p>The is a comparison of the steam turbine results using the conditions and comparing the results specified in Example 8.1 part b in the source.</p>
<p><br>References:</p>
<p>Smith, J.M., Vand Ness, H.C., Abbott, M.M.m &apos;Introduction to Chemical Engineering Thermodynamics 7E,&apos;</p>
<p>pg. 269-270, Example 8.1, 2005.</p>
</html>"));
end RankineCycle_Example8_1;
