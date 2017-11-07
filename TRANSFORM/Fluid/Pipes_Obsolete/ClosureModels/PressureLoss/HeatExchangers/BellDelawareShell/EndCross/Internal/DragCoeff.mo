within TRANSFORM.Fluid.Pipes_Obsolete.ClosureModels.PressureLoss.HeatExchangers.BellDelawareShell.EndCross.Internal;
function DragCoeff
   import Modelica.Math.exp "Exponential function";

   input Boolean toggleStaggered;
   input SI.ReynoldsNumber Re;
   input Real a;
   input Real b;
   input Real c;
   input Real f_zL;
   input Real f_zt;
   input Real df_zL_dm_flow;
   input Real df_zt_dm_flow;
   input Real aux1;

   output Real epsilon;
   output Real depsilon_dm_flow;

protected
  Real f_a1v, f_atv;
  Real f_a1f, f_atf;
  Real epsilon_lam, epsilon_turb;
  Real depsilon_lam_dm_flow, depsilon_turb_dm_flow;
  Real dexp_dm_flow;
algorithm
  if toggleStaggered then

    if b >= 0.5*(2*a+1)^0.5 then
      f_a1v := 280*pi*((b^0.5-0.6)^2+0.75)/((4*a*b-pi)*a^1.6);
    else
      f_a1v := 280*pi*((b^0.5-0.6)^2+0.75)/((4*a*b-pi)*c^1.6);
    end if;

    epsilon_lam :=f_a1v/Re;

    f_atv :=2.5 + 1.2/(a - 0.85)^1.08 + 0.4*(b/a - 1)^3 - 0.01*(a/b - 1)^3;

    epsilon_turb :=f_atv/Re^0.25;

    epsilon :=epsilon_lam*f_zL + epsilon_turb*f_zt*(1 - exp(-(Re + 200)/1000));

    depsilon_lam_dm_flow := -f_a1v*aux1/(Re*Re);
    depsilon_turb_dm_flow := -0.25*f_atv*aux1/Re^1.25;
    dexp_dm_flow :=aux1/1000*exp(-(Re + 200)/1000);

    depsilon_dm_flow :=depsilon_lam_dm_flow*f_zL + epsilon_lam*df_zL_dm_flow +
      depsilon_turb_dm_flow*f_zt*(1 - exp(-(Re + 200)/1000)) + epsilon_turb*
      df_zt_dm_flow*(1 - exp(-(Re + 200)/1000)) + epsilon_turb*f_zt*
      dexp_dm_flow;
  else

    f_a1f :=280*pi*((b^0.5 - 0.6)^2 + 0.75)/((4*a*b - pi)*a^1.6);

    epsilon_lam :=f_a1f/Re;

    f_atf :=(0.22 + 1.2*(1 - 0.94/b)^0.6/(a - 0.85)^1.3)*10^(0.47*(b/a - 1.5))
     + 0.03*(a - 1)*(b - 1);

    epsilon_turb :=f_atf/Re^(0.1*b/a);

    epsilon :=epsilon_lam*f_zL + epsilon_turb*f_zt*(1 - exp(-(Re + 1000)/2000));

    depsilon_lam_dm_flow := -f_a1f*aux1/(Re*Re);
    depsilon_turb_dm_flow := -(0.1*b/a)*f_atf*aux1/Re^(0.1*b/a+1);
    dexp_dm_flow :=aux1/1000*exp(-(Re + 1000)/2000);

    depsilon_dm_flow :=depsilon_lam_dm_flow*f_zL + epsilon_lam*df_zL_dm_flow +
      depsilon_turb_dm_flow*f_zt*(1 - exp(-(Re + 200)/1000)) + epsilon_turb*
      df_zt_dm_flow*(1 - exp(-(Re + 200)/1000)) + epsilon_turb*f_zt*
      dexp_dm_flow;
  end if;

end DragCoeff;
