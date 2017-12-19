within TRANSFORM.Media.Fluids.Examples;
model LinearNaFZrF4_pT

  extends LinearFLiBe_pT(
    redeclare replaceable package Medium =
        TRANSFORM.Media.Fluids.NaFZrF4.LinearNaFZrF4_pT,
    d_exp={3.1397e3,2.7841e3,2.384e3},
    eta_exp={1.3145e-2,2.2754e-3,8.8898e-4},
    lambda_exp={3.9178e-1,5.9178e-1,8.1678e-1},
    d_T=TRANSFORM.Media.Fluids.NaFZrF4.Utilities.d_T(Ts));

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end LinearNaFZrF4_pT;
