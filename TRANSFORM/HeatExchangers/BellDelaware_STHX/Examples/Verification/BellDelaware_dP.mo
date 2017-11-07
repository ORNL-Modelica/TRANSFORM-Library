within TRANSFORM.HeatExchangers.BellDelaware_STHX.Examples.Verification;
model BellDelaware_dP
  extends Modelica.Icons.Example;

  TRANSFORM.Utilities.ErrorAnalysis.Errors_AbsRelRMSold summary_Error(
    n=1,
    x_1={shell.entryPipe_a.mediums[1].p - sink.p},
    x_2={dP}) annotation (Placement(transformation(extent={{60,60},{80,80}})));

  parameter SI.PressureDifference dP = 0.032e5 "Example total pressure drop";

  Modelica.Fluid.Sources.Boundary_pT sink(
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    nPorts=1,
    p=100000,
    T=333.15) annotation (Placement(transformation(extent={{70,-10},{50,10}})));
  Modelica.Fluid.Sources.MassFlowSource_T source(
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    m_flow=60/60^2*983,
    nPorts=1,
    T=333.15)
    annotation (Placement(transformation(extent={{-68,-10},{-48,10}})));
  inner Modelica.Fluid.System system(energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyStateInitial)
    annotation (Placement(transformation(extent={{80,80},{100,100}})));
  BaseClasses.STHX_ShellSide_BellDelaware shell(
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    toggleStaggered=true,
    n_tubes=258,
    DB=0.56,
    d_o=0.025,
    e1=0.029,
    nes=16,
    D_i=0.597,
    n_MR=11,
    n_MRE=15.5,
    H=0.1345,
    D_l=0.59,
    d_B=0.026,
    s1=0.032,
    s2=0.0277,
    S=0.25,
    S_E_a=0.315,
    S_E_b=0.315,
    n_RW=4.5,
    d_N_a=0.21,
    d_N_b=0.21,
    modelStructure=Modelica.Fluid.Types.ModelStructure.av_b,
    nb=8,
    m_flow_start=source.m_flow,
    p_b_start=sink.p,
    n_W_tubes=82,
    T_a_start=source.T,
    T_b_start=sink.T,
    p_a_start=sink.p + 3e3)
    annotation (Placement(transformation(extent={{-18,-18},{18,18}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature[shell.nNodes_intTotal](each T=
        338.15)
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
    experiment(StopTime=500),
    __Dymola_experimentSetupOutput,
    Documentation(info="<html>
<p>Solution and comparison to Example problem at end of chapter L1.5 from VDI Heat Atals 2010 (pp. 1100-1102).</p>
</html>"));
end BellDelaware_dP;
