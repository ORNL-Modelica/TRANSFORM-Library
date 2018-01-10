within TRANSFORM.Examples.MoltenSaltReactor.Data;
model data_PFL
  extends Icons.Record;

  /*
  Calculate:
  volumes
  surface areas
  hydraulic dimensions
  restrictions (orifices)
  materials
  path lengths for loop
  other volumes (plenums/ pumps)
  size heat exchanger (primary, coolant)
  size steam generator
  size reheater?
  */
  import TRANSFORM.Units.Conversions.Functions.Distance_m.from_inch;
  import TRANSFORM.Units.Conversions.Functions.Area_m2.from_inch2;
  import Modelica.Constants.pi;

  parameter SI.Length cell_width = from_inch(11.430) "Width of square core cell";
  parameter SI.Length cell_cornR = from_inch(3.0/2) "Radius of cell corner post";

  parameter Integer cell_intG_nA = 2 "# of internal graphite-A per cell";
  parameter Integer cell_intG_nB = 3 "# of internal graphite-B per cell";
  parameter SI.Length cell_perimeter_intG_A = from_inch(21.7354) "Internal graphite-A perimeter";
  parameter SI.Length cell_perimeter_intG_B = from_inch(21.8234) "Internal graphite-A perimeter";
  parameter SI.Area cell_crossArea_intG_A = from_inch2(16.4265) "Internal graphite-A cross-sectional area";
  parameter SI.Area cell_crossArea_intG_B = from_inch2(16.4622) "Internal graphite-A cross-sectional area";

  parameter Integer nSpacer = 28 "# of spacers per cell";
  parameter SI.Length cell_diameter_spacer = from_inch(0.142) "Spacer diameter";
  parameter SI.Area cell_crossArea_spacer = 0.25*pi*cell_diameter_spacer^2 "Spacer cross-sectional area";

  parameter SI.Length cell_perimeter_inner_empty = from_inch(36.0108) + 8*pi*from_inch(1.5)*(18.02/360) "perimeter of empty inner cell region";
  parameter SI.Area cell_crossArea_inner_empty = from_inch2(93.2048) "crossArea of empty inner cell region";

end data_PFL;
