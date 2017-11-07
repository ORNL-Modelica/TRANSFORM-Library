within TRANSFORM.Fluid.Examples.SteamRankine_BalanceOfPlant.Components.Control;
block FWH_LP_levelFF
  extends FWH_LP_level(controller(with_FF=true));
  package Medium=Modelica.Media.Water.StandardWater;
  Controls.FeedForward.getRPM_centrifugalPump
                                     pumpInverse(
    m_flow_nom=nominalData.m_flow_nom_turbine_LP_stage2 - nominalData.m_flow_nom_turbine_LP_stage3,
    d_nom=Medium.bubbleDensity(Medium.setSat_p(nominalData.p_nom_preheater_LP)),
    dp=u_m_dp,
    m_flow_ref=u_m_flowIn,
    q_nom=(pumpInverse.m_flow_nom/pumpInverse.d_nom)*{0,1,2},
    head_nom=(1/10*1/pumpInverse.d_nom)*(nominalData.p_nom_dearator -
        nominalData.p_nom_preheater_LP)*{2,1,0},
    omega_RPM_nom=1200)
    annotation (Placement(transformation(extent={{-68,48},{-48,68}})));

  Records.RankineNominalValues nominalData
    annotation (Placement(transformation(extent={{62,64},{82,84}})));
  Modelica.Blocks.Continuous.FirstOrder FF_firstOrder(
    T=2,
    initType=Modelica.Blocks.Types.Init.InitialState,
    y_start=1200)
    annotation (Placement(transformation(extent={{-32,52},{-20,64}})));
  Modelica.Blocks.Math.Gain scaling_FF(k=100/20000)
                                              annotation (Placement(
        transformation(
        extent={{10,10},{-10,-10}},
        rotation=90,
        origin={-6,32})));
equation
  connect(scaling_FF.u, FF_firstOrder.y)
    annotation (Line(points={{-6,44},{-6,58},{-19.4,58}}, color={0,0,127}));
  connect(scaling_FF.y, controller.u_ff) annotation (Line(points={{-6,21},{-6,
          21},{-6,12},{-5,12}}, color={0,0,127}));
  connect(pumpInverse.y, FF_firstOrder.u)
    annotation (Line(points={{-47,58},{-33.2,58}}, color={0,0,127}));
end FWH_LP_levelFF;
