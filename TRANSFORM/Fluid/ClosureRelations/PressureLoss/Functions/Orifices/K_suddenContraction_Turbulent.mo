within TRANSFORM.Fluid.ClosureRelations.PressureLoss.Functions.Orifices;
function K_suddenContraction_Turbulent "Orifice | Sudden Contraction | Turbulent | Re > 3.5e4"

  // Source: Idelčik, I. E. & Ginevskiĭ, A. S. Handbook of hydraulic resistance. (Begell House, 2007).
  // Diagram 4.9 - Sudden Contraction - Turbulent Region (Re > 3.5e4)

  extends TRANSFORM.Icons.Function;

  input SI.Area crossAreas[2] = {0.5,1.0} "Cross-sectional areas (order does not matter)";
  input Units.NonDim CF = 1.0 "Correction factor";

  output Units.NonDim K "Resistance coefficient";

protected
  SI.Area F0 = min(crossAreas) "Small cross-sectional area";
  SI.Area F1 = max(crossAreas) "Large cross-sectional area";
  Units.NonDim R_F0F1 = F0/F1;

algorithm
  K := CF*0.5*(1.0 - R_F0F1)^(0.75);

end K_suddenContraction_Turbulent;
