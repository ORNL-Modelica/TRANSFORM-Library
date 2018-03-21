within TRANSFORM.HeatAndMassTransfer.ClosureRelations.HeatTransfer.Models;
model Alphas_TwoPhase_5Region "Specify alphas | Two Phase | 5 Regions"

  extends
    TRANSFORM.HeatAndMassTransfer.ClosureRelations.HeatTransfer.Models.PartialTwoPhase;

  input SI.CoefficientOfHeatTransfer[nHT] alpha_SinglePhaseLiquid_lam=
      mediums_film.lambda ./ dimensions .*
      Functions.SinglePhase.InternalFlow.Nu_Laminar_Local_Developed_Circular(
      Res_film,
      Prs_film,
      xs,
      dimensions,
      true) "Laminar coefficient of heat transfer - Liquid Phase"
    annotation (Dialog(group="Input Variables"));

  input SI.CoefficientOfHeatTransfer[nHT] alpha_SinglePhaseLiquid_turb=
      mediums_film.lambda ./ dimensions .*
      Functions.SinglePhase.InternalFlow.Nu_Turbulent_Local_Developed(
      Res_film,
      Prs_film,
      xs,
      dimensions,
      roughnesses) "Turbulent coefficient of heat transfer - Liquid Phase"
    annotation (Dialog(group="Input Variables"));

  input SI.CoefficientOfHeatTransfer[nHT] alpha_TwoPhaseSaturated={mediums_film[
      i].lambda/dimensions[i]*
      Functions.TwoPhase.NucleateBoiling.alpha_Chen_TubeFlow(
      D=dimensions[i],
      G=m_flows[i]/crossAreas[i],
      x=mediums[i].x_abs,
      rho_fsat=mediums[i].rho_lsat,
      mu_fsat=mediums[i].mu_lsat,
      lambda_fsat=mediums[i].lambda_lsat,
      cp_fsat=mediums[i].cp_lsat,
      sigma=mediums[i].sigma,
      rho_gsat=mediums[i].rho_vsat,
      mu_gsat=mediums[i].mu_vsat,
      h_fg=mediums[i].h_lv,
      Delta_Tsat=Ts_wall[i] - mediums[i].sat.Tsat,
      Delta_psat=Medium.saturationPressure(Ts_wall[i]) - mediums[i].p) for i in
          1:nHT} "Coefficient of heat transfer - Saturated Two Phase"
    annotation (Dialog(group="Input Variables"));

  input SI.CoefficientOfHeatTransfer[nHT] alpha_SinglePhaseVapor_lam=
      mediums_film.lambda ./ dimensions .*
      Functions.SinglePhase.InternalFlow.Nu_Laminar_Local_Developed_Circular(
      Res_film,
      Prs_film,
      xs,
      dimensions,
      true) "Laminar coefficient of heat transfer - Vapor Phase"
    annotation (Dialog(group="Input Variables"));

  input SI.CoefficientOfHeatTransfer[nHT] alpha_SinglePhaseVapor_turb=
      mediums_film.lambda ./ dimensions .*
      Functions.SinglePhase.InternalFlow.Nu_Turbulent_Local_Developed(
      Res_film,
      Prs_film,
      xs,
      dimensions,
      roughnesses) "Turbulent coefficient of heat transfer - Vapor Phase"
    annotation (Dialog(group="Input Variables"));

  input SI.Length[nHT] L_char=dimensions
    "Characteristic dimension for calculation of Nu"
    annotation (Dialog(group="Input Variables"));
  input SI.ThermalConductivity[nHT] lambda=mediums_film.lambda
    "Thermal conductivity for calculation of Nu"
    annotation (Dialog(group="Input Variables"));

  parameter Units.NonDim x_CHF=0.9
    "Steam quality corresponding to Critical Heat Flux"
    annotation (Dialog(group="Heat Transfer Model:"));

protected
  SI.CoefficientOfHeatTransfer[nHT] alpha_SinglePhase_Liquid;
  SI.CoefficientOfHeatTransfer[nHT] alpha_SinglePhase_Vapor;
  SI.CoefficientOfHeatTransfer[nHT]
    alpha_SinglePhase_Liquid_To_TwoPhaseSaturated;
  SI.CoefficientOfHeatTransfer[nHT]
    alpha_SinglePhase_TwoPhaseSaturated_To_Vapor;

equation

  for i in 1:nHT loop
    alpha_SinglePhase_Liquid[i] = TRANSFORM.Math.spliceTanh(
      alpha_SinglePhaseLiquid_turb[i],
      alpha_SinglePhaseLiquid_lam[i],
      Res_film[i] - Re_center,
      Re_width);

    alpha_SinglePhase_Vapor[i] = TRANSFORM.Math.spliceTanh(
      alpha_SinglePhaseVapor_turb[i],
      alpha_SinglePhaseVapor_lam[i],
      Res_film[i] - Re_center,
      Re_width);

    alpha_SinglePhase_Liquid_To_TwoPhaseSaturated[i] =
      TRANSFORM.Math.spliceTanh(
      alpha_TwoPhaseSaturated[i],
      alpha_SinglePhase_Liquid[i],
      mediums[i].x_th,
      deltax=0.02);

    alpha_SinglePhase_TwoPhaseSaturated_To_Vapor[i] = TRANSFORM.Math.spliceTanh(
      alpha_SinglePhase_Vapor[i],
      alpha_TwoPhaseSaturated[i],
      mediums[i].x_th - x_CHF,
      deltax=0.02);

    alphas[i] = TRANSFORM.Math.spliceTanh(
      alpha_SinglePhase_TwoPhaseSaturated_To_Vapor[i],
      alpha_SinglePhase_Liquid_To_TwoPhaseSaturated[i],
      mediums[i].x_th - 0.5,
      deltax=0.02);
  end for;

  Nus = alphas .* L_char ./ lambda;

  annotation (
    defaultComponentName="heatTransfer",
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)));
end Alphas_TwoPhase_5Region;
