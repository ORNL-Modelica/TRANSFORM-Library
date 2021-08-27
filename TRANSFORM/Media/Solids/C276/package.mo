within TRANSFORM.Media.Solids;
package C276 "C276"
  extends Interfaces.Solids.PartialSimpleAlloy_TableBased(
    mediumName="C276",
    T_min=Modelica.Units.Conversions.from_degC(-168),
    T_max=Modelica.Units.Conversions.from_degC(1100),
    tableDensity=[105.15,8890; 1373.15,8190;],
    tableHeatCapacity=[105.15; 1373.15,427;],
    tableConductivity=[105.15,7.2; 200.15, 8.7; 293.15, 9.8; 373.15,  11.2; 473.15, 12.8;
    573.15, 14.7; 673.15, 16.4; 773.15, 18.2; 873.15, 20; 973.15, 21.9; 1073.15, 23.7;
    1173.15, 25.4; 1273.15, 27; 1373.15, 28.3]);

  annotation (Documentation(info="<html>
<p>Source:https://www.specialmetals.com/documents/technical-bulletins/inconel/inconel-alloy-c-276.pdf</p>
</html>"));
end C276;
