within TRANSFORM.Fluid.Volumes.ClosureModels.Geometry.Models.Volume;
model ShellSide_STHX
  "Shell and Tube HX | Shell Side (use straight geometry for tube side): Shell side of a heat exchanger with correction for unequal overall tube and shell lengths"

  parameter SI.Length length_shell = 1.0 "Overall shell side length"
    annotation (Dialog(group="General"));
  parameter Boolean isAnnulus=false
    "= true if annulus geometry"
    annotation(Dialog(group="General"));
  parameter SI.Diameter D_o_shell=if isAnnulus then 4*crossAreaEmpty_shell/perimeterEmpty_shell else 0  "Outer diameter of shell"
    annotation(Dialog(group="General",enable=not isAnnulus));
  parameter SI.Diameter D_i_shell=0  "Inner diameter of shell"
    annotation(Dialog(group="General",enable=not isAnnulus));
  parameter SI.Area crossAreaEmpty_shell = 0.25*pi*(D_o_shell^2-D_i_shell^2) "Cross-sectional area of an empty shell (i.e., no tubes)"
    annotation(Dialog(group="General",enable=isAnnulus));
  parameter SI.Length perimeterEmpty_shell = pi*(D_o_shell+D_i_shell) "Wetted perimeter of an empty shell (i.e., no tubes)"
    annotation(Dialog(group="General",enable=isAnnulus));
  parameter SI.Area surfaceArea_shell = pi*D_o_tube*length_tube*nTubes "Heat Transfer surface area (not including parallel shells)"
    annotation(Dialog(group="General"));

  extends
    TRANSFORM.Fluid.Volumes.ClosureModels.Geometry.Models.Volume.StraightPipe(
    final length=length_shell,
    final use_Dimension=false,
    final dimension=4*crossAreaEmpty_shell/perimeterEmpty_shell,
    final crossArea=crossArea_shell,
    final perimeter=perimeter_shell,
    final surfaceArea=surfaceArea_shell);

  parameter Real nTubes(min=0)=1 "Number of parallel tubes"
    annotation(Dialog(group="Tube Side"));
  parameter SI.Length length_tube "Overall tube side length"
    annotation (Dialog(group="Tube Side"));
  parameter SI.Length D_o_tube   "Outer diameter of tubes"
   annotation (Dialog(group="Tube Side"));

  final parameter Units.NonDim lengthRatio = length_tube/length_shell "Ratio of tube length to shell length";

  final parameter SI.Area crossAreaWithLratio_tube = 0.25*pi*D_o_tube*D_o_tube*nTubes*lengthRatio "Estimate of cross sectional area of tubes (exact if tubes are circular) with an unequal shell-tube length factor correction";

  final parameter SI.Length perimeterWithLratio_tube = pi*D_o_tube*nTubes*lengthRatio "Wetted perimeter of tubes in shell with an unequal shell-tube length factor correction";

  final parameter SI.Area crossArea_shell = crossAreaEmpty_shell-crossAreaWithLratio_tube "Cross-sectional flow area of shell";

  final parameter SI.Length perimeter_shell = perimeterEmpty_shell + perimeterWithLratio_tube "Wetted perimeter of shell";

equation
  assert(crossArea_shell > 0, "Cross flow area of tubes is greater than the area of the empty shell");

  annotation (defaultComponentName="geometry",
    Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end ShellSide_STHX;
