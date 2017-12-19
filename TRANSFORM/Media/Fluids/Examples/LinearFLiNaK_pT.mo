within TRANSFORM.Media.Fluids.Examples;
model LinearFLiNaK_pT

  extends LinearFLiBe_pT(
    redeclare replaceable package Medium =
        TRANSFORM.Media.Fluids.FLiNaK.LinearFLiNaK_pT,
    d_exp={2.1646e3,1.8726e3,1.5441e3},
    eta_exp={8.7991e-3,1.3989e-3,5.2215e-4},
    lambda_exp={0.81658,1.0166,1.2416},
    d_T=TRANSFORM.Media.Fluids.FLiNaK.Utilities.d_T(Ts));

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end LinearFLiNaK_pT;
