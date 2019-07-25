within TRANSFORM.Fluid.Volumes.ClosureModels.MassTransfer.PhaseInterface;
model ConstantHeatTransferCoefficient
  extends
    TRANSFORM.Fluid.Volumes.ClosureModels.MassTransfer.PhaseInterface.PartialPhase_alpha;
  parameter SI.CoefficientOfHeatTransfer alpha0 = 0 "Heat transfer coefficient";
equation
  alpha = alpha0;
  Q_flow = alpha*surfaceArea*(state_vapor.T - state_liquid.T);
end ConstantHeatTransferCoefficient;
