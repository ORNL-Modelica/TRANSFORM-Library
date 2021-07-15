within TRANSFORM.HeatExchangers.Examples;
model OilWater_Simple_HX
  "Example of an oil and water concentric tube heat exchanger"
  import TRANSFORM;
  extends TRANSFORM.Icons.Example;

  TRANSFORM.Fluid.BoundaryConditions.MassFlowSource_T tube_inlet(
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    m_flow=0.2,
    T(displayUnit="degC") = 303.15,
    nPorts=1)
    annotation (Placement(transformation(extent={{-51,-6},{-39,6}})));
  TRANSFORM.Fluid.BoundaryConditions.Boundary_pT tube_outlet(
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    p(displayUnit="bar") = 100000,
    T(displayUnit="degC") = 313.15,
    nPorts=1)
    annotation (Placement(transformation(extent={{51,-5},{41,5}})));
  TRANSFORM.Fluid.BoundaryConditions.MassFlowSource_T shell_inlet(
    m_flow=0.1,
    T(displayUnit="degC") = 373.15,
    redeclare package Medium =
        Media.Fluids.Incompressible.EngineOilUnused,
    nPorts=1)
    annotation (Placement(transformation(extent={{51,15},{39,27}})));
  TRANSFORM.Fluid.BoundaryConditions.Boundary_pT shell_outlet(
    p(displayUnit="bar") = 100000,
    T(displayUnit="degC") = 333.15,
    redeclare package Medium =
        Media.Fluids.Incompressible.EngineOilUnused,
    nPorts=1)
    annotation (Placement(transformation(extent={{-51,15},{-41,25}})));
  TRANSFORM.HeatExchangers.Simple_HX STHX(
    redeclare package Medium_1 = Media.Fluids.Incompressible.EngineOilUnused,
    redeclare package Medium_2 = Modelica.Media.Water.StandardWater,
    nV=4,
    counterCurrent=true,
    p_a_start_1=shell_outlet.p,
    T_a_start_1=shell_inlet.T,
    p_a_start_2=tube_outlet.p,
    T_a_start_2=tube_inlet.T,
    m_flow_start_1=shell_inlet.m_flow,
    m_flow_start_2=tube_inlet.m_flow,
    V_1=0.1,
    V_2=0.01,
    UA=156) annotation (Placement(transformation(extent={{21,-10},{-21,30}})));

equation
  connect(tube_inlet.ports[1], STHX.port_a2) annotation (Line(points={{-39,0},{-26,
          0},{-26,2},{-21,2}}, color={0,127,255}));
  connect(STHX.port_a1, shell_inlet.ports[1]) annotation (Line(points={{21,18},{
          30,18},{30,21},{39,21}}, color={0,127,255}));
  connect(shell_outlet.ports[1], STHX.port_b1) annotation (Line(points={{-41,20},
          {-26,20},{-26,18},{-21,18}}, color={0,127,255}));
  connect(STHX.port_b2, tube_outlet.ports[1])
    annotation (Line(points={{21,2},{36,2},{36,0},{41,0}}, color={0,127,255}));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,100}})),
    experiment(StopTime=1000, __Dymola_NumberOfIntervals=1000),
    __Dymola_experimentSetupOutput,
    Documentation(info="<html>
<p>Example 11.1 (pp. 680-682).</p>
<p>A counterflow, concentric tube heat exchanger with oil and water taken from Example 11.1 (pp. 680-682) of Fundamentals of Heat and Mass Transfer by Incropera and DeWitt.</p>
</html>"));
end OilWater_Simple_HX;
