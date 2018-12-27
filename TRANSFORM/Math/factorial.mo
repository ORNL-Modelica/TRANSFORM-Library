within TRANSFORM.Math;
function factorial "Calculates the factorial of integer n"
  extends Modelica.Icons.Function;

  input Integer n "Integer used to calculate factorial";
  output Real y "Factorial n";

algorithm

    y :=1;
  for i in 1:n loop
    y :=y*i;
  end for;

  annotation (Documentation(info="<html>
<p>Returns the factorial of the input.</p>
<p><br>Example:</p>
<p>n = 3</p>
<p>y = 3! = 3*2*1 = 6</p>
</html>"));
end factorial;
