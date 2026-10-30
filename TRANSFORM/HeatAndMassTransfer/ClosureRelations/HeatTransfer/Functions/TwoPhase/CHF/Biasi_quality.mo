within TRANSFORM.HeatAndMassTransfer.ClosureRelations.HeatTransfer.Functions.TwoPhase.CHF;
function Biasi_quality
  input SIadd.MassFlux G "Mass flux";
  input SI.Pressure p "Pressure";
  input SI.Length L_B "Length of pipe in two phase region (boiling length)";
  input SI.Length D_htd "Heated diameter";
  input SI.SpecificEnthalpy h_lv "Latent heat of vaporization";
  input SI.Length perimeter = Modelica.Constants.pi*D_htd "Wetted perimeter";
  input SI.Length perimeter_htd = Modelica.Constants.pi*D_htd "Heated perimeter";
  input SIadd.NonDim R_f = 1 "Radial peaking factor";
  output SI.HeatFlux x_CHF "Critical heat flux prediction";
protected
  Real p_bar = p/100000 "[Pa] to [bar]";
  Real fp = 0.7249 + 0.099*p_bar*exp(-0.032*p_bar);
  Real hp = -1.159 + 0.149*p_bar*exp(-0.019*p_bar) + 8.99*p_bar/(10 + p_bar^2);
 //CISE-GE correlation
  Real A1 = 1.0;
  Real B1 = (1.048*10^(-8)*G^(1.6)*D_htd^(1.4)*h_lv)/hp;
  Real A2 = fp/G^(1/6);
  Real B2 = 5.707*10^(-8)*G^(7/6)*D_htd^(1.4)*h_lv;
  Real x_CHF_1;
  Real x_CHF_2;
algorithm
  if L_B > 0 then
      x_CHF_1 :=A1*L_B/(B1 + L_B)*(perimeter_htd/perimeter)*sqrt(1/R_f);
      x_CHF_2 :=A2*L_B/(B2 + L_B)*(perimeter_htd/perimeter)*sqrt(1/R_f);
  else
      x_CHF_1 :=0.75;
      x_CHF_2 :=0.75;
  end if;
  // Biasi Prediction is the maximum of the two quality regions
  x_CHF :=max(x_CHF_1, x_CHF_2);
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
end Biasi_quality;
