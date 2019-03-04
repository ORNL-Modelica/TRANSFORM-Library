within TRANSFORM.Fluid.Machines.Examples;
model Turbine_SinglePhase_Test3
  import TRANSFORM;
  extends TRANSFORM.Icons.Example;
  package Medium = Modelica.Media.IdealGases.SingleGases.H2 "Working fluid";
  parameter SI.MassFlowRate m_flow = 59.02 "Flow rate in cycle";
  parameter SI.Pressure p_steam = 8.6e6 "Steam pressure";
  parameter SI.Temperature T_steam = SI.Conversions.from_degC(500) "Steam temperature";
  parameter SI.Pressure p_condenser = 1e4 "Condenser pressure";
  parameter SI.Efficiency eta = 0.75 "Overall turbine efficiency";
  parameter SI.Temperature T_condenser = SI.Conversions.from_degC(45.8) "Condenser saturated liquid temperature";
  parameter SI.Power Q_capacity = 56.4e6 "Rated steam turbine capacity";
  Real pR = 1/turbine.PR;
  TRANSFORM.Fluid.BoundaryConditions.Boundary_pT source(
    use_p_in=true,
    p=p_steam,
    nPorts=1,
    T=T_steam,
    redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{-50,10},{-30,30}})));
  Modelica.Mechanics.Rotational.Sources.ConstantSpeed constantSpeed(w_fixed=
       3000/60*3.14159)
    annotation (Placement(transformation(extent={{40,-10},{20,10}})));
  TRANSFORM.Fluid.BoundaryConditions.Boundary_pT sink(
    nPorts=1,
    use_p_in=false,
    p(displayUnit="kPa") = p_condenser,
    T=T_condenser,
    redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{38,48},{18,28}})));
  inner TRANSFORM.Fluid.System
                  system
    annotation (Placement(transformation(extent={{60,80},{80,100}})));
  TRANSFORM.Fluid.Machines.Turbine_SinglePhase_Mechanical turbine(
    p_a_start(displayUnit="kPa") = p_steam,
    p_b_start(displayUnit="kPa") = p_condenser,
    T_a_start=T_steam,
    T_b_start=T_condenser,
    m_flow_start=m_flow,
    redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Sources.Ramp ramp(
    height=p_condenser - p_steam,
    duration=1,
    offset=p_steam)
    annotation (Placement(transformation(extent={{-90,20},{-70,40}})));
equation
  connect(turbine.shaft_b, constantSpeed.flange)
    annotation (Line(points={{10,0},{20,0}}, color={0,0,0}));
  connect(source.ports[1], turbine.port_a) annotation (Line(points={{-30,20},{-20,
          20},{-20,22},{-10,22},{-10,6}}, color={0,127,255}));
  connect(turbine.port_b, sink.ports[1])
    annotation (Line(points={{10,6},{10,38},{18,38}}, color={0,127,255}));
  connect(ramp.y, source.p_in) annotation (Line(points={{-69,30},{-60,30},{-60,28},
          {-52,28}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(__Dymola_NumberOfIntervals=100),
    Documentation(info="<html>
<p>The is a comparison of the steam turbine results using the conditions and comparing the results specified in Example 7.6 in the source.</p>
<p><br>References:</p>
<p>Smith, J.M., Vand Ness, H.C., Abbott, M.M.m &apos;Introduction to Chemical Engineering Thermodynamics 7E,&apos;</p>
<p>pg. 269-270, Example 7.6, 2005.</p>
</html>"));
end Turbine_SinglePhase_Test3;
