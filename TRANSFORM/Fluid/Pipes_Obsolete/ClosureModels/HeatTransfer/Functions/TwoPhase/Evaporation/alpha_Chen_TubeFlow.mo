within TRANSFORM.Fluid.Pipes_Obsolete.ClosureModels.HeatTransfer.Functions.TwoPhase.Evaporation;
function alpha_Chen_TubeFlow "Chen's correlation for two-phase flow in a tube"
  import TRANSFORM;

  /*
  Correlation for the following conditions:
  1. Saturated, two-phase fluid in convective flow
  2. Vertical, axial-flow
  3. Stable flow
  4. No slug flow
  5. No liquid deficiency
  6. Heat flux less than the critical flux
  *These conditions usually occur with annular flow or annular-mist flow
  in the quality range of approximately 1-70%.
  
Source 1:
J. C. Chen, "Correlation for Boiling Heat Transfer to Saturated Fluids in
Convective Flow," Industrial & Engineering Chemistry Process Design and 
Development, 5(3), pp. 322-329, July, 1966.

Additional sources referencing Source 1:
- J. R. Thome, "Engineering Data Book III," Wolverine Tube Inc., Ch. 10.3.1.
- J. G. Collier and J. R. Thome, "Convection Boiling and Condensation 3E," 1996.
- W. Chen and X. Fang, "A note on the Chen correlation of saturated flow boiling
  heat transfer," International Journal of Refrigeration, 48, pp. 100-104, 2014.

Notes:
Saturated fluid properties are based on the bulk fluid temperature and pressure.

  */

  //Constants
  input SI.Length D "Hydraulic diameter";

  // Variables
  input TRANSFORM.Units.MassFlux G "Mass flux";
  input TRANSFORM.Units.NonDim x(min=0.0, max=1.0) "Absolute Steam quality";

  input SI.Density rho_fsat "Saturated liquid density";
  input SI.DynamicViscosity mu_fsat "Liquid dynamic viscosity";
  input SI.ThermalConductivity lambda_fsat "Liquid thermal conductivity";
  input SI.SpecificHeatCapacity cp_fsat
    "Liquid constant pressure heat capacity";
  input SI.SurfaceTension sigma "Surface Tension";

  input SI.Density rho_gsat "Vapour density";
  input SI.DynamicViscosity mu_gsat "Vapour dynamic viscosity";
  input SI.SpecificEnthalpy h_fg "Latent heat of vaporization";

  input SI.TemperatureDifference Delta_Tsat
    "Saturation temperature difference (Twall-Tsat)";
  input SI.PressureDifference Delta_psat
    "Saturation pressure difference (psat(Twall)-psat(Tsat))";

  output SI.CoefficientOfHeatTransfer alpha
    "Two-phase total heat transfer coefficient";
  output Real X_tt_inv "Inverse of the Martenelli Parameter";
  output Real F
    "Correction factor for two-phase impact on liquid-phase convection";
  output Real S "Nucleare boiling suppresion factor";
  output Real Re_tp "Two-phase Reynolds number";

protected
  Real Re_fsat "Liquid-phase Reynolds number";
  Real Pr_fsat "Liquid-phase Prandtl number";

  SI.CoefficientOfHeatTransfer alpha_f
    "Liquid phase convection heat transfer coefficient";
  SI.CoefficientOfHeatTransfer alpha_FZ
    "Forster-Zuber correlation for nucleate pool boiling coefficient";
  SI.CoefficientOfHeatTransfer alpha_cb
    "Macroconvective or Convection boiling convection heat transfer coefficient";
  SI.CoefficientOfHeatTransfer alpha_nb
    "Microconvective or Nucleate boiling convection heat transfer coefficient";
  TRANSFORM.Units.NonDim x_limit
    "Limited quality to prevent infinity result for X_tt_inv";

algorithm
  // Source 1: eq. A-10
  Re_fsat :=abs(G)*(1 - x)*D/mu_fsat;
  Pr_fsat :=cp_fsat*mu_fsat/lambda_fsat;

  x_limit :=TRANSFORM.Math.spliceSigmoid(
     x,
     0.98,
     x,
     0.96);

  // Source 1: Figure 6
  X_tt_inv :=(x_limit/(1 - x_limit))^(0.9)*(rho_fsat/rho_gsat)^(0.5)*(mu_gsat/mu_fsat)^(0.1);

  F :=TRANSFORM.Math.spliceSigmoid(
     1.0,
     2.35*(X_tt_inv + 0.213)^(0.736),
     X_tt_inv,
     0.1);

  // Source 1: eq. 9
  alpha_f :=
    TRANSFORM.Fluid.Pipes_Obsolete.ClosureModels.HeatTransfer.Functions.SinglePhase.alpha_DittusBoelter(
              D=D,
              lambda=lambda_fsat,
              Re=Re_fsat,
              Pr=Pr_fsat);

  // Source 1: Figure 7
  Re_tp :=Re_fsat*F^(1.25);

  // Source 1: Figure 7
  S :=1/(1 + 2.53e-6*Re_tp^(1.17));

  // Source 1: eq. 17
  alpha_FZ:=0.00122*(lambda_fsat^(0.79)*cp_fsat^(0.45)*rho_fsat^(0.49)*Modelica.Constants.g_n^(0.25))/(sigma^(0.5)*mu_fsat^(0.29)
    *h_fg^(0.24)*rho_gsat^(0.24))*max(0,Delta_Tsat)^(0.24)*max(0,Delta_psat)^(0.75);

  // Source 1: eq. 9, 17, 18
  alpha_cb :=alpha_f*F;
  alpha_nb :=alpha_FZ*S;
  alpha :=alpha_nb + alpha_cb;

  annotation (Documentation(info="<html>
<p>Chen&apos;s correlation for the computation of the heat transfer coefficient in two-phase flows. </p>
</html>"));
end alpha_Chen_TubeFlow;
