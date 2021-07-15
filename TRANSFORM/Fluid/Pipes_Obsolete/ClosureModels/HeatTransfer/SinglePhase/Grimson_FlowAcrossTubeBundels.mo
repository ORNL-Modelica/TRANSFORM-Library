within TRANSFORM.Fluid.Pipes_Obsolete.ClosureModels.HeatTransfer.SinglePhase;
model Grimson_FlowAcrossTubeBundels "Grimson: Flow Across Tube Bundels"
  extends
    TRANSFORM.Fluid.Pipes_Obsolete.ClosureModels.HeatTransfer.BaseClasses.PartialPipeFlowHeatTransfer;
  parameter Boolean tubesAligned=false "true if aligned else staggered";
  parameter SI.Length D "Diameter of tubes in tube bank";
  parameter SI.Length S_T "Transverse (within same row) tube pitch";
  parameter SI.Length S_L "Longitudinal (between rows) tube pitch";
  Modelica.Blocks.Sources.RealExpression R_T(y=S_T/D) "Ratio of S_T/D"
    annotation (Placement(transformation(extent={{-90,-54},{-70,-34}})));
  Modelica.Blocks.Sources.RealExpression R_L(y=S_L/D) "Ratio of S_L/D"
    annotation (Placement(transformation(extent={{-90,-26},{-70,-6}})));
  Modelica.Blocks.Tables.CombiTable2Ds C_1a(table=[0.0,1.25,1.50,2.00,
        3.00; 1.25,0.348,0.275,0.100,0.0633; 1.50,0.367,0.250,0.101,
        0.0678; 2.00,0.418,0.299,0.229,0.198; 3.00,0.290,0.357,0.374,
        0.286]) "Aligned constant" annotation (Placement(
        transformation(extent={{-40,0},{-20,20}})));
  Modelica.Blocks.Tables.CombiTable2Ds m_a(table=[0.0,1.25,1.50,2.00,
        3.00; 1.25,0.592,0.608,0.704,0.752; 1.50,0.586,0.620,0.702,0.744;
        2.00,0.570,0.602,0.632,0.648; 3.00,0.601,0.584,0.581,0.608])
    "Aligned constant" annotation (Placement(transformation(extent={
            {-40,-26},{-20,-6}})));
  Modelica.Blocks.Tables.CombiTable2Ds m_s(table=[0.0,1.25,1.50,2.00,
        3.00; 0.600,0.556,0.558,0.571,0.636; 0.900,0.556,0.558,0.571,
        0.581; 1.000,0.556,0.558,0.568,0.571; 1.125,0.556,0.556,0.565,
        0.560; 1.250,0.556,0.554,0.556,0.562; 1.500,0.568,0.562,0.568,
        0.568; 2.000,0.572,0.568,0.556,0.570; 3.000,0.592,0.580,0.562,
        0.574]) "Staggered contant" annotation (Placement(
        transformation(extent={{-40,-80},{-20,-60}})));
  Modelica.Blocks.Tables.CombiTable2Ds C_1s(table=[0.0,1.25,1.50,2.00,
        3.00; 0.600,0.518,0.497,0.446,0.213; 0.900,0.518,0.497,0.446,
        0.401; 1.000,0.518,0.497,0.462,0.460; 1.125,0.518,0.501,0.478,
        0.518; 1.250,0.518,0.505,0.519,0.522; 1.500,0.451,0.460,0.452,
        0.488; 2.000,0.404,0.416,0.482,0.449; 3.000,0.310,0.356,0.440,
        0.428]) "Staggered contant" annotation (Placement(
        transformation(extent={{-40,-54},{-20,-34}})));
protected
  Units.NonDim A "Maximum velocity correction factor";
  SI.Length S_D = (S_L^2+0.25*S_T^2)^(0.5) "Shortest distance between tube centers of neighboring tube rows";
  Units.NonDim C_1 "Interpolated constant";
  Units.NonDim m "Interpolated constant";
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
  else
    C_1 = C_1s.y;
    m = m_s.y;
  end if;
  for i in 1:nHT loop
    Res_Dmax[i] = A*Res[i]*D/dimensions[i];
    Nus[i] = 1.13*C_1*Res_Dmax[i]^m*Prs[i]^(1/3);
    alphas[i] = TRANSFORM.Utilities.CharacteristicNumbers.HeatTransferCoeffient(
       Nu=Nus[i],
       D=D,
       lambda=lambdas[i]);
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
  annotation (Documentation(info="<html>
<p>
Heat transfer model for laminar and turbulent flow in pipes. Range of validity:
</p>
<ul>
<li>fully developed pipe flow</li>
<li>forced convection</li>
<li>one phase Newtonian fluid</li>
<li>(spatial) constant wall temperature in the laminar region</li>
<li>0 &le; Re &le; 1e6, 0.6 &le; Pr &le; 100, d/L &le; 1</li>
<li>The correlation holds for non-circular pipes only in the turbulent region. Use diameter=4*crossArea/perimeter as characteristic length.</li>
</ul>
<p>
The correlation takes into account the spatial position along the pipe flow, which changes discontinuously at flow reversal. However, the heat transfer coefficient itself is continuous around zero flow rate, but not its derivative.
</p>
<h4>References</h4>
<dl><dt>Verein Deutscher Ingenieure (1997):</dt>
    <dd><b>VDI W&auml;rmeatlas</b>.
         Springer Verlag, Ed. 8, 1997.</dd>
</dl>
</html>"));
end Grimson_FlowAcrossTubeBundels;
