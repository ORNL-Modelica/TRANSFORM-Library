within TRANSFORM.Fluid.ClosureRelations.MassTransfer.Functions;
function v_Stokes "Bubble terminal velocity using Stokes solution"
  input SI.Length d_e "Equivalent bubble diameter as a sphere";
  input SI.Density rho_l "Liquid density";
  input SI.Density rho_v "Vapor density";
  input SI.DynamicViscosity mu_l "Liquid dynamic viscosity";
  input SI.Acceleration g = Modelica.Constants.g_n "Acceleration due to gravity";
  output SI.Velocity v "Bubble terminal velocity";
algorithm
  v :=g*d_e*d_e*(rho_l*rho_v)/(18*mu_l);
end v_Stokes;
