within TRANSFORM.Nuclear.CoreSubchannels.Examples;
model Regions_1_Test
  extends TRANSFORM.Icons.Example;
  Modelica.Fluid.Sources.MassFlowSource_T m_boundary(
    nPorts=1,
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    m_flow=8*589,
    T(displayUnit="degC") = 520)
    annotation (Placement(transformation(extent={{-108,-10},{-88,10}})));
  Modelica.Fluid.Sources.Boundary_pT P_boundary(
    nPorts=1,
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    p(displayUnit="Pa") = 15649100,
    T(displayUnit="degC") = 563.15)
    annotation (Placement(transformation(extent={{110,-10},{90,10}})));
  inner Fluid.System    system(energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyStateInitial)
    annotation (Placement(transformation(extent={{80,80},{100,100}})));
  Regions_1    coreSubchannel(
    nParallel=23496,
    p_a_start=P_boundary.p + 1000,
    T_a_start=m_boundary.T,
    T_b_start=m_boundary.T,
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    redeclare package Material_1 = Media.Solids.UO2,
    p_b_start=P_boundary.p,
    energyDynamics=system.energyDynamics,
    energyDynamics_fuel=system.energyDynamics,
    redeclare model HeatTransfer =
        Fluid.ClosureRelations.HeatTransfer.Models.DistributedPipe_1D_MultiTransferSurface.Nus_SinglePhase_2Region,
    redeclare model Geometry =
        ClosureRelations.Geometry.Models.CoreSubchannels.Generic (
        crossArea=2.726627/23496,
        perimeter=767.6466/23496,
        length=4.27,
        rs_outer={0.5*0.0095},
        nPins=23496),
    rho_input=ControlRod_Reactivity.y + Other_Reactivity.y,
    Teffref_fuel=624.087,
    Teffref_coolant=547.25,
    T_start_1=623.15)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

  Modelica.Blocks.Sources.Step     ControlRod_Reactivity(
                     height=0.001, startTime=100)
    annotation (Placement(transformation(extent={{-60,70},{-40,90}})));
  Modelica.Blocks.Sources.Step     Other_Reactivity(
             height=-0.001, startTime=250)
    annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
equation
  connect(m_boundary.ports[1], coreSubchannel.port_a)
    annotation (Line(points={{-88,0},{-49,0},{-10,0}}, color={0,127,255}));
  connect(coreSubchannel.port_b, P_boundary.ports[1])
    annotation (Line(points={{10,0},{50,0},{90,0}}, color={0,127,255}));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    experiment(StopTime=1000, __Dymola_NumberOfIntervals=1000));
end Regions_1_Test;
