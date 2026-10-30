within TRANSFORM.Fluid.ClosureRelations.PressureLoss.Functions.Orifices;
function K_suddenExpansion
  "Orifice | Sudden Expansion | Laminar, Transition, and Turbulent | Uniform Velocity Distribution"
  // Source: Idelčik, I. E. & Ginevskiĭ, A. S. Handbook of hydraulic resistance. (Begell House, 2007).
  // Diagram 4.1 - Sudden Expansion - Laminar, Transition, and Turbulent Region
  extends TRANSFORM.Icons.Function;
  input SI.Area crossAreas[2]={0.5,1.0}
    "Cross-sectional areas (order does not matter)";
  input SI.ReynoldsNumber Re "Reynolds number";
  input Units.NonDim CFs[2]={1.0,1.0}
    "Correction factor {laminar/transition,turbulent}";
  output Units.NonDim K "Resistance coefficient";
protected
  Units.NonDim K_lam;
  Units.NonDim K_turb;
  SI.ReynoldsNumber Re_center=3.3e3 "Re smoothing transition center";
  SI.ReynoldsNumber Re_width=200 "Re smoothing transition width";
algorithm
  K_lam := K_suddenExpansion_LaminarAndTransition(
    crossAreas,
    Re,
    CFs[1]);
  K_turb := K_suddenExpansion_Turbulent(crossAreas, CFs[2]);
  K := TRANSFORM.Math.spliceTanh(
    K_turb,
    K_lam,
    Re - Re_center,
    Re_width);
  annotation (smoothOrder=1);
end K_suddenExpansion;
