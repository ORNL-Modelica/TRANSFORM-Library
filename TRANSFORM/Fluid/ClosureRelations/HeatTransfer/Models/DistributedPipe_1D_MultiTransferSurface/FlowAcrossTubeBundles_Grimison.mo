within TRANSFORM.Fluid.ClosureRelations.HeatTransfer.Models.DistributedPipe_1D_MultiTransferSurface;
model FlowAcrossTubeBundles_Grimison

  extends PartialSinglePhase;

  parameter Boolean tubesAligned=false " = false if staggered";
  parameter Real nRows=10 "Not necessary if nRows >= 10";

  input SI.Length D "Diameter of tubes in tube bank" annotation(Dialog(group="Inputs"));
  input SI.Length S_T = 1.0*D "Transverse (within same row) tube pitch" annotation(Dialog(group="Inputs"));
  input SI.Length S_L = 1.0*D "Longitudinal (between rows) tube pitch" annotation(Dialog(group="Inputs"));

protected
  Modelica.Blocks.Sources.RealExpression R_T(y=S_T/D) "Ratio of S_T/D"
    annotation (Placement(transformation(extent={{-90,-54},{-70,-34}})));
  Modelica.Blocks.Sources.RealExpression R_L(y=S_L/D) "Ratio of S_L/D"
    annotation (Placement(transformation(extent={{-90,-26},{-70,-6}})));
  Modelica.Blocks.Tables.CombiTable2D C_1a(table=[0.0,1.25,1.50,2.00,3.00; 1.25,
        0.348,0.275,0.100,0.0633; 1.50,0.367,0.250,0.101,0.0678; 2.00,0.418,0.299,
        0.229,0.198; 3.00,0.290,0.357,0.374,0.286]) "Aligned constant"
    annotation (Placement(transformation(extent={{-40,0},{-20,20}})));
  Modelica.Blocks.Tables.CombiTable2D m_a(table=[0.0,1.25,1.50,2.00,3.00; 1.25,0.592,
        0.608,0.704,0.752; 1.50,0.586,0.620,0.702,0.744; 2.00,0.570,0.602,0.632,
        0.648; 3.00,0.601,0.584,0.581,0.608]) "Aligned constant"
    annotation (Placement(transformation(extent={{-40,-26},{-20,-6}})));
  Modelica.Blocks.Tables.CombiTable2D m_s(table=[0.0,1.25,1.50,2.00,3.00; 0.600,
        0.556,0.558,0.571,0.636; 0.900,0.556,0.558,0.571,0.581; 1.000,0.556,0.558,
        0.568,0.571; 1.125,0.556,0.556,0.565,0.560; 1.250,0.556,0.554,0.556,0.562;
        1.500,0.568,0.562,0.568,0.568; 2.000,0.572,0.568,0.556,0.570; 3.000,0.592,
        0.580,0.562,0.574]) "Staggered contant"
    annotation (Placement(transformation(extent={{-40,-80},{-20,-60}})));
  Modelica.Blocks.Tables.CombiTable2D C_1s(table=[0.0,1.25,1.50,2.00,3.00; 0.600,
        0.518,0.497,0.446,0.213; 0.900,0.518,0.497,0.446,0.401; 1.000,0.518,0.497,
        0.462,0.460; 1.125,0.518,0.501,0.478,0.518; 1.250,0.518,0.505,0.519,0.522;
        1.500,0.451,0.460,0.452,0.488; 2.000,0.404,0.416,0.482,0.449; 3.000,0.310,
        0.356,0.440,0.428]) "Staggered contant"
    annotation (Placement(transformation(extent={{-40,-54},{-20,-34}})));

  // S1:Table 7.6
  Real[10] N_L={1,2,3,4,5,6,7,8,9,10};
  Real[size(N_L, 1)] C_2a={0.64,0.80,0.87,0.90,0.92,0.94,0.96,0.98,0.99,1.0};
  Real[size(N_L, 1)] C_2s={0.68,0.75,0.83,0.89,0.92,0.95,0.97,0.98,0.99,1.0};

  Units.NonDim A "Maximum velocity correction factor";
  SI.Length S_D = (S_L^2+0.25*S_T^2)^(0.5) "Shortest distance between tube centers of neighboring tube rows";
  Units.NonDim C_1 "Interpolated constant";
  Units.NonDim m "Interpolated constant";
  Units.NonDim C_2 "Interpolated constant";
  SI.ReynoldsNumber[nHT] Res_Dmax "Corrected reynolds number based on tube diameter";

equation

  if tubesAligned or S_D >= 0.5*(S_T+D) then
    A = S_T/(S_T - D);
  else
    A = 0.5*S_T/(S_D - D);
  end if;

  if tubesAligned then
    C_1 = C_1a.y;
    m = m_a.y;
    C_2 = Math.interpolate_wLimit(
      N_L,
      C_2a,
      nRows,
      useBound=true);
  else
    C_1 = C_1s.y;
    m = m_s.y;
    C_2 =  Math.interpolate_wLimit(
      N_L,
      C_2s,
      nRows,
      useBound=true);
  end if;

  for i in 1:nHT loop
    Res_Dmax[i] = A*Res[i];
    for j in 1:nSurfaces loop
      Nus[i,j] = 1.13*C_1*C_2*Res_Dmax[i]^m*Prs[i]^(1/3);
      alphas[i,j] =Nus[i, j]*mediaProps[i].lambda/D;
    end for;
  end for;

  connect(R_L.y, C_1a.u1) annotation (Line(points={{-69,-16},{-60,-16},{-60,16},
          {-42,16}}, color={0,0,127}));
  connect(m_a.u1, C_1a.u1) annotation (Line(points={{-42,-10},{-60,-10},{-60,16},
          {-42,16}}, color={0,0,127}));
  connect(m_s.u1, C_1a.u1) annotation (Line(points={{-42,-64},{-60,-64},{-60,16},
          {-42,16}}, color={0,0,127}));
  connect(C_1s.u1, C_1a.u1) annotation (Line(points={{-42,-38},{-60,-38},{-60,16},
          {-42,16}}, color={0,0,127}));
  connect(R_T.y, m_s.u2) annotation (Line(points={{-69,-44},{-56,-44},{-56,-76},
          {-42,-76}}, color={0,0,127}));
  connect(C_1a.u2, m_s.u2) annotation (Line(points={{-42,4},{-56,4},{-56,-76},{-42,
          -76}}, color={0,0,127}));
  connect(m_a.u2, m_s.u2) annotation (Line(points={{-42,-22},{-56,-22},{-56,-76},
          {-42,-76}}, color={0,0,127}));
  connect(C_1s.u2, m_s.u2) annotation (Line(points={{-42,-50},{-56,-50},{-56,-76},
          {-42,-76}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end FlowAcrossTubeBundles_Grimison;
