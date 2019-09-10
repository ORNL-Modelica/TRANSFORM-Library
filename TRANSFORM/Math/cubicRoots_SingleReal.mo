within TRANSFORM.Math;
function cubicRoots_SingleReal
  "Returns a single real root within the user defined range for a cubic equation (a*x^3+b*x^2+c*x+d=0)"
  input Real a;
  input Real b;
  input Real c;
  input Real d;
  input Real u_min "Lower bound of search interval";
  input Real u_max "Upper bound of search interval";
  output Real u "Value of real root";
protected
  Real[3] reRoots "Real roots";
  Real nRoots "Number of distinct real solutions expected";
  Integer found=0 "Number of roots found in interval";
  Integer reIndex = 0;
algorithm
  (reRoots,nRoots) :=TRANSFORM.Math.cubicRoots_Real(
    a=a,
    b=b,
    c=c,
    d=d);
  for i in 1:3 loop
    if reRoots[i] >= u_min and reRoots[i] <= u_max then
      found :=found + 1;
      reIndex :=i;
    end if;
  end for;
  assert(found==1, String(found) + " real roots found in the interval: "
         + String(u_min) + " <= u <= " + String(u_max)
         + ". Redefine bounds so only one root is bounded.");
  u :=reRoots[reIndex];
  annotation (Documentation(info="<html>
<p>Returns only one real root between the bounds specified by the user.</p>
</html>"));
end cubicRoots_SingleReal;
