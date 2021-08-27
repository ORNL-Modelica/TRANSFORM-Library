within TRANSFORM.Media.Solids;
package C276 "C276"
  extends Interfaces.Solids.PartialSimpleAlloy_TableBased(
    mediumName="C276",
    T_min=105.15,
    T_max=105.15,
    tableDensity=[105.15,8890; 200.15, 8890; 293.15, 8890; 373.15,  8890; 473.15, 8890;
    573.15, 8890; 673.15, 8890; 773.15, 8890; 873.15, 8890; 973.15, 8890; 1073.15, 8890;
    1173.15, 8890; 1273.15, 8890; 1373.15, 8890]),
    tableHeatCapacity= [105.15,427; 200.15, 427; 293.15, 427; 373.15,  427; 473.15, 427;
    573.15, 427; 673.15, 427; 773.15, 427; 873.15, 427; 973.15, 427; 1073.15, 427;
    1173.15, 427; 1273.15, 427; 1373.15, 427]),
    tableConductivity=[105.15,7.2; 200.15, 8.7; 293.15, 9.8; 373.15,  11.2; 473.15, 12.8;
    573.15, 14.7; 673.15, 16.4; 773.15, 18.2; 873.15, 20; 973.15, 21.9; 1073.15, 23.7;
    1173.15, 25.4; 1273.15, 27; 1373.15, 28.3]);

  annotation (Documentation(info="<html>
<p>Source:https://www.specialmetals.com/documents/technical-bulletins/inconel/inconel-alloy-c-276.pdf</p>
"));
end C276;
