within TRANSFORM.Fluid.Volumes.ClosureModels.MassTransfer.Evaporation;
model ConstantTimeDelay
  extends
    TRANSFORM.Fluid.Volumes.ClosureModels.MassTransfer.Evaporation.PartialBulkEvaporation;
  input SI.Mass m "Mass of region" annotation(Dialog(group="Inputs"));
  parameter SI.Time tau = 1e6 "Time constant for bubble/droplet transport";
equation
  m_flow = (1.0-medium2.x_abs)*m/tau;
end ConstantTimeDelay;
