within TRANSFORM.Fluid.Examples.SteamRankine_BalanceOfPlant.Components.Control;
block DrumLevelFF "Drum level with feed forward"
  extends DrumLevel(controller(with_FF=true));
  Controls.FeedForward.getOpening_ValveIncompressible
                                 valveLiquidInverse(
    dp=u_m_dp,
    m_flow_ref=u_m_steamFlow,
    dp_nom=(nominalData.p_nom_preheater_HP_cooling_out - nominalData.p_nom_to_SG_drain)
        /2,
    m_flow_nom=nominalData.m_flow_nom_feedWaterPump/3,
    d_nom=Medium.density(Medium.setState_pTX(
          nominalData.p_nom_preheater_HP_cooling_out,
          nominalData.T_nom_preheater_HP_cooling_out - 5,
          Medium.X_default)),
    d=valveLiquidInverse.d_nom)
    annotation (Placement(transformation(extent={{-68,46},{-48,66}})));
  Modelica.Blocks.Math.Gain scaling_FF(k=100) annotation (Placement(
        transformation(
        extent={{10,10},{-10,-10}},
        rotation=90,
        origin={-6,32})));
  Modelica.Blocks.Continuous.FirstOrder FF_firstOrder(
    T=2,
    initType=Modelica.Blocks.Types.Init.InitialState,
    y_start=0.3)
    annotation (Placement(transformation(extent={{-32,50},{-20,62}})));
equation
  connect(FF_firstOrder.y, scaling_FF.u)
    annotation (Line(points={{-19.4,56},{-6,56},{-6,44}}, color={0,0,127}));
  connect(scaling_FF.y, controller.u_ff) annotation (Line(points={{-6,21},{-6,
          21},{-6,12},{-5,12}}, color={0,0,127}));
  connect(valveLiquidInverse.y, FF_firstOrder.u)
    annotation (Line(points={{-47,56},{-33.2,56}}, color={0,0,127}));
end DrumLevelFF;
