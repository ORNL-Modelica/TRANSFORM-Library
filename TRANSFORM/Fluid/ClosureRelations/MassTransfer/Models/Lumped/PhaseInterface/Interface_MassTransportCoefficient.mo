within TRANSFORM.Fluid.ClosureRelations.MassTransfer.Models.Lumped.PhaseInterface;
model Interface_MassTransportCoefficient

  extends PhaseInterface.PartialPhaseInterface;

  input Real alphaM0(unit="kg/(s.m2.K)")=0
    "Coefficient of mass transfer" annotation (Dialog(group="Input Variables"));

equation

  m_flow = alphaM0*surfaceArea*(state_vapor.T - state_liquid.T);

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Interface_MassTransportCoefficient;
