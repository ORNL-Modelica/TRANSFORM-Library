within TRANSFORM.Fluid.ClosureRelations.PressureLoss.Functions.HeatExchangers.BellDelawareSTHX_ShellSide.Internal;
function f_L_baffact
  input Real gamma;
  input SI.Length D_l;
  input SI.Length D_i;
  input SI.Length d_B;
  input SI.Length d_o;
  input Real n_T;
  input Real n_W;
  input SI.Area A_E;
  output Real f_L;
protected
  SI.Area A_GSB;
  SI.Area A_GTB;
  SI.Area A_SG;
  Real R_L;
  Real R_M;
  Real r;
algorithm
A_GSB :=pi/4*(D_i^2 - D_l^2)*(360 - gamma)/360;
A_GTB :=(n_T - n_W/2)*pi*(d_B^2 - d_o^2)/4;
A_SG :=A_GTB + A_GSB;
if A_SG < 1e-6 then
  f_L :=1.0;
else
  R_L :=A_SG/A_E;
  R_M :=A_GSB/A_SG;
  r :=-0.15*(1 + R_M) + 0.8;
  f_L := Modelica.Math.exp(-1.33*(1 + R_M)*R_L^r);
end if;
end f_L_baffact;
