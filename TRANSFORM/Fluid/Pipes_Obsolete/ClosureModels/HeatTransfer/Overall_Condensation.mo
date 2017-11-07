within TRANSFORM.Fluid.Pipes_Obsolete.ClosureModels.HeatTransfer;
model Overall_Condensation
  "Condensation: Overall condensation model from condensable superheated vapor to saturated vapor."

  extends
    TRANSFORM.Fluid.Pipes_Obsolete.ClosureModels.HeatTransfer.TwoPhase.Partial_TwoPhaseHeatTransfer;

  replaceable function heatTransfer_Condensation =
      TRANSFORM.Fluid.Pipes_Obsolete.ClosureModels.HeatTransfer.Functions.TwoPhase.Condensation.alpha_NusseltTheory_Condensation
    constrainedby
    TRANSFORM.Fluid.Pipes_Obsolete.ClosureModels.HeatTransfer.Functions.TwoPhase.Condensation.alpha_NusseltTheory_Condensation
    annotation (choicesAllMatching=true);

  SI.CoefficientOfHeatTransfer[nHT] alphas_Condensation;

equation

  for i in 1:nHT loop

    alphas_Condensation[i] = heatTransfer_Condensation(
      L=dimensions[i],
      lambda=lambdas[i],
      rho_fsat=rho_fsat[i],
      mu_fsat=mu_fsat[i],
      lambda_fsat=lambda_fsat[i],
      cp_fsat=cp_fsat[i],
      rho_gsat=rho_gsat[i],
      mu_gsat=mu_gsat[i],
      h_fg=h_gsat[i] - h_fsat[i],
      Ts=Ts[i],
      Tsat=sat[i].Tsat,
      Twall=heatPorts[i].T);

    // These perform the same function just using different methods
    //alphas[i] = TRANSFORM.Math.spliceSigmoid(TRANSFORM.Math.spliceSigmoid(alphas_SinglephaseLiquid[i],alphas_SaturatedVapor[i],x_th[i],0,k=200),alphas_SinglephaseVapor[i],x_th[i],1.0,k=200);
    //alphas[i] = TRANSFORM.Math.spliceTanh(alphas_SinglephaseVapor[i],TRANSFORM.Math.spliceTanh(alphas_SaturatedVapor[i],alphas_SinglephaseLiquid[i],x_th[i],deltax=0.02),x_th[i]-1.0,deltax=0.02);
    //alphas[i] = TRANSFORM.Math.spliceTanh(alphas_SaturatedVapor[i],alphas_SinglephaseVapor[i],Ts[i]-sat[i].Tsat,deltax=0.01);
    alphas[i] = alphas_Condensation[i];
    //TRANSFORM.Math.spliceTanh(alphas_Condensation[i],0,x_th[i]-1.0,deltax=0.001);
    Nus[i] = dimensions[i]/lambdas[i]*alphas[i];
  end for;

end Overall_Condensation;
