within TRANSFORM.HeatAndMassTransfer.ClosureRelations.HeatTransfer.Functions.SinglePhase.InternalFlow;
function Nu_LiquidMetal_Developed_Circular
  "Liquid metal | Circular | Fully Developed"
  input SI.ReynoldsNumber Re "Reynolds number";
  input SI.PrandtlNumber Pr "Prandtl number";
  input Boolean constantTwall=true
    "= true for constant wall temperature correlation else constant heat flux";
  output SI.NusseltNumber Nu "Nusselt number";
protected
  SI.PecletNumber Pe=TRANSFORM.Utilities.CharacteristicNumbers.PecletNumber(Re,
      Pr);
  SI.NusseltNumber Nu_T
    "Constant wall temperature Nusselt number - S1:Eq. 10-2";
  SI.NusseltNumber Nu_H
    "Constant heat flux Nusselt number  - S1:Eq. 10-3";
algorithm
  Nu_T := 7.0 + 0.025*Pe^0.8;
  Nu_H := 5.0 + 0.025*Pe^0.8;
  if constantTwall then
    Nu := Nu_T;
  else
    Nu := Nu_H;
  end if;
  annotation (Documentation(info="<html>
<p>The Lyon-Martinelli heat transfer correlation is for flow of liquid metal in circular tubes with contant heat flux along the tube wall.</p>
<p>Range of validity:</p>
<ul>
<li>liquid metal coolant</li>
<li>flow in circular tubes</li>
<li>constant heat flux along tube wall (Lyon-Martinelli) or constant wall temperature (Seban-Shimazaki)</li>
</ul>
<h4>References</h4>
<ol>
<li>M. M. Wakil, Nuclear Heat Transport 1993</li>
</ol>
</html>"));
end Nu_LiquidMetal_Developed_Circular;
