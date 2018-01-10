within TRANSFORM.Examples.MoltenSaltReactor.Data;
model data_CoreCell
  extends Icons.Record;

  /*
  Note, cells are orificed to provide uniform flow distribution
  This is subject to the model so exact dimensions of ref. design won't necessarilly be used.
  For references:
  In fueled cells:
  At top graphite cap
    - in center of core: diameter_orifice = 0.74 in;
    - at edge of core: diameter_orifice = 2.05 in;
    - scaled accordingly in the middle proportional to radial power
  In control rod cells:
  At bottom of graphite cell:
    - diameter_orifice = 0.5 in;
  */

  import TRANSFORM.Units.Conversions.Functions.Distance_m.from_inch;
  import TRANSFORM.Units.Conversions.Functions.Area_m2.from_inch2;
  import TRANSFORM.Units.Conversions.Functions.Distance_m.from_feet;
  import Modelica.Constants.pi;

  parameter Real nFcells = 357 "# of normal fueled cells";
  parameter Real nCRcells = 6 "# of control rod cells";
  parameter Real nCells = nFcells + nCRcells "# of core cells total";
  parameter Real nRGs = 8 "# of radial graphite reflector regions";

  parameter Integer nIntG_A = 2 "# of internal graphite-A per cell";
  parameter Integer nIntG_B = 3 "# of internal graphite-B per cell";
  parameter SI.Length perimeter_intG_A = from_inch(21.7354) "Internal graphite-A perimeter";
  parameter SI.Length perimeter_intG_B = from_inch(21.8234) "Internal graphite-A perimeter";
  parameter SI.Area crossArea_intG_A = from_inch2(16.4265) "Internal graphite-A cross-sectional area";
  parameter SI.Area crossArea_intG_B = from_inch2(16.4622) "Internal graphite-A cross-sectional area";

  parameter Integer nSpacer = 28 "# of spacers per cell";
  parameter SI.Length diameter_spacer = from_inch(0.142) "Spacer diameter";
  parameter SI.Area crossArea_spacer = 0.25*pi*diameter_spacer^2 "Spacer cross-sectional area";

  parameter SI.Length perimeter_inner_empty = from_inch(36.0108 + 8*pi*1.5*(18.02/360)) "perimeter of empty inner cell region";
  parameter SI.Area crossArea_inner_empty = from_inch2(93.2048) "crossArea of empty inner cell region";
  parameter SI.Area crossArea_extG = from_inch2(11.43^2)-crossArea_inner_empty "Cross area of external graphite box per cell";

  parameter SI.Area crossArea_outer_empty = from_inch2(7.952) "Cross-sectional flow area of outer region of a non-repeated graphite box (approximated from CAD)";
  parameter SI.Area crossArea_extG_whole = from_inch2(14.343^2) - crossArea_outer_empty - crossArea_inner_empty "Cross area of external graphite box whole box (calculated from CAD)";

  parameter Integer nfG = 5+2 "# of characteristic graphite slabs in fueled cell";
  parameter SI.Length length_fG = crossArea_fG/(nfG*width_fG) "Characteric length of graphite slabs in fueled cell";
  parameter SI.Length width_fG = from_inch(1.763) "Characteric width of graphite slabs in fueled cell";

  parameter SI.Area crossArea_fG = crossArea_extG + nIntG_A*crossArea_intG_A + nIntG_B*crossArea_intG_B "Cross-sectional area of graphite per fueled cell";
  parameter SI.Length perimeter_f = perimeter_inner_empty + nIntG_A*perimeter_intG_A + nIntG_B*perimeter_intG_B + nSpacer*pi*diameter_spacer "Wetted perimeter of fueled cell";
  parameter SI.Area crossArea_f = crossArea_inner_empty - nIntG_A*crossArea_intG_A - nIntG_B*crossArea_intG_B - nSpacer*crossArea_spacer "Cross-sectional flow area of fueled cell";

  parameter SI.Length perimeter_crG_inner = from_inch(36.8873 + pi*7.0) "Wetted perimeter of control rod cell inner graphite";
  parameter SI.Area crossArea_crG_inner = from_inch2(87.8893) - 0.25*pi*from_inch(7.0)^2 "Cross-sectional area of control rod cell inner graphite";
  parameter SI.Area crossArea_crG = crossArea_extG + crossArea_crG_inner "Cross-sectional area of control rod cell graphite";
  parameter SI.Length perimeter_cr = perimeter_inner_empty + perimeter_crG_inner "Wetted perimeter of control rod cell (no control rod)";
  parameter SI.Area crossArea_cr = crossArea_inner_empty - crossArea_crG_inner "Cross-sectional flow area of control rod cell (no control rod)";

  parameter SI.Length perimeter_crRod = from_inch(4*(2*2.375+pi*0.375+0.5*pi*0.125)) "Wetted perimeter of control rod";
  parameter SI.Area crossArea_crRod = from_inch2(4*(0.5*pi*0.375^2 + 2.375*0.75 + 0.25*(1.0-pi*0.125^2))) "Cross-sectional area of control rod";

  parameter SI.Length perimeter_crRod_inner = from_inch(4*(2*2.375+pi*0.25+0.5*pi*0.25)) "Alloy-N - Boron carbide interface perimeter of control rod";
  parameter SI.Area crossArea_crRod_BC = from_inch2(4*(0.5*pi*0.25^2 + 2.375*0.5 + 0.25*(1.0-pi*0.25^2))) "Cross-sectional area of Boron carbide in control rod";
  parameter SI.Area crossArea_crRod_alloyN = crossArea_crRod - crossArea_crRod_BC "Cross-sectional area of alloy-N in control rod";

  parameter SI.Length length_cells = from_feet(21) "Length of cells (fueled and control rod)";
  parameter SI.Length length_crRod = length_cells - from_feet(3) "Length of control rods";

  parameter SI.Volume volume_fG = crossArea_fG*length_cells "Volume of graphite per fueled cell";
  parameter SI.Volume volume_f = crossArea_f*length_cells "Volume of fluid per fueled cell";
  parameter SI.Volume volume_crG = crossArea_crG*length_cells "Volume of graphite per control rod cell";
  parameter SI.Volume volume_cr = crossArea_cr*length_cells "Volume of fluid per control rod cell";
  parameter SI.Volume volume_crRod = crossArea_crRod*length_crRod "Volume of each control rod";
  parameter SI.Volume volume_crRod_BC = crossArea_crRod_BC*length_crRod "Volume of boron carbide per control rod";
  parameter SI.Volume volume_crRod_alloyN = crossArea_crRod_alloyN*length_crRod "Volume of alloy-N per control rod";

  parameter SI.Length perimeter_reflR_inner = from_inch(8*(2*12+2*24) + 2*(1.33+25.977+11.271+24)) "Wetted perimeter of inner radial reflector per region";
  parameter SI.Area crossArea_reflR_innerG = from_inch2(8*(12*24) + 2*(151.208)) "Cross-sectional area of the inner graphite radial reflector per region";
  // This is normal gaps + the outer layer of fuel cells box fluid gap of which there are 5.25 cells per graphite region with 1/4 of the flow area present
  parameter SI.Area crossArea_reflR_inner = from_inch2(2641.35 - crossArea_reflR_innerG) + 5.25*0.25*crossArea_outer_empty "Cross-sectional flow area around the inner graphite radial reflector per region";

  parameter SI.Length perimeter_reflR_outer = from_inch(2*59.9877 + 156.727*45*pi/180) "Wetted perimeter of outer radial reflector per region";
  parameter SI.Area crossArea_reflR_outerG = from_inch2(0.5*156.727^2*45*pi/180- 0.5*119.843*156.727*cos(45*pi/180/2)) + from_inch2(11.1156) "Cross-sectional area of the outer graphite radial reflector per region";
  parameter SI.Area crossArea_reflR_outer =  from_inch2(0.5*156.789^2*45*pi/180- 0.5*120.001*156.789*cos(45*pi/180/2)) + from_inch2(25.2654) - crossArea_reflR_outerG "Cross-sectional flow area around the outer graphite radial reflector per region";

  parameter SI.Length length_reflR_inner = from_feet(21) "Length of inner reflector";
  parameter SI.Length length_reflR_outer = from_feet(21) "Length of outer reflector";

  parameter SI.Volume volume_reflR_innerG = crossArea_reflR_innerG*length_reflR_inner "Volume of graphite in inner reflector per region";
  parameter SI.Volume volume_reflR_inner = crossArea_reflR_inner*length_reflR_inner "Volume of fluid in inner reflector per region";
  parameter SI.Volume volume_reflR_outerG = crossArea_reflR_outerG*length_reflR_outer "Volume of graphite in outer reflector per region";
  parameter SI.Volume volume_reflR_outer = crossArea_reflR_outer*length_reflR_outer "Volume of fluid in outer reflector per region";


  // Now calculate the axial reflectors

end data_CoreCell;
