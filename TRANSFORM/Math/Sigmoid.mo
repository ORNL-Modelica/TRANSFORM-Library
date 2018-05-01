within TRANSFORM.Math;
function Sigmoid

  input Real x "Value of interest";
  input Real x0 "Transition or center value";
  input Real k "Transition region factor (larger value increases slope steepness)";

  output Real sigmoid "Sigmoid result";

algorithm
  sigmoid :=1/(1 + exp(-k*(x - x0)));

end Sigmoid;
