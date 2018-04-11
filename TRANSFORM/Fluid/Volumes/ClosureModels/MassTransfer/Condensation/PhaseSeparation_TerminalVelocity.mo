within TRANSFORM.Fluid.Volumes.ClosureModels.MassTransfer.Condensation;
model PhaseSeparation_TerminalVelocity

  extends
    TRANSFORM.Fluid.Volumes.ClosureModels.MassTransfer.Condensation.PartialBulkCondensation;
  /*
  Source:
  1. NUREG-CR-4449 pg 28
  */

  input SI.Volume V_fluid "Volume of fluid" annotation(Dialog(group="Inputs"));
  input SI.Length L_c "Average distance bubbles/drop travel" annotation(Dialog(group="Inputs"));

  parameter SI.Velocity v_drop = 0.79248 "Velocity of bubbles/droplets (default = terminal velocity)";

   Modelica.Blocks.Nonlinear.VariableDelay delay(delayMax=Modelica.Constants.inf)
     annotation (Placement(transformation(extent={{-10,-8},{10,12}})));

  SI.MassFlowRate m_flow_noDelay "Mass flow rate with no time delay";

protected
  constant SI.Time tt = 1 "Time for correct variables";
equation

   delay.u = m_flow_noDelay;
   delay.delayTime = L_c/v_drop;

   m_flow_noDelay = (1.0 - medium2.x_abs)*medium2.d*V_fluid/tt;

   m_flow = delay.y;

end PhaseSeparation_TerminalVelocity;
