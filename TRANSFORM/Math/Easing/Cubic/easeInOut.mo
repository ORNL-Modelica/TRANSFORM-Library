within TRANSFORM.Math.Easing.Cubic;
function easeInOut
  input Real t;
  output Real result;
algorithm
  if t < 0.5 then
    result :=easeIn(t)/2;
  else
    result := 1 - (1-t)^3/2;
  end if;
end easeInOut;
