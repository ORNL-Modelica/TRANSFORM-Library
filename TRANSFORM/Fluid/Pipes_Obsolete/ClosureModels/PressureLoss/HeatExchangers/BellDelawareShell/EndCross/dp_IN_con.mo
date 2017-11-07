within TRANSFORM.Fluid.Pipes_Obsolete.ClosureModels.PressureLoss.HeatExchangers.BellDelawareShell.EndCross;
record dp_IN_con "Input record for function dp_DP and dp_MFLOW"

extends
    TRANSFORM.Fluid.Pipes_Obsolete.ClosureModels.PressureLoss.Models.Functions.BaseClasses.Partial_dp_GenericPipe_IN_con;

  Boolean toggleStaggered "true = staggered grid type; false = in-line";

  SI.Length d_o "Outer diameter of tubes";
  SI.Length D_i "Inside shell diameter";
  SI.Length DB "Tube bundle diameter";

  SI.Length s1 "Tube to tube pitch parallel to baffel edge";
  SI.Length s2 "Tube to tube pitch perpindicular to baffel edge";
  SI.Length S "Baffle spacing between baffles";
  SI.Length S_E
    "Baffle spacing between the heat exchanger sheets and adjacent baffles";
  SI.Length e1 "Space between tubes and shell";

  Real nes "# of shortest connections connecting neighboring tubes";
  Real n_MR "# of  main resistances in cross flow path";
  Real n_MRE "# of main resistances in end cross flow path";
  Real n_s "# of pairs of sealing strips";
  Integer nNodes;

end dp_IN_con;
