within TRANSFORM.HeatAndMassTransfer.ClosureRelations.HeatTransfer.Functions.Examples.SinglePhase.ExternalFlow;
model check_Nu_Grimison_FlowAcrossTubeBanks

  extends TRANSFORM.Icons.Example;

  parameter SI.PrandtlNumber Pr=1.5 "Prandtl Number";
  parameter SI.Length D = 0.4 "Tube diameter";
  parameter SI.Length S_T = 0.6 "Transverse (within same row) tube pitch";
  parameter SI.Length S_L = 0.5 "Longitudinal (between rows) tube pitch";
  parameter Real nRows=10 "Not necessary if nRows >= 10";
  parameter Boolean tubesAligned=false " = false if staggered";

  Real y[2];

  Modelica.Blocks.Sources.Trapezoid Re(
    rising=1,
    width=0,
    falling=1,
    period=2,
    nperiod=1,
    amplitude=4000)
    annotation (Placement(transformation(extent={{-10,10},{10,30}})));
  Utilities.ErrorAnalysis.UnitTests unitTests(n=2, x=y)
    annotation (Placement(transformation(extent={{80,80},{100,100}})));

equation

  y[1] =
    TRANSFORM.HeatAndMassTransfer.ClosureRelations.HeatTransfer.Functions.SinglePhase.ExternalFlow.Nu_Grimison_FlowAcrossTubeBanks(
    Re.y,
    Pr,
    D,
    S_T,
    S_L,
    nRows,
    tubesAligned);
  y[2] =
    TRANSFORM.HeatAndMassTransfer.ClosureRelations.HeatTransfer.Functions.SinglePhase.ExternalFlow.Nu_Grimison_FlowAcrossTubeBanks(
    Re.y,
    Pr,
    D,
    S_T,
    S_L,
    nRows,
    not tubesAligned);

  annotation (experiment(StopTime=2, __Dymola_NumberOfIntervals=160));
end check_Nu_Grimison_FlowAcrossTubeBanks;
