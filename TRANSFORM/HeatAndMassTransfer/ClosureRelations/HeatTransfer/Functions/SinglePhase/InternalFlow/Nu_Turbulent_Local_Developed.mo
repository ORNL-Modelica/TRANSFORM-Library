within TRANSFORM.HeatAndMassTransfer.ClosureRelations.HeatTransfer.Functions.SinglePhase.InternalFlow;
function Nu_Turbulent_Local_Developed
  "Nusselt Number | Single phase | Turbulent | Local | Internal | Fully Developed"

  input SI.ReynoldsNumber Re "Reynolds Number";
  input SI.PrandtlNumber Pr "Prandtl Number";
  input SI.Length x "Position of local heat transfer calculation";
  input SI.Length dimension
    "Characteristic dimension (e.g., hydraulic diameter)";
  input SI.Height roughness=2.5e-5 "Average height of surface asperities";

  output SI.NusseltNumber Nu "Nusselt number";

protected
  Real Xi_smooth "Friction factor - S1:Eq. G1-27";
  SI.NusseltNumber Nu_smooth "Smooth pipe Nusselt number  - S1:Eq. G1-28";

  Real Xi_rough "Friction factor - S2:Eq. 5-65";
  SI.NusseltNumber Nu_rough "Rough pipe Nusselt number  - S2:Eq. 5-84";

  SI.ReynoldsNumber Re_int = max(2300,Re) "Internal Re to avoid illegal mathematical operations";

algorithm

  Xi_smooth := (1.8*Modelica.Math.log10(Re_int) - 1.5)^(-2);
  Nu_smooth := 0.125*Xi_smooth*Re_int*Pr/(1 + 12.7*(0.125*Xi_smooth)^0.5*(Pr^(2/3)
     - 1));

  Xi_rough := (-2.0*Modelica.Math.log10(2*roughness/(7.54*dimension) - 5.02/Re_int*
    Modelica.Math.log10(2*roughness/(7.54*dimension) + 13/Re_int)))^(-2);
  Nu_rough := 0.125*Xi_rough*(Re_int - 1000)*Pr/(1 + 12.7*(0.125*Xi_rough)^0.5*(Pr^
    (2/3) - 1))*(1 + (dimension/x)^(2/3)/3);

  Nu := TRANSFORM.Math.spliceTanh(
    Nu_rough,
    Nu_smooth,
    roughness - 0.0001,
    0.00001);

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
<li>2300 &le; Re &le; 1e6, 0.1 &le; Pr &le; 1000, d/L &le; 1</li>
<li>Turbulent region is independent of pipe shape.</li>
</ul>
<h4>References</h4>
<ol>
<li>VDI Heat Atlas 2E, 2010.</li>
<li>Heat Transfer. Nellis and Klein. 2009</li>
</ol>
</html>"));
end Nu_Turbulent_Local_Developed;
