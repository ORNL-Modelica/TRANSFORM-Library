within TRANSFORM.Fluid.Volumes.ClosureModels.MassTransfer.Evaporation;
model PhaseSeparationHypothesis
  extends TRANSFORM.Fluid.Volumes.ClosureModels.MassTransfer.Evaporation.PartialBulkEvaporation;
  /*
  Source:
  1. NUREG-CR-4449 pg 30
  */
  input SI.Area Ac "Average cross sectional area" annotation(Dialog(group="Inputs"));
  parameter SI.Length d_e = 0.001 "Equivalent spherical bubble diameter";
  SI.Velocity v_bub=Functions.v_Stokes(
      d_e,
      medium2.rho_lsat,
      medium2.rho_vsat,
      medium2.mu_lsat) "Bubble terminal velocity";
equation
  m_flow = noEvent(
             if medium2.h > medium2.h_lsat and medium2.h < medium2.h_vsat then
               v_bub*(0.9 + 0.1*medium2.alphaV)*medium2.rho_vsat*Ac
             else
               0);
end PhaseSeparationHypothesis;
