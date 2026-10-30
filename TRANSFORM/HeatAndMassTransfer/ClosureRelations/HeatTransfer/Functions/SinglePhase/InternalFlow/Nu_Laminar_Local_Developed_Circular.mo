within TRANSFORM.HeatAndMassTransfer.ClosureRelations.HeatTransfer.Functions.SinglePhase.InternalFlow;
function Nu_Laminar_Local_Developed_Circular
  "Nusselt Number | Single phase | Laminar | Local | Circular | Internal | Fully Developed"
  input SI.ReynoldsNumber Re "Reynolds Number";
  input SI.PrandtlNumber Pr "Prandtl Number";
  input SI.Length x "Position of local heat transfer calculation";
  input SI.Length dimension
    "Characteristic dimension (e.g., hydraulic diameter)";
  input Boolean constantTwall=true
    "= true for constant wall temperature correlation else constant heat flux";
  output SI.NusseltNumber Nu "Nusselt number";
protected
  Real Nu_T1=3.66 "S1:Eq. G1-1";
  Real Nu_T2 "S1:Eq. G1-2";
  Real Nu_H1=4.354 "S1:Eq. G1-14";
  Real Nu_H2 "S1:Eq. G1-15";
  SI.NusseltNumber Nu_T
    "Constant wall temperature Nusselt number - S1:Eq. G1-3";
  SI.NusseltNumber Nu_H
    "Constant heat flux Nusselt number  - S1:Eq. G1-16";
algorithm
  Nu_T2 := 1.077*(Re*Pr*dimension/x)^(1/3);
  Nu_T := (Nu_T1^3 + 0.7^3 + (Nu_T2 - 0.7)^3)^(1/3);
  Nu_H2 := 1.302*(Re*Pr*dimension/x)^(1/3);
  Nu_H := (Nu_H1^3 + 1 + (Nu_H2 - 1)^3)^(1/3);
  if constantTwall then
    Nu := Nu_T;
  else
    Nu := Nu_H;
  end if;
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
<li>0 &le; Re &le; ~2300, 0.1 &le; Pr &le; 1000, d/L &le; 1</li>
<li>Applies only to circular pipes in the laminar region but can approximate other shapes with the characteristic dimension.</li>
<li>Laminar region is independent of surface roughness</li>
</ul>
<h4>References</h4>
<ol>
<li>VDI Heat Atlas 2E, 2010.</li>
</ol>
</html>"));
end Nu_Laminar_Local_Developed_Circular;
