within TRANSFORM.Fluid.Examples.SteamRankine_BalanceOfPlant.Components.Control;
block CondenserLevelFF "Condenser level with feedforward"
  extends CondenserLevel(controller(with_FF=true));
  package Medium=Modelica.Media.Water.StandardWater;
  parameter Integer nbr_pumps_LP=3 "Number of low pressure feed-water pumps";
  Controls.FeedForward.getRPM_centrifugalPump
                                     pumpInverse(
    dp=u_m_dp,
    q_nom=(pumpInverse.m_flow_nom/pumpInverse.d_nom)*{0,1,2},
    head_nom=(1/10*1/pumpInverse.d_nom)*(nominalData.p_nom_dearator -
        nominalData.p_nom_condenser)*{2,1,0},
    d_nom=Medium.bubbleDensity(Medium.setSat_p(nominalData.p_nom_condenser)),
    m_flow_nom=nominalData.m_flow_nom_turbine_LP_stage3/nbr_pumps_LP,
    m_flow_ref=u_m_flowIn/nbr_pumps_LP,
    omega_RPM_nom=1200)
    annotation (Placement(transformation(extent={{-70,52},{-50,72}})));
  Modelica.Blocks.Continuous.FirstOrder FF_firstOrder(
    T=2,
    initType=Modelica.Blocks.Types.Init.InitialState,
    y_start=1200)
    annotation (Placement(transformation(extent={{-34,56},{-22,68}})));
  Modelica.Blocks.Math.Gain scaling_FF(k=100/20000)
                                              annotation (Placement(
        transformation(
        extent={{10,10},{-10,-10}},
        rotation=90,
        origin={-8,36})));
  Records.RankineNominalValues nominalData
    annotation (Placement(transformation(extent={{64,68},{84,88}})));
equation
  connect(scaling_FF.u,FF_firstOrder. y)
    annotation (Line(points={{-8,48},{-8,62},{-21.4,62}}, color={0,0,127}));
  connect(controller.u_ff, scaling_FF.y) annotation (Line(points={{-7,12},{-7,
          18},{-8,18},{-8,25}}, color={0,0,127}));
  connect(pumpInverse.y, FF_firstOrder.u) annotation (Line(points={{-49,62},{
          -35.2,62},{-35.2,62}}, color={0,0,127}));
end CondenserLevelFF;
