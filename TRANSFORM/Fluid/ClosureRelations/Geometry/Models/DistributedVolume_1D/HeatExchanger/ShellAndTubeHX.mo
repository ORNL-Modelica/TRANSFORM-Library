within TRANSFORM.Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.HeatExchanger;
model ShellAndTubeHX
  input SI.Diameter D_i_shell=0  "Inner diameter of shell (if shell is an annulus)"
    annotation(Dialog(tab="Shell Side",group="Inputs"));
  input SI.Diameter D_o_shell=4*crossAreaEmpty_shell/perimeterEmpty_shell  "Outer diameter of shell"
    annotation(Dialog(tab="Shell Side",group="Inputs"));
  input SI.Area crossAreaEmpty_shell = 0.25*pi*(D_o_shell^2-D_i_shell^2) "Cross-sectional area of an empty shell (i.e., no tubes)"
    annotation(Dialog(tab="Shell Side",group="Inputs"));
  input SI.Length perimeterEmpty_shell = pi*(D_o_shell+D_i_shell) "Wetted perimeter of an empty shell (i.e., no tubes)"
    annotation(Dialog(tab="Shell Side",group="Inputs"));
  extends StraightPipeHX(
  surfaceArea_shell={if i ==1 then pi*D_o_tube*length_tube*nTubes else 0 for i in 1:nSurfaces_shell},
  final dimension_shell = 4*crossAreaNew_shell/perimeterNew_shell,
  final crossArea_shell=crossAreaNew_shell,
  final perimeter_shell=perimeterNew_shell);
  // Translate input parameters to best estimate of dimensions for closure models (i.e., flow and heat transfer models)
protected
  Units.NonDim lengthRatio = length_tube/length_shell "Ratio of tube length to shell length";
  SI.Area crossAreaModded_tube = 0.25*pi*D_o_tube^2*nTubes*lengthRatio "Estimate of cross sectional area of tubes (exact if tubes are circular) with an unequal shell-tube length factor correction";
  SI.Length perimeterModded_tube = pi*D_o_tube*nTubes*lengthRatio "Wetted perimeter of tubes in shell with an unequal shell-tube length factor correction";
  SI.Area crossAreaNew_shell = crossAreaEmpty_shell-crossAreaModded_tube "Cross-sectional flow area of shell";
  SI.Length perimeterNew_shell = perimeterEmpty_shell + perimeterModded_tube "Wetted perimeter of shell";
equation
  assert(crossAreaNew_shell > 0, "Cross flow area of tubes is greater than the area of the empty shell");
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end ShellAndTubeHX;
