within TRANSFORM.Media.Solids;
package Inconel625 "IN625: Inconel 625"

  extends Interfaces.Solids.PartialSimpleAlloy_TableBased(
    mediumName="IN625",
    T_min=Modelica.Units.Conversions.from_degC(0),
    T_max=Modelica.Units.Conversions.from_degC(1500),
    tableDensity=[298.15,8440; 373.15,8440; 473.15,8440; 573.15,8440; 673.15,
        8440; 773.15,8440; 873.15,8440; 973.15,8440; 1073.15,8440; 1173.15,
        8440; 1273.15,8440; 1373.15,8440],
    tableHeatCapacity=[294.15,402; 366.15,427; 477.15,456; 589.15,481; 700.15,
        511; 811.15,536; 922.15,565; 1033.15,590; 1144.15,620; 1255.15,645;
        1366.15,670; 1500.15,670],
    tableConductivity=[294.15,9.8; 366.15,10.8; 477.15,12.5; 589.15,14.1;
        700.15,15.7; 811.15,17.5; 922.15,19.0; 1033.15,20.8; 1144.15,22.8;
        1255.15,25.2; 1366.15,25.2; 1500.15,25.2]);

annotation (Documentation(info="<html>
<p>Source:</p>
<p>1. http://www.specialmetals.com/assets/smc/documents/alloys/inconel/inconel-alloy-625.pdf</p>
</html>"));
end Inconel625;
