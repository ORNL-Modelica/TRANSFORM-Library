within TRANSFORM.Fluid.Machines;
model TurboPump_homologouscurves

  extends BaseClasses.PartialTurboPump;

extends TRANSFORM.Icons.UnderConstruction;

  SIadd.NonDim v;
  SIadd.NonDim alpha;
  SIadd.NonDim h;
  SIadd.NonDim beta;

  final parameter SI.Torque tau_nominal=Modelica.Constants.g_n*d_nominal*
      head_nominal*V_flow_nominal/(eta_nominal*omega_nominal)
    "Rated or design torque";
  final parameter SI.AngularVelocity omega_nominal=N_nominal*2*Modelica.Constants.pi
      /60;
  parameter SI.Efficiency eta_nominal=0.8 "Rated or design efficiency";

  replaceable model
    HomoSet =
      TRANSFORM.Fluid.Machines.BaseClasses.PumpCharacteristics.HomologousSets.Semiscale
                                                                                                     constrainedby
    TRANSFORM.Fluid.Machines.BaseClasses.PumpCharacteristics.HomologousSets.PartialHomoSet
                                                                                                                                                                                                            annotation(choicesAllMatching=true);

    HomoSet homoSet;

  Modelica.Blocks.Tables.CombiTable1D HVN(table=homoSet.table_BAN)
    annotation (Placement(transformation(extent={{50,-74},{70,-54}})));
  Modelica.Blocks.Tables.CombiTable1D HAD(table=homoSet.table_HAD)
    annotation (Placement(transformation(extent={{-20,-74},{-40,-54}})));
  Modelica.Blocks.Tables.CombiTable1D HVD(table=homoSet.table_HVD)
    annotation (Placement(transformation(extent={{20,-74},{40,-54}})));
  Modelica.Blocks.Tables.CombiTable1D HAT(table=homoSet.table_HAT)
    annotation (Placement(transformation(extent={{-20,-100},{-40,-80}})));
  Modelica.Blocks.Tables.CombiTable1D HVR(table=homoSet.table_HVR)
    annotation (Placement(transformation(extent={{50,-100},{70,-80}})));
  Modelica.Blocks.Tables.CombiTable1D HAR(table=homoSet.table_HAR)
    annotation (Placement(transformation(extent={{-50,-100},{-70,-80}})));
  Modelica.Blocks.Tables.CombiTable1D HVT(table=homoSet.table_HVT)
    annotation (Placement(transformation(extent={{20,-100},{40,-80}})));
  Modelica.Blocks.Tables.CombiTable1D HAN(table=homoSet.table_HAN)
    annotation (Placement(transformation(extent={{-50,-74},{-70,-54}})));

  Modelica.Blocks.Sources.RealExpression alpha_v(y=alpha/max(1e-6, v))
    annotation (Placement(transformation(extent={{-10,-50},{10,-30}})));
  Modelica.Blocks.Sources.RealExpression v_alpha(y=v/max(1e-6, alpha))
    annotation (Placement(transformation(extent={{10,-64},{-10,-44}})));
  Modelica.Blocks.Tables.CombiTable1D BVN(table=homoSet.table_BVN)
    annotation (Placement(transformation(extent={{50,-14},{70,6}})));
  Modelica.Blocks.Tables.CombiTable1D BAD(table=homoSet.table_BAD)
    annotation (Placement(transformation(extent={{-20,-14},{-40,6}})));
  Modelica.Blocks.Tables.CombiTable1D BVD(table=homoSet.table_BVD)
    annotation (Placement(transformation(extent={{20,-14},{40,6}})));
  Modelica.Blocks.Tables.CombiTable1D BAT(table=homoSet.table_BAT)
    annotation (Placement(transformation(extent={{-20,-40},{-40,-20}})));
  Modelica.Blocks.Tables.CombiTable1D BVR(table=homoSet.table_BVR)
    annotation (Placement(transformation(extent={{50,-40},{70,-20}})));
  Modelica.Blocks.Tables.CombiTable1D BAR(table=homoSet.table_BAR)
    annotation (Placement(transformation(extent={{-50,-40},{-70,-20}})));
  Modelica.Blocks.Tables.CombiTable1D BVT(table=homoSet.table_BVT)
    annotation (Placement(transformation(extent={{20,-40},{40,-20}})));
  Modelica.Blocks.Tables.CombiTable1D BAN(table=homoSet.table_BAN)
    annotation (Placement(transformation(extent={{-50,-14},{-70,6}})));

