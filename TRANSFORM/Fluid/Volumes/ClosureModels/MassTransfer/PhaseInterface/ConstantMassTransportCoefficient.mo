within TRANSFORM.Fluid.Volumes.ClosureModels.MassTransfer.PhaseInterface;
model ConstantMassTransportCoefficient
  extends
    TRANSFORM.Fluid.Volumes.ClosureModels.MassTransfer.PhaseInterface.PartialPhase_m_flow;
  parameter Real alphaD0(unit="kg/(s.m2.K)") = 0
    "Coefficient of mass transport";
equation
  m_flow = alphaD0*surfaceArea*(state_vapor.T - state_liquid.T);
end ConstantMassTransportCoefficient;
