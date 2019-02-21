within TRANSFORM.Fluid.Pipes_Obsolete.ClosureModels.HeatTransfer.Lumped.SinglePhase;
model DittusBoelter_SinglePhase_Lumped
  "Single Phase: Dittus Boelter correlation"
  extends
    TRANSFORM.Fluid.Pipes_Obsolete.ClosureModels.HeatTransfer.Lumped.BaseClasses.PartialLumpedHeatTransfer;
  SI.CoefficientOfHeatTransfer alpha "Coefficient of heat transfer";
  SI.NusseltNumber Nu "Nusselt number";
  SI.SpecificEnthalpy h_fgp "Modified latent heat of vaporization";
  Units.NonDim Ja "Jakob number";
equation
  alpha =
    TRANSFORM.Fluid.Pipes_Obsolete.ClosureModels.HeatTransfer.Functions.SinglePhase.alpha_DittusBoelter(
            D=dimensions,
            lambda=lambdas,
            Re=Re,
            Pr=Pr);
  Nu = Utilities.CharacteristicNumbers.NusseltNumber(alpha, dimension, medium2.lambda);
  Q_flow=alpha*surfaceArea*(T_wall - state.T)*nParallel;
end DittusBoelter_SinglePhase_Lumped;
