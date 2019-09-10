within TRANSFORM.Media.Solids;
package Inconel690 "IN690: Inconel 690"
   extends Interfaces.Solids.PartialSimpleAlloy_TableBased(
     mediumName="IN690",
     T_min=Modelica.SIunits.Conversions.from_degC(0),
     T_max=Modelica.SIunits.Conversions.from_degC(1500),
     tableDensity=[298.15,8190; 373.15,8190; 473.15,8190; 573.15,8190; 673.15,8190;
         773.15,8190; 873.15,8190; 973.15,8190; 1073.15,8190; 1173.15,8190; 1273.15,
         8190; 1373.15,8190],
     tableHeatCapacity=[298.15,450; 373.15,471; 473.15,497; 573.15,525; 673.15,551;
         773.15,578; 873.15,604; 973.15,631; 1073.15,658; 1173.15,684; 1273.15,711;
         1373.15,738],
     tableConductivity=[298.15,13.5; 373.15,13.5; 473.15,15.4; 573.15,17.3; 673.15,
         19.1; 773.15,21; 873.15,22.9; 973.15,24.8; 1073.15,26.6; 1173.15,28.5; 1273.15,
         30.1; 1373.15,30.1]);

  annotation (Documentation(info="<html>
<p>Source: http://www.specialmetals.com/assets/documents/alloys/inconel/inconel-alloy-690.pdf</p>
</html>"));
end Inconel690;
