within TRANSFORM.Fluid.Pipes_Obsolete.ClosureModels.PressureLoss.HeatExchangers.BellDelawareShell.Nozzle;
record dp_IN_con "Input record for function dp_DP and dp_MFLOW"

extends
    TRANSFORM.Fluid.Pipes_Obsolete.ClosureModels.PressureLoss.Models.Functions.BaseClasses.Partial_dp_GenericPipe_IN_con;

  SI.Length d_N "Nozzle diameter";
  SI.Length d_o "Outer diameter of tubes";
  Real n_T "Total # of tubes (including blind and support)";
  SI.Length D_i "Inside shell diameter";
  SI.Length D_BE "Diameter of circle that touches outermost tubes";
  Integer nNodes "Number of flow model calculations";

end dp_IN_con;
