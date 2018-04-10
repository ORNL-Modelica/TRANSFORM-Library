within TRANSFORM.HeatExchangers.BellDelaware_STHX.Examples.Verification;
model BellDelaware_hT

  extends TRANSFORM.Icons.Example;

  TRANSFORM.Utilities.ErrorAnalysis.Errors_AbsRelRMSold[2] summary_Error(
    n={1,1},
    x_1={{shell.alpha_avg_output},{shell.entryPipe_b.mediums[1].T - source.T}},
    x_2={{alpha},{dT}})
    annotation (Placement(transformation(extent={{60,60},{80,80}})));

  parameter SI.Temperature T_inlet = 63.3+273.15 "Example problem input temperature";
  parameter SI.Temperature T_outlet = 56.7+273.15 "Example problem output temperature";
  final parameter SI.TemperatureDifference  dT = T_outlet - T_inlet;

  parameter SI.CoefficientOfHeatTransfer alpha = 3324 "Example problem calculated heat transfer coefficient";

  Modelica.Fluid.Sources.Boundary_pT sink(
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    nPorts=1,
    p=100000,
    T=328.15) annotation (Placement(transformation(extent={{70,-10},{50,10}})));
  Modelica.Fluid.Sources.MassFlowSource_T source(
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    nPorts=1,
    m_flow=20/60^2*983,
    T=336.45)
    annotation (Placement(transformation(extent={{-68,-10},{-48,10}})));
  inner Modelica.Fluid.System system(energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyStateInitial)
    annotation (Placement(transformation(extent={{80,80},{100,100}})));
  BaseClasses.STHX_ShellSide_BellDelaware shell(
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    toggleStaggered=true,
    n_bs=0,
    d_o=0.025,
    s2=0.0277,
    n_s=0,
    m_flow_start=source.m_flow,
    p_b_start=sink.p,
    n_tubes=66,
    DB=0.285,
    nes=8,
    D_i=0.310,
    n_MR=5,
    n_MRE=7.5,
    n_RW=2.5,
    H=0.076,
    D_l=0.307,
    d_B=0.026,
    e1=0.0125,
    nb=4,
    s1=0.032,
    S=0.184,
    S_E_a=0.184,
    S_E_b=0.184,
    d_N_a=0.2,
    d_N_b=0.2,
    n_W_tubes=25,
    nNodes_nozzle=1,
    nNodes_endCross=1,
    nNodes_window=1,
    nNodes_centerCross=1,
    modelStructure=Modelica.Fluid.Types.ModelStructure.av_b,
    p_a_start=sink.p + 1400,
    T_a_start=source.T,
    T_b_start=sink.T)
    annotation (Placement(transformation(extent={{-18,-18},{18,18}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature[shell.nNodes_intTotal](
     each T=323.15)
    annotation (Placement(transformation(extent={{-36,44},{-24,56}})));

equation
  connect(source.ports[1], shell.port_a)
    annotation (Line(points={{-48,0},{-34,0},{-18,0}}, color={0,127,255}));
  connect(shell.port_b, sink.ports[1])
    annotation (Line(points={{18,0},{34,0},{50,0}}, color={0,127,255}));
  connect(fixedTemperature.port, shell.heatPorts_a)
    annotation (Line(points={{-24,50},{0,50},{0,-2.88}}, color={191,0,0}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})),
    experiment(StopTime=500, __Dymola_Algorithm="Dassl"),
    __Dymola_experimentSetupOutput,
    Documentation(info="<html>
<p>Solution and comparison to Example problem at end of chapter G8 from VDI Heat Atals 2010 (pp. 738-739).</p>
</html>"));
end BellDelaware_hT;
