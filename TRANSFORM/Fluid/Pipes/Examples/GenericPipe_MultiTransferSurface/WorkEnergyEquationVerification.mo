within TRANSFORM.Fluid.Pipes.Examples.GenericPipe_MultiTransferSurface;
model WorkEnergyEquationVerification
  extends TRANSFORM.Icons.Example;

  TRANSFORM.Fluid.Volumes.ExpansionTank tank(
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    A=0.1,
    V0=0.05,
    p_start=1000000,
    level_start=0.5,
    T_start=323.15)
    annotation (Placement(transformation(extent={{-172,92},{-192,112}})));
  TRANSFORM.Fluid.Machines.Pump_SimpleMassFlow pump(
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    use_input=false,
    m_flow_nominal=10) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={-226,96})));
  TRANSFORM.Utilities.Visualizers.displayReal display2(
    val=pipe.port_a.h_outflow - pipe.port_b.h_outflow,
    precision=2,
    unitLabel="delta_h") annotation (Placement(transformation(extent={{-20,-10},
            {20,10}}, origin={-208,44})));
  TRANSFORM.Utilities.Visualizers.displayReal display1(
    val=pipe.geometry.nV,
    precision=0,
    unitLabel="nV") annotation (Placement(transformation(extent={{-20,-10},{20,10}},
          origin={-208,34})));

  TRANSFORM.Utilities.Visualizers.displayReal display9(
    val=pipe.Wb_flows[1],
    precision=2,
    unitLabel="wb_flow[1]") annotation (Placement(transformation(extent={{-20,-10},
            {20,10}}, origin={-208,24})));
  TRANSFORM.Utilities.Visualizers.displayReal display13(
    val=pipe.Wb_flows[2],
    precision=2,
    unitLabel="wb_flow[2]") annotation (Placement(transformation(extent={{-20,-10},
            {20,10}}, origin={-208,14})));

  TRANSFORM.Fluid.Pipes.GenericPipe_MultiTransferSurface pipe(
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    p_a_start=1000000,
    p_b_start=1000000,
    T_a_start=323.15,
    T_b_start=323.15,
    m_flow_a_start=1,
    redeclare model Geometry =
        TRANSFORM.Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.StraightPipe
        (dimension=0.1, nV=2),
    exposeState_a=true,
    exposeState_b=false)
    annotation (Placement(transformation(extent={{-216,66},{-196,86}})));
  TRANSFORM.Utilities.Visualizers.displayReal display_exposeState_a(
    val=if pipe.exposeState_a then 1 else 0,
    precision=0,
    unitLabel="a") annotation (Placement(transformation(extent={{-8,-11},{8,11}},
          origin={-230,65})));
  TRANSFORM.Utilities.Visualizers.displayReal display_exposeState_b(
    val=if pipe.exposeState_b then 1 else 0,
    precision=0,
    unitLabel="b") annotation (Placement(transformation(extent={{-8,-11},{8,11}},
          origin={-188,65})));
  TRANSFORM.Fluid.Volumes.ExpansionTank tank1(
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    A=0.1,
    V0=0.05,
    p_start=1000000,
    level_start=0.5,
    T_start=323.15)
    annotation (Placement(transformation(extent={{-48,94},{-68,114}})));
  TRANSFORM.Fluid.Machines.Pump_SimpleMassFlow pump1(
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    use_input=false,
    m_flow_nominal=10) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={-102,98})));
  TRANSFORM.Utilities.Visualizers.displayReal display3(
    val=pipe1.port_a.h_outflow - pipe1.port_b.h_outflow,
    precision=2,
    unitLabel="delta_h") annotation (Placement(transformation(extent={{-20,-10},
            {20,10}}, origin={-84,46})));
  TRANSFORM.Utilities.Visualizers.displayReal display4(
    val=pipe1.geometry.nV,
    precision=0,
    unitLabel="nV") annotation (Placement(transformation(extent={{-20,-10},{20,10}},
          origin={-84,36})));
  TRANSFORM.Utilities.Visualizers.displayReal display5(
    val=pipe1.Wb_flows[1],
    precision=2,
    unitLabel="wb_flow[1]") annotation (Placement(transformation(extent={{-20,-10},
            {20,10}}, origin={-84,26})));
  TRANSFORM.Utilities.Visualizers.displayReal display6(
    val=pipe1.Wb_flows[2],
    precision=2,
    unitLabel="wb_flow[2]") annotation (Placement(transformation(extent={{-20,-10},
            {20,10}}, origin={-84,16})));
  TRANSFORM.Fluid.Pipes.GenericPipe_MultiTransferSurface pipe1(
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    p_a_start=1000000,
    p_b_start=1000000,
    T_a_start=323.15,
    T_b_start=323.15,
    m_flow_a_start=1,
    redeclare model Geometry =
        TRANSFORM.Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.StraightPipe
        (dimension=0.1, nV=2),
    exposeState_a=false,
    exposeState_b=true)
    annotation (Placement(transformation(extent={{-92,68},{-72,88}})));
  TRANSFORM.Utilities.Visualizers.displayReal display_exposeState_a1(
    val=if pipe1.exposeState_a then 1 else 0,
    precision=0,
    unitLabel="a") annotation (Placement(transformation(extent={{-8,-11},{8,11}},
          origin={-106,67})));
  TRANSFORM.Utilities.Visualizers.displayReal display_exposeState_b1(
    val=if pipe1.exposeState_b then 1 else 0,
    precision=0,
    unitLabel="b") annotation (Placement(transformation(extent={{-8,-11},{8,11}},
          origin={-64,67})));
  TRANSFORM.Fluid.Volumes.ExpansionTank tank2(
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    A=0.1,
    V0=0.05,
    p_start=1000000,
    level_start=0.5,
    T_start=323.15)
    annotation (Placement(transformation(extent={{92,94},{72,114}})));
  TRANSFORM.Fluid.Machines.Pump_SimpleMassFlow pump2(
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    use_input=false,
    m_flow_nominal=10) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={38,98})));
  TRANSFORM.Utilities.Visualizers.displayReal display7(
    val=pipe2.port_a.h_outflow - pipe2.port_b.h_outflow,
    precision=2,
    unitLabel="delta_h") annotation (Placement(transformation(extent={{-20,-10},
            {20,10}}, origin={56,46})));
  TRANSFORM.Utilities.Visualizers.displayReal display8(
    val=pipe2.geometry.nV,
    precision=0,
    unitLabel="nV") annotation (Placement(transformation(extent={{-20,-10},{20,10}},
          origin={56,36})));
  TRANSFORM.Utilities.Visualizers.displayReal display10(
    val=pipe2.Wb_flows[1],
    precision=2,
    unitLabel="wb_flow[1]") annotation (Placement(transformation(extent={{-20,-10},
            {20,10}}, origin={56,26})));
  TRANSFORM.Utilities.Visualizers.displayReal display11(
    val=pipe2.Wb_flows[2],
    precision=2,
    unitLabel="wb_flow[2]") annotation (Placement(transformation(extent={{-20,-10},
            {20,10}}, origin={56,16})));
  TRANSFORM.Fluid.Pipes.GenericPipe_MultiTransferSurface pipe2(
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    p_a_start=1000000,
    p_b_start=1000000,
    T_a_start=323.15,
    T_b_start=323.15,
    m_flow_a_start=1,
    redeclare model Geometry =
        TRANSFORM.Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.StraightPipe
        (dimension=0.1, nV=2),
    exposeState_a=true,
    exposeState_b=true)
    annotation (Placement(transformation(extent={{48,68},{68,88}})));
  TRANSFORM.Utilities.Visualizers.displayReal display_exposeState_a2(
    val=if pipe2.exposeState_a then 1 else 0,
    precision=0,
    unitLabel="a") annotation (Placement(transformation(extent={{-8,-11},{8,11}},
          origin={34,67})));
  TRANSFORM.Utilities.Visualizers.displayReal display_exposeState_b2(
    val=if pipe2.exposeState_b then 1 else 0,
    precision=0,
    unitLabel="b") annotation (Placement(transformation(extent={{-8,-11},{8,11}},
          origin={76,67})));
  TRANSFORM.Fluid.Volumes.ExpansionTank tank3(
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    A=0.1,
    V0=0.05,
    p_start=1000000,
    level_start=0.5,
    T_start=323.15)
    annotation (Placement(transformation(extent={{230,96},{210,116}})));
  TRANSFORM.Fluid.Machines.Pump_SimpleMassFlow pump3(
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    use_input=false,
    m_flow_nominal=10) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={176,100})));
  TRANSFORM.Utilities.Visualizers.displayReal display12(
    val=pipe3.port_a.h_outflow - pipe3.port_b.h_outflow,
    precision=2,
    unitLabel="delta_h") annotation (Placement(transformation(extent={{-20,-10},
            {20,10}}, origin={194,48})));
  TRANSFORM.Utilities.Visualizers.displayReal display14(
    val=pipe3.geometry.nV,
    precision=0,
    unitLabel="nV") annotation (Placement(transformation(extent={{-20,-10},{20,10}},
          origin={194,38})));
  TRANSFORM.Utilities.Visualizers.displayReal display15(
    val=pipe3.Wb_flows[1],
    precision=2,
    unitLabel="wb_flow[1]") annotation (Placement(transformation(extent={{-20,-10},
            {20,10}}, origin={194,28})));
  TRANSFORM.Utilities.Visualizers.displayReal display16(
    val=pipe3.Wb_flows[2],
    precision=2,
    unitLabel="wb_flow[1]") annotation (Placement(transformation(extent={{-20,-10},
            {20,10}}, origin={194,18})));
  TRANSFORM.Fluid.Pipes.GenericPipe_MultiTransferSurface pipe3(
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    p_a_start=1000000,
    p_b_start=1000000,
    T_a_start=323.15,
    T_b_start=323.15,
    m_flow_a_start=1,
    redeclare model Geometry =
        TRANSFORM.Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.StraightPipe
        (dimension=0.1, nV=2),
    exposeState_a=false,
    exposeState_b=false)
    annotation (Placement(transformation(extent={{186,70},{206,90}})));
  TRANSFORM.Utilities.Visualizers.displayReal display_exposeState_a3(
    val=if pipe3.exposeState_a then 1 else 0,
    precision=0,
    unitLabel="a") annotation (Placement(transformation(extent={{-8,-11},{8,11}},
          origin={172,69})));
  TRANSFORM.Utilities.Visualizers.displayReal display_exposeState_b3(
    val=if pipe3.exposeState_b then 1 else 0,
    precision=0,
    unitLabel="b") annotation (Placement(transformation(extent={{-8,-11},{8,11}},
          origin={214,69})));
  TRANSFORM.Fluid.Volumes.ExpansionTank tank4(
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    A=0.1,
    V0=0.05,
    p_start=1000000,
    level_start=0.5,
    T_start=323.15)
    annotation (Placement(transformation(extent={{-176,-24},{-196,-4}})));
  TRANSFORM.Fluid.Machines.Pump_SimpleMassFlow pump4(
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    use_input=false,
    m_flow_nominal=10) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={-230,-20})));
  TRANSFORM.Utilities.Visualizers.displayReal display17(
    val=pipe4.port_a.h_outflow - pipe4.port_b.h_outflow,
    precision=2,
    unitLabel="delta_h") annotation (Placement(transformation(extent={{-20,-10},
            {20,10}}, origin={-212,-72})));
  TRANSFORM.Utilities.Visualizers.displayReal display18(
    val=pipe4.geometry.nV,
    precision=0,
    unitLabel="nV") annotation (Placement(transformation(extent={{-20,-10},{20,10}},
          origin={-212,-82})));
  TRANSFORM.Utilities.Visualizers.displayReal display19(
    val=pipe4.Wb_flows[1],
    precision=2,
    unitLabel="wb_flow[1]") annotation (Placement(transformation(extent={{-20,-10},
            {20,10}}, origin={-212,-92})));
  TRANSFORM.Utilities.Visualizers.displayReal display20(
    val=pipe4.Wb_flows[2],
    precision=2,
    unitLabel="wb_flow[2]") annotation (Placement(transformation(extent={{-20,-10},
            {20,10}}, origin={-212,-102})));
  TRANSFORM.Fluid.Pipes.GenericPipe_MultiTransferSurface pipe4(
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    p_a_start=1000000,
    p_b_start=1000000,
    T_a_start=323.15,
    T_b_start=323.15,
    m_flow_a_start=1,
    redeclare model Geometry =
        TRANSFORM.Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.StraightPipe
        (dimension=0.1, nV=3),
    exposeState_a=true,
    exposeState_b=false)
    annotation (Placement(transformation(extent={{-220,-50},{-200,-30}})));
  TRANSFORM.Utilities.Visualizers.displayReal display_exposeState_a4(
    val=if pipe4.exposeState_a then 1 else 0,
    precision=0,
    unitLabel="a") annotation (Placement(transformation(extent={{-8,-11},{8,11}},
          origin={-234,-51})));
  TRANSFORM.Utilities.Visualizers.displayReal display_exposeState_b4(
    val=if pipe4.exposeState_b then 1 else 0,
    precision=0,
    unitLabel="b") annotation (Placement(transformation(extent={{-8,-11},{8,11}},
          origin={-192,-51})));
  TRANSFORM.Fluid.Volumes.ExpansionTank tank5(
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    A=0.1,
    V0=0.05,
    p_start=1000000,
    level_start=0.5,
    T_start=323.15)
    annotation (Placement(transformation(extent={{-52,-22},{-72,-2}})));
  TRANSFORM.Fluid.Machines.Pump_SimpleMassFlow pump5(
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    use_input=false,
    m_flow_nominal=10) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={-106,-18})));
  TRANSFORM.Utilities.Visualizers.displayReal display21(
    val=pipe5.port_a.h_outflow - pipe5.port_b.h_outflow,
    precision=2,
    unitLabel="delta_h") annotation (Placement(transformation(extent={{-20,-10},
            {20,10}}, origin={-88,-70})));
  TRANSFORM.Utilities.Visualizers.displayReal display22(
    val=pipe5.geometry.nV,
    precision=0,
    unitLabel="nV") annotation (Placement(transformation(extent={{-20,-10},{20,10}},
          origin={-88,-80})));
  TRANSFORM.Utilities.Visualizers.displayReal display23(
    val=pipe5.Wb_flows[1],
    precision=2,
    unitLabel="wb_flow[1]") annotation (Placement(transformation(extent={{-20,-10},
            {20,10}}, origin={-88,-90})));
  TRANSFORM.Utilities.Visualizers.displayReal display24(
    val=pipe5.Wb_flows[2],
    precision=2,
    unitLabel="wb_flow[2]") annotation (Placement(transformation(extent={{-20,-10},
            {20,10}}, origin={-88,-100})));
  TRANSFORM.Fluid.Pipes.GenericPipe_MultiTransferSurface pipe5(
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    p_a_start=1000000,
    p_b_start=1000000,
    T_a_start=323.15,
    T_b_start=323.15,
    m_flow_a_start=1,
    redeclare model Geometry =
        TRANSFORM.Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.StraightPipe
        (dimension=0.1, nV=3),
    exposeState_a=false,
    exposeState_b=true)
    annotation (Placement(transformation(extent={{-96,-48},{-76,-28}})));
  TRANSFORM.Utilities.Visualizers.displayReal display_exposeState_a5(
    val=if pipe5.exposeState_a then 1 else 0,
    precision=0,
    unitLabel="a") annotation (Placement(transformation(extent={{-8,-11},{8,11}},
          origin={-110,-49})));
  TRANSFORM.Utilities.Visualizers.displayReal display_exposeState_b5(
    val=if pipe5.exposeState_b then 1 else 0,
    precision=0,
    unitLabel="b") annotation (Placement(transformation(extent={{-8,-11},{8,11}},
          origin={-68,-49})));
  TRANSFORM.Fluid.Volumes.ExpansionTank tank6(
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    A=0.1,
    V0=0.05,
    p_start=1000000,
    level_start=0.5,
    T_start=323.15)
    annotation (Placement(transformation(extent={{88,-22},{68,-2}})));
  TRANSFORM.Fluid.Machines.Pump_SimpleMassFlow pump6(
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    use_input=false,
    m_flow_nominal=10) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={34,-18})));
  TRANSFORM.Utilities.Visualizers.displayReal display25(
    val=pipe6.port_a.h_outflow - pipe6.port_b.h_outflow,
    precision=2,
    unitLabel="delta_h") annotation (Placement(transformation(extent={{-20,-10},
            {20,10}}, origin={52,-70})));
  TRANSFORM.Utilities.Visualizers.displayReal display26(
    val=pipe6.geometry.nV,
    precision=0,
    unitLabel="nV") annotation (Placement(transformation(extent={{-20,-10},{20,10}},
          origin={52,-80})));
  TRANSFORM.Utilities.Visualizers.displayReal display27(
    val=pipe6.Wb_flows[1],
    precision=2,
    unitLabel="wb_flow[1]") annotation (Placement(transformation(extent={{-20,-10},
            {20,10}}, origin={52,-90})));
  TRANSFORM.Utilities.Visualizers.displayReal display28(
    val=pipe6.Wb_flows[2],
    precision=2,
    unitLabel="wb_flow[2]") annotation (Placement(transformation(extent={{-20,-10},
            {20,10}}, origin={52,-100})));
  TRANSFORM.Fluid.Pipes.GenericPipe_MultiTransferSurface pipe6(
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    p_a_start=1000000,
    p_b_start=1000000,
    T_a_start=323.15,
    T_b_start=323.15,
    m_flow_a_start=1,
    redeclare model Geometry =
        TRANSFORM.Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.StraightPipe
        (dimension=0.1, nV=3),
    exposeState_a=true,
    exposeState_b=true)
    annotation (Placement(transformation(extent={{44,-48},{64,-28}})));
  TRANSFORM.Utilities.Visualizers.displayReal display_exposeState_a6(
    val=if pipe6.exposeState_a then 1 else 0,
    precision=0,
    unitLabel="a") annotation (Placement(transformation(extent={{-8,-11},{8,11}},
          origin={30,-49})));
  TRANSFORM.Utilities.Visualizers.displayReal display_exposeState_b6(
    val=if pipe6.exposeState_b then 1 else 0,
    precision=0,
    unitLabel="b") annotation (Placement(transformation(extent={{-8,-11},{8,11}},
          origin={72,-49})));
  TRANSFORM.Fluid.Volumes.ExpansionTank tank7(
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    A=0.1,
    V0=0.05,
    p_start=1000000,
    level_start=0.5,
    T_start=323.15)
    annotation (Placement(transformation(extent={{226,-20},{206,0}})));
  TRANSFORM.Fluid.Machines.Pump_SimpleMassFlow pump7(
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    use_input=false,
    m_flow_nominal=10) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={172,-16})));
  TRANSFORM.Utilities.Visualizers.displayReal display29(
    val=pipe7.port_a.h_outflow - pipe7.port_b.h_outflow,
    precision=2,
    unitLabel="delta_h") annotation (Placement(transformation(extent={{-20,-10},
            {20,10}}, origin={190,-68})));
  TRANSFORM.Utilities.Visualizers.displayReal display30(
    val=pipe7.geometry.nV,
    precision=0,
    unitLabel="nV") annotation (Placement(transformation(extent={{-20,-10},{20,10}},
          origin={190,-78})));
  TRANSFORM.Utilities.Visualizers.displayReal display31(
    val=pipe7.Wb_flows[1],
    precision=2,
    unitLabel="wb_flow[1]") annotation (Placement(transformation(extent={{-20,-10},
            {20,10}}, origin={190,-88})));
  TRANSFORM.Utilities.Visualizers.displayReal display32(
    val=pipe7.Wb_flows[2],
    precision=2,
    unitLabel="wb_flow[1]") annotation (Placement(transformation(extent={{-20,-10},
            {20,10}}, origin={190,-98})));
  TRANSFORM.Fluid.Pipes.GenericPipe_MultiTransferSurface pipe7(
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    p_a_start=1000000,
    p_b_start=1000000,
    T_a_start=323.15,
    T_b_start=323.15,
    m_flow_a_start=1,
    redeclare model Geometry =
        TRANSFORM.Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.StraightPipe
        (dimension=0.1, nV=3),
    exposeState_a=false,
    exposeState_b=false)
    annotation (Placement(transformation(extent={{182,-46},{202,-26}})));
  TRANSFORM.Utilities.Visualizers.displayReal display_exposeState_a7(
    val=if pipe7.exposeState_a then 1 else 0,
    precision=0,
    unitLabel="a") annotation (Placement(transformation(extent={{-8,-11},{8,11}},
          origin={168,-47})));
  TRANSFORM.Utilities.Visualizers.displayReal display_exposeState_b7(
    val=if pipe7.exposeState_b then 1 else 0,
    precision=0,
    unitLabel="b") annotation (Placement(transformation(extent={{-8,-11},{8,11}},
          origin={210,-47})));
