within TRANSFORM.HeatAndMassTransfer.ClosureRelations.HeatTransfer.Functions.Examples.SinglePhase.InternalFlow;
model check_Nu_Turbulent_Local_Developed

  extends TRANSFORM.Icons.Example;

  parameter SI.PrandtlNumber Pr = 1.5 "Prandtl Number";
  parameter SI.Length x = 0.1 "Position of local heat transfer calculation";
  parameter SI.Length dimension = 0.01
    "Characteristic dimension (e.g., hydraulic diameter)";

    Real y[2];

  Modelica.Blocks.Sources.Trapezoid Re(
    amplitude=8000,
    rising=1,
    width=0,
    falling=1,
    period=2,
    nperiod=1)
    annotation (Placement(transformation(extent={{-10,10},{10,30}})));
  Utilities.ErrorAnalysis.UnitTests unitTests(n=2, x=y)
    annotation (Placement(transformation(extent={{80,80},{100,100}})));
  Modelica.Blocks.Sources.Trapezoid roughness(
    rising=1,
    width=0,
    falling=1,
    period=2,
    nperiod=1,
    amplitude=2e-4)
    annotation (Placement(transformation(extent={{-10,-28},{10,-8}})));
equation

 y[1] = TRANSFORM.HeatAndMassTransfer.ClosureRelations.HeatTransfer.Functions.SinglePhase.InternalFlow.Nu_Turbulent_Local_Developed(Re.y, Pr, x, dimension, 2e-5);
 y[2] = TRANSFORM.HeatAndMassTransfer.ClosureRelations.HeatTransfer.Functions.SinglePhase.InternalFlow.Nu_Turbulent_Local_Developed(10000, Pr, x, dimension, roughness.y);

end check_Nu_Turbulent_Local_Developed;
