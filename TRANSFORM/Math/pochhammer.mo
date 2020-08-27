within TRANSFORM.Math;
function pochhammer
  //https://en.wikipedia.org/wiki/Hypergeometric_function
  input Real q;
  input Integer n;
  output Real y;
algorithm

  if n == 0 then
    y :=1;
  else
    y :=1;
    for i in 1:n loop
      y :=y*(q + i - 1);
    end for;
  end if;

  annotation (Documentation(info="<html>
</html>"));
end pochhammer;
