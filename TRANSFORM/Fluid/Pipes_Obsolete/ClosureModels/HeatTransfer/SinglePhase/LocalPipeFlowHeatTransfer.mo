within TRANSFORM.Fluid.Pipes_Obsolete.ClosureModels.HeatTransfer.SinglePhase;
model LocalPipeFlowHeatTransfer
  "LocalPipeFlowHeatTransfer: Laminar and turbulent forced convection in pipes, local coefficients"
  extends
    TRANSFORM.Fluid.Pipes_Obsolete.ClosureModels.HeatTransfer.BaseClasses.PartialPipeFlowHeatTransfer;
protected
  Real[nHT] Nus_turb "Nusselt number for turbulent flow";
  Real[nHT] Nus_lam "Nusselt number for laminar flow";
  Real Nu_1;
  Real[nHT] Nus_2;
  Real[nHT] Xis;
equation
  Nu_1=3.66;

  for i in 1:nHT loop
   Nus_turb[i]=smooth(0,(Xis[i]/8)*abs(Res[i])*Prs[i]/(1+12.7*(Xis[i]/8)^0.5*(Prs[i]^(2/3)-1))*(1+1/3*(dimensions[i]/lengths[i]/(if m_flows[i]>=0 then (i-0.5) else (nHT-i+0.5)))^(2/3)));
   Xis[i]=(1.8*Modelica.Math.log10(max(1e-10,Res[i]))-1.5)^(-2);
   Nus_lam[i]=(Nu_1^3+0.7^3+(Nus_2[i]-0.7)^3)^(1/3);
   Nus_2[i]=smooth(0,1.077*(abs(Res[i])*Prs[i]*dimensions[i]/lengths[i]/(if m_flows[i]>=0 then (i-0.5) else (nHT-i+0.5)))^(1/3));
   Nus[i]=Modelica.Media.Air.MoistAir.Utilities.spliceFunction(Nus_turb[i], Nus_lam[i], Res[i]-6150, 3850);
   alphas[i] = TRANSFORM.Utilities.CharacteristicNumbers.HeatTransferCoeffient(
       Nu=Nus[i],
       D=dimensions[i],
       lambda=lambdas[i]);
  end for;
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
end LocalPipeFlowHeatTransfer;
