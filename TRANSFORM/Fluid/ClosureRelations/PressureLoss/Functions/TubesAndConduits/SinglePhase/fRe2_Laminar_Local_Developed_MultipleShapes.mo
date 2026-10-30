within TRANSFORM.Fluid.ClosureRelations.PressureLoss.Functions.TubesAndConduits.SinglePhase;
function fRe2_Laminar_Local_Developed_MultipleShapes
  "f*Re^2 | Laminar | Local | Fully Developed | Specify Shape"
  input SI.ReynoldsNumber Re "Reynolds Number";
  input String shape = "Circle" "Geometry shape" annotation(choices(choice= "Circle",choice= "Rectangle",choice= "Ellipse",choice= "Isosceles Triangle"));
  input Units.NonDim ab = 1 "Ratio of major (a)/minor (b) length (only for rectangle and elipse)";
  input SI.Angle theta = 10 "Angle (only for triangle)";
  output Units.NonDim fRe2 "Friction factor*Re^2";
algorithm
  if shape == "Circle" then
    fRe2 :=64*Re;
  elseif shape == "Rectangle" then
    fRe2 :=56.92*Re;
  elseif shape == "Ellipse" then
    fRe2 :=64*Re;
  elseif shape == "Isosceles Triangle" then
    fRe2 :=50.80*Re;
  else
    assert(false,"Shape for friction factor not recognized");
  end if;
end fRe2_Laminar_Local_Developed_MultipleShapes;
