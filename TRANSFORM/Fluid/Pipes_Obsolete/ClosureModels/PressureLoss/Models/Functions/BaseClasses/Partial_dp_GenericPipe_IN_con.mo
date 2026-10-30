within TRANSFORM.Fluid.Pipes_Obsolete.ClosureModels.PressureLoss.Models.Functions.BaseClasses;
record Partial_dp_GenericPipe_IN_con
  "Base input record for models used in GenericPipe"
  extends Modelica.Icons.Record;
  SI.Diameter diameter_a "Inner (hydraulic) diameter at port_a";
  SI.Diameter diameter_b "Inner (hydraulic) diameter at port_b";
  SI.Area crossArea_a=Modelica.Constants.pi*diameter_a^2/4
    "Inner cross section area at port_a";
  SI.Area crossArea_b=Modelica.Constants.pi*diameter_b^2/4
    "Inner cross section area at port_b";
  SI.Length length "Length of pipe";
  SI.Length roughness_a(min=0)=2.5e-5
    "Absolute roughness of pipe at port_a, with a default for a smooth steel pipe";
  SI.Length roughness_b(min=0)=2.5e-5
    "Absolute roughness of pipe at port_b, with a default for a smooth steel pipe";
end Partial_dp_GenericPipe_IN_con;
