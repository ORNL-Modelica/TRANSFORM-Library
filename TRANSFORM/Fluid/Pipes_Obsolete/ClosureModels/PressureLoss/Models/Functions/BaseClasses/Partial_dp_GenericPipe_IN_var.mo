within TRANSFORM.Fluid.Pipes_Obsolete.ClosureModels.PressureLoss.Models.Functions.BaseClasses;
record Partial_dp_GenericPipe_IN_var
  "Base input record for models used in GenericPipe"

  extends Modelica.Icons.Record;

  SI.Density rho_a "Density at port_a";
  SI.Density rho_b "Density at port_b";
  SI.DynamicViscosity mu_a "Dynamic viscosity at port_a";
  SI.DynamicViscosity mu_b "Dynamic viscosity at port_b";

end Partial_dp_GenericPipe_IN_var;
