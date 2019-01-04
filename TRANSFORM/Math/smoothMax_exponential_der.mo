within TRANSFORM.Math;
function smoothMax_exponential_der
  extends Modelica.Icons.Function;

  import Modelica.Math.exp;
  import Modelica.Math.log;

  input Real x1 "First argument of smooth max operator";
  input Real x2 "Second argument of smooth max operator";
  input Real dx
  "Approximate difference between x1 and x2, below which regularization starts";
  input Real dx1;
  input Real dx2;
  input Real ddx;
  output Real dy "Derivative of smooth max operator";
algorithm
  dy := (if x1 > x2 then dx1 else dx2) + 0.25*(((4*(dx1 - (if x1 > x2
     then dx1 else dx2))/dx - 4*(x1 - max(x1, x2))*ddx/dx^2)*exp(4*(x1 -
    max(x1, x2))/dx) + (4*(dx2 - (if x1 > x2 then dx1 else dx2))/dx - 4*(
    x2 - max(x1, x2))*ddx/dx^2)*exp(4*(x2 - max(x1, x2))/dx))*dx/(exp(4*(
    x1 - max(x1, x2))/dx) + exp(4*(x2 - max(x1, x2))/dx)) + log(exp(4*(x1
     - max(x1, x2))/dx) + exp(4*(x2 - max(x1, x2))/dx))*ddx);

  annotation (Documentation(info="<html>
<p>Derivative of smoothMax_exponential. See smoothMax_exponential.</p>
</html>"));
end smoothMax_exponential_der;
