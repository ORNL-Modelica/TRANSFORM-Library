within TRANSFORM.Fluid.Pipes_Obsolete.ClosureModels.HeatTransfer.Examples;
model DittusBoelter_Test
  "Test case for Dittus-Boelter Correlation heat transfer model"
  extends Modelica.Icons.Example;
  inner System_TP system(energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyStateInitial)
    annotation (Placement(transformation(extent={{60,60},{80,80}})));

  Pipes_Obsolete.StraightPipeOLD pipe(
    use_HeatTransfer=true,
    modelStructure=Modelica.Fluid.Types.ModelStructure.av_b,
    isCircular=true,
    nV=10,
    p_b_start=Sink.p,
    m_flow_a_start=Source.m_flow,
    p_a_start=Sink.p + 1000,
    redeclare model HeatTransfer = SinglePhase.DittusBoelter,
    redeclare package Medium = Modelica.Media.Air.DryAirNasa,
    length=5,
    diameter=0.15,
    T_a_start=Source.T,
    T_b_start=Sink.T)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

  Modelica.Fluid.Sources.Boundary_pT Sink(
    nPorts=1,
    p=100000,
    T=350.15,
    redeclare package Medium = Modelica.Media.Air.DryAirNasa)
             annotation (Placement(transformation(extent={{60,-10},{40,10}})));
  Modelica.Fluid.Sources.MassFlowSource_T Source(
    nPorts=1,
    m_flow=0.05,
    T=376.15,
    redeclare package Medium = Modelica.Media.Air.DryAirNasa)
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Modelica.Thermal.HeatTransfer.Components.Convection convection[pipe.nV]
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,40})));
  Modelica.Blocks.Sources.Constant const[pipe.nV](k=Modelica.Constants.pi*
        0.15*5*6/pipe.nV*ones(pipe.nV))
    annotation (Placement(transformation(extent={{-60,30},{-40,50}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature[
    pipe.nV](each T=273.15)
    annotation (Placement(transformation(extent={{-30,60},{-10,80}})));
equation
  connect(Source.ports[1], pipe.port_a)
    annotation (Line(points={{-40,0},{-10,0}},         color={0,127,255}));
  connect(pipe.port_b, Sink.ports[1])
    annotation (Line(points={{10,0},{40,0}},       color={0,127,255}));

  connect(const.y, convection.Gc)
    annotation (Line(points={{-39,40},{-10,40}}, color={0,0,127}));
  connect(convection.solid, pipe.heatPorts)
    annotation (Line(points={{0,30},{0,4.4},{0.1,4.4}}, color={191,0,0}));
  connect(fixedTemperature.port, convection.fluid)
    annotation (Line(points={{-10,70},{0,70},{0,50}}, color={191,0,0}));
  annotation (experiment(__Dymola_NumberOfIntervals=10, __Dymola_Algorithm=
          "Dassl"),                      __Dymola_experimentSetupOutput,
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,100}})),
    Documentation(info="<html>
<p>This example is taken from Example 8.6  from Fundamentals of Heat and Mass Transfer 6E by Incropera and DeWitt.</p>
</html>"));
end DittusBoelter_Test;
