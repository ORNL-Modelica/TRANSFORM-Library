within TRANSFORM.Fluid.ClosureRelations.PressureLoss.Functions.TubesAndConduits.SinglePhase;
function fRe2_Turbulent_Local_Developed_Serghides
  input SI.ReynoldsNumber Re "Reynolds Number";
  input SI.Length dimension "Hydraulic diameter";
  input SI.Length roughness "Average height of surface asperities";
  output Units.NonDim fRe2 "Friction factor*Re^2";
protected
  Units.NonDim delta = roughness/dimension;
  SI.ReynoldsNumber Re_int = max(Re,10);
  Real A, B, C;
algorithm
  A := -2*Modelica.Math.log10(min(1,delta/3.7 + 12/Re_int));
  B := -2*Modelica.Math.log10(min(delta/3.7 + 2.51*A/Re_int));
  C := -2*Modelica.Math.log10(min(delta/3.7 + 2.51*B/Re_int));
  fRe2 :=Re_int*(A-(B-A)^2/(C-2*B+A));
end fRe2_Turbulent_Local_Developed_Serghides;
