within TRANSFORM.Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D;
model ShellSide_STHX
  "Shell and Tube HX | Shell Side (use straight geometry for tube side): Shell side of a heat exchanger with correction for unequal overall tube and shell lengths"
  parameter Real nTubes(min=0)=1 "Number of parallel tubes";
  input SI.Length length_shell = 1.0 "Overall shell side length"
    annotation (Dialog(group="Inputs"));
  input SI.Diameter D_o_shell=4*crossAreaEmpty_shell/perimeterEmpty_shell "Outer diameter of shell"
    annotation (Dialog(group="Inputs"));
  input SI.Diameter D_i_shell=0  "Inner diameter of shell"
    annotation (Dialog(group="Inputs"));
  input SI.Area crossAreaEmpty_shell = 0.25*pi*(D_o_shell^2-D_i_shell^2) "Cross-sectional area of an empty shell (i.e., no tubes)"
    annotation (Dialog(group="Inputs"));
  input SI.Length perimeterEmpty_shell = pi*(D_o_shell+D_i_shell) "Wetted perimeter of an empty shell (i.e., no tubes)"
    annotation (Dialog(group="Inputs"));
  input SI.Area surfaceArea_shell = pi*D_o_tube*length_tube*nTubes "Heat Transfer surface area"
    annotation (Dialog(group="Inputs"));
  extends StraightPipe(
      final length = length_shell,
      final dimension = 4*crossAreaEmpty_shell/perimeterEmpty_shell,
      final crossArea = crossArea_shell,
      final perimeter = perimeter_shell,
      final surfaceArea = {if i == 1 then surfaceArea_shell + 0 else 0 for i in 1:nSurfaces});
  input SI.Length length_tube "Overall tube side length"
    annotation (Dialog(group="Inputs: Tube"));
  input SI.Length D_o_tube   "Outer diameter of tubes"
    annotation (Dialog(group="Inputs: Tube"));
  Units.NonDim lengthRatio = length_tube/length_shell "Ratio of tube length to shell length";
  SI.Area crossAreaWithLratio_tube = 0.25*pi*D_o_tube*D_o_tube*nTubes*lengthRatio "Estimate of cross sectional area of tubes (exact if tubes are circular) with an unequal shell-tube length factor correction";
  SI.Length perimeterWithLratio_tube = pi*D_o_tube*nTubes*lengthRatio "Wetted perimeter of tubes in shell with an unequal shell-tube length factor correction";
  SI.Area crossArea_shell = crossAreaEmpty_shell-crossAreaWithLratio_tube "Cross-sectional flow area of shell";
  SI.Length perimeter_shell = perimeterEmpty_shell + perimeterWithLratio_tube "Wetted perimeter of shell";
equation
  assert(crossArea_shell > 0, "Cross flow area of tubes is greater than the area of the empty shell");
  annotation (defaultComponentName="geometry",
    Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end ShellSide_STHX;
