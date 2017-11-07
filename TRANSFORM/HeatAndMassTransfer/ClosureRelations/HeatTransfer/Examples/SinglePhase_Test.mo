within TRANSFORM.HeatAndMassTransfer.ClosureRelations.HeatTransfer.Examples;
model SinglePhase_Test

  Modelica.Blocks.Sources.Trapezoid Re(
    amplitude=1e6,
    rising=100,
    width=10,
    falling=100,
    period=220,
    nperiod=1,
    startTime=10)
    annotation (Placement(transformation(extent={{-100,20},{-80,40}})));

    Real Nu;
equation

  Nu =
    .TRANSFORM.HeatAndMassTransfer.ClosureRelations.HeatTransfer.Functions.SinglePhase.InternalFlow.Nu_Overall_Local_Developed_Circular(
      Re.y,
      1,
      1,
      1);

  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    experiment(StopTime=250));
end SinglePhase_Test;
