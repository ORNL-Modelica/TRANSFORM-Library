within TRANSFORM.Fluid.Pipes_Obsolete.ClosureModels.PressureLoss.HeatExchangers.BellDelawareShell.Window.Internal;
function f_LeakFactors

  input SI.ReynoldsNumber Re;
  input Real a;
  input Real b;
  input SI.DynamicViscosity eta;
  input SI.DynamicViscosity eta_w;

  output Real f_zL;
  output Real f_zt;
  output Real df_zL_dm_flow;
  output Real df_zt_dm_flow;
algorithm
  f_zL := (eta_w/eta)^(0.57/((4*a*b/pi-1)*Re)^0.25);
  f_zt :=(eta_w/eta)^0.14;

  df_zL_dm_flow :=0;
  df_zt_dm_flow :=-0.25*0.57*(4*a*b/pi - 1)*Modelica.Math.log(eta/eta_w)*(eta/eta_w)^(0.57/((4*
    a*b/pi - 1)*Re)^(0.25))/((4*a*b/pi - 1)*Re)^(1.25);
end f_LeakFactors;
