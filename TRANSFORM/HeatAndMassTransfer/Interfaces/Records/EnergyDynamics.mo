within TRANSFORM.HeatAndMassTransfer.Interfaces.Records;
record EnergyDynamics
  parameter Modelica.Fluid.Types.Dynamics energyDynamics=Modelica.Fluid.Types.Dynamics.DynamicFreeInitial
    "Formulation of energy balances"
    annotation (Dialog(tab="Assumptions", group="Dynamics"));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end EnergyDynamics;
