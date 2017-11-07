within TRANSFORM.Fluid.ClosureRelations.HeatTransfer.Models.DistributedPipe_1D_MultiTransferSurface;
model Alphas_TwoPhase_5Region
  "Specify alphas | Two Phase | 5 Regions - 1P Liquid Laminar & Turbulent, 2P, 1P Vapor Laminar & Turbulent"

  extends PartialTwoPhase;

  input SI.CoefficientOfHeatTransfer[nHT,nSurfaces] alpha_SinglePhaseLiquid_lam=
     {{mediaProps[i].lambda/dimensions[i]*
      HeatAndMassTransfer.ClosureRelations.HeatTransfer.Functions.SinglePhase.InternalFlow.Nu_Laminar_Local_Developed_Circular(
      Res[i],
      Prs[i],
      xs[i],
      dimensions[i],
      true) for j in 1:nSurfaces} for i in 1:nHT}
    "Laminar coefficient of heat transfer - Liquid Phase"
    annotation (Dialog(group="Input Variables"));

  input SI.CoefficientOfHeatTransfer[nHT,nSurfaces]
    alpha_SinglePhaseLiquid_turb={{mediaProps[i].lambda/dimensions[i]*
      HeatAndMassTransfer.ClosureRelations.HeatTransfer.Functions.SinglePhase.InternalFlow.Nu_Turbulent_Local_Developed(
      Res[i],
      Prs[i],
      xs[i],
      dimensions[i],
      roughnesses[i]) for j in 1:nSurfaces} for i in 1:nHT}
    "Turbulent coefficient of heat transfer - Liquid Phase"
    annotation (Dialog(group="Input Variables"));

  input SI.CoefficientOfHeatTransfer[nHT,nSurfaces] alpha_TwoPhaseSaturated={{
      HeatAndMassTransfer.ClosureRelations.HeatTransfer.Functions.TwoPhase.Evaporation.alpha_Chen_TubeFlow(
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
    annotation (Dialog(group="Input Variables"));

  input SI.CoefficientOfHeatTransfer[nHT,nSurfaces] alpha_SinglePhaseVapor_lam=
      {{mediaProps[i].lambda/dimensions[i]*
      HeatAndMassTransfer.ClosureRelations.HeatTransfer.Functions.SinglePhase.InternalFlow.Nu_Laminar_Local_Developed_Circular(
      Res[i],
      Prs[i],
      xs[i],
      dimensions[i],
      true) for j in 1:nSurfaces} for i in 1:nHT}
    "Laminar coefficient of heat transfer - Vapor Phase"
    annotation (Dialog(group="Input Variables"));

  input SI.CoefficientOfHeatTransfer[nHT,nSurfaces] alpha_SinglePhaseVapor_turb=
     {{mediaProps[i].lambda/dimensions[i]*
      HeatAndMassTransfer.ClosureRelations.HeatTransfer.Functions.SinglePhase.InternalFlow.Nu_Turbulent_Local_Developed(
      Res[i],
      Prs[i],
      xs[i],
      dimensions[i],
      roughnesses[i]) for j in 1:nSurfaces} for i in 1:nHT}
    "Turbulent coefficient of heat transfer - Vapor Phase"
    annotation (Dialog(group="Input Variables"));

  input SI.Length[nHT,nSurfaces] L_char=transpose({dimensions for i in 1:nSurfaces})
    "Characteristic dimension for calculation of Nu"
    annotation (Dialog(group="Input Variables"));
  input SI.ThermalConductivity[nHT,nSurfaces] lambda=transpose({mediaProps.lambda
      for i in 1:nSurfaces}) "Thermal conductivity for calculation of Nu"
    annotation (Dialog(group="Input Variables"));

  parameter Units.nonDim x_CHF=0.9
    "Steam quality corresponding to Critical Heat Flux"
    annotation (Dialog(group="Heat Transfer Model:"));

protected
  SI.CoefficientOfHeatTransfer[nHT,nSurfaces] alpha_SinglePhase_Liquid;
  SI.CoefficientOfHeatTransfer[nHT,nSurfaces] alpha_SinglePhase_Vapor;
  SI.CoefficientOfHeatTransfer[nHT,nSurfaces]
    alpha_SinglePhase_Liquid_To_TwoPhaseSaturated;
  SI.CoefficientOfHeatTransfer[nHT,nSurfaces]
    alpha_SinglePhase_TwoPhaseSaturated_To_Vapor;

equation

  for i in 1:nHT loop
    for j in 1:nSurfaces loop
    alpha_SinglePhase_Liquid[i,j] = TRANSFORM.Math.spliceTanh(
      alpha_SinglePhaseLiquid_turb[i,j],
      alpha_SinglePhaseLiquid_lam[i,j],
      Res[i] - Re_center,
      Re_width);

    alpha_SinglePhase_Vapor[i,j] = TRANSFORM.Math.spliceTanh(
      alpha_SinglePhaseVapor_turb[i,j],
      alpha_SinglePhaseVapor_lam[i,j],
      Res[i] - Re_center,
      Re_width);

    alpha_SinglePhase_Liquid_To_TwoPhaseSaturated[i,j] =
        TRANSFORM.Math.spliceTanh(
        alpha_TwoPhaseSaturated[i, j],
        alpha_SinglePhase_Liquid[i, j],
        mediaProps[i].x_th,
        deltax=0.02);

    alpha_SinglePhase_TwoPhaseSaturated_To_Vapor[i,j] =
        TRANSFORM.Math.spliceTanh(
        alpha_SinglePhase_Vapor[i, j],
        alpha_TwoPhaseSaturated[i, j],
        mediaProps[i].x_th - x_CHF,
        deltax=0.02);

    alphas[i,j] =TRANSFORM.Math.spliceTanh(
        alpha_SinglePhase_TwoPhaseSaturated_To_Vapor[i, j],
        alpha_SinglePhase_Liquid_To_TwoPhaseSaturated[i, j],
        mediaProps[i].x_th - 0.5,
        deltax=0.02);
    end for;
  end for;

  Nus = alphas .* L_char ./ lambda;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Alphas_TwoPhase_5Region;
