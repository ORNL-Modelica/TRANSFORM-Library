within TRANSFORM.Fluid.Pipes_Obsolete.ClosureModels.HeatTransfer.Lumped;
model Overall_Evaporation_Lumped "Evaporation |"
  extends TRANSFORM.Fluid.Pipes_Obsolete.ClosureModels.HeatTransfer.Lumped.BaseClasses.PartialLumpedHeatTransfer;
  parameter Units.NonDim x_CHF=0.9
    "Steam quality corresponding to Critical Heat Flux";
  replaceable function heatTransfer_SinglephaseLiquid =
     TRANSFORM.Fluid.Pipes_Obsolete.ClosureModels.HeatTransfer.Functions.SinglePhase.alpha_DittusBoelter
    constrainedby TRANSFORM.Fluid.Pipes_Obsolete.ClosureModels.HeatTransfer.Functions.SinglePhase.alpha_DittusBoelter
     annotation(choicesAllMatching=true);
  replaceable function heatTransfer_TwoPhaseSaturated =
     TRANSFORM.Fluid.Pipes_Obsolete.ClosureModels.HeatTransfer.Functions.TwoPhase.Evaporation.alpha_Chen_TubeFlow
    constrainedby TRANSFORM.Fluid.Pipes_Obsolete.ClosureModels.HeatTransfer.Functions.TwoPhase.Evaporation.alpha_Chen_TubeFlow
     annotation(choicesAllMatching=true);
  replaceable function heatTransfer_SinglephaseVapor =
     TRANSFORM.Fluid.Pipes_Obsolete.ClosureModels.HeatTransfer.Functions.SinglePhase.alpha_DittusBoelter
    constrainedby TRANSFORM.Fluid.Pipes_Obsolete.ClosureModels.HeatTransfer.Functions.SinglePhase.alpha_DittusBoelter
     annotation(choicesAllMatching=true);
  SI.CoefficientOfHeatTransfer alpha "Coefficient of heat transfer";
  SI.NusseltNumber Nu "Nusselt number";
  SI.ReynoldsNumber Re "Reynolds number";
  SI.PrandtlNumber Pr "Prandtl number";
  SI.CoefficientOfHeatTransfer alpha_SinglephaseLiquid;
  SI.CoefficientOfHeatTransfer alpha_TwoPhaseSaturated;
  SI.CoefficientOfHeatTransfer alpha_SinglephaseVapor;
equation
  Pr = Medium.prandtlNumber(state);
  Re = TRANSFORM.Utilities.CharacteristicNumbers.ReynoldsNumber_m_flow(
    m_flow=m_flow,
    mu=medium2.mu,
    D=dimension,
    A=crossArea);
  alpha_SinglephaseLiquid = heatTransfer_SinglephaseLiquid(
     D=dimension,
     lambda=medium2.lambda,
     Re=Re,
     Pr=Pr);
  alpha_TwoPhaseSaturated = heatTransfer_TwoPhaseSaturated(
     D=dimension,
     G=m_flow/crossArea,
     x=medium2.x_abs,
     rho_fsat=medium2.rho_lsat,
     mu_fsat=medium2.mu_lsat,
     lambda_fsat=medium2.lambda_lsat,
     cp_fsat=medium2.cp_lsat,
     sigma=medium2.sigma,
     rho_gsat=medium2.rho_vsat,
     mu_gsat=medium2.mu_vsat,
     h_fg=medium2.h_lv,
     Delta_Tsat=T_wall - medium2.sat.Tsat,
     Delta_psat=Medium.saturationPressure(T_wall) - medium2.p);
  alpha_SinglephaseVapor = heatTransfer_SinglephaseVapor(
     D=dimension,
     lambda=medium2.lambda,
     Re=Re,
     Pr=Pr);
  // These perform the same function just using different methods
  //alpha = TRANSFORM.Math.spliceSigmoid(TRANSFORM.Math.spliceSigmoid(alpha_SinglephaseLiquid,alpha_TwoPhaseSaturated,x_th,0,k=200),alpha_SinglephaseVapor,x_th,x_CHF,k=200);
  alpha = TRANSFORM.Math.spliceTanh(alpha_SinglephaseVapor,TRANSFORM.Math.spliceTanh(alpha_TwoPhaseSaturated,alpha_SinglephaseLiquid,medium2.x_th,deltax=0.02),medium2.x_th-x_CHF,deltax=0.02);
  Nu = Utilities.CharacteristicNumbers.NusseltNumber(alpha, dimension, medium2.lambda);
  Q_flow=alpha*surfaceArea*(T_wall - state.T)*nParallel;
end Overall_Evaporation_Lumped;
