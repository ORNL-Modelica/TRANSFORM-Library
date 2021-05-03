within TRANSFORM.Media.Interfaces.Fluids.TableBased;
function density_T "Return density as function of temperature"
  extends Modelica.Icons.Function;

  input Temperature T "Temperature";
  output Density d "Density";
algorithm
  d := Polynomials.evaluate(poly_rho, if TinK then T else
    Modelica.Units.Conversions.to_degC(T));
  annotation(Inline=true,smoothOrder=2);
end density_T;
