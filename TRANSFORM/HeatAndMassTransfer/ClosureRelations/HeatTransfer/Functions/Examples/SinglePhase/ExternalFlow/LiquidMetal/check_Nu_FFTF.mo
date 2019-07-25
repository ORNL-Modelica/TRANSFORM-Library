within TRANSFORM.HeatAndMassTransfer.ClosureRelations.HeatTransfer.Functions.Examples.SinglePhase.ExternalFlow.LiquidMetal;
model check_Nu_FFTF
  extends TRANSFORM.Icons.Example;
  parameter SI.PrandtlNumber Pr = 1.5 "Prandtl number";
  parameter Real PDratio = 1.2 "Tube Pitch to Diameter ratio";
  Real y[1];
  Modelica.Blocks.Sources.Trapezoid Re(
    rising=1,
    width=0,
    falling=1,
    period=2,
    nperiod=1,
    amplitude=4000)
    annotation (Placement(transformation(extent={{-10,10},{10,30}})));
  Utilities.ErrorAnalysis.UnitTests unitTests(n=1, x=y)
    annotation (Placement(transformation(extent={{80,80},{100,100}})));
equation
  y[1] =
    TRANSFORM.HeatAndMassTransfer.ClosureRelations.HeatTransfer.Functions.SinglePhase.ExternalFlow.LiquidMetal.Nu_FFTF(
    Re.y,
    Pr,
    PDratio);
  annotation (experiment(StopTime=2, __Dymola_NumberOfIntervals=160));
end check_Nu_FFTF;
