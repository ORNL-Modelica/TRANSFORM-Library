within TRANSFORM.HeatAndMassTransfer.ClosureRelations.HeatTransfer.Functions.TwoPhase.CHF;
function EPRI_flux

  input SI.HeatFlux q_flux "Local heat flux";
  input SI.HeatFlux q_avg "Average heat flux";
  input Real x_th "Local thermodynamic quality";
  input SIadd.MassFlux G "Mass flux";
  input Real x_th_in "Thermodynamic quality at inlet";
  input SI.Pressure P_red "Reduced pressure (i.e., P/P_crit)";
  input SIadd.NonDim K_g=1.0 "Grid spacer pressure loss coefficient";
  input Boolean cwall=false "=true to use cold wall correction factor";
  input Boolean nu=false "=true to use nonuniform heat flux correction factor";

  output SI.HeatFlux CHF "Critical heat flux prediction";

protected
  Real P[8]={0.5328,0.1212,1.6151,1.4066,-0.3040,0.4843,-0.3285,-2.0749} "EPRI Regressed Constants";

  // Convert from SI to English Units
  Real G_en=abs(G)*7.3733812*10^(-4) "[kg/m^2-s] to [Mlbm/ft^2-hr]";

  // EPRI Defined Variables
  Real A=P[1]*P_red^(P[2])*G_en^(P[5] + P[7]*P_red);
  Real C=P[3]*P_red^(P[4])*G_en^(P[6] + P[8]*P_red);

  // Grid spacer effect correction factor
  Real F_g=1.3 - 0.3*K_g;

  // Cold wall effect correction factors
  Real F_A=if cwall then G_en^(0.1) else 1.0;
  Real F_C=if cwall then 1.183*G_en^(0.1) else 1.0;

  // Nonuniform effect correction factor
  Real Y = q_avg/max(0.0001,q_flux);
  Real F_nu = if nu then 1 + (1-Y)/(1+G_en) else 0;

algorithm

  CHF :=(A*F_A - x_th_in)/(C*F_g*F_C*F_nu + (x_th - x_th_in)/max(0.0001,q_flux))/(3.169983306e-4) "[BTU/ft^2-hr] to [kW/m^2]";

  annotation (Documentation(info="<html>
<p>Prediction of the critical heat flux using the EPRI correlation as presented in 1982 EPRI Parametric Study of CHF Data Vol. 1-3</p>
<p><br>      &quot;Outputs&quot;</p>
<p>CHF_EPRI =&gt; Critical heat flux predicted by EPRI              [kW/m^2]</p>
<p>CHF_EPRI_Avg =&gt; Average heat flux based on total heater power [kW/m^2]</p>
<p>L_EPRI =&gt; Location of CHF event                               [m]</p>
<p>x_EPRI_local =&gt; quality at location of predicted CHF          [-]</p>
<p>      &quot;Inputs&quot;</p>
<p>G =&gt; mass flux per subchannel                     [kg/m^2s]</p>
<p>A_heated =&gt; total heated area per heater element  [m^2]</p>
<p>A_test =&gt; flow area per subchannel                [m^2]</p>
<p>L_heated =&gt; heated length per heater element      [m]</p>
<p>x_in =&gt; inlet quality                             [-]</p>
<p>h_fg =&gt; latent heat of vaporization               [J/kg]</p>
<p>Pr =&gt; reduced pressure                            [-]</p>
<p>K_g =&gt; grid spacer pressure loss coefficient [-]. Set default K_g = 1.</p>
<p>cwall toggels cold wall effect correction factor -&gt; 1/0 = on/off</p>
<p>nu toggels nonuniform heat flux effect correction factor -&gt; 1/0 = on/off</p>
<p>toggle_vis =&gt; toggle visibility of the convergence plot. &apos;on&apos;/&apos;off&apos;</p>
</html>"));
end EPRI_flux;
