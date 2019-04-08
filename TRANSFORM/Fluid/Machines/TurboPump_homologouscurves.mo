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

  Modelica.Blocks.Tables.CombiTable1D HVN(table=[0,-0.332848837; 0.119832814,-0.274709302;
        0.260049238,-0.172965116; 0.405342439,-0.050872093; 0.497628519,0.04505814;
        0.61429704,0.172965116; 0.810524925,0.510174419; 0.928069712,0.699127907;
        0.972634083,0.80377907; 1,0.943313953])
    annotation (Placement(transformation(extent={{50,-74},{70,-54}})));
  Modelica.Blocks.Tables.CombiTable1D HAD(table=[-1,1.547965116; -0.907971236,1.45494186;
        -0.818731223,1.338662791; -0.79123317,1.254360465; -0.680309058,1.315406977;
        -0.564850618,1.359011628; -0.368720096,1.356104651; -0.187819907,1.292151163;
        0,1.19622093])
    annotation (Placement(transformation(extent={{-20,-74},{-40,-54}})));
  Modelica.Blocks.Tables.CombiTable1D HVD(table=[-1,1.547965116; -0.951116891,1.449127907;
        -0.839330422,1.236918605; -0.674662012,1.042151163; -0.480784745,0.882267442;
        -0.305044787,0.792151163; -0.157428786,0.742732558; 0,0.716569767])
    annotation (Placement(transformation(extent={{20,-74},{40,-54}})));
  Modelica.Blocks.Tables.CombiTable1D HAT(table=[0,0.952034884; 0.399904028,1.236918605;
        0.608566541,1.440406977; 0.768547624,1.585755814; 0.865868755,1.699127907;
        1,1.890988372])
    annotation (Placement(transformation(extent={{-20,-100},{-40,-80}})));
  Modelica.Blocks.Tables.CombiTable1D HVR(table=[-1,0.175872093; -0.82939941,-0.07122093;
        -0.644715979,-0.20494186; -0.469226383,-0.3125; -0.230909925,-0.376453488;
        0,-0.332848837])
    annotation (Placement(transformation(extent={{50,-100},{70,-80}})));
  Modelica.Blocks.Tables.CombiTable1D HAR(table=[-1,0.175872093; -0.881516357,0.297965116;
        -0.793722877,0.414244186; -0.711256537,0.492732558; -0.532303605,0.626453488;
        -0.416344442,0.70494186; -0.290231724,0.824127907; -0.179432792,0.876453488;
        0,0.952034884])
    annotation (Placement(transformation(extent={{-50,-100},{-70,-80}})));
  Modelica.Blocks.Tables.CombiTable1D HVT(table=[0,0.716569767; 0.215610048,0.731104651;
        0.32653416,0.792151163; 0.46121481,0.841569767; 0.567980138,0.94622093;
        0.656316068,1.100290698; 0.72526288,1.236918605; 0.882670802,1.536337209;
        0.946040113,1.617732558; 1,1.890988372])
    annotation (Placement(transformation(extent={{20,-100},{40,-80}})));
  Modelica.Blocks.Tables.CombiTable1D HAN(table=[0,1.19622093; 0.102314454,1.171511628;
        0.180990598,1.152616279; 0.298090297,1.143895349; 0.393450261,1.120639535;
        0.613295594,1.103197674; 0.751509124,1.065406977; 0.884645877,1.007267442;
        1,0.943313953])
    annotation (Placement(transformation(extent={{-50,-74},{-70,-54}})));

  Modelica.Blocks.Sources.RealExpression alpha_v(y=alpha/max(1e-6, v))
    annotation (Placement(transformation(extent={{-10,-50},{10,-30}})));
  Modelica.Blocks.Sources.RealExpression v_alpha(y=v/max(1e-6, alpha))
    annotation (Placement(transformation(extent={{10,-64},{-10,-44}})));
  Modelica.Blocks.Tables.CombiTable1D BVN(table=[0,-0.073972603; 0.328887191,0.205479452;
        0.518070185,0.367123288; 0.642820499,0.471232877; 0.824493806,0.671232877;
        0.925568957,0.794520548; 0.990689298,0.909589041; 1,0.95890411])
    annotation (Placement(transformation(extent={{50,-14},{70,6}})));
  Modelica.Blocks.Tables.CombiTable1D BAD(table=[-1,0.821917808; -0.895213666,0.789041096;
        -0.771871418,0.775342466; -0.700616711,0.736986301; -0.639179719,0.720547945;
        -0.610489549,0.610958904; -0.531692408,0.536986301; -0.468405829,0.498630137;
        -0.205490367,0.495890411; 0,0.539726027])
    annotation (Placement(transformation(extent={{-20,-14},{-40,6}})));
  Modelica.Blocks.Tables.CombiTable1D BVD(table=[-1,0.821917808; -0.947890629,0.715068493;
        -0.814626426,0.531506849; -0.628587022,0.430136986; -0.269988539,0.432876712;
        0,0.353424658])
    annotation (Placement(transformation(extent={{20,-14},{40,6}})));
  Modelica.Blocks.Tables.CombiTable1D BAT(table=[0,-0.701369863; 0.360967091,-0.443835616;
        0.565562408,-0.326027397; 0.75800906,-0.224657534; 1,-0.079452055])
    annotation (Placement(transformation(extent={{-20,-40},{-40,-20}})));
  Modelica.Blocks.Tables.CombiTable1D BVR(table=[-1,-1.468493151; -0.891688042,-1.249315068;
        -0.770070403,-1.073972603; -0.607858975,-0.835616438; -0.498259019,-0.665753425;
        -0.392970583,-0.523287671; -0.311815751,-0.4; 0,-0.073972603])
    annotation (Placement(transformation(extent={{50,-40},{70,-20}})));
  Modelica.Blocks.Tables.CombiTable1D BAR(table=[-1,-1.468493151; -0.892834143,-1.345205479;
        -0.603034438,-1.098630137; -0.297855155,-0.898630137; 0,-0.701369863])
    annotation (Placement(transformation(extent={{-50,-40},{-70,-20}})));
  Modelica.Blocks.Tables.CombiTable1D BVT(table=[0,0.353424658; 0.364874748,0.216438356;
        0.611100802,0.150684932; 0.880412596,0.016438356; 1,-0.079452055])
    annotation (Placement(transformation(extent={{20,-40},{40,-20}})));
  Modelica.Blocks.Tables.CombiTable1D BAN(table=[0,0.539726027; 0.222147028,0.608219178;
        0.454467063,0.712328767; 0.698935764,0.832876712; 1,0.95890411])
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
