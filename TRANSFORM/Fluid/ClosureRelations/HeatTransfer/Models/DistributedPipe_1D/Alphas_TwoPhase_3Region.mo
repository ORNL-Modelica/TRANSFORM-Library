within TRANSFORM.Fluid.ClosureRelations.HeatTransfer.Models.DistributedPipe_1D;
model Alphas_TwoPhase_3Region "Specify alphas | Two Phase | 3 Regions - 1P Liquid, 2P, 1P Vapor"
  extends PartialTwoPhase;
  input SI.CoefficientOfHeatTransfer[nHT] alpha_SinglePhaseLiquid=mediaProps.lambda
       ./ dimensions .*
      TRANSFORM.HeatAndMassTransfer.ClosureRelations.HeatTransfer.Functions.SinglePhase.InternalFlow.Nu_DittusBoelter(
      Res,
      Prs) "Turbulent coefficient of heat transfer - Liquid Phase"
    annotation (Dialog(group="Inputs"));
  input SI.CoefficientOfHeatTransfer[nHT] alpha_TwoPhaseSaturated={
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
      Delta_Tsat=Ts_wall[i] - mediaProps[i].sat.Tsat,
      Delta_psat=Medium.saturationPressure(Ts_wall[i]) - mediaProps[i].p) for i in
          1:nHT} "Coefficient of heat transfer - Saturated Two Phase"
    annotation (Dialog(group="Inputs"));
  input SI.CoefficientOfHeatTransfer[nHT] alpha_SinglePhaseVapor=mediaProps.lambda
       ./ dimensions .*
      TRANSFORM.HeatAndMassTransfer.ClosureRelations.HeatTransfer.Functions.SinglePhase.InternalFlow.Nu_DittusBoelter(
      Res,
      Prs) "Turbulent coefficient of heat transfer - Vapor Phase"
    annotation (Dialog(group="Inputs"));
  input SI.Length[nHT] L_char=dimensions
    "Characteristic dimension for calculation of Nu"
    annotation (Dialog(group="Inputs"));
  input SI.ThermalConductivity[nHT] lambda=mediaProps.lambda
    "Thermal conductivity for calculation of Nu"
    annotation (Dialog(group="Inputs"));
  input Real HT_width[3]={0.02,0.02,0.02}
   "Smooth transition width"
   annotation (Dialog(tab="Advanced",group="Inputs"));
  input Real HT_smooth[3]={0,0.5,0.9}
   "Smooth value for transition between regions with phase transition"
   annotation (Dialog(tab="Advanced",group="Inputs"));
  input Real Var_smooth[nHT]=mediaProps.alphaV
    "Variable for smoothing between regions with phase transition"
    annotation (Dialog(tab="Advanced",group="Inputs"));
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
      Var_smooth[i] - HT_smooth[1],
      deltax=HT_width[1]);
    alpha_SinglePhase_TwoPhaseSaturated_To_Vapor[i] =TRANSFORM.Math.spliceTanh(
      alpha_SinglePhaseVapor[i],
      alpha_TwoPhaseSaturated[i],
      Var_smooth[i] - HT_smooth[3],
      deltax=HT_width[3]);
    alphas[i] =TRANSFORM.Math.spliceTanh(
      alpha_SinglePhase_TwoPhaseSaturated_To_Vapor[i],
      alpha_SinglePhase_Liquid_To_TwoPhaseSaturated[i],
      Var_smooth[i] - HT_smooth[2],
      deltax=HT_width[2]);
  end for;
  Nus = alphas .* L_char ./ lambda;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Alphas_TwoPhase_3Region;
