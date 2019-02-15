within TRANSFORM.Fluid.Pipes_Obsolete.ClosureModels.PressureLoss.HeatExchangers.BellDelawareShell.EndCross;
record dp_IN_var "Input record for function dp_DP and dp_MFLOW"
  extends
    TRANSFORM.Fluid.Pipes_Obsolete.ClosureModels.PressureLoss.Models.Functions.BaseClasses.Partial_dp_GenericPipe_IN_var;
  SI.DynamicViscosity mu_w "Viscosity of fluid at average wall temperature";
end dp_IN_var;
