within TRANSFORM.Media.Fluids.Examples;
model LinearKFZrF4_pT

  extends LinearFLiBe_pT(
    redeclare replaceable package Medium =
        TRANSFORM.Media.Fluids.KFZrF4.LinearKFZrF4_pT,
    d_exp={2.9722e3,2.6174e3,2.2183e3},
    eta_exp={9.7075e-3,2.3892e-3,1.1271e-3},
    lambda_exp={3.5458e-1,5.5458e-1,7.7958e-1},
    d_T=TRANSFORM.Media.Fluids.KFZrF4.Utilities.d_T(Ts));

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end LinearKFZrF4_pT;
