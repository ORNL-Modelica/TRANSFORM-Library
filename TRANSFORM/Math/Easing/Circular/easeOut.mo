within TRANSFORM.Math.Easing.Circular;
function easeOut
  input Real t;
  input Real b;
  input Real c;
  output Real result;
algorithm
  result :=c * sqrt(1 - (t-1)^2) + b;

end easeOut;
