within TRANSFORM.Examples.SodiumFastReactor.Components;
model AirSide

replaceable package Medium =
      TRANSFORM.Media.Fluids.Sodium.ConstantPropertyLiquidSodium
    "Primary heat system medium" annotation(choicesAllMatching=true);

 replaceable package Medium_Ambient =
      Modelica.Media.Air.DryAirNasa
    "Ambient medium" annotation(choicesAllMatching=true);

  Data.SFR_PHS data
    annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
  Modelica.Fluid.Sources.MassFlowSource_T blower(
    nPorts=1,
    redeclare package Medium = Medium_Ambient,
    m_flow=200,
    T=298.15) annotation (Placement(transformation(extent={{76,-50},{56,-30}})));
  Fluid.BoundaryConditions.Boundary_pT atmosphere(
    nPorts=1,
    p=100000,
    T=293.15,
    redeclare package Medium = Medium_Ambient)
              annotation (Placement(transformation(extent={{72,30},{52,50}})));
  Fluid.Pipes.GenericPipe                      pipe(
    redeclare model Geometry =
        Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.ShellSide_STHX
        (
        nTubes=data.nTubes_AHX,
        length_shell=data.height_active_shell_AHX,
        D_o_shell=data.D_shell_outer_AHX,
        surfaceArea_shell=data.surfaceArea_finnedTube,
        angle=1.5707963267949,
        nV=2,
        length_tube=data.length_tube_AHX,
        D_o_tube=data.D_tube_outer_AHX),
    use_HeatTransfer=true,
    redeclare model HeatTransfer =
        Fluid.ClosureRelations.HeatTransfer.Models.DistributedPipe_1D.FlowAcrossTubeBundles_Grimison
        (
        D=data.D_tube_outer_AHX,
        S_T=data.pitch_tube_AHX,
        S_L=data.pitch_tube_AHX),
    redeclare package Medium = Medium_Ambient,
    p_a_start=100000,
    T_a_start=298.15,
    T_b_start=323.15,
    m_flow_a_start=blower.m_flow) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={42,0})));
  HeatAndMassTransfer.BoundaryConditions.Heat.HeatFlow_multi boundary_AHX1(nPorts=2, Q_flow=
        fill(data.Qth_nominal_IHXs/2/3, 2))
    annotation (Placement(transformation(extent={{-6,-10},{14,10}})));
equation
  connect(blower.ports[1], pipe.port_a)
    annotation (Line(points={{56,-40},{42,-40},{42,-10}}, color={0,127,255}));
  connect(atmosphere.ports[1], pipe.port_b)
    annotation (Line(points={{52,40},{42,40},{42,10}}, color={0,127,255}));
  connect(boundary_AHX1.port, pipe.heatPorts) annotation (Line(points={{14,0},{37,
          0},{37,4.44089e-016}}, color={191,0,0}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end AirSide;
