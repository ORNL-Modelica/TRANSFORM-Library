within TRANSFORM.Fluid.Volumes.BaseClasses.BaseDrum.Evaporation;
model ConstantTimeDelay
  extends TRANSFORM.Fluid.Volumes.BaseClasses.BaseDrum.Evaporation.PartialBulkEvaporation;
  parameter SI.Time tau = 0.0001 "Time constant for bubble transport";
equation
  m_flow = x*m/tau;
end ConstantTimeDelay;
