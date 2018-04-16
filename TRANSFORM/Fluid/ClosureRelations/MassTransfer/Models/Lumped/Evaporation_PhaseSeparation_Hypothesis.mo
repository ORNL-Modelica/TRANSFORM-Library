within TRANSFORM.Fluid.ClosureRelations.MassTransfer.Models.Lumped;
model Evaporation_PhaseSeparation_Hypothesis

  extends PartialTwoPhase;

  /*
  Source:
  1. NUREG-CR-4449 pg 30
  */

  input SI.Area Ac "Average cross sectional area" annotation(Dialog(group="Inputs"));
  parameter SI.Length d_e = 0.001 "Equivalent spherical bubble diameter";

  SI.Velocity v_bub=ClosureRelations.MassTransfer.Functions.v_Stokes(
        d_e,
        medium.rho_lsat,
        medium.rho_vsat,
        medium.mu_lsat) "Bubble terminal velocity";

equation
  m_flow = noEvent(
             if medium.h > medium.h_lsat and medium.h < medium.h_vsat then
               v_bub*(0.9 + 0.1*medium.alphaV)*medium.rho_vsat*Ac
             else
               0);

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Evaporation_PhaseSeparation_Hypothesis;
