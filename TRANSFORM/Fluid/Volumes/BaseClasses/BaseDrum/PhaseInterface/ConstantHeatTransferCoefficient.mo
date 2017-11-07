within TRANSFORM.Fluid.Volumes.BaseClasses.BaseDrum.PhaseInterface;
model ConstantHeatTransferCoefficient

  extends
    TRANSFORM.Fluid.Volumes.BaseClasses.BaseDrum.PhaseInterface.PartialPhase_alpha;

  parameter SI.CoefficientOfHeatTransfer alpha0 = 0 "Heat transfer coefficient";

equation
  alpha = alpha0;

end ConstantHeatTransferCoefficient;
