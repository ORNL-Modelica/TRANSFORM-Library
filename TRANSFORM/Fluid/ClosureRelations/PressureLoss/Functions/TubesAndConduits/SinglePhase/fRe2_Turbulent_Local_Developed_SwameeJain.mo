within TRANSFORM.Fluid.ClosureRelations.PressureLoss.Functions.TubesAndConduits.SinglePhase;
function fRe2_Turbulent_Local_Developed_SwameeJain

  input SI.ReynoldsNumber Re "Reynolds Number";
  input SI.Length dimension "Hydraulic diameter";
  input SI.Length roughness "Average height of surface asperities";

  output Units.NonDim fRe2 "Friction factor*Re^2";

protected
  Units.NonDim delta = roughness/dimension;
  SI.ReynoldsNumber Re_int = max(Re,10);

algorithm

  fRe2 :=0.25*(Re_int/(Modelica.Math.log10(delta/3.7 + 5.74/Re_int^0.9)))^2;
end fRe2_Turbulent_Local_Developed_SwameeJain;
