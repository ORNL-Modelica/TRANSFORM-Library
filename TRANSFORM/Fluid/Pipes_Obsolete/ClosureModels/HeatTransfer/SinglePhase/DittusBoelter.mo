within TRANSFORM.Fluid.Pipes_Obsolete.ClosureModels.HeatTransfer.SinglePhase;
model DittusBoelter "Dittus-Boelter: Single-phase"
  import TRANSFORM;

  extends
    TRANSFORM.Fluid.Pipes_Obsolete.ClosureModels.HeatTransfer.BaseClasses.PartialPipeFlowHeatTransfer;

equation
   for i in 1:nHT loop
    alphas[i] =
      TRANSFORM.Fluid.Pipes_Obsolete.ClosureModels.HeatTransfer.Functions.SinglePhase.alpha_DittusBoelter(
            D=dimensions[i],
            lambda=lambdas[i],
            Re=Res[i],
            Pr=Prs[i]);

    Nus[i] = alphas[i]*dimensions[i]/lambdas[i];
  end for;

end DittusBoelter;
