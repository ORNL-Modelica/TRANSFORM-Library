within TRANSFORM.Math.Easing.Cubic;
function easeIn
  input Real t;
  output Real result;
algorithm
  result :=t*t*t;

end easeIn;
