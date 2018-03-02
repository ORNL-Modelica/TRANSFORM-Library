within TRANSFORM.Fluid.ClosureRelations.PressureLoss.Functions.TubesAndConduits.TwoPhase.LaminarTurbulent_MSLDetailed;
record dp_IN_var "Input record for function dp_DP and dp_MFLOW"

  extends TRANSFORM.Icons.Record;

  SI.Density rho_a "Density at port_a";
  SI.Density rho_b "Density at port_b";
  SI.Density rho_l_a "Liquid density at port_a";
  SI.Density rho_l_b "Liquid density at port_b";
  SI.Density rho_v_a "Vapor density at port_a";
  SI.Density rho_v_b "Vapor density at port_b";

  SI.DynamicViscosity mu_a "Dynamic viscosity at port_a";
  SI.DynamicViscosity mu_b "Dynamic viscosity at port_b";
  SI.DynamicViscosity mu_l_a "Liquid dynamic viscosity at port_a";
  SI.DynamicViscosity mu_l_b "Liquid dynamic viscosity at port_b";
  SI.DynamicViscosity mu_v_a "Vapor dynamic viscosity at port_a";
  SI.DynamicViscosity mu_v_b "Vapor dynamic viscosity at port_b";

  SIadd.NonDim x_abs_a "Absolute quality at port_a";
  SIadd.NonDim x_abs_b "Absolute quality at port_a";

end dp_IN_var;
