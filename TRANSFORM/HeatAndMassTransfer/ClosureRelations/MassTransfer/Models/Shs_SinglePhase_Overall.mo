within TRANSFORM.HeatAndMassTransfer.ClosureRelations.MassTransfer.Models;
model Shs_SinglePhase_Overall "Specify Shs | Single Phase | Overall"

  extends PartialSinglePhase;

  input SI.SchmidtNumber Shs_lam[nMT,nC]={
      Functions.SinglePhase.InternalFlow.Sh_Laminar_Local_Developed_Circular_SiederTate(
      Res[i],
      Scs[i, j],
      sum(dlengths),
      dimensions[i]) for i in 1:nMT,j in 1:nC} "Laminar Schmidt number"
    annotation (Dialog(group="Inputs"));

  input SI.SchmidtNumber Shs_turb[nMT,nC]={
      Functions.SinglePhase.InternalFlow.Sh_Turbulent_Local_Developed_Circular_DittusBoelter(
       Res[i], Scs[i, j]) for i in 1:nMT,j in 1:nC}
    "Turbulent Schmidt number" annotation (Dialog(group="Inputs"));

  input SI.Length[nMT] L_char=dimensions
    "Characteristic dimension for calculation of alphaM"
    annotation (Dialog(group="Inputs"));

equation

  for i in 1:nMT loop
    Shs[i, :] = TRANSFORM.Math.spliceTanh(
      Shs_turb[i, :],
      Shs_lam[i, :],
      Res[i] - Re_center,
      Re_width);
  end for;

  for i in 1:nMT loop
    alphasM[i, :] =Shs[i, :] .* Ds_ab[i, :] ./ L_char[i];
  end for;

  annotation (Documentation(info="<html>
<p>Local heat transfer model for fully developed laminar and turbulent flow in circular pipes.</p>
<ul>
<li>The laminar region has been shown to be significantly impacted by the duct shape and wall boundary conditions but not the surface roughness.</li>
<li>The turbulent region has been shown to be highly depenedent of surface roughness but not impacted by duct shape or wall boundary conditions.</li>
<li>The characteristic dimension is defined as dimension = 4*crossArea/perimeter where &QUOT;crossArea&QUOT; is the cross sectional flow area and &QUOT;perimeter&QUOT; is the wetted perimeter.</li>
</ul>
<p>Range of validity: </p>
<ul>
<li>fully developed pipe flow</li>
<li>forced convection</li>
<li>one phase Newtonian fluid</li>
<li>constant wall temperature or constant heat flux in laminar region</li>
<li>0 &le; Re &le; 1e6, 0.1 &le; Pr &le; 1000, d/L &le; 1</li>
<li>Applies only to circular pipes in the laminar region but can approximate other with the characteristic dimension. Turbulent region is independent of pipe shape.</li>
</ul>
<p>The correlation takes into account the spatial position along the pipe flow, which changes discontinuously at flow reversal. However, the heat transfer coefficient itself is continuous around zero flow rate, but not its derivative. </p>
<h4>References</h4>
<ol>
<li>VDI Heat Atlas 2E, 2010.</li>
<li>Heat Transfer. Nellis and Klein. 2009</li>
</ol>
</html>"));
end Shs_SinglePhase_Overall;
