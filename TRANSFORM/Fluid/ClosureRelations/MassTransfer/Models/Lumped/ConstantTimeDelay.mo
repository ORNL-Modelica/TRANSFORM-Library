within TRANSFORM.Fluid.ClosureRelations.MassTransfer.Models.Lumped;
model ConstantTimeDelay

  extends PartialTwoPhase;

  input SI.Mass m "Mass of region" annotation(Dialog(group="Input Variables"));

  parameter SI.Time tau = 1e6 "Time constant for bubble/droplet transport";

equation

  m_flow = (1.0-medium.x_abs)*m/tau;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end ConstantTimeDelay;
