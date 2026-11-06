within TRANSFORM.Media.Solids.Copper;
package OFHC_RRR200 "Oxygen-free, high conductivity copper (OFHC) of Residual Resistivity Ratio = 200"
  import Poly =
  TRANSFORM.Media.Interfaces.Solids.Polynomials_Temp;

   extends TRANSFORM.Media.Interfaces.Solids.PartialSimpleAlloy_TableBased(
     mediumName="OFHC_RRR200",
     T_min=0,
     T_max=750,
     npolDensity=0,
     npolHeatCapacity=0,
     tableDensity=[298.15,8917],
     tableHeatCapacity=[298.15,385],
     tableConductivity=[50,1100; 55,911; 60,783; 70,625; 80,543; 90,498; 100,
         471; 125,434; 150,424; 200,411; 250,404; 300,399; 400,415; 500,431]);

  // Conductivity: a cubic spline through tableConductivity, held at the end points outside it.
  // The inherited degree-2 polynomial fit could not follow the steep rise below 100 K: it was
  // off by up to 318 W/(m.K) inside the table (296 instead of 399 at 300 K, 617 instead of 471
  // at 100 K).
  final constant Real x_lambda[:]=tableConductivity[:, 1] "Spline support points";
  final constant Real y_lambda[size(x_lambda, 1)]=tableConductivity[:, 2]
    "Spline support values";
  final constant Real d_lambda[size(x_lambda, 1)]=TRANSFORM.Math.splineDerivatives(
      x=x_lambda,
      y=y_lambda,
      ensureMonotonicity=false) "Spline derivatives at the support points";

  redeclare replaceable function thermalConductivity
    "Thermal conductivity: cubic spline through the table, held at its end points outside it"
    extends Modelica.Icons.Function;
    input ThermodynamicState state "Thermodynamic state record";
    output ThermalConductivity lambda "Thermal conductivity";
  algorithm
    lambda := TRANSFORM.Math.cspline(
        min(max(state.T, x_lambda[1]), x_lambda[end]),
        x_lambda,
        y_lambda,
        d_lambda);
    annotation (Inline=true);
  end thermalConductivity;

    redeclare function extends linearExpansionCoefficient
      "Linear expansion coefficient"
    algorithm
      alpha := 17.7e-6;
    end linearExpansionCoefficient;

    redeclare function extends electricalResistivity
      "Electrical resistivity"
  protected
    constant Real tableData[:,2] = [50,0.057; 55,0.076; 60,0.098; 70,0.15; 80,0.22; 90,
         0.29; 100,0.36; 125,0.54; 150,0.72; 200,1.06; 250,1.39; 300,1.73; 400,2.49;
         500,3.19]*[1,0;0,1e-8];
    constant Real polyFit[:] = Poly.fitting(
        tableData[:, 1],
        tableData[:, 2],
        2);
    algorithm
      rho_e := Poly.evaluate(polyFit, state.T);
    end electricalResistivity;
  annotation (Documentation(info="<html>
</html>"));
end OFHC_RRR200;
