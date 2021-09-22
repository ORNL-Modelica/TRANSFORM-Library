within TRANSFORM.HeatExchangers.Examples;
model CondensationConvection_Example
  "Example of an 2 stage condensation convection HX"
  import TRANSFORM;
  extends TRANSFORM.Icons.Example;
  replaceable package Medium_1 = Modelica.Media.Water.StandardWater;
  replaceable package Medium_2 = Modelica.Media.Water.StandardWater;
  parameter SI.SpecificEnthalpy h_1[3] = {2700000, 640185, 431458};
  parameter SI.SpecificEnthalpy h_2[3] = {389067, 409939, 615921};
  parameter SI.Temperature T_1[3] = {560.837, 424.986, 376.011};
  parameter SI.Temperature T_2[3] = {365.417, 370.417, 418.986};
  parameter SI.Pressure p_1[3] = {10e5, 5e5, 4.99e5};
  parameter SI.Pressure p_2[3] = {34e5, 33e5, 32e5};
  parameter SI.MassFlowRate m_flow_1 = 10;
  parameter SI.MassFlowRate m_flow_2 = 100;
  parameter SI.Power Q_condensation_1 = m_flow_1*(h_1[1]-h_1[2]);
  parameter SI.Power Q_condensation_2 = m_flow_2*(h_2[3]-h_2[2]);
  parameter SI.Power Q_convection_1 = m_flow_1*(h_1[2]-h_1[3]);
  parameter SI.Power Q_convection_2 = m_flow_2*(h_2[2]-h_2[1]);


  TRANSFORM.Fluid.BoundaryConditions.MassFlowSource_h tube_inlet(
    redeclare package Medium = Medium_2,
    m_flow=m_flow_2,
    h=h_2[1],
    nPorts=1)
    annotation (Placement(transformation(extent={{85,-22},{73,-10}})));
  TRANSFORM.Fluid.BoundaryConditions.Boundary_ph tube_outlet(
    redeclare package Medium = Medium_2,
    p(displayUnit="bar") = p_2[3],
    h=h_2[3],
    nPorts=1)
    annotation (Placement(transformation(extent={{-79,-21},{-69,-11}})));
  TRANSFORM.Fluid.BoundaryConditions.MassFlowSource_h shell_inlet(
    m_flow=m_flow_1,
    redeclare package Medium = Medium_1,
    h=h_1[1],
    nPorts=1)
    annotation (Placement(transformation(extent={{-81,10},{-69,22}})));
  TRANSFORM.Fluid.BoundaryConditions.Boundary_ph shell_outlet(
    p(displayUnit="bar") = p_1[3],
    redeclare package Medium = Medium_1,
    h=h_1[3],
    nPorts=1)
    annotation (Placement(transformation(extent={{85,11},{75,21}})));
  TRANSFORM.HeatExchangers.CondensationConvectionHX CondensationConvectionHx(
      redeclare package Medium_1 = Medium_1, redeclare package Medium_2 =
        Medium_2,
    p_start_condensation1=p_1[1],
    h_start_condensation1=h_2[2],
    R_condensation1=(p_1[1] - p_1[2])/m_flow_1,
    V_condensation1=0.01,
    R_condensation2=(p_2[2] - p_2[3])/m_flow_2,
    V_condensation2=0.01,
    p_start_condensation2=p_2[2],
    h_start_condensation2=h_2[3],
    Ts_h=T_1[2:3],
    Ts_c=T_2[1:2],
    Q_flow_nominal_convection=Q_convection_2,
    V_convection1=0.01,
    V_convection2=0.01,
    CF=1.8,
    R_convection1=(p_1[2] - p_1[3])/m_flow_1,
    R_convection2=(p_2[1] - p_2[2])/m_flow_2,
    ps_start_convection1={p_1[2],(p_1[2] + p_1[3])/2},
    hs_start_convection1={(h_1[2] + h_1[3])/2,h_1[3]},
    m_flow_start_convection1=m_flow_1,
    ps_start_convection2={p_2[1],(p_2[1] + p_2[2])/2},
    Ts_start_convection2={(T_2[1] + T_2[2])/2,T_2[2]},
    m_flow_start_convection2=m_flow_2)
    annotation (Placement(transformation(extent={{-40,-40},{40,40}})));

  UserInteraction.Outputs.NumericValue numericValue9(precision=3, input_Value
      =CondensationConvectionHx.Q_flow_condensation/1e6)
    annotation (Placement(transformation(extent={{-30,24},{-10,44}})));
  UserInteraction.Outputs.NumericValue numericValue1(precision=3, input_Value
      =CondensationConvectionHx.Q_flow_convection/1e6)
    annotation (Placement(transformation(extent={{10,24},{30,44}})));
  UserInteraction.Outputs.NumericValue numericValue2(precision=3, input_Value
      =Q_convection_1/1e6)
    annotation (Placement(transformation(extent={{10,36},{30,56}})));
  UserInteraction.Outputs.NumericValue numericValue3(precision=3, input_Value
      =Q_condensation_1/1e6)
    annotation (Placement(transformation(extent={{-30,36},{-10,56}})));
equation
  connect(tube_inlet.ports[1], CondensationConvectionHx.port_a2)
    annotation (Line(points={{73,-16},{40,-16}}, color={0,127,255}));
  connect(CondensationConvectionHx.port_a1, shell_inlet.ports[1])
    annotation (Line(points={{-40,16},{-69,16}}, color={0,127,255}));
  connect(shell_outlet.ports[1], CondensationConvectionHx.port_b1)
    annotation (Line(points={{75,16},{40,16}}, color={0,127,255}));
  connect(CondensationConvectionHx.port_b2, tube_outlet.ports[1])
    annotation (Line(points={{-40,-16},{-69,-16}}, color={0,127,255}));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,100}}), graphics={Text(
          extent={{-82,50},{-56,30}},
          textColor={28,108,200},
          textString="Setpoint

Output")}),
    experiment(
      StopTime=10,
      __Dymola_NumberOfIntervals=1000,
      __Dymola_Algorithm="Dassl"),
    __Dymola_experimentSetupOutput,
    Documentation(info="<html>
<p>Example 11.1 (pp. 680-682).</p>
<p>A counterflow, concentric tube heat exchanger with oil and water taken from Example 11.1 (pp. 680-682) of Fundamentals of Heat and Mass Transfer by Incropera and DeWitt.</p>
</html>"));
end CondensationConvection_Example;
