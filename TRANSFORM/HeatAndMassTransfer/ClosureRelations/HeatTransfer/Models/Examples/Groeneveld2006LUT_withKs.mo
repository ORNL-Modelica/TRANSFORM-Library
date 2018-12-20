within TRANSFORM.HeatAndMassTransfer.ClosureRelations.HeatTransfer.Models.Examples;
model Groeneveld2006LUT_withKs
  import TRANSFORM;

  extends TRANSFORM.Icons.Example;

  Modelica.Blocks.Sources.Sine G(
    freqHz=1/10,
    offset=4000,
    amplitude=5000)
              "mass flux [kg/(m2.s)]"
    annotation (Placement(transformation(extent={{-60,-40},{-40,-20}})));
  Modelica.Blocks.Sources.Sine x(
    amplitude=0.75,
    freqHz=1,
    offset=0.25)  "thermodynamic quality"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Modelica.Blocks.Sources.Sine P(
    amplitude=10.5e6,
    offset=10.55e6,
    freqHz=10)     "pressure [Pa]"
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));
  TRANSFORM.Utilities.ErrorAnalysis.UnitTests unitTests(n=4, x={G.y,x.y,P.y,q.y})
    annotation (Placement(transformation(extent={{80,80},{100,100}})));
  TRANSFORM.HeatAndMassTransfer.ClosureRelations.HeatTransfer.Models.Utilities.Groeneveld2006LUT
    q(
    use_Ks=fill(true, 8),
    D_hyd=0.015,
    D_htr=0.015,
    K_g=2,
    L_sp=0.5,
    L_htd=2,
    rho_lsat(displayUnit="kg/m3") = 800,
    rho_vsat(displayUnit="kg/m3") = 200,
    q_BLA=1e5,
    q_rc_avg=1e5,
    q_rc_max=2e5,
    f_L=2,
    g_n=9.81,
    Pitch=0.02,
    q_local=3e5)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
algorithm

equation
  connect(P.y, q.P) annotation (Line(points={{-39,30},{-26,30},{-26,4},{-12,4}},
        color={0,0,127}));
  connect(x.y, q.x_th)
    annotation (Line(points={{-39,0},{-12,0}}, color={0,0,127}));
  connect(G.y, q.G) annotation (Line(points={{-39,-30},{-26,-30},{-26,-4},{-12,-4}},
        color={0,0,127}));
  annotation (experiment(StopTime=10));
end Groeneveld2006LUT_withKs;
