within TRANSFORM.Math.Scratch.Easing.Cubic;
function easeOut
  input Real t;
  output Real result;
algorithm
  result :=1-(1-t)^3;

end easeOut;
