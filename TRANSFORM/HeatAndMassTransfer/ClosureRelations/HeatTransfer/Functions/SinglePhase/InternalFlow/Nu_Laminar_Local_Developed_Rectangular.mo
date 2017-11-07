within TRANSFORM.HeatAndMassTransfer.ClosureRelations.HeatTransfer.Functions.SinglePhase.InternalFlow;
function Nu_Laminar_Local_Developed_Rectangular
  "Nuselt Number | Single phase | Laminar | Local | Rectangular | Internal | Fully Developed"

  input SI.ReynoldsNumber Re "Reynolds Number";
  input SI.PrandtlNumber Pr "Prandtl Number";
  input Real AR "Ratio of maximum to minimum duct dimension";
  input Boolean constantTwall=true
    "= true for constant wall temperature correlation else constant heat flux";

  output SI.NusseltNumber Nu "Nusselt number";

protected
  SI.NusseltNumber Nu_T
    "Constant wall temperature Nusselt number - S1:Eq. 5-82";
  SI.NusseltNumber Nu_H "Constant heat flux Nusselt number  - S1:Eq. 5-83";

algorithm

  Nu_T := 7.541*(1 - 2.610*AR + 4.970*AR^2 - 5.119*AR^3 + 2.702*AR^4 - 0.548*AR
    ^5);

  Nu_H := 8.235*(1 - 2.042*AR + 3.085*AR^2 - 2.477*AR^3 + 1.058*AR^4 - 0.186*AR
    ^5);

  if constantTwall then
    Nu := Nu_T;
  else
    Nu := Nu_H;
  end if;

  annotation (Documentation(info="<html>
<p>Local heat transfer model for fully developed laminar and turbulent flow in rectangular ducts.</p>
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
<li>Applies only to rectangular ducts in the laminar region.</li>
<li>Laminar region is independent of surface roughness</li>
</ul>
<h4>References</h4>
<ol>
<li>Heat Transfer. Nellis and Klein. 2009</li>
</ol>
</html>"));
end Nu_Laminar_Local_Developed_Rectangular;
