within TRANSFORM.Fluid.Pipes_Obsolete.ClosureModels.HeatTransfer.TwoPhase;
model Chen "Chen Correlation: Two-phase"
  import TRANSFORM;

  extends
    TRANSFORM.Fluid.Pipes_Obsolete.ClosureModels.HeatTransfer.TwoPhase.Partial_TwoPhaseHeatTransfer;

equation
   for i in 1:nHT loop
     alphas[i] =
      TRANSFORM.Fluid.Pipes_Obsolete.ClosureModels.HeatTransfer.Functions.TwoPhase.Evaporation.alpha_Chen_TubeFlow(
            D=dimensions[i],
            G=m_flows[i]/crossAreas[i],
            x=x_abs[i],
            rho_fsat=rho_fsat[i],
            mu_fsat=mu_fsat[i],
            lambda_fsat=lambda_fsat[i],
            cp_fsat=cp_fsat[i],
            sigma=sigma[i],
            rho_gsat=rho_gsat[i],
            mu_gsat=mu_gsat[i],
            h_fg=h_gsat[i] - h_fsat[i],
            Delta_Tsat=heatPorts[i].T - sat[i].Tsat,
            Delta_psat=Medium.saturationPressure(heatPorts[i].T) - states[
        i].p);

     Nus[i] = alphas[i]*dimensions[i]/lambdas[i];
   end for;

end Chen;
