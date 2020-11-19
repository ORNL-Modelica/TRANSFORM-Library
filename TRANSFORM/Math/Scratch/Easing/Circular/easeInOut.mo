within TRANSFORM.Math.Scratch.Easing.Circular;
function easeInOut
  input Real t;
  input Real b;
  input Real c;
  output Real result;
algorithm
  if t < 0.5 then
    result :=-c/2 * (sqrt(1 - t*t) - 1) + b;
  else
    result := c/2 * (sqrt(1 - (1-t)^2) + 1) + b;
  end if;

end easeInOut;
