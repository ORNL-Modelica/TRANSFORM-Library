within TRANSFORM.Fluid.ClosureRelations.PressureLoss.Functions.TubesAndConduits.SinglePhase.LaminarTurbulent_MSLDetailed_TwoPhaseMultiplier;
record dp_IN_con "Input record for function dp_DP and dp_MFLOW"

  extends TRANSFORM.Icons.Record;

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

  SI.ReynoldsNumber Re_turbulent=4000
    "Turbulent transition point if Re >= Re_turbulent";
end dp_IN_con;