equation

  connect(tank.port_b, pump.port_a)
    annotation (Line(points={{-189,96},{-216,96}}, color={0,127,255}));
  connect(pump.port_b, pipe.port_a) annotation (Line(points={{-236,96},{-238,96},
          {-238,76},{-216,76}}, color={0,127,255}));
  connect(pipe.port_b, tank.port_a) annotation (Line(points={{-196,76},{-175,76},
          {-175,96}}, color={0,127,255}));
  connect(tank1.port_b, pump1.port_a)
    annotation (Line(points={{-65,98},{-92,98}}, color={0,127,255}));
  connect(pump1.port_b, pipe1.port_a) annotation (Line(points={{-112,98},{-114,98},
          {-114,78},{-92,78}}, color={0,127,255}));
  connect(pipe1.port_b, tank1.port_a)
    annotation (Line(points={{-72,78},{-51,78},{-51,98}}, color={0,127,255}));
  connect(tank2.port_b, pump2.port_a)
    annotation (Line(points={{75,98},{48,98}}, color={0,127,255}));
  connect(pump2.port_b, pipe2.port_a) annotation (Line(points={{28,98},{26,98},{
          26,78},{48,78}}, color={0,127,255}));
  connect(pipe2.port_b, tank2.port_a) annotation (Line(points={{68,78},{100,78},
          {100,98},{89,98}}, color={0,127,255}));
  connect(tank3.port_b, pump3.port_a)
    annotation (Line(points={{213,100},{186,100}}, color={0,127,255}));
  connect(pump3.port_b, pipe3.port_a) annotation (Line(points={{166,100},{164,100},
          {164,80},{186,80}}, color={0,127,255}));
  connect(pipe3.port_b, tank3.port_a) annotation (Line(points={{206,80},{238,80},
          {238,100},{227,100}}, color={0,127,255}));
  connect(tank4.port_b, pump4.port_a)
    annotation (Line(points={{-193,-20},{-220,-20}}, color={0,127,255}));
  connect(pump4.port_b, pipe4.port_a) annotation (Line(points={{-240,-20},{-242,
          -20},{-242,-40},{-220,-40}}, color={0,127,255}));
  connect(pipe4.port_b, tank4.port_a) annotation (Line(points={{-200,-40},{-179,
          -40},{-179,-20}}, color={0,127,255}));
  connect(tank5.port_b, pump5.port_a)
    annotation (Line(points={{-69,-18},{-96,-18}}, color={0,127,255}));
  connect(pump5.port_b, pipe5.port_a) annotation (Line(points={{-116,-18},{-118,
          -18},{-118,-38},{-96,-38}}, color={0,127,255}));
  connect(pipe5.port_b, tank5.port_a) annotation (Line(points={{-76,-38},{-55,-38},
          {-55,-18}}, color={0,127,255}));
  connect(tank6.port_b, pump6.port_a)
    annotation (Line(points={{71,-18},{44,-18}}, color={0,127,255}));
  connect(pump6.port_b, pipe6.port_a) annotation (Line(points={{24,-18},{22,-18},
          {22,-38},{44,-38}}, color={0,127,255}));
  connect(pipe6.port_b, tank6.port_a) annotation (Line(points={{64,-38},{96,-38},
          {96,-18},{85,-18}}, color={0,127,255}));
  connect(tank7.port_b, pump7.port_a)
    annotation (Line(points={{209,-16},{182,-16}}, color={0,127,255}));
  connect(pump7.port_b, pipe7.port_a) annotation (Line(points={{162,-16},{160,-16},
          {160,-36},{182,-36}}, color={0,127,255}));
  connect(pipe7.port_b, tank7.port_a) annotation (Line(points={{202,-36},{234,-36},
          {234,-16},{223,-16}}, color={0,127,255}));
  annotation (
    experiment(
      StopTime=1000000,
      __Dymola_NumberOfIntervals=5000,
      Tolerance=1e-05,
      __Dymola_Algorithm="Esdirk45a"),
    Diagram(coordinateSystem(extent={{-280,-120},{280,120}})),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}})),
    Documentation(info="<html>
<p>See marchermao: https://github.com/ORNL-Modelica/TRANSFORM-Library/issues/105</p>
</html>"));
end WorkEnergyEquationVerification;