equation

  v = V_flow/V_flow_nominal;
  alpha = omega/omega_nominal;
  h = head/head_nominal;
  beta = tau/tau_nominal;

  if alpha > 0 and v >= 0 and v/alpha <= 1 then
    h/alpha^2 = HAN.y[1];
    beta/alpha^2 = BAN.y[1];
  elseif alpha >= 0 and v >= 0 and v/alpha > 1 then
    h/v^2 = HVN.y[1];
    beta/v^2 = BVN.y[1];
  elseif alpha > 0 and v < 0 and v/alpha >= -1 then
    h/alpha^2 = HAD.y[1];
    beta/alpha^2 = BAD.y[1];
  elseif alpha >= 0 and v < 0 and v/alpha < -1 then
    h/v^2 = HVD.y[1];
    beta/v^2 = BVD.y[1];
  elseif alpha < 0 and v <= 0 and v/alpha <= 1 then
    h/alpha^2 = HAT.y[1];
    beta/alpha^2 = BAT.y[1];
  elseif alpha < 0 and v <= 0 and v/alpha > 1 then
    h/v^2 = HVT.y[1];
    beta/v^2 = BVT.y[1];
  elseif alpha < 0 and v > 0 and v/alpha >= -1 then
    h/alpha^2 = HAR.y[1];
    beta/alpha^2 = BAR.y[1];
  elseif alpha < 0 and v > 0 and v/alpha < -1 then
    h/v^2 = HVR.y[1];
    beta/v^2 = BVR.y[1];
  else
    h = 0; //Dummy
    beta = 0; //Dummy
    assert(false,"Unknown condition");
  end if;

  connect(alpha_v.y, HVD.u[1])
    annotation (Line(points={{11,-40},{14,-40},{14,-64},{18,-64}},
                                                 color={0,0,127}));
  connect(v_alpha.y, HAT.u[1])
    annotation (Line(points={{-11,-54},{-14,-54},{-14,-90},{-18,-90}},
                                                   color={0,0,127}));
  connect(v_alpha.y, HAD.u[1]) annotation (Line(points={{-11,-54},{-14,-54},{-14,
          -64},{-18,-64}}, color={0,0,127}));
  connect(v_alpha.y, HAR.u[1]) annotation (Line(points={{-11,-54},{-14,-54},{-14,
          -46},{-44,-46},{-44,-90},{-48,-90}}, color={0,0,127}));
  connect(v_alpha.y, HAN.u[1]) annotation (Line(points={{-11,-54},{-14,-54},{-14,
          -46},{-44,-46},{-44,-64},{-48,-64}}, color={0,0,127}));
  connect(alpha_v.y, HVT.u[1]) annotation (Line(points={{11,-40},{14,-40},{14,-90},
          {18,-90}}, color={0,0,127}));
  connect(alpha_v.y, HVR.u[1]) annotation (Line(points={{11,-40},{14,-40},{14,-46},
          {44,-46},{44,-90},{48,-90}}, color={0,0,127}));
  connect(alpha_v.y, HVN.u[1]) annotation (Line(points={{11,-40},{14,-40},{14,-46},
          {44,-46},{44,-64},{48,-64}}, color={0,0,127}));
  connect(v_alpha.y, BAT.u[1]) annotation (Line(points={{-11,-54},{-14,-54},{-14,
          -30},{-18,-30}}, color={0,0,127}));
  connect(v_alpha.y, BAD.u[1]) annotation (Line(points={{-11,-54},{-14,-54},{-14,
          -4},{-18,-4}}, color={0,0,127}));
  connect(v_alpha.y, BAR.u[1]) annotation (Line(points={{-11,-54},{-14,-54},{-14,
          -46},{-44,-46},{-44,-30},{-48,-30}}, color={0,0,127}));
  connect(v_alpha.y, BAN.u[1]) annotation (Line(points={{-11,-54},{-14,-54},{-14,
          -46},{-44,-46},{-44,-4},{-48,-4}}, color={0,0,127}));
  connect(alpha_v.y, BVD.u[1]) annotation (Line(points={{11,-40},{14,-40},{14,-4},
          {18,-4}}, color={0,0,127}));
  connect(alpha_v.y, BVT.u[1]) annotation (Line(points={{11,-40},{14,-40},{14,-30},
          {18,-30}}, color={0,0,127}));
  connect(alpha_v.y, BVR.u[1]) annotation (Line(points={{11,-40},{14,-40},{14,-46},
          {44,-46},{44,-30},{48,-30}}, color={0,0,127}));
  connect(alpha_v.y, BVN.u[1]) annotation (Line(points={{11,-40},{14,-40},{14,-46},
          {44,-46},{44,-4},{48,-4}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end TurboPump_homologouscurves;
