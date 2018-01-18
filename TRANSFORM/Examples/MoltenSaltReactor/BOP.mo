within TRANSFORM.Examples.MoltenSaltReactor;
model BOP

  package Medium_PCL = TRANSFORM.Media.Fluids.FLiBe.LinearFLiBe_pT (
  extraPropertiesNames={"Tritium"},
  C_nominal={1e6}) "Primary coolant loop medium";

package Medium_BOP = Modelica.Media.Water.StandardWater;

  parameter Integer toggleStaticHead = 0 "=1 to turn on, =0 to turn off";


  HeatExchangers.GenericDistributed_HX           SHX(
    redeclare package Medium_shell = Medium_PCL,
    redeclare package Material_tubeWall = Media.Solids.AlloyN,
    nParallel=2*3,
    redeclare model HeatTransfer_tube =
        Fluid.ClosureRelations.HeatTransfer.Models.DistributedPipe_1D.Nus_SinglePhase_2Region,
    redeclare model Geometry =
        Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.HeatExchanger.ShellAndTubeHX
        (
        nV=10,
        nR=3,
        D_o_shell=data_SHX.D_shell_inner,
        nTubes=data_SHX.nTubes,
        length_shell=data_SHX.length_tube,
        dimension_tube=data_SHX.D_tube_inner,
        length_tube=data_SHX.length_tube,
        th_wall=data_SHX.th_tube),
    redeclare model HeatTransfer_shell =
        Fluid.ClosureRelations.HeatTransfer.Models.DistributedPipe_1D.FlowAcrossTubeBundles_Grimison
        (
        CF=fill(0.44, SHX.shell.heatTransfer.nHT),
        D=data_SHX.D_tube_outer,
        S_T=data_SHX.pitch_tube,
        S_L=data_SHX.pitch_tube),
    p_a_start_shell=data_SHX.p_inlet_shell,
    T_a_start_shell=data_SHX.T_inlet_shell,
    T_b_start_shell=data_SHX.T_outlet_shell,
    m_flow_a_start_shell=2*3*data_SHX.m_flow_shell,
    p_a_start_tube=data_SHX.p_inlet_tube,
    T_a_start_tube=data_SHX.T_inlet_tube,
    T_b_start_tube=data_SHX.T_outlet_tube,
    m_flow_a_start_tube=2*3*data_SHX.m_flow_tube,
    redeclare package Medium_tube = Medium_BOP)   annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-80,0})));

  Fluid.BoundaryConditions.Boundary_pT boundary1(
    p=data_SHX.p_outlet_tube,
    T=data_SHX.T_outlet_tube,
    nPorts=1,
    redeclare package Medium = Medium_BOP)
                             annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={-50,40})));
  Fluid.BoundaryConditions.MassFlowSource_T boundary4(
    m_flow=2*3*data_SHX.m_flow_tube,
    T=data_SHX.T_inlet_tube,
    nPorts=1,
    redeclare package Medium = Medium_BOP)
                              annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-50,-38})));
  Fluid.BoundaryConditions.Boundary_pT boundary2(
    nPorts=1,
    redeclare package Medium = Medium_PCL,
    p=data_SHX.p_outlet_shell,
    T=data_SHX.T_outlet_shell)
                             annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-114,-28})));
  Fluid.BoundaryConditions.MassFlowSource_T boundary3(
    nPorts=1,
    redeclare package Medium = Medium_PCL,
    m_flow=2*3*data_SHX.m_flow_shell,
    T=data_SHX.T_inlet_shell) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-110,32})));
  Data.data_SHX data_SHX
    annotation (Placement(transformation(extent={{-100,100},{-80,120}})));
equation
  connect(boundary2.ports[1], SHX.port_b_shell) annotation (Line(points={{-104,-28},
          {-84.6,-28},{-84.6,-10}}, color={0,127,255}));
  connect(boundary3.ports[1], SHX.port_a_shell) annotation (Line(points={{-100,32},
          {-84.6,32},{-84.6,10}}, color={0,127,255}));
  connect(boundary1.ports[1], SHX.port_b_tube)
    annotation (Line(points={{-60,40},{-80,40},{-80,10}}, color={0,127,255}));
  connect(boundary4.ports[1], SHX.port_a_tube) annotation (Line(points={{-60,-38},
          {-80,-38},{-80,-10}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end BOP;
