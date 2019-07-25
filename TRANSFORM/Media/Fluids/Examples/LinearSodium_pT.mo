within TRANSFORM.Media.Fluids.Examples;
model LinearSodium_pT
  extends LinearFLiBe_pT(
    redeclare replaceable package Medium =
        TRANSFORM.Media.Fluids.Sodium.LinearSodium_pT,
  d_exp = {834.62,738.25,619.22},
  eta_exp = {2.3577e-4,1.5638e-4,1.2056e-4},
  lambda_exp = {64.217,48.040,34.798},
    d_T=TRANSFORM.Media.Fluids.Sodium.Utilities.d_T(Ts));
  SI.SpecificEnthalpy h_exp[3] = {7.3543e5,1.2383e6,1.8448e6};
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end LinearSodium_pT;
