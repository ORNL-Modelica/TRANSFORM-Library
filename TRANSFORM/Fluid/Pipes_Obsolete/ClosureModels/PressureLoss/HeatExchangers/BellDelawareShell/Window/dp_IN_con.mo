within TRANSFORM.Fluid.Pipes_Obsolete.ClosureModels.PressureLoss.HeatExchangers.BellDelawareShell.Window;
record dp_IN_con "Input record for function dp_DP and dp_MFLOW"
extends TRANSFORM.Fluid.Pipes_Obsolete.ClosureModels.PressureLoss.Models.Functions.BaseClasses.Partial_dp_GenericPipe_IN_con;
  Boolean toggleStaggered "true = staggered grid type; false = in-line";
  SI.Length d_B "Diameter of holes in baffles";
  SI.Length d_o "Outer diameter of tubes";
  SI.Length D_i "Inside shell diameter";
  SI.Length D_l "Baffle Diameter";
  SI.Length H "Height of baffle cut";
  SI.Length s1 "Tube to tube pitch parallel to baffel edge";
  SI.Length s2 "Tube to tube pitch perpindicular to baffel edge";
  SI.Length S "Baffle spacing between baffles";
  SI.Length e1 "Space between tubes and shell";
  Real nes "# of shortest connections connecting neighboring tubes";
  Real n_RW "# of tube rows in a window section";
  Real n_W "# of tubes in both the upper and lower window";
  Real n_T "Total # of tubes (including blind and support)";
  Integer nNodes "Number of flow model calculations";
end dp_IN_con;
