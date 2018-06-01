within TRANSFORM.Fluid.ClosureRelations.VoidFraction;
model Homogeneous_wSlipVelocity
  "Volume void fraction with velocity slip ratio (i.e., S = 1 is homogeneous model)"
  extends PartialVoidFraction;

equation

  alphaV = rho_p*x_abs/(S*rho_s*(1 - x_abs) + rho_p*x_abs);

end Homogeneous_wSlipVelocity;
