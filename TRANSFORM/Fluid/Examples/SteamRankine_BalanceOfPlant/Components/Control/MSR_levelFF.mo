within TRANSFORM.Fluid.Examples.SteamRankine_BalanceOfPlant.Components.Control;
block MSR_levelFF "MSR with feedforward control"
  extends MSRLevel(controller(with_FF=true));
  package Medium=Modelica.Media.Water.StandardWater;
  Controls.FeedForward.getOpening_ValveIncompressible
                                 valveLiquidInverse(
    d_nom=1000,
    m_flow_nom=200,
    dp=u_m_dp,
    m_flow_ref=u_m_flowIn,
    dp_nom=300000)
    annotation (Placement(transformation(extent={{-68,48},{-48,68}})));

  Modelica.Blocks.Math.Gain scaling_FF(k=100) annotation (Placement(
        transformation(
        extent={{10,10},{-10,-10}},
        rotation=90,
        origin={-6,34})));
  Modelica.Blocks.Continuous.FirstOrder FF_firstOrder(
    T=2,
    initType=Modelica.Blocks.Types.Init.InitialState,
    y_start=0.3)
    annotation (Placement(transformation(extent={{-32,52},{-20,64}})));
  parameter Records.RankineNominalValues nominalData "Nominal data"
    annotation (Dialog(group="Nominal operating data"), Placement(
        transformation(extent={{60,60},{80,80}})));
equation
  connect(FF_firstOrder.y, scaling_FF.u)
    annotation (Line(points={{-19.4,58},{-6,58},{-6,46}}, color={0,0,127}));
  connect(controller.u_ff, scaling_FF.y)
    annotation (Line(points={{-4.75,12},{-6,12},{-6,23}}, color={0,0,127}));
  connect(valveLiquidInverse.y, FF_firstOrder.u) annotation (Line(points={{-47,
          58},{-33.2,58},{-33.2,58}}, color={0,0,127}));
end MSR_levelFF;
