within TRANSFORM.Fluid.Volumes.BaseClasses.BaseDrum.PhaseInterface;
model ConstantMassTransportCoefficient
  extends TRANSFORM.Fluid.Volumes.BaseClasses.BaseDrum.PhaseInterface.PartialPhase_m_flow;
  parameter Real alphaD0(unit="kg/(s.m2.K)") = 0
    "Coefficient of mass transport";
equation
  alphaD = alphaD0;
end ConstantMassTransportCoefficient;
