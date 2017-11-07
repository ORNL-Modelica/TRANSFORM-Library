within TRANSFORM.Fluid.Pipes_Obsolete.ClosureModels.HeatTransfer.Lumped.TwoPhase;
model Nusselt_Condensation_Lumped
  "Condensation | Laminar | Film: Nusselt theory two phase laminar film condensation model"

  extends
    TRANSFORM.Fluid.Pipes_Obsolete.ClosureModels.HeatTransfer.Lumped.BaseClasses.PartialLumpedHeatTransfer;

  SI.CoefficientOfHeatTransfer alpha "Coefficient of heat transfer";
  SI.NusseltNumber Nu "Nusselt number";
  SI.SpecificEnthalpy h_fgp "Modified latent heat of vaporization";
  Units.nonDim Ja "Jakob number";
equation

  (alpha,Nu,h_fgp,Ja) =
    TRANSFORM.Fluid.Pipes_Obsolete.ClosureModels.HeatTransfer.Functions.TwoPhase.Condensation.alpha_NusseltTheory_Condensation(
            L_c=dimension,
            lambda=medium2_film.lambda,
            rho_fsat=medium2_film.rho_lsat,
            mu_fsat=medium2_film.mu_lsat,
            lambda_fsat=medium2_film.lambda_lsat,
            cp_fsat=medium2_film.cp_lsat,
            rho_gsat=medium2_film.rho_vsat,
            mu_gsat=medium2_film.mu_vsat,
            h_fg=medium2.h_lv,
            T_state=state.T,
            T_sat=medium2.sat.Tsat,
            T_wall=heatPort.T);

  Q_flow=alpha*surfaceArea*(T_wall - state.T)*nParallel;

end Nusselt_Condensation_Lumped;
