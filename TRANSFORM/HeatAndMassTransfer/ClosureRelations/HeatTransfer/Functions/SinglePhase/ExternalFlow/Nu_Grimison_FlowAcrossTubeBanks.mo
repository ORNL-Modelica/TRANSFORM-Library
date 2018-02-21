within TRANSFORM.HeatAndMassTransfer.ClosureRelations.HeatTransfer.Functions.SinglePhase.ExternalFlow;
function Nu_Grimison_FlowAcrossTubeBanks

  input SI.ReynoldsNumber Re "Reynolds Number";
  input SI.PrandtlNumber Pr "Prandtl Number";
  input SI.Length D "Tube diameter";
  input SI.Length S_T "Transverse (within same row) tube pitch";
  input SI.Length S_L "Longitudinal (between rows) tube pitch";
  input Real nRows=10 "Not necessary if nRows >= 10";
  input Boolean tubesAligned=false " = false if staggered";

  output SI.NusseltNumber Nu "Nusselt number - Eq. 7.60 and 7.61";

protected
  Units.NonDim A "Maximum velocity correction factor - S1:Eq. 7.62 or 7.63";
  SI.Length S_D=(S_L^2 + 0.25*S_T^2)^(0.5)
    "Shortest distance between tube centers of neighboring tube rows - S1:No Eq. number but between Eq. 7.62 and 7.63";
  Units.NonDim C_1 "Interpolated constant - S1:Table 7.5";
  Units.NonDim m "Interpolated constant - S1:Table 7.5";
  Units.NonDim C_2 "Tube rows correction coefficient - S1:Table 7.6";
  SI.ReynoldsNumber Re_Dmax "Corrected reynolds number based on tube diameter - S1:Eq. 7.59";

  // S1:Table 7.5
  Real[4] ST_D={1.25,1.50,2.00,3.00};
  Real[4] SL_Da={1.25,1.50,2.00,3.00};
  Real[8] SL_Ds={0.60,0.90,1.00,1.125,1.25,1.50,2.00,3.00};

  Real[size(SL_Da, 1),size(ST_D, 1)] C_1a=[0.348,0.275,0.1,0.0633; 0.367,0.25,0.101,
      0.0678; 0.418,0.299,0.229,0.198; 0.29,0.357,0.374,0.286];

  Real[size(SL_Da, 1),size(ST_D, 1)] m_a=[0.592,0.608,0.704,0.752; 0.586,0.62,0.702,
      0.744; 0.57,0.602,0.632,0.648; 0.601,0.584,0.581,0.608];

  Real[size(SL_Ds, 1),size(ST_D, 1)] C_1s=[0.518,0.497,0.446,0.213; 0.518,0.497,
      0.446,0.401; 0.518,0.497,0.462,0.46; 0.518,0.501,0.478,0.518; 0.518,0.505,
      0.519,0.522; 0.451,0.46,0.452,0.488; 0.404,0.416,0.482,0.449; 0.31,0.356,0.44,
      0.428];

  Real[size(SL_Ds, 1),size(ST_D, 1)] m_s=[0.556,0.558,0.571,0.636; 0.556,0.558,0.571,
      0.581; 0.556,0.558,0.568,0.571; 0.556,0.556,0.565,0.56; 0.556,0.554,0.556,
      0.562; 0.568,0.562,0.568,0.568; 0.572,0.568,0.556,0.57; 0.592,0.58,0.562,0.574];

  // S1:Table 7.6
  Real[10] N_L={1,2,3,4,5,6,7,8,9,10};
  Real[size(N_L, 1)] C_2a={0.64,0.80,0.87,0.90,0.92,0.94,0.96,0.98,0.99,1.0};
  Real[size(N_L, 1)] C_2s={0.68,0.75,0.83,0.89,0.92,0.95,0.97,0.98,0.99,1.0};

algorithm

  if tubesAligned then
    C_1 := TRANSFORM.Math.interpolate2D(
      SL_Da,
      ST_D,
      C_1a,
      S_L/D,
      S_T/D,
      true);
    m := TRANSFORM.Math.interpolate2D(
      SL_Da,
      ST_D,
      m_a,
      S_L/D,
      S_T/D,
      true);
    C_2 := Math.interpolate_wLimit(
      N_L,
      C_2a,
      nRows,
      useBound=true);
  else
    C_1 := TRANSFORM.Math.interpolate2D(
      SL_Ds,
      ST_D,
      C_1s,
      S_L/D,
      S_T/D,
      true);
    m := TRANSFORM.Math.interpolate2D(
      SL_Ds,
      ST_D,
      m_s,
      S_L/D,
      S_T/D,
      true);
    C_2 := Math.interpolate_wLimit(
      N_L,
      C_2s,
      nRows,
      useBound=true);
  end if;

  if tubesAligned or S_D >= 0.5*(S_T + D) then
    A := S_T/(S_T - D);
  else
    A := 0.5*S_T/(S_D - D);
  end if;

  Re_Dmax := A*Re;
  Nu := 1.13*C_1*C_2*Re_Dmax^m*Pr^(1/3);

  annotation (Documentation(info="<html>
<p>The Grimison average Nusselt number correlation for flow across tube bundles.</p>
<p>Range of validity:</p>
<ul>
<li>2000 &LT; Re_Dmax &LT; 40e3</li>
<li>Pr &GT; 0.7</li>
</ul>
<p><br><img src=\"modelica://TRANSFORM/Resources/Images/Information/Grimison_tubeArrangement.jpg\"/></p>
<h4>References</h4>
<ol>
<li>Incropera &AMP; DeWitt, Fundamentals of HEat and Mass Transfer 6E 2007.</li>
</ol>
</html>"));
end Nu_Grimison_FlowAcrossTubeBanks;
