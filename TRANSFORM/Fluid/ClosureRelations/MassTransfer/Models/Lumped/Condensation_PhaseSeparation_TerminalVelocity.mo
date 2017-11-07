within TRANSFORM.Fluid.ClosureRelations.MassTransfer.Models.Lumped;
model Condensation_PhaseSeparation_TerminalVelocity

  extends PartialTwoPhase;

  /*
  Source:
  1. NUREG-CR-4449 pg 28
  */

  input SI.Volume V_fluid "Volume of fluid" annotation(Dialog(group="Input Variables"));
  input SI.Length L_c "Average distance bubbles/drop travel" annotation(Dialog(group="Input Variables"));

  parameter SI.Velocity v_drop = 0.79248 "Velocity of bubbles/droplets (default = terminal velocity)";

   Modelica.Blocks.Nonlinear.VariableDelay delay(delayMax=Modelica.Constants.inf)
     annotation (Placement(transformation(extent={{-10,-8},{10,12}})));

  SI.MassFlowRate m_flow_noDelay "Mass flow rate with no time delay";

protected
  constant SI.Time tt = 1 "Time for correct variables";
equation

   delay.u = m_flow_noDelay;
   delay.delayTime = L_c/v_drop;

   m_flow_noDelay = (1.0 - medium.x_abs)*medium.d*V_fluid/tt;

   m_flow = delay.y;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Condensation_PhaseSeparation_TerminalVelocity;
