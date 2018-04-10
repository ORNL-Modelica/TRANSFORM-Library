within TRANSFORM.Fluid.ClosureRelations.PressureLoss.Functions.Examples.TubesAndConduits.TwoPhase;
model LaminarTurbulent_MSLDetailed

  package Medium = Modelica.Media.Water.StandardWater;

  parameter Integer nFM=11;

  parameter SI.SpecificEnthalpy hs_start[nFM + 1]=linspace(
      1e5,
      3e6,
      nFM + 1);
  parameter SI.Pressure ps_start[nFM + 1]=linspace(1e5,2e5, nFM + 1);
  parameter SI.MassFlowRate m_flows_start[nFM]=fill(1, nFM);

  Medium.ThermodynamicState states_start[nFM + 1]=Medium.setState_ph(ps_start,
      hs_start);
  parameter SI.MassFlowRate m_flow_small=0.001;
  parameter SI.PressureDifference dp_small=0.001;

  parameter SI.Length dimensions[nFM + 1]=fill(0.1, nFM + 1)
    "Characteristic dimensions (e.g. hydraulic diameter)";
  parameter SI.Area crossAreas[nFM + 1]=0.25*pi*dimensions .^ 2
    "Cross sectional area";
  parameter SI.Length dlengths[nFM]=fill(0.1, nFM) "Length of flow model";
  parameter SI.Height[nFM + 1] roughnesses=fill(2.5e-5, nFM + 1)
    "Average height of surface asperities";
  parameter SI.Length[nFM] dheights=dlengths
    "Height(states[2:nFM+1]) - Height(states[1:nFM])";
  parameter SI.ReynoldsNumber Re_turb=4000;

  parameter SI.Acceleration g_n=9.81;

  TRANSFORM.Fluid.ClosureRelations.PressureLoss.Functions.TubesAndConduits.TwoPhase.LaminarTurbulent_MSLDetailed.dp_IN_con
    [nFM] IN_con(
    length=dlengths,
    diameter_a=dimensions[1:nFM],
    diameter_b=dimensions[2:nFM + 1],
    crossArea_a=crossAreas[1:nFM],
    crossArea_b=crossAreas[2:nFM + 1],
    roughness_a=roughnesses[1:nFM],
    roughness_b=roughnesses[2:nFM + 1],
    each Re_turbulent=Re_turb)
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));

  TRANSFORM.Fluid.ClosureRelations.PressureLoss.Functions.TubesAndConduits.TwoPhase.LaminarTurbulent_MSLDetailed.dp_IN_var
    [nFM] IN_var(
    rho_a=ds_a,
    rho_b=ds_b,
    rho_l_a=ds_l_a,
    rho_l_b=ds_l_b,
    rho_v_a=ds_v_a,
    rho_v_b=ds_v_b,
    mu_a=mus_a,
    mu_b=mus_b,
    mu_l_a=mus_l_a,
    mu_l_b=mus_l_b,
    mu_v_a=mus_v_a,
    mu_v_b=mus_v_b,
    x_abs_a=x_abs_a,
    x_abs_b=x_abs_b)
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));

  Media.BaseProperties2Phase[nFM + 1] mediaProps(redeclare package
              Medium =
        Medium, state=states_start) "Bulk fluid properties"
    annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));

  SI.PressureDifference dps_start[nFM]={ps_start[i + 1] - ps_start[i] for i in 1
      :nFM};

  SI.DynamicViscosity mus_a[nFM]=mediaProps[1:nFM].mu;
  SI.DynamicViscosity mus_b[nFM]=mediaProps[2:nFM + 1].mu;

  SI.Density ds_a[nFM]=mediaProps[1:nFM].d;
  SI.Density ds_b[nFM]=mediaProps[2:nFM + 1].d;

  SI.Density ds_l_a[nFM]=mediaProps[1:nFM].rho_lsat;
  SI.Density ds_l_b[nFM]=mediaProps[2:nFM + 1].rho_lsat;
  SI.Density ds_v_a[nFM]=mediaProps[1:nFM].rho_vsat;
  SI.Density ds_v_b[nFM]=mediaProps[2:nFM + 1].rho_vsat;

  SI.DynamicViscosity mus_l_a[nFM]=mediaProps[1:nFM].mu_lsat;
  SI.DynamicViscosity mus_l_b[nFM]=mediaProps[2:nFM + 1].mu_lsat;
  SI.DynamicViscosity mus_v_a[nFM]=mediaProps[1:nFM].mu_vsat;
  SI.DynamicViscosity mus_v_b[nFM]=mediaProps[2:nFM + 1].mu_vsat;

  SIadd.NonDim x_abs_a[nFM]=mediaProps[1:nFM].x_abs;
  SIadd.NonDim x_abs_b[nFM]=mediaProps[2:nFM + 1].x_abs;

  SI.PressureDifference dps_fg_c[nFM];
  SI.PressureDifference dps_fg[nFM];

  SI.MassFlowRate m_flows_c[nFM];
  SI.MassFlowRate m_flows[nFM];

  Real phi2[nFM] = TRANSFORM.Fluid.ClosureRelations.PressureLoss.Functions.Utilities.TwoPhaseFrictionMultiplier(x_abs_a,mus_l_a,mus_v_a,ds_l_a,ds_v_a);
equation

  m_flows_c =
    TRANSFORM.Fluid.ClosureRelations.PressureLoss.Functions.TubesAndConduits.TwoPhase.LaminarTurbulent_MSLDetailed.dp_MFLOW(
    IN_con,
    IN_var,
    dps_start - {g_n*dheights[i]*ds_a[i] for i in 1:nFM},
    dp_small/(nFM));

  dps_fg_c =
    TRANSFORM.Fluid.ClosureRelations.PressureLoss.Functions.TubesAndConduits.TwoPhase.LaminarTurbulent_MSLDetailed.dp_DP(
    IN_con,
    IN_var,
    m_flows_start,
    m_flow_small);

  m_flows =
    TRANSFORM.Fluid.ClosureRelations.PressureLoss.Functions.TubesAndConduits.TwoPhase.LaminarTurbulent_MSLDetailed.dp_MFLOW_staticHead(
    IN_con,
    IN_var,
    dps_start,
    dp_small/(nFM),
    g_n*dheights);

  dps_fg =
    TRANSFORM.Fluid.ClosureRelations.PressureLoss.Functions.TubesAndConduits.TwoPhase.LaminarTurbulent_MSLDetailed.dp_DP_staticHead(
    IN_con,
    IN_var,
    m_flows_start,
    m_flow_small,
    g_n*dheights);

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end LaminarTurbulent_MSLDetailed;
