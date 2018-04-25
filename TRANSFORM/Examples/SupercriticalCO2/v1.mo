within TRANSFORM.Examples.SupercriticalCO2;
model v1

  package Medium = ExternalMedia.Examples.CO2CoolProp(p_default=8e6);  //Requires VS2012 compiler option

  Data.Data_Basic data
    annotation (Placement(transformation(extent={{80,80},{100,100}})));
  Fluid.Pipes.GenericPipe_MultiTransferSurface pipe(
    exposeState_b=true,
    redeclare package Medium = Medium,
    p_a_start(displayUnit="Pa") = 8e6,
    use_HeatTransfer=true,
    redeclare model HeatTransfer =
        Fluid.ClosureRelations.HeatTransfer.Models.DistributedPipe_1D_MultiTransferSurface.Nus_SinglePhase_2Region,

    T_a_start=301.15,
    redeclare model Geometry =
        TRANSFORM.Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.StraightPipe
        (
        dimension=0.00116,
        length=0.5,
        nV=20))       annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-30,0})));
  Fluid.BoundaryConditions.MassFlowSource_T boundary(
    redeclare package Medium = Medium,
    nPorts=1,
    m_flow=0.001,
    T=301.15)
    annotation (Placement(transformation(extent={{-60,-60},{-40,-40}})));
  Fluid.BoundaryConditions.Boundary_pT boundary1(
    nPorts=1,
    redeclare package Medium = Medium,
    p(displayUnit="MPa") = 7900000,
    T=998.15) annotation (Placement(transformation(extent={{-60,50},{-40,70}})));
  Fluid.FittingsAndResistances.SpecifiedResistance resistance1(redeclare
      package Medium = Medium, R=1) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-30,30})));
  HeatAndMassTransfer.BoundaryConditions.Heat.Temperature_multi boundary2(
      nPorts=pipe.nV, T=linspace(
        625,
        825,
        pipe.nV))
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
equation
  connect(boundary1.ports[1], resistance1.port_b)
    annotation (Line(points={{-40,60},{-30,60},{-30,37}}, color={0,127,255}));
  connect(resistance1.port_a, pipe.port_b)
    annotation (Line(points={{-30,23},{-30,10}}, color={0,127,255}));
  connect(boundary.ports[1], pipe.port_a) annotation (Line(points={{-40,-50},{-30,
          -50},{-30,-10}}, color={0,127,255}));
  connect(boundary2.port, pipe.heatPorts[:, 1])
    annotation (Line(points={{-60,0},{-35,0}}, color={191,0,0}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end v1;
