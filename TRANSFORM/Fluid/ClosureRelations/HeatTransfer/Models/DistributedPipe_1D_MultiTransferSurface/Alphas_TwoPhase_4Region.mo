within TRANSFORM.Fluid.ClosureRelations.HeatTransfer.Models.DistributedPipe_1D_MultiTransferSurface;
model Alphas_TwoPhase_4Region
  "Specify alphas | Two Phase | 4 Regions - 1P Liquid, 2P, CHF, 1P Vapor"

  extends PartialTwoPhase;

  input SI.CoefficientOfHeatTransfer[nHT,nSurfaces] alphas_SinglePhaseLiquid={{
      mediaProps[i].lambda/dimensions[i]*
      TRANSFORM.HeatAndMassTransfer.ClosureRelations.HeatTransfer.Functions.SinglePhase.InternalFlow.Nu_DittusBoelter(
      Res[i],
      Prs[i]) for j in 1:nSurfaces} for i in 1:nHT}
    "Turbulent coefficient of heat transfer - Liquid Phase"
    annotation (Dialog(group="Inputs"));

  input SI.CoefficientOfHeatTransfer alphas_NucleateBoiling[nHT,nSurfaces]={{
      HeatAndMassTransfer.ClosureRelations.HeatTransfer.Functions.TwoPhase.NucleateBoiling.alpha_Chen_TubeFlow(
      D=dimensions[i],
      G=m_flows[i]/crossAreas[i],
      x=mediaProps[i].x_abs,
      rho_fsat=mediaProps[i].rho_lsat,
      mu_fsat=mediaProps[i].mu_lsat,
      lambda_fsat=mediaProps[i].lambda_lsat,
      cp_fsat=mediaProps[i].cp_lsat,
      sigma=mediaProps[i].sigma,
      rho_gsat=mediaProps[i].rho_vsat,
      mu_gsat=mediaProps[i].mu_vsat,
      h_fg=mediaProps[i].h_lv,
      Delta_Tsat=Ts_wall[i, j] - mediaProps[i].sat.Tsat,
      Delta_psat=Medium.saturationPressure(Ts_wall[i, j]) - mediaProps[i].p)
      for j in 1:nSurfaces} for i in 1:nHT}
    "Coefficient of heat transfer - Saturated Two Phase"
    annotation (Dialog(group="Inputs"));

  input SI.CoefficientOfHeatTransfer alphas_PostCHF[nHT,nSurfaces]={{TRANSFORM.HeatAndMassTransfer.ClosureRelations.HeatTransfer.Functions.TwoPhase.PostCHF.alpha_Groeneveld(
    D_hyd=dimensions[i],
    crossArea=crossAreas[i],
    m_flow=m_flows[i],
    x_abs=mediaProps[i].x_abs,
    mu_vsat=mediaProps[i].mu_vsat,
    rho_lsat=mediaProps[i].rho_lsat,
    rho_vsat=mediaProps[i].rho_vsat,
    lambda_vsat=mediaProps[i].lambda_vsat,
    Pr_vw=mediaProps[i].mu_vsat*mediaProps[i].cp_vsat/mediaProps[i].lambda_vsat)
                                                                       for j in 1:nSurfaces} for i in 1:nHT} "Post-CHF heat transfer coefficient"
    annotation (Dialog(group="Inputs"));

  input SI.CoefficientOfHeatTransfer[nHT,nSurfaces] alphas_SinglePhaseVapor={{
      mediaProps[i].lambda/dimensions[i]*
      TRANSFORM.HeatAndMassTransfer.ClosureRelations.HeatTransfer.Functions.SinglePhase.InternalFlow.Nu_DittusBoelter(
      Res[i],
      Prs[i]) for j in 1:nSurfaces} for i in 1:nHT}
    "Turbulent coefficient of heat transfer - Vapor Phase"
    annotation (Dialog(group="Inputs"));

  input SI.Length[nHT,nSurfaces] L_char=transpose({dimensions for i in 1:
      nSurfaces}) "Characteristic dimension for calculation of Nu"
    annotation (Dialog(group="Inputs"));
  input SI.ThermalConductivity[nHT,nSurfaces] lambda=transpose({mediaProps.lambda
      for i in 1:nSurfaces}) "Thermal conductivity for calculation of Nu"
    annotation (Dialog(group="Inputs"));

  input Real HT_width[3]={0.02,0.02,0.02}
   "Smooth transition width"
   annotation (Dialog(tab="Advanced",group="Inputs"));

  input Real HT_smooth[3]={0,0.96,0.98}
    "Smooth value for transition between regions"
    annotation (Dialog(tab="Advanced",group="Inputs"));

  input Real Var_smooth[nHT]=mediaProps.alphaV
    "Variable for smoothing between regions with phase transition"
    annotation (Dialog(tab="Advanced",group="Inputs"));

protected
  SI.CoefficientOfHeatTransfer[nHT,nSurfaces]
    alphas_1;
  SI.CoefficientOfHeatTransfer[nHT,nSurfaces]
    alphas_2;

equation

  for i in 1:nHT loop
    for j in 1:nSurfaces loop
      alphas_1[i, j] =TRANSFORM.Math.spliceTanh(
        alphas_NucleateBoiling[i, j],
        alphas_SinglePhaseLiquid[i, j],
        Var_smooth[i] - HT_smooth[1],
        deltax=HT_width[1]);

      alphas_2[i, j] =
        TRANSFORM.Math.spliceTanh(
        alphas_PostCHF[i, j],
        alphas_1[i, j],
        Var_smooth[i] - HT_smooth[3],
        deltax=HT_width[3]);

      alphas[i, j] =TRANSFORM.Math.spliceTanh(
        alphas_SinglePhaseVapor[i, j],
        alphas_2[i, j],
        Var_smooth[i] - HT_smooth[2],
        deltax=HT_width[2]);
    end for;
  end for;

  Nus = alphas .* L_char ./ lambda;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Alphas_TwoPhase_4Region;
