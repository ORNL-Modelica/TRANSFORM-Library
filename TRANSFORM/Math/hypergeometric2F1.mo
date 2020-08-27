within TRANSFORM.Math;
function hypergeometric2F1
  //https://en.wikipedia.org/wiki/Hypergeometric_function
  input Real a;
  input Real b;
  input Real c;
  input Real z;
  input Integer n=10;
  output Real y;

protected
  Real an, bn, cn;

algorithm

  y :=0;
  for i in 1:n loop
    an :=pochhammer(a, n);
    bn :=pochhammer(b, n);
    cn :=pochhammer(c, n);
    y :=y + (an*bn*z^n/cn/factorial(n));
  end for;

   annotation (Documentation(info="<html>
</html>"));
end hypergeometric2F1;
