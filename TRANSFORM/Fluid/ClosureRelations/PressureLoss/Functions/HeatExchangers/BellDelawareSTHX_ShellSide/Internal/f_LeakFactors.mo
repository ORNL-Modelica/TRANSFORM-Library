within TRANSFORM.Fluid.ClosureRelations.PressureLoss.Functions.HeatExchangers.BellDelawareSTHX_ShellSide.Internal;
function f_LeakFactors

  input SI.ReynoldsNumber Re;
  input Real a;
  input Real b;
  input SI.DynamicViscosity mu;
  input SI.DynamicViscosity mu_w;

  output Real f_zL;
  output Real f_zt;
  output Real df_zL_dm_flow;
  output Real df_zt_dm_flow;
algorithm
  f_zL := (mu_w/mu)^(0.57/((4*a*b/pi-1)*Re)^0.25);
  f_zt :=(mu_w/mu)^0.14;

  df_zL_dm_flow :=-0.25*0.57*(4*a*b/pi - 1)*Modelica.Math.log(mu/mu_w)*(mu/mu_w)^(0.57/((4*
    a*b/pi - 1)*Re)^(0.25))/((4*a*b/pi - 1)*Re)^(1.25);
  df_zt_dm_flow :=0;

end f_LeakFactors;
