within TRANSFORM.HeatAndMassTransfer.ClosureRelations.HeatTransfer.Functions.Examples.SinglePhase.InternalFlow;
model check_Nu_Laminar_Local_Developed_Rectangular
  extends TRANSFORM.Icons.Example;
  parameter Boolean constantTwall=true
    "= true for constant wall temperature correlation else constant heat flux";
    Real y[2];
  Modelica.Blocks.Sources.Trapezoid AR(
    rising=1,
    width=0,
    falling=1,
    period=2,
    nperiod=1,
    amplitude=1)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Utilities.ErrorAnalysis.UnitTests unitTests(n=2, x=y)
    annotation (Placement(transformation(extent={{80,80},{100,100}})));
equation
 y[1] = TRANSFORM.HeatAndMassTransfer.ClosureRelations.HeatTransfer.Functions.SinglePhase.InternalFlow.Nu_Laminar_Local_Developed_Rectangular(AR.y, constantTwall);
 y[2] = TRANSFORM.HeatAndMassTransfer.ClosureRelations.HeatTransfer.Functions.SinglePhase.InternalFlow.Nu_Laminar_Local_Developed_Rectangular(AR.y, not constantTwall);
  annotation (experiment(StopTime=2, __Dymola_NumberOfIntervals=100));
end check_Nu_Laminar_Local_Developed_Rectangular;
