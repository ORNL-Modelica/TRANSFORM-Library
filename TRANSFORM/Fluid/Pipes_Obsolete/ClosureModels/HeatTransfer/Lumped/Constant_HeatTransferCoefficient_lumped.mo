within TRANSFORM.Fluid.Pipes_Obsolete.ClosureModels.HeatTransfer.Lumped;
model Constant_HeatTransferCoefficient_lumped
  "Constant Heat Transfer Coefficient"
  extends
    TRANSFORM.Fluid.Pipes_Obsolete.ClosureModels.HeatTransfer.Lumped.BaseClasses.PartialLumpedHeatTransfer;
  parameter SI.CoefficientOfHeatTransfer alpha0 = 0.0 "Coefficient of heat transfer";
equation
  Q_flow=alpha0*surfaceArea*(T_wall - state.T)*nParallel;
end Constant_HeatTransferCoefficient_lumped;
