within TRANSFORM.Math.Examples;
model check_bessel
  extends TRANSFORM.Icons.Example;
  Real I0_1 = TRANSFORM.Math.besselI(0, 1) "I_0(1)";
  Real I1_3 = TRANSFORM.Math.besselI(1, 3) "I_1(3)";
  Real K0_05 = TRANSFORM.Math.besselK(0, 0.5) "K_0(0.5)";
  Real K1_2 = TRANSFORM.Math.besselK(1, 2) "K_1(2)";
  Real Y0_1 = TRANSFORM.Math.besselY(0, 1) "Y_0(1)";
  Real Y2_5 = TRANSFORM.Math.besselY(2, 5) "Y_2(5)";
  Real K1_5 = TRANSFORM.Math.besselK(1, 5) "K_1(5)";
  Real K3_1 = TRANSFORM.Math.besselK(3, 1) "K_3(1)";
  Real Y1_1 = TRANSFORM.Math.besselY(1, 1) "Y_1(1)";
  Real J1_40 = TRANSFORM.Math.besselJ(1, 40) "J_1(40)";
  Real J5_20 = TRANSFORM.Math.besselJ(5, 20) "J_5(20)";
  Utilities.ErrorAnalysis.UnitTests unitTests(
    n=11,
    x={I0_1,I1_3,K0_05,K1_2,Y0_1,Y2_5,K1_5,K3_1,Y1_1,J1_40,J5_20},
    x_reference={1.266065877752009,3.953370217402609,0.924419071227666,
        0.1398658818165224,0.08825696421567691,0.3676628826055245,
        0.004044613445452164,7.101262824737944,-0.7812128213002888,
        0.12603831803758497,0.15116976798239493})
    "Reference values from the GNU Scientific Library (first six) and SciPy (last five)"
    annotation (Placement(transformation(extent={{80,80},{100,100}})));
  annotation (experiment(StopTime=1));
end check_bessel;
