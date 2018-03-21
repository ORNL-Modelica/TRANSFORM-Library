within TRANSFORM.HeatAndMassTransfer.ClosureRelations.HeatTransfer.Functions.TwoPhase.PostCHF;
function alpha_Groeneveld

  // VDI Heat Atlas H3.6-2.2 pg. 873
  // Upward Flow Through Straight Vertical Tubes and Annular Gaps Under Thermodynamic Equilibrium

  input SI.Length D_hyd "Hydraulic diameter";
  input SI.Area crossArea "Cross-sectional flow area";
  input SI.MassFlowRate m_flow "Mass flow rate";

  input SIadd.NonDim x_abs "Absolute quality";
  input SI.DynamicViscosity mu_vsat
    "Vapor phase saturated dynamic viscosity";
  input SI.Density rho_lsat "Saturated liquid density";
  input SI.Density rho_vsat "Saturated vapor density";
  input SI.ThermalConductivity lambda_vsat "Vapor phase thermal conductivity";
  input SI.PrandtlNumber Pr_vw
    "Prandtl number for the vapor at the wall temperature";

  output SI.CoefficientOfHeatTransfer alpha;
  output Real status "Success/Failure (0/1) status";

protected
  Real A=0.00327;
  Real B=0.9;
  Real C=1.32;
  Real D=-1.5;

  Real Re "Vapor phase Reynolds number";
  Real Nu "Nusselt number of vapor phase";
  Real Y;
  Real epsilon_hom "Void fraction in the homogenous flow";

  Real status_p=if rho_lsat/rho_vsat > 6 then 1 else 0 "pressure status";
  Real status_G=if m_flow/crossArea < 2000 then 10 else 0 "mass flux status";

algorithm
  status := status_p + status_G;

  Re := D_hyd*abs(m_flow)/(crossArea*mu_vsat);
  epsilon_hom := x_abs/(x_abs + (rho_vsat/rho_lsat)*(1 - x_abs));
  Y := 1 - 0.1*((rho_lsat/rho_vsat - 1)*(1 - x_abs))^0.4;
  Nu := A*(Re*x_abs/max(epsilon_hom, Modelica.Constants.eps))^B*Pr_vw^C*Y^D;

  alpha := Nu*lambda_vsat/D_hyd;

end alpha_Groeneveld;
