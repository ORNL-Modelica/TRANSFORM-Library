within TRANSFORM.Math.ComplexMath;
function csqrt
  "Returns the complex result of the the square root of a real number"

  input Real x;
  output Complex y;

algorithm
  if x < 0 then
    y :=Complex(0, sqrt(abs(x)));
  else
    y :=Complex(sqrt(x), 0);
  end if;

end csqrt;
