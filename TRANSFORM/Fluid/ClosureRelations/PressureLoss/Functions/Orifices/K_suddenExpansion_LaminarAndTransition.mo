within TRANSFORM.Fluid.ClosureRelations.PressureLoss.Functions.Orifices;
function K_suddenExpansion_LaminarAndTransition
  "Orifice | Sudden Expansion | Laminar and Transition | 500 < Re < 3.3e3 | Uniform Velocity Distribution"

  // Source: Idelčik, I. E. & Ginevskiĭ, A. S. Handbook of hydraulic resistance. (Begell House, 2007).
  // Diagram 4.1 - Sudden Expansion - Turbulent Region (10 < Re < 3.3e3)

  extends TRANSFORM.Icons.Function;

  input SI.Area crossAreas[2] = {0.5,1.0} "Cross-sectional areas (order does not matter)";
  input SI.ReynoldsNumber Re "Reynolds number";
  input SIadd.nonDim CF=1.0 "Correction factor (e.g., 0.6 with baffles)";

  output SIadd.nonDim K "Resistance coefficient";

protected
  SI.Area F0 = min(crossAreas) "Small cross-sectional area";
  SI.Area F1 = max(crossAreas) "Large cross-sectional area";
  SIadd.nonDim R_F0F1 = F0/F1;

  Real dataR_F0F1[6]={0.1,0.2,0.3,0.4,0.5,0.6};
  Real dataRe[13]={10,15,20,30,40,50,1e2,2e2,5e2,1e3,2e3,3e3,4e3};
  Real data[size(dataR_F0F1, 1),size(dataRe, 1)]=[3.1,3.2,3,2.4,2.15,1.95,1.7,1.65,
      1.7,2,1.6,1,0.81; 3.1,3.2,2.8,2.2,1.85,1.65,1.4,1.3,1.3,1.6,1.25,0.7,0.64;
      3.1,3.1,2.6,2,1.6,1.4,1.2,1.1,1.1,1.3,0.95,0.6,0.5; 3.1,3,2.4,1.8,1.5,1.3,
      1.1,1,0.85,1.05,0.8,0.4,0.36; 3.1,2.8,2.3,1.65,1.35,1.15,0.9,0.75,0.65,0.9,
      0.65,0.3,0.25;3.1,2.7,2.15,1.55,1.25,1.05,0.8,0.6,0.4,0.6,0.5,0.2,0.16];

algorithm

  K := CF*TRANSFORM.Math.interpolate2D(
    x=dataR_F0F1,
    y=dataRe,
    data=data,
    xi=R_F0F1,
    yi=Re);

end K_suddenExpansion_LaminarAndTransition;
