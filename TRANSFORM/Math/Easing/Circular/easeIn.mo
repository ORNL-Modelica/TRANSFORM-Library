within TRANSFORM.Math.Easing.Circular;
function easeIn
  input Real t;
  input Real b;
  input Real c;
  output Real result;
algorithm
  result :=-c * (sqrt(1 - t^2) - 1) + b;

end easeIn;
