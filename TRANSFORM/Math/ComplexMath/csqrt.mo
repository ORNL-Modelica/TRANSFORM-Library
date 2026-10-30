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
  annotation (Documentation(info="<html>
<pre>Returns complex record y.re and y.im of sqrt(x).</pre>
</html>"));
end csqrt;
