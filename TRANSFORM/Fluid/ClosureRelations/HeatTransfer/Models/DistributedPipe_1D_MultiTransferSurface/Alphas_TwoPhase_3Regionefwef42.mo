within TRANSFORM.Fluid.ClosureRelations.HeatTransfer.Models.DistributedPipe_1D_MultiTransferSurface;
model Alphas_TwoPhase_3Regionefwef42
  "Specify alphas | Two Phase | 3 Regions - 1P Liquid, 2P, 1P Vapor"

  extends PartialTwoPhase;

  input SI.CoefficientOfHeatTransfer[nHT,nSurfaces] alpha_SinglePhaseLiquid={{
      mediaProps[i].lambda/dimensions[i]*
      TRANSFORM.HeatAndMassTransfer.ClosureRelations.HeatTransfer.Functions.SinglePhase.InternalFlow.Nu_DittusBoelter(
      Res[i],
      Prs[i]) for j in 1:nSurfaces} for i in 1:nHT}
    "Turbulent coefficient of heat transfer - Liquid Phase"
    annotation (Dialog(group="Input Variables"));

  input SI.CoefficientOfHeatTransfer[nHT,nSurfaces] alpha_TwoPhaseSaturated={{
      HeatAndMassTransfer.ClosureRelations.HeatTransfer.Functions.TwoPhase.NucleateBoiling.alpha_Chen_TubeFlow(
      D=dimensions[i],
      G=m_flows[i]/crossAreas[i],
      x=mediaProps[i].x_abs,
      rho_fsat=mediaProps[i].rho_lsat,
      mu_fsat=mediaProps[i].mu_lsat,
      lambda_fsat=mediaProps[i].lambda_lsat,
      cp_fsat=mediaProps[i].cp_lsat,
      sigma=mediaProps[i].sigma,
      rho_gsat=mediaProps[i].rho_vsat,
      mu_gsat=mediaProps[i].mu_vsat,
      h_fg=mediaProps[i].h_lv,
      Delta_Tsat=Ts_wall[i, j] - mediaProps[i].sat.Tsat,
      Delta_psat=Medium.saturationPressure(Ts_wall[i, j]) - mediaProps[i].p)
      for j in 1:nSurfaces} for i in 1:nHT}
    "Coefficient of heat transfer - Saturated Two Phase"
    annotation (Dialog(group="Input Variables"));

  input SI.CoefficientOfHeatTransfer[nHT,nSurfaces] alpha_SinglePhaseVapor={{
      mediaProps[i].lambda/dimensions[i]*
      TRANSFORM.HeatAndMassTransfer.ClosureRelations.HeatTransfer.Functions.SinglePhase.InternalFlow.Nu_DittusBoelter(
      Res[i],
      Prs[i]) for j in 1:nSurfaces} for i in 1:nHT}
    "Turbulent coefficient of heat transfer - Vapor Phase"
    annotation (Dialog(group="Input Variables"));

  input SI.Length[nHT,nSurfaces] L_char=transpose({dimensions for i in 1:
      nSurfaces}) "Characteristic dimension for calculation of Nu"
    annotation (Dialog(group="Input Variables"));
  input SI.ThermalConductivity[nHT,nSurfaces] lambda=transpose({mediaProps.lambda
      for i in 1:nSurfaces}) "Thermal conductivity for calculation of Nu"
    annotation (Dialog(group="Input Variables"));

  input Real HT_width[3]={0.02,0.02,0.02}
   "Smooth transition width"
   annotation (Dialog(tab="Advanced",group="Input Variables"));

  input Real Var_smooth[nHT]=mediaProps.x_th
    "Variable for smoothing between regions with phase transition"
    annotation (Dialog(tab="Advanced",group="Input Variables"));

//   input Real HT_smooth[nHT]={
//       HeatAndMassTransfer.ClosureRelations.HeatTransfer.Functions.TwoPhase.CHF.EPRI_quality(
//       heatPorts[i, 1].Q_flow/surfaceAreas[i, 1],
//       sum(heatPorts[:, 1].Q_flow)/nHT,
//       mediaProps[i].x_th,
//       m_flows[i]/crossAreas[i],
//       mediaProps[i].p/mediaProps[i].p_crit) for i in 1:nHT}
//     "Smooth value for transition between regions with phase transition"
//     annotation (Dialog(tab="Advanced", group="Input Variables"));


protected
  SI.CoefficientOfHeatTransfer[nHT,nSurfaces]
    alpha_SinglePhase_Liquid_To_TwoPhaseSaturated;

public
  SDF.NDTable q[nHT](
    each dataset="/q",
    each nin=3,
    each readFromFile=true,
    each filename=Modelica.Utilities.Files.loadResource("modelica://TRANSFORM/Resources/Data/2006LUT.sdf"),
    each interpMethod=SDF.Types.InterpolationMethod.Akima,
    each extrapMethod=SDF.Types.ExtrapolationMethod.Hold)
    "Outputs predicted CHF heat flux [W/m2] // {\"kg/(m2.s)\",\"1\",\"Pa\"}   \"W/m2\""
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

  Modelica.Blocks.Sources.RealExpression G[nHT](y=abs(m_flows) ./ crossAreas)
    "mass flux [kg/(m2.s)]"
    annotation (Placement(transformation(extent={{-60,-40},{-40,-20}})));
  Modelica.Blocks.Sources.RealExpression x[nHT](y=mediaProps.x_th)
    "thermodynamic quality"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Modelica.Blocks.Sources.RealExpression P1[nHT](y=mediaProps.p)
    "pressure [Pa]"
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));
equation


  for i in 1:nHT loop
    for j in 1:nSurfaces loop
      alpha_SinglePhase_Liquid_To_TwoPhaseSaturated[i, j] =
        TRANSFORM.Math.spliceTanh(
        alpha_TwoPhaseSaturated[i, j],
        alpha_SinglePhaseLiquid[i, j],
        Var_smooth[i] - 0,
        deltax=HT_width[1]);

      alphas[i, j] =
        TRANSFORM.Math.spliceTanh(
        alpha_SinglePhaseVapor[i, j],
        alpha_SinglePhase_Liquid_To_TwoPhaseSaturated[i, j],
        Q_flows[i,1]/surfaceAreas[i,1] - q[i].y,
        deltax=100);

    end for;
  end for;

  Nus = alphas .* L_char ./ lambda;

  connect(P1.y, q.u[3]) annotation (Line(points={{-39,30},{-30,30},{-30,1.33333},
          {-12,1.33333}}, color={0,0,127}));
  connect(x.y, q.u[2])
    annotation (Line(points={{-39,0},{-12,0}}, color={0,0,127}));
  connect(G.y, q.u[1]) annotation (Line(points={{-39,-30},{-30,-30},{-30,-1.33333},
          {-12,-1.33333}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Alphas_TwoPhase_3Regionefwef42;
