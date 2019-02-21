within TRANSFORM.Math;
function quadraticCoefficients
  "Returns the coefficients of a quadritic equation a*x + b*x^2 + c*x^3 from three number pairs (x,y)"
  input Real[3] x "Abscissa points";
  input Real[3] y "Ordinate points";
  output Real[3] c "Quadratic coefficients";
protected
  Real[3] x2;
algorithm
  x2 :={x[1]^2,x[2]^2,x[3]^2}  "Squared nominal flow rates";
  /* Linear system to determine the coefficients:
  y[1] = c[1] + x[1]*c[2] + x[1]^2*c[3];
  y[2] = c[1] + x[2]*c[2] + x[2]^2*c[3];
  y[3] = c[1] + x[3]*c[2] + x[3]^2*c[3];
  */
  c :=Modelica.Math.Matrices.solve([ones(3),x,x2], y)
      "Coefficients of quadratic power consumption curve";
end quadraticCoefficients;
