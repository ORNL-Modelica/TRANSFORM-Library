within TRANSFORM.Fluid.ClosureRelations.PressureLoss.Functions.TubesAndConduits.SinglePhase;
function fRe2_Laminar_Local_Developed_Circular
  "f*Re^2 | Laminar | Local | Fully Developed | Circular"

  input SI.ReynoldsNumber Re "Reynolds Number";

  output Units.nonDim fRe2 "Friction factor*Re^2";

algorithm

    fRe2 :=64*Re;

end fRe2_Laminar_Local_Developed_Circular;
