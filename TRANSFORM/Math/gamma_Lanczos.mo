within TRANSFORM.Math;
function gamma_Lanczos
  "Gamma function using the Lanczos approximation"
  extends Modelica.Icons.Function;

  input Real z "Input value for gamma(z)";
  output Real gamma "Gamma function value";

protected
  Real t;
  Real x;
  Integer plen = 8;
  Real[plen] p = {676.5203681218851, -1259.1392167224028, 771.32342877765313,
               -176.61502916214059, 12.507343278686905, -0.13857109526572012,
               9.9843695780195716e-6, 1.5056327351493116e-7};

algorithm

  if z < 0.5 then
    gamma :=pi/(sin(pi*z)*gamma_Lanczos(1.0 - z));

  else
    x :=0.99999999999980993;

    for i in 1:plen loop
      x :=x + p[i]/(z - 1.0 + i);
    end for;

    t :=z + plen - 1.5;
    gamma := sqrt(2.0*pi) * t^(z-0.5) * exp(-t) * x;
  end if;

  annotation (Documentation(info="<html>
<p>An implementation of Kreisselmeier Steinhauser smooth maximum</p>
</html>"));
end gamma_Lanczos;
