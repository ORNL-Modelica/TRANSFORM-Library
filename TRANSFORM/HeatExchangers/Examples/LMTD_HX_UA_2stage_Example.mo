within TRANSFORM.HeatExchangers.Examples;
model LMTD_HX_UA_2stage_Example
  "Example of an 2 stage condensation convection HX"
  import TRANSFORM;
  extends TRANSFORM.Icons.Example;
  replaceable package Medium_1 = Modelica.Media.Water.StandardWater;
  replaceable package Medium_2 = Modelica.Media.Water.StandardWater;

  TRANSFORM.Fluid.BoundaryConditions.MassFlowSource_h tube_inlet(
    redeclare package Medium = Medium_2,
    m_flow=504.1,
    h=929.8e3,
    nPorts=1)
    annotation (Placement(transformation(extent={{85,-22},{73,-10}})));
  TRANSFORM.Fluid.BoundaryConditions.Boundary_ph tube_outlet(
    redeclare package Medium = Medium_2,
    p(displayUnit="bar") = 7957000,
    h=1046.5e3,
    nPorts=1)
    annotation (Placement(transformation(extent={{-79,-21},{-69,-11}})));
  TRANSFORM.Fluid.BoundaryConditions.MassFlowSource_h shell_inlet(
    m_flow=32.35,
    redeclare package Medium = Medium_1,
    h=2775.3e3,
    nPorts=1)
    annotation (Placement(transformation(extent={{-81,10},{-69,22}})));
  TRANSFORM.Fluid.BoundaryConditions.Boundary_ph shell_outlet(
    p(displayUnit="bar") = 6079000,
    redeclare package Medium = Medium_1,
    nPorts=1)
    annotation (Placement(transformation(extent={{85,11},{75,21}})));
  TRANSFORM.HeatExchangers.LMTD_HX_UA_2stage TwoStageHx(
    redeclare package Medium_1 = Medium_1,
    redeclare package Medium_2 = Medium_2,
    counterCurrent=true,
    p_start_1_condensation=7113000,
    p_start_1_convection=6079000,
    p_start_2_convection=8054000,
    p_start_2_condensation=99999.99999999999*((80.54 + 79.57)/2),
    h_start_1_condensation=1218346,
    h_start_1_convection=956.8e3,
    h_start_2_convection=946584,
    h_start_2_condensation=1046.5e3,
    m_flow_start_1=shell_inlet.m_flow,
    m_flow_start_2=tube_inlet.m_flow,
    UA(start=TwoStageHx.UA0),
    R_1_condensation=10.34e5/32.35,
    R_1_convection=0.001,
    R_2_condensation=0.97e5/504.1/2,
    R_2_convection=0.97e5/504.1/2,
    V_1_condensation=0.01,
    V_1_convection=0.01,
    V_2_condensation=0.01,
    V_2_convection=0.01,
    UA0=376757)
    annotation (Placement(transformation(extent={{-40,-40},{40,40}})));

equation
  connect(tube_inlet.ports[1], TwoStageHx.port_a2) annotation (Line(points={{73,-16},
          {40,-16}},                   color={0,127,255}));
  connect(TwoStageHx.port_a1, shell_inlet.ports[1]) annotation (Line(points={{-40,16},
          {-69,16}},                       color={0,127,255}));
  connect(shell_outlet.ports[1], TwoStageHx.port_b1) annotation (Line(points={{75,16},
          {40,16}},                             color={0,127,255}));
  connect(TwoStageHx.port_b2, tube_outlet.ports[1]) annotation (Line(points={{-40,-16},
          {-69,-16}},                  color={0,127,255}));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,100}})),
    experiment(
      StopTime=350,
      __Dymola_NumberOfIntervals=1000,
      __Dymola_Algorithm="Dassl"),
    __Dymola_experimentSetupOutput,
    Documentation(info="<html>
<p>Example 11.1 (pp. 680-682).</p>
<p>A counterflow, concentric tube heat exchanger with oil and water taken from Example 11.1 (pp. 680-682) of Fundamentals of Heat and Mass Transfer by Incropera and DeWitt.</p>
</html>"));
end LMTD_HX_UA_2stage_Example;
