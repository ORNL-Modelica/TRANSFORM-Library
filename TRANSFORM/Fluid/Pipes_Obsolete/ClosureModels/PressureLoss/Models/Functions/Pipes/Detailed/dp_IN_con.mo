within TRANSFORM.Fluid.Pipes_Obsolete.ClosureModels.PressureLoss.Models.Functions.Pipes.Detailed;
record dp_IN_con "Input record for function dp_DP and dp_MFLOW"
extends
    TRANSFORM.Fluid.Pipes_Obsolete.ClosureModels.PressureLoss.Models.Functions.BaseClasses.Partial_dp_GenericPipe_IN_con;
  SI.ReynoldsNumber Re_turbulent=4000
    "Turbulent transition point if Re >= Re_turbulent";
end dp_IN_con;
