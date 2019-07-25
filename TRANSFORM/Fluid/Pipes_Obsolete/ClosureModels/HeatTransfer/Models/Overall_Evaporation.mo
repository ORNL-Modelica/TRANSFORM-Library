within TRANSFORM.Fluid.Pipes_Obsolete.ClosureModels.HeatTransfer.Models;
model Overall_Evaporation
  extends
    TRANSFORM.Fluid.Pipes_Obsolete.ClosureModels.HeatTransfer.Models.TwoPhase.PartialTwoPhase;
  parameter Units.NonDim x_CHF=0.9
    "Steam quality corresponding to Critical Heat Flux" annotation(Dialog(group="Heat Transfer Model:"));
  replaceable function heatTransfer_SinglephaseLiquid =
     TRANSFORM.Fluid.Pipes_Obsolete.ClosureModels.HeatTransfer.Functions.SinglePhase.alpha_DittusBoelter
    constrainedby
    TRANSFORM.Fluid.Pipes_Obsolete.ClosureModels.HeatTransfer.Functions.SinglePhase.alpha_DittusBoelter
     annotation(choicesAllMatching=true,Dialog(group="Heat Transfer Model:"));
  replaceable function heatTransfer_TwoPhaseSaturated =
     TRANSFORM.Fluid.Pipes_Obsolete.ClosureModels.HeatTransfer.Functions.TwoPhase.Evaporation.alpha_Chen_TubeFlow
    constrainedby
    TRANSFORM.Fluid.Pipes_Obsolete.ClosureModels.HeatTransfer.Functions.TwoPhase.Evaporation.alpha_Chen_TubeFlow
     annotation(choicesAllMatching=true,Dialog(group="Heat Transfer Model:"));
  replaceable function heatTransfer_SinglephaseVapor =
     TRANSFORM.Fluid.Pipes_Obsolete.ClosureModels.HeatTransfer.Functions.SinglePhase.alpha_DittusBoelter
    constrainedby
    TRANSFORM.Fluid.Pipes_Obsolete.ClosureModels.HeatTransfer.Functions.SinglePhase.alpha_DittusBoelter
     annotation(choicesAllMatching=true,Dialog(group="Heat Transfer Model:"));
  SI.NusseltNumber[nHT] Nus "Nusselt number";
  SI.ReynoldsNumber[nHT] Res "Reynolds number";
  SI.PrandtlNumber[nHT] Prs "Prandtl number";
  SI.CoefficientOfHeatTransfer[nHT] alphas_SinglephaseLiquid;
  SI.CoefficientOfHeatTransfer[nHT] alphas_TwoPhaseSaturated;
  SI.CoefficientOfHeatTransfer[nHT] alphas_SinglephaseVapor;
equation
  Prs = Medium.prandtlNumber(states);
  Res = TRANSFORM.Utilities.CharacteristicNumbers.ReynoldsNumber_m_flow(
    m_flow=m_flows/nParallel,
    mu=mediums1.mu,
    D=dimensions,
    A=crossAreas);
  for i in 1:nHT loop
    alphas_SinglephaseLiquid[i] =heatTransfer_SinglephaseLiquid(
      D=dimensions[i],
      lambda=mediums1[i].lambda,
      Re=Res[i],
      Pr=Prs[i]);
    alphas_TwoPhaseSaturated[i] =heatTransfer_TwoPhaseSaturated(
      D=dimensions[i],
      G=m_flows[i]/crossAreas[i]/nParallel,
      x=mediums2[i].x_abs,
      rho_fsat=mediums2[i].rho_lsat,
      mu_fsat=mediums2[i].mu_lsat,
      lambda_fsat=mediums2[i].lambda_lsat,
      cp_fsat=mediums2[i].cp_lsat,
      sigma=mediums2[i].sigma,
      rho_gsat=mediums2[i].rho_vsat,
      mu_gsat=mediums2[i].mu_vsat,
      h_fg=mediums2[i].h_lv,
      Delta_Tsat=Ts_wall[i] - mediums2[i].sat.Tsat,
      Delta_psat=Medium.saturationPressure(Ts_wall[i]) - mediums2[i].p);
    alphas_SinglephaseVapor[i] =heatTransfer_SinglephaseVapor(
      D=dimensions[i],
      lambda=mediums1[i].lambda,
      Re=Res[i],
      Pr=Prs[i]);
    alphas[i] =TRANSFORM.Math.spliceTanh(
      alphas_SinglephaseVapor[i],
      TRANSFORM.Math.spliceTanh(
        alphas_TwoPhaseSaturated[i],
        alphas_SinglephaseLiquid[i],
        mediums2[i].x_th,
        deltax=0.02),
      mediums2[i].x_th - x_CHF,
      deltax=0.02);
  end for;
  Nus = Utilities.CharacteristicNumbers.NusseltNumber(alphas, dimensions,mediums1.lambda);
  annotation (defaultComponentName="heatTransfer",
Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Overall_Evaporation;
