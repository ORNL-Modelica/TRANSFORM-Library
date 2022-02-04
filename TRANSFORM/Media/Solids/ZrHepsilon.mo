within TRANSFORM.Media.Solids;
package ZrHepsilon "ZrHx x=1.9"
  //NTP1-EMEM-21-0002 rev 000
  constant Real X = 1.9;
  constant Modelica.Units.SI.Density d0 = 1/(0.1706 + 0.0042*X)*1000;
  extends Interfaces.Solids.PartialSimpleAlloy_TableBased(
    mediumName="ZrH1p9",
    T_min=1,
    T_max=1000,
    tableDensity=[T_min,d0; T_max,d0],
    tableHeatCapacity=[T_min, 0.1447;
                         100, 0.1447;
                         150, 0.2030;
                         200, 0.2587;
                         250, 0.3116;
                         300, 0.3619;
                         350, 0.4094;
                         400, 0.4543;
                         450, 0.4966;
                         500, 0.5361;
                         550, 0.5730;
                         600, 0.6071;
                         650, 0.6386;
                         700, 0.6675;
                         750, 0.6936;
                         800, 0.7171;
                         850, 0.7378;
                         900, 0.7559;
                         950, 0.7714;
                       T_max, 0.7714],
    tableConductivity=[T_min, 37.6;
                         300, 37.6;
                         350, 36.8;
                         400, 35.8;
                         450, 34.8;
                         500, 33.8;
                         550, 32.7;
                         600, 31.6;
                         650, 30.5;
                         700, 29.4;
                         750, 28.3;
                         800, 27.2;
                         850, 26.1;
                         900, 25.0;
                         950, 23.9;
                        T_max,23.9]);

end ZrHepsilon;
