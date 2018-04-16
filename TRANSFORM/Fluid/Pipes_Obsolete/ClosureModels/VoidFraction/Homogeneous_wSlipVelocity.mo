within TRANSFORM.Fluid.Pipes_Obsolete.ClosureModels.VoidFraction;
model Homogeneous_wSlipVelocity
  "Volume void fraction with velocity slip ratio (i.e., S = 1 is homogeneous model)"
  extends PartialVoidFraction;

  input SI.Velocity v_p "Primary phase velocity (e.g., liquid)" annotation(Dialog(group="Inputs"));
  input SI.Velocity v_s "Secondary phase velocity (e.g., vapor)" annotation(Dialog(group="Inputs"));

  Units.NonDim S "Velocity slip ratio";

equation

  S =
    TRANSFORM.Fluid.Pipes_Obsolete.ClosureModels.VoidFraction.Functions.SlipRatio.S_simpleVelocity(
    v_p, v_s);

  alphaV =
    TRANSFORM.Fluid.Pipes_Obsolete.ClosureModels.VoidFraction.Functions.alphaV_Homogeneous_wSlipRatio(
        medium2.x_abs,
        medium2.rho_lsat,
        medium2.rho_vsat,
        S);

end Homogeneous_wSlipVelocity;
