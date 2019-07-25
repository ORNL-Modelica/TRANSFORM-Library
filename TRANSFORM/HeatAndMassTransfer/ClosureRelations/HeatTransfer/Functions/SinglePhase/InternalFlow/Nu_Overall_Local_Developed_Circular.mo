within TRANSFORM.HeatAndMassTransfer.ClosureRelations.HeatTransfer.Functions.SinglePhase.InternalFlow;
function Nu_Overall_Local_Developed_Circular
  input SI.ReynoldsNumber Re "Reynolds Number";
  input SI.PrandtlNumber Pr "Prandtl Number";
  input SI.Length x "Position of local heat transfer calculation";
  input SI.Length dimension
    "Characteristic dimension (e.g., hydraulic diameter)";
  input SI.Height roughness=2.5e-5 "Average height of surface asperities";
  input Boolean constantTwall=true
    "= true for constant wall temperature correlation else constant heat flux (laminar conditions only Re ~< 2300)";
  output SI.NusseltNumber Nu "Nusselt number";
protected
  SI.NusseltNumber Nu_lam "Laminar Nusselt number";
  SI.NusseltNumber Nu_turb "Turbulent Nusselt number";
algorithm
  Nu_lam := Nu_Laminar_Local_Developed_Circular(
    Re,
    Pr,
    x,
    dimension,
    constantTwall);
  Nu_turb :=Nu_Turbulent_Local_Developed(
    Re,
    Pr,
    x,
    dimension,
    roughness);
  // Transition region from 2300 < Re < 1e4 with center at 6150
  Nu := TRANSFORM.Math.spliceTanh(
    Nu_turb,
    Nu_lam,
    Re - 6150,
    3850);
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
<h4>References</h4>
<ol>
<li>VDI Heat Atlas 2E, 2010.</li>
<li>Heat Transfer. Nellis and Klein. 2009</li>
</ol>
</html>"));
end Nu_Overall_Local_Developed_Circular;
