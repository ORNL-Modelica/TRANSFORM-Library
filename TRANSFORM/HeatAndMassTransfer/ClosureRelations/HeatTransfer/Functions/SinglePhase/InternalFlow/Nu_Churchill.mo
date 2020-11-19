within TRANSFORM.HeatAndMassTransfer.ClosureRelations.HeatTransfer.Functions.SinglePhase.InternalFlow;
function Nu_Churchill
  "Churchill (1977) Correlation for all Reynolds and Prandtl numbers for internal flow"
  input SI.ReynoldsNumber Re = 100 "Reynolds number";
  input SI.PrandtlNumber Pr = 0.8 "Prandtl number";
  input SI.Height eps = 0.00001 "Surface roughness";
  input SI.Diameter dimension = 0.01 "Hydrualic diameter";
  output SI.NusseltNumber Nu "Nusselt number";
protected
  Real f "churchill friction factor";
algorithm
  f := 8*((((8/Re)^12)+(((2.457*Modelica.Math.log(((((7/Re)^0.9))+0.27*eps/dimension)^(-1)))^16)+((37530/Re)^16))^(-1.5))^(1/12));
  Nu := ((4.364^10)+(((Modelica.Math.exp((2200-Re)/365)/(4.364^2))+((6.3+((0.079*((f/8)^0.5))*Re*Pr/((1+(Pr^0.8))^(5/6))))^(-2)))^(-5)))^(1/10);
  annotation (Documentation(info="<html>
<p>Dittus-Boelter&apos;s correlation for the computation of the heat transfer coefficient in one-phase flows. </p>
</html>"));
end Nu_Churchill;
