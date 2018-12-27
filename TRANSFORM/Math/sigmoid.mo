within TRANSFORM.Math;
function sigmoid

  input Real x "Value of interest (e.g., x = val-x_t)";
  input Real k "Transition region factor (larger value increases slope steepness)";

  output Real y "Sigmoid result";

algorithm
  y :=1/(1 + exp(-k*x));

  annotation (Documentation(info="<html>
<p><img src=\"modelica://TRANSFORM/Resources/Images/Information/sigmoid.jpg\"/></p>
</html>"));
end sigmoid;
