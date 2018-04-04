within TRANSFORM.HeatAndMassTransfer.ClosureRelations.HeatTransfer.Models.Utilities.Internal.GroeneveldCorrectionFactors;
function K_3 "Mid-Plane Spacer Factor"
  input SI.Length D_hyd "Hydraulic diameter of subchannel";
  input SIadd.MassFlux G "Mass flux";
  input SIadd.NonDim K_g "Pressure loss coefficient of spacer";
  input SI.Length L_sp "Distance between mid-plane of spacers";

  output Real K "Correction factor";

protected
  Real A;
  Real B;

algorithm
  A := 1.5*sqrt(K_g)*(abs(G)/1000)^(0.2);
  B := 0.10;
  K := 1 + A*exp(-B*L_sp/D_hyd);
end K_3;
