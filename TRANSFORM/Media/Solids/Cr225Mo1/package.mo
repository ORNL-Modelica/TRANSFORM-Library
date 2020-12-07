within TRANSFORM.Media.Solids;
package Cr225Mo1 "Chrome-Moly Steel: 2-1/4 Cr - 1 Mo steel"
extends Interfaces.Solids.PartialSimpleAlloy_TableBased(
  mediumName="Cr225Mo1",
  T_min=Modelica.Units.Conversions.from_degC(0),
  T_max=Modelica.Units.Conversions.from_degC(1500),
  npolDensity=0,
  npolHeatCapacity=0,
  tableDensity=[298.15,7990],
  tableHeatCapacity=[298.15,500],
  tableConductivity=[294.26,36.17; 310.93,36.35; 338.71,36.69; 366.48,36.86;
      394.26,37.04; 422.04,37.21; 449.82,37.21; 477.59,37.21; 505.37,37.21;
      533.15,37.04; 560.93,36.86; 588.71,36.52; 616.48,36.17; 644.26,35.83;
      672.04,35.48; 699.82,34.96; 727.59,34.61; 755.37,34.1; 783.15,33.58;
      810.93,33.06; 838.71,32.54; 866.48,32.02; 894.26,31.67; 922.04,31.15;
      949.82,30.63; 977.59,29.77; 1005.37,28.38; 1033.15,27; 1060.93,26.65;
      1088.71,26.48]);

annotation (Documentation(info="<html>
<p>Source: http://www.osti.gov/scitech/servlets/purl/455553/</p>
<p><br>Metals design handbook.</p>
<p><br>Important density and specific heat capacity are taken from SS316 as no data was yet found.</p>
</html>"));
end Cr225Mo1;
