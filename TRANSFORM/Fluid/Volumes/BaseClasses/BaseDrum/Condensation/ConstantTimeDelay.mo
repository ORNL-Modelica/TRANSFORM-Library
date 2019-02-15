within TRANSFORM.Fluid.Volumes.BaseClasses.BaseDrum.Condensation;
model ConstantTimeDelay
  extends
    TRANSFORM.Fluid.Volumes.BaseClasses.BaseDrum.Condensation.PartialBulkCondensation;
  parameter SI.Time tau = 0.0001 "Time constant for droplet transport";
equation
  m_flow = (1 - x)*m/tau;
end ConstantTimeDelay;
