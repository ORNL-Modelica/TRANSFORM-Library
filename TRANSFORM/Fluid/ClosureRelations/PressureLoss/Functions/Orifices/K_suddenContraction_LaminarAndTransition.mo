within TRANSFORM.Fluid.ClosureRelations.PressureLoss.Functions.Orifices;
function K_suddenContraction_LaminarAndTransition "Orifice | Sudden Contraction | Laminar and Transition | 10 < Re < 1e4"
  extends TRANSFORM.Icons.Function;

  // Source: Idelčik, I. E. & Ginevskiĭ, A. S. Handbook of hydraulic resistance. (Begell House, 2007).
  // Diagram 4.10 - Sudden Contraction - Transition and laminar regions (10 < Re < 1e4)

  input SI.Area crossAreas[2] = {0.5,1.0} "Cross-sectional areas (order does not matter)";
  input SI.ReynoldsNumber Re "Reynolds number";
  input Units.NonDim CF=1.0 "Correction factor";

  output Units.NonDim K "Resistance coefficient";

protected
  SI.Area F0 = min(crossAreas) "Small cross-sectional area";
  SI.Area F1 = max(crossAreas) "Large cross-sectional area";
  Units.NonDim R_F0F1 = F0/F1;

  Real dataR_F0F1[6]={0.1,0.2,0.3,0.4,0.5,0.6};
  Real dataRe[14]={10,20,30,40,50,1e2,2e2,5e2,1e3,2e3,4e3,5e3,1e4,2e4};
  Real data[size(dataR_F0F1,1),size(dataRe,1)]=[5,3.2,2.4,2,1.8,1.3,1.04,0.82,0.64,
        0.5,0.8,0.75,0.5,0.45; 5,3.1,2.3,1.84,1.62,1.2,0.95,0.7,0.5,0.4,0.6,0.6,
        0.4,0.4; 5,2.95,2.15,1.7,1.5,1.1,0.85,0.6,0.44,0.3,0.55,0.55,0.35,0.35;
        5,2.8,2,1.6,1.4,1,0.78,0.5,0.35,0.25,0.45,0.5,0.3,0.3; 5,2.7,1.8,1.46,1.3,
        0.9,0.65,0.42,0.3,0.2,0.4,0.42,0.25,0.25; 5,2.6,1.7,1.35,1.2,0.8,0.56,0.35,
        0.24,0.15,0.35,0.35,0.2,0.2];

algorithm

  K := CF*TRANSFORM.Math.interpolate2D(
    x=dataR_F0F1,
    y=dataRe,
    data=data,
    xi=R_F0F1,
    yi=Re);

end K_suddenContraction_LaminarAndTransition;
