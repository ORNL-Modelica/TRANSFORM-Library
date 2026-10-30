within TRANSFORM.HeatExchangers.Examples;
model UAdT_lm_Example_11_1
  extends TRANSFORM.Icons.Example;
  UAdT_lm uAdT_lm(
    Q_flow=0.1*2131*(uAdT_lm.Ts_h[1] - uAdT_lm.Ts_h[2]),
    U_input=38.1,
    calcType="U",
    surfaceArea_input=5.178,
    Ts_h={373.15,333.15},
    Ts_c={303.15,313.35})
    annotation (Placement(transformation(extent={{-60,-20},{-20,20}})));
  TRANSFORM.Utilities.ErrorAnalysis.UnitTests unitTests(
    x={uAdT_lm.U,uAdT_lm1.surfaceArea},
    x_reference={38.1,5.178},
    n=2) annotation (Placement(transformation(extent={{80,80},{100,100}})));
  TRANSFORM.HeatExchangers.UAdT_lm uAdT_lm1(
    Q_flow=0.1*2131*(uAdT_lm.Ts_h[1] - uAdT_lm.Ts_h[2]),
    U_input=38.1,
    surfaceArea_input=5.178,
    calcType="surfaceArea",
    Ts_h={373.15,333.15},
    Ts_c={303.15,313.35})
    annotation (Placement(transformation(extent={{20,-20},{60,20}})));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end UAdT_lm_Example_11_1;
