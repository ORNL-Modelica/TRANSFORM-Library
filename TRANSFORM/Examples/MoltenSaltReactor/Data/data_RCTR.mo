within TRANSFORM.Examples.MoltenSaltReactor.Data;
model data_RCTR
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
  import TRANSFORM.Units.Conversions.Functions.MassFlowRate_kg_s.from_lbm_hr;
  import TRANSFORM.Units.Conversions.Functions.Temperature_K.from_degF;
  import Modelica.Constants.pi;

  parameter SI.Power Q_nominal = 750e6 "Nominal power of reactor";
  parameter SI.Power Q_nominal_fuelcell = Q_nominal/nFcells "Approximate nominal power output per fuel cell";
  parameter SI.Temperature T_inlet_core = from_degF(1050) "Inlet core temperature";
  parameter SI.Temperature T_outlet_core = from_degF(1250) "Outlet core temperature";
  parameter SI.SpecificHeatCapacity cp = TRANSFORM.Media.Fluids.FLiBe.Utilities_12Th_05U.cp_T(0.5*(T_inlet_core+T_outlet_core)) "Heat capacity of PFL fluid";
  parameter SI.TemperatureDifference dT_core = Q_nominal/(m_flow*cp) "Expected temperature difference across core";

  parameter SI.Velocity vs_reflA_core = TRANSFORM.Units.Conversions.Functions.Velocity_m_s.from_feet_s(7) "Velocity of fueled and control rod cells region in top axial reflector";
  parameter SI.Velocity vs_reflA_reflR = TRANSFORM.Units.Conversions.Functions.Velocity_m_s.from_feet_s(1) "Velocity of radial reflector region in top axial reflector";

  parameter SI.MassFlowRate m_flow = from_lbm_hr(6*6.6e6) "Total mass flow rate through reactor";

  parameter Real nFcells = 357 "# of normal fueled cells";
  parameter Real nCRcells = 6 "# of control rod cells";
  parameter Real nCells = nFcells + nCRcells "# of core cells total";

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
  parameter SI.Area crossArea_extG_whole = from_inch2(14.343^2) - crossArea_outer_empty - crossArea_inner_empty "Cross area of external graphite box whole box (calculated from CAD) - i.e., little extra bit between fuel cells and inner radial reflector";

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

  // Axial graphite reflector
  parameter Integer nRegions = 8 "Number of identiical radial reflector regions";

  parameter SI.Length perimeter_reflR_inner = from_inch(8*(2*12+2*24) + 2*(1.33+25.977+11.271+24)) "Wetted perimeter of inner radial reflector per region";
  parameter SI.Area crossArea_reflR_innerG = from_inch2(8*(12*24) + 2*(151.208)) "Cross-sectional area of the inner graphite radial reflector per region";
  // This is normal gaps + the outer layer of fuel cells box fluid gap of which there are 5.25 cells per graphite region with 1/4 of the flow area present
  parameter SI.Area crossArea_reflR_inner = from_inch2(2641.35) - crossArea_reflR_innerG + 5.25*0.25*crossArea_outer_empty "Cross-sectional flow area around the inner graphite radial reflector per region";

  parameter SI.Length perimeter_reflR_outer = from_inch(2*59.9877 + 156.727*45*pi/180) "Wetted perimeter of outer radial reflector per region";
  parameter SI.Area crossArea_reflR_outerG = from_inch2(0.5*156.727^2*45*pi/180- 0.5*119.843*156.727*cos(45*pi/180/2)) + from_inch2(11.1156) "Cross-sectional area of the outer graphite radial reflector per region";
  parameter SI.Area crossArea_reflR_outer =  from_inch2(0.5*156.789^2*45*pi/180- 0.5*120.001*156.789*cos(45*pi/180/2)) + from_inch2(25.2654) - crossArea_reflR_outerG "Cross-sectional flow area around the outer graphite radial reflector per region";

  parameter SI.Area crossArea_reflR = crossArea_reflR_inner + crossArea_reflR_outer "Total cross-sectional flow area of axial graphite reflector per region";
  parameter SI.Length perimeter_reflR = perimeter_reflR_inner + perimeter_reflR_outer "Total wetted perimeter of axial graphite reflector per region";

  parameter SI.Length length_reflR_inner = from_feet(21) "Length of inner reflector";
  parameter SI.Length length_reflR_outer = from_feet(21) "Length of outer reflector";
  parameter SI.Length length_reflR = 0.5*(length_reflR_inner+length_reflR_outer) "Characteristic length of radial reflector";

  parameter SI.Volume volume_reflR_innerG = crossArea_reflR_innerG*length_reflR_inner "Volume of graphite in inner radial reflector per region";
  parameter SI.Volume volume_reflR_inner = crossArea_reflR_inner*length_reflR_inner "Volume of fluid in inner radial reflector per region";
  parameter SI.Volume volume_reflR_outerG = crossArea_reflR_outerG*length_reflR_outer "Volume of graphite in outer radial reflector per region";
  parameter SI.Volume volume_reflR_outer = crossArea_reflR_outer*length_reflR_outer "Volume of fluid in outer radial reflector per region";
  parameter SI.Volume volume_reflR_G = volume_reflR_innerG + volume_reflR_outerG "Total volume of graphite in radial reflector per region";
  parameter SI.Volume volume_reflR = volume_reflR_inner + volume_reflR_outer "Total volume of fluid in radial reflector per region";

  parameter SI.Length length_reflR_blockG = from_inch(24) "length of reflR block";
  parameter SI.Length width_reflR_blockG = from_inch(12) "width of reflR block";
  parameter SI.Volume volume_reflR_blockG = length_reflR_blockG*width_reflR_blockG*length_reflR "Volume of characteristic radial reflector block";

  parameter Real n_reflR_blockG = volume_reflR_G/volume_reflR_blockG "# of characteristic blocks of graphite in radial reflector per region";

  // Now calculate the axial reflectors
  parameter Integer nAs = 2 "# of axial reflectors";
  parameter Integer nARs = 13 "# of axial reflector rings";
  parameter SI.Length length_reflA = from_inch(48) "Vertical length of each axial reflector";
  parameter SI.Length length_reflA_edge = from_inch(42) "Vertical length to start edge of each axial reflector";
  parameter SI.Length radius_reflA = from_inch(311/2) "Radius of each axial reflector";
  parameter SI.Length radius_reflA_edge = from_inch(156/2) "Radius to start edge of each axial reflector";
  parameter SI.Length length_reflA_ring_cell = radius_reflA/nARs "Length of ring unit cell";
  parameter SI.Length width_reflA_channel[nARs+1] = from_inch({0.14,0.14,0.22,0.25,0.24,0.24,0.22,0.20,0.16,0.16,0.11,0.07,0.03,0.02}) "Width of channels between axial reflector blocks"; //[1] is the diameter assumed of the center whole
  parameter SI.Length length_reflA_ring[nARs] = from_inch({48,48,48,48,48,48,48,42,36,30,24,18,12}) "Vertical length of each axial reflector ring";
  parameter Integer nGaps[nARs] = {0,3,4,8,8,12,12,12,12,12,12,12,12} "# of gaps in each axial reflector ring";

  parameter SI.Volume volume_reflA_reg = pi*radius_reflA_edge^2*(length_reflA_edge) + 0.5*pi*length_reflA_edge*(radius_reflA^2 - radius_reflA_edge^2) + pi*radius_reflA^2*(length_reflA-length_reflA_edge) "Volume of each axial reflector region (no fuel channels) - approximate for checking";
  //parameter SI.Area crossArea_reflA_reg_avg = volume_reflA_reg/length_reflA "Cross-sectional area (avg) of each axial reflector region (no fuel channels)";

  parameter SI.Length rs_ring_cell[nARs+1] = cat(1,{0},{rs_ring_cell[i-1] + length_reflA_ring_cell for i in 2:nARs+1}) "Radial position of axial reflector ring unit cells";
  parameter SI.Length rs_ring_edge_inner[nARs] = {rs_ring_cell[i] + 0.5*width_reflA_channel[i] for i in 1:nARs} "Radial position of the inner edge of each axial reflector graphite ring";
  parameter SI.Length rs_ring_edge_outer[nARs] = {rs_ring_cell[i+1] - 0.5*width_reflA_channel[i+1] for i in 1:nARs} "Radial position of the outer edge of each axial reflector graphite ring";
  parameter SI.Length rs_ring_edge[2*nARs] = {if rem(i,2)==0 then rs_ring_edge_outer[integer(i/2)] else rs_ring_edge_inner[integer((i+1)/2)] for i in 1:2*nARs} "Radial position of each graphite ring edge";
  parameter SI.Length width_reflA_blocks[nARs] = {rs_ring_edge_outer[i]-rs_ring_edge_inner[i] for i in 1:nARs} "Width of graphite blocks in each axial reflector ring";

  parameter SI.Length perimeters_reflA_ring[nARs] = {2*pi*rs_ring_edge_inner[i]-nGaps[i]*width_reflA_channel[i+1]+2*nGaps[i]*width_reflA_blocks[i] + 2*pi*rs_ring_edge_outer[i]-nGaps[i]*width_reflA_channel[i+1] for i in 1:nARs} "Wetted perimeter of graphite for each axial reflector ring";

  parameter SI.Area crossAreas_reflA_ring_radial[nARs]={if i==1 then rs_ring_edge[i]^2*pi else pi*(rs_ring_edge[integer(2*i-1)]^2 - rs_ring_edge[integer(2*(i-1))]^2) for i in 1:nARs} " Cross-sectional flow area(excluding gaps in ring) of each ring";
  parameter SI.Area crossAreas_reflA_ring_gaps[nARs] = {nGaps[i]*width_reflA_blocks[i]*width_reflA_channel[i+1] for i in 1:nARs}  "Cross-sectional flow area of gaps within each ring each axial reflector ring";

  parameter SI.Area crossAreas_reflA_ring[nARs] = crossAreas_reflA_ring_gaps + crossAreas_reflA_ring_radial  "Cross-sectional flow area in each axial reflector ring";
  parameter SI.Area crossAreas_reflA_ringG[nARs] = {(rs_ring_edge_outer[i]^2 - rs_ring_edge_inner[i]^2)*pi - crossAreas_reflA_ring_gaps[i] for i in 1:nARs}  "Cross-sectional area of graphite in each axial reflector ring";
  parameter SI.Area crossArea_reflA_ring = sum(crossAreas_reflA_ring) "Total cross-sectional flow area in each axial reflector";
  parameter SI.Area crossArea_reflA_ringG = sum(crossAreas_reflA_ringG) "Total cross-sectional area of graphite in each axial reflector";
  parameter SI.Length perimeter_reflA_ring = sum(perimeters_reflA_ring) "Total wetted perimeter of graphite in each axial reflector";

  parameter Real n_reflA_ringG = volume_reflA_ringG/(length_reflA*crossAreas_reflA_ringG[6]/nGaps[6]) "# of characteristic graphite pieces in ring - assumed based on ring 6";
  parameter SI.Angle angle_reflA_ring_blockG = SI.Conversions.from_deg(29.8085) "Angle to conserve volume of graphite (removes small spacing between graphite blocks within ring)";

  parameter SI.Volume volumes_reflA_ring[nARs] = crossAreas_reflA_ring.*length_reflA_ring "Volume of fluid in each axial reflector ring";
  parameter SI.Volume volumes_reflA_ringG[nARs] = crossAreas_reflA_ringG.*length_reflA_ring "Volume of graphite in each axial reflector ring";
  parameter SI.Volume volume_reflA_ring = sum(volumes_reflA_ring) "Total volume of fluid in each axial reflector";
  parameter SI.Volume volume_reflA_ringG = sum(volumes_reflA_ringG) "Total volume of graphite in each axial reflector";

  // Plenum
  parameter SI.Area crossArea_plenum = from_inch2(0.25*pi*156^2) "Cross-sectional area of each plenum";
  parameter SI.Length length_plenum = from_inch(18) "Vertical length of each plenum, assume whole cylinder";
  parameter SI.Volume volume_plenum = crossArea_plenum*length_plenum "Approximate volume of each plenum";

  // Reactor Inlet Tee
  parameter SI.Area crossArea_tee_inlet = from_inch2(0.25*pi*28^2) "Cross-sectional area of the inlet tee";
  parameter SI.Length length_tee_inlet = from_inch(42) "Vertical length of the inlet tee";
  parameter SI.Volume volume_tee_inlet = crossArea_tee_inlet*length_tee_inlet "Volume of the inlet tee";
  parameter SI.Length diameter_tee_pipe = from_inch(12) "Diameter of pipe into the inlet tee";
  parameter SI.Length diameter_pipe_draintank = from_inch(6) "Diameter of pipe between the inlet tee and drain tank";

  // Reactor/Pump Overflow line
  parameter SI.Area crossArea_tee_overflow = from_inch2(0.25*pi*18^2) "Cross-sectional area of the pump overflow that enters the top of the reactor";
  parameter SI.Length length_tee_overflow = from_inch(24) "Vertical length of the pump overflow";
  parameter SI.Volume volume_tee_overflow = crossArea_tee_overflow*length_tee_overflow "Volume of the pump overflow";
  parameter SI.Length diameter_pipe_overflow = from_inch(6) "Diameter of pump overflow pipe";

  // Pipe to drain tank
  parameter SI.Length diameter_pumpPipe_inlet = from_inch(17) "Diameter of pipe leaving reactor and entering pump";

  // Reactor Vessel
  parameter String Material_rtr_wall = "Alloy-N" "Material of reactor vessel";
  parameter SI.Length th_rtr_wall = from_inch(2) "Thickness of reactor vessel wall";
  parameter SI.Length radius_rtr_outer = from_inch(318/2) "Outer radius of reactor vessel";

  // Pump
  parameter SI.Length D_pumpbowl = from_inch(48) "Diameter of pump bowl - guess";
  parameter SI.Length length_pumpbowl = from_inch(48) "Vertical height of pumpbowl";
  parameter SI.Area crossArea_pumpbowl = 0.25*pi*D_pumpbowl^2 "Cross-sectional area of pumpbowl";
  parameter SI.Volume volume_pumpbowl = crossArea_pumpbowl*length_pumpbowl "Total pumpbowl volume";
  parameter SI.Length level_pumpbowlnominal = from_inch(24) "Nominal level of fluid in pumpbowl";
  parameter SI.Volume volume_pumpbowlnominal = crossArea_pumpbowl*level_pumpbowlnominal "Nominal fluid volume of pumpbowl";

  // what is the length to use to for axial reflector?

end data_RCTR;
