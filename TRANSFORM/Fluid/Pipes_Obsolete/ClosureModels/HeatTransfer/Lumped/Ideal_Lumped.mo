within TRANSFORM.Fluid.Pipes_Obsolete.ClosureModels.HeatTransfer.Lumped;
model Ideal_Lumped
  "Ideal: Ideal heat transfer without thermal resistance"
  extends TRANSFORM.Fluid.Pipes_Obsolete.ClosureModels.HeatTransfer.Lumped.BaseClasses.PartialLumpedHeatTransfer;
equation
  T_wall = state.T;
end Ideal_Lumped;
