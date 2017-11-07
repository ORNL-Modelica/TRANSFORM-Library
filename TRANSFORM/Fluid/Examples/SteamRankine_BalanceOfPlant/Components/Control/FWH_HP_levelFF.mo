within TRANSFORM.Fluid.Examples.SteamRankine_BalanceOfPlant.Components.Control;
block FWH_HP_levelFF
  "Feedwater high pressure heater with feedforward control"
  extends FWH_HP_level(controller(with_FF=true));
  package Medium =
      Modelica.Media.Water.StandardWater;
  Controls.FeedForward.getOpening_ValveIncompressible
                                 valveLiquidInverse(
    dp=u_m_dp,
    d=valveLiquidInverse.d_nom,
    m_flow_nom=(nominalData.m_flow_nom_turbine_HP_stage1 - nominalData.m_flow_nom_turbine_HP_stage2)
        *2,
    m_flow_ref=u_m_flowIn,
    dp_nom=(nominalData.p_nom_preheater_HP - nominalData.p_nom_dearator),
    d_nom=1000)
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
    annotation (Line(points={{-6.75,12},{-6,12},{-6,23}}, color={0,0,127}));
  connect(valveLiquidInverse.y, FF_firstOrder.u) annotation (Line(points={{-47,
          58},{-33.2,58},{-33.2,58}}, color={0,0,127}));
end FWH_HP_levelFF;
