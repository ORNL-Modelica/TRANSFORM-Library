within TRANSFORM.Fluid.ClosureRelations.HeatTransfer.Models.DistributedPipe_1D;
model Alphas_TwoPhase_3Region "Specify alphas | Two Phase | 3 Regions - 1P Liquid, 2P, 1P Vapor"

  extends PartialTwoPhase;

  input SI.CoefficientOfHeatTransfer[nHT] alpha_SinglePhaseLiquid=mediaProps.lambda
       ./ dimensions .*
      TRANSFORM.HeatAndMassTransfer.ClosureRelations.HeatTransfer.Functions.SinglePhase.InternalFlow.Nu_DittusBoelter(
      Res,
      Prs) "Turbulent coefficient of heat transfer - Liquid Phase"
    annotation (Dialog(group="Input Variables"));

  input SI.CoefficientOfHeatTransfer[nHT] alpha_TwoPhaseSaturated={
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
      Delta_Tsat=Ts_wall[i] - mediaProps[i].sat.Tsat,
      Delta_psat=Medium.saturationPressure(Ts_wall[i]) - mediaProps[i].p) for i in
          1:nHT} "Coefficient of heat transfer - Saturated Two Phase"
    annotation (Dialog(group="Input Variables"));

  input SI.CoefficientOfHeatTransfer[nHT] alpha_SinglePhaseVapor=mediaProps.lambda
       ./ dimensions .*
      TRANSFORM.HeatAndMassTransfer.ClosureRelations.HeatTransfer.Functions.SinglePhase.InternalFlow.Nu_DittusBoelter(
      Res,
      Prs) "Turbulent coefficient of heat transfer - Vapor Phase"
    annotation (Dialog(group="Input Variables"));

  input SI.Length[nHT] L_char=dimensions
    "Characteristic dimension for calculation of Nu"
    annotation (Dialog(group="Input Variables"));
  input SI.ThermalConductivity[nHT] lambda=mediaProps.lambda
    "Thermal conductivity for calculation of Nu"
    annotation (Dialog(group="Input Variables"));

  parameter Units.nonDim x_CHF=0.9
    "Steam quality corresponding to Critical Heat Flux"
    annotation (Dialog(group="Heat Transfer Model:"));

protected
  SI.CoefficientOfHeatTransfer[nHT]
    alpha_SinglePhase_Liquid_To_TwoPhaseSaturated;
  SI.CoefficientOfHeatTransfer[nHT]
    alpha_SinglePhase_TwoPhaseSaturated_To_Vapor;

equation

  for i in 1:nHT loop
    alpha_SinglePhase_Liquid_To_TwoPhaseSaturated[i] =TRANSFORM.Math.spliceTanh(
      alpha_TwoPhaseSaturated[i],
      alpha_SinglePhaseLiquid[i],
      mediaProps[i].x_th,
      deltax=0.02);

    alpha_SinglePhase_TwoPhaseSaturated_To_Vapor[i] =TRANSFORM.Math.spliceTanh(
      alpha_SinglePhaseVapor[i],
      alpha_TwoPhaseSaturated[i],
      mediaProps[i].x_th - x_CHF,
      deltax=0.02);

    alphas[i] =TRANSFORM.Math.spliceTanh(
      alpha_SinglePhase_TwoPhaseSaturated_To_Vapor[i],
      alpha_SinglePhase_Liquid_To_TwoPhaseSaturated[i],
      mediaProps[i].x_th - 0.5,
      deltax=0.02);
  end for;

  Nus = alphas .* L_char ./ lambda;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Alphas_TwoPhase_3Region;
