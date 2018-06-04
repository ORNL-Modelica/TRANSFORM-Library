within TRANSFORM.Nuclear.CoreSubchannels.Examples;
model Regions_2_Test
  extends TRANSFORM.Icons.Example;

  Regions_2    coreSubchannel(
    Ts_start_1(displayUnit="K"),
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    redeclare package Material_1 = TRANSFORM.Media.Solids.UO2,
    redeclare package Material_2 = TRANSFORM.Media.Solids.ZrNb_E125,
    nParallel=23496,
    p_a_start=P_boundary.p + 100,
    p_b_start=P_boundary.p,
    T_a_start=m_boundary.T,
    T_b_start=P_boundary.T,
    m_flow_a_start=m_boundary.m_flow,
    energyDynamics=system.energyDynamics,
    energyDynamics_fuel=system.energyDynamics,
    redeclare model HeatTransfer =
        Fluid.ClosureRelations.HeatTransfer.Models.DistributedPipe_1D_MultiTransferSurface.Nus_SinglePhase_2Region,
    rho_input=ControlRod_Reactivity.y + Other_Reactivity.y,
    redeclare model Geometry =
        ClosureRelations.Geometry.Models.CoreSubchannels.Generic (
        nPins=23496,
        crossArea=2.726627/23496,
        perimeter=767.6466/23496,
        length=4.27,
        rs_outer={0.5*0.0081915,0.5*0.0095}),
    Q_nominal=1e9,
    Teffref_fuel=636.321,
    Teffref_coolant=547.25,
    T_start_1=743.15,
    T_start_2=573.15)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

  Modelica.Fluid.Sources.Boundary_pT P_boundary(
    nPorts=1,
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    T(displayUnit="K") = 600,
    p(displayUnit="Pa") = 15649100)
    annotation (Placement(transformation(extent={{110,-10},{90,10}})));
  Modelica.Fluid.Sources.MassFlowSource_T m_boundary(
    nPorts=1,
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    m_flow=8*589,
    T(displayUnit="K") = 520)
    annotation (Placement(transformation(extent={{-108,-10},{-88,10}})));
  inner Fluid.System    system(
    m_flow_start=m_boundary.m_flow,
    p_start=P_boundary.p,
    T_start=0.5*(m_boundary.T + P_boundary.T),
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyStateInitial)
    annotation (Placement(transformation(extent={{80,80},{100,100}})));
  Modelica.Blocks.Sources.Step     ControlRod_Reactivity(
      startTime=100, height=0.001)
    annotation (Placement(transformation(extent={{-60,70},{-40,90}})));
  Modelica.Blocks.Sources.Step     Other_Reactivity(                startTime=
        250, height=-0.001)
    annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
equation
  connect(coreSubchannel.port_b, P_boundary.ports[1])
    annotation (Line(points={{10,0},{50,0},{90,0}}, color={0,127,255}));
  connect(coreSubchannel.port_a, m_boundary.ports[1])
    annotation (Line(points={{-10,0},{-49,0},{-88,0}}, color={0,127,255}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})),
    experiment(StopTime=1000, __Dymola_NumberOfIntervals=1000),
    __Dymola_experimentSetupOutput);
end Regions_2_Test;
