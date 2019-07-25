within TRANSFORM.Fluid.Pipes_Obsolete.ClosureModels.HeatTransfer.Models.TwoPhase;
model NusseltTheory_Condensation
  extends
    TRANSFORM.Fluid.Pipes_Obsolete.ClosureModels.HeatTransfer.Models.TwoPhase.PartialTwoPhase;
  SI.NusseltNumber[nHT] Nus "Nusselt number";
  SI.SpecificEnthalpy[nHT] hs_fgp "Modified latent heat of vaporization";
  Units.NonDim[nHT] Jas "Jakob number";
equation
  for i in 1:nHT loop
    (alphas[i],Nus[i],hs_fgp[i],Jas[i]) =
      TRANSFORM.Fluid.Pipes_Obsolete.ClosureModels.HeatTransfer.Functions.TwoPhase.Condensation.alpha_NusseltTheory_Condensation(
              L_c=dimensions[i],
              lambda=mediums2_film[i].lambda,
              rho_fsat=mediums2_film[i].rho_lsat,
              mu_fsat=mediums2_film[i].mu_lsat,
              lambda_fsat=mediums2_film[i].lambda_lsat,
              cp_fsat=mediums2_film[i].cp_lsat,
              rho_gsat=mediums2_film[i].rho_vsat,
              mu_gsat=mediums2_film[i].mu_vsat,
              h_fg=mediums2[i].h_lv,
              T_state=states[i].T,
              T_sat=mediums2[i].sat.Tsat,
              T_wall=Ts_wall[i]);
  end for;
  annotation (defaultComponentName="heatTransfer",
Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end NusseltTheory_Condensation;
