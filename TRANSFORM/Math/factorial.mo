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
<p>An implementation of Kreisselmeier Steinhauser smooth maximum</p>
</html>"));
end factorial;
