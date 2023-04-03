within TRANSFORM.Fluid.Volumes.BaseClasses.BaseDrum.HeatTransfer;
model ConstantHeatTransferCoefficient
  extends TRANSFORM.Fluid.Volumes.BaseClasses.BaseDrum.HeatTransfer.PartialHeatTransfer;
  parameter SI.CoefficientOfHeatTransfer alpha0 = 0 "Heat transfer coefficient";
equation
  alpha = alpha0;
end ConstantHeatTransferCoefficient;
