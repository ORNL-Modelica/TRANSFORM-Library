within TRANSFORM.Fluid.ClosureRelations.PressureLoss.Functions.TubesAndConduits.TwoPhase.LaminarTurbulent_MSLDetailed2;
record dp_IN_var "Input record for function dp_DP and dp_MFLOW"

  extends TRANSFORM.Icons.Record;

  SI.Density rho_a "Density at port_a";
  SI.Density rho_b "Density at port_b";
  SI.DynamicViscosity mu_a "Dynamic viscosity at port_a";
  SI.DynamicViscosity mu_b "Dynamic viscosity at port_b";

end dp_IN_var;
