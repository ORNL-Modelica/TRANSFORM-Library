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
