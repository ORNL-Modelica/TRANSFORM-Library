within TRANSFORM.Fluid.Valves.BaseClasses.ValveCharacteristics;
function equalPercentage "Equal percentage characteristic"
  extends baseFun;
  input Real rangeability = 20 "Rangeability" annotation(Dialog);
  input Real delta = 0.01 annotation(Dialog);
algorithm
  rc := if pos > delta then rangeability^(pos-1) else
          pos/delta*rangeability^(delta-1);
  annotation (Documentation(info="<html>
This characteristic is such that the relative change of the flow coefficient is proportional to the change in the opening position:
<p> d(rc)/d(pos) = k d(pos).
<p> The constant k is expressed in terms of the rangeability, i.e., the ratio between the maximum and the minimum useful flow coefficient:
<p> rangeability = exp(k) = rc(1.0)/rc(0.0).
<p> The theoretical characteristic has a non-zero opening when pos = 0; the implemented characteristic is modified so that the valve closes linearly when pos &lt; delta.
</html>"));
end equalPercentage;
