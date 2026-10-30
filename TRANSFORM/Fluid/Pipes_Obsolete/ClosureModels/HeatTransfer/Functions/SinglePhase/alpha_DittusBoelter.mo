within TRANSFORM.Fluid.Pipes_Obsolete.ClosureModels.HeatTransfer.Functions.SinglePhase;
function alpha_DittusBoelter
  "Dittus-Boelter correlation for one-phase flow in a tube"
  // Constant
  input SI.Length D "Hydraulic diameter";
  // Variables
  input SI.ThermalConductivity lambda "Thermal conductivity";
  input SI.ReynoldsNumber Re "Reynolds number";
  input SI.PrandtlNumber Pr "Prandtl number";
  output SI.CoefficientOfHeatTransfer alpha "Heat transfer coefficient";
algorithm
  alpha := 0.023*Re^0.8*Pr^0.4*lambda/D;
  annotation (Documentation(info="<html>
<p>Dittus-Boelter&apos;s correlation for the computation of the heat transfer coefficient in one-phase flows. </p>
</html>"));
end alpha_DittusBoelter;
