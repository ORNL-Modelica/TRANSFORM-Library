within TRANSFORM.HeatAndMassTransfer.ClosureRelations.HeatTransfer.Functions.Examples.SinglePhase.InternalFlow;
model check_Nu_SiederTate

  extends TRANSFORM.Icons.Example;

  parameter SI.PrandtlNumber Pr = 1.5 "Prandtl Number";
  parameter Real R_mu = 2 "Ratio of dynamic viscosity (@T_bulk/@T_wall)";
    Real y[1];

  Modelica.Blocks.Sources.Trapezoid Re(
    rising=1,
    width=0,
    falling=1,
    period=2,
    nperiod=1,
    amplitude=4000)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Utilities.ErrorAnalysis.UnitTests unitTests(n=1, x=y)
    annotation (Placement(transformation(extent={{80,80},{100,100}})));

equation

 y[1] = TRANSFORM.HeatAndMassTransfer.ClosureRelations.HeatTransfer.Functions.SinglePhase.InternalFlow.Nu_SiederTate(Re.y, Pr, R_mu);

  annotation (experiment(StopTime=2, __Dymola_NumberOfIntervals=160));
end check_Nu_SiederTate;
