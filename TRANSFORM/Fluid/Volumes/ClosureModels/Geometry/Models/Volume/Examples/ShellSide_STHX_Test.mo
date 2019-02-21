within TRANSFORM.Fluid.Volumes.ClosureModels.Geometry.Models.Volume.Examples;
model ShellSide_STHX_Test
  extends Icons.Example;
  extends
    TRANSFORM.Fluid.Volumes.ClosureModels.Geometry.Models.Volume.Examples.PartialGeometryTest(
    dimensions_Exp=0.0125,
    crossAreas_Exp=0.0589048623,
    perimeters_Exp=18.84955592,
    surfaceAreas_Exp=25.44690049,
    height_b_Exp=8.363961031,
    Volume_total_Exp=3.180862564,
    dxs_Exp=0.2,
    surfaceArea_total_Exp=763.4070148,
    redeclare ShellSide_STHX geometry(
      length_shell=length_shell,
      D_o_shell=D_o_shell,
      D_i_shell=D_i_shell,
      dheight=dheight,
      nParallel=nParallel,
      nNodes=nNodes,
      height_a=height_a,
      nTubes=nTubes,
      length_tube=length_tube,
      D_o_tube=D_o_tube));
  constant Real nParallel=6;
  constant Integer nNodes=5;
  constant SI.Length length_shell=9;
  constant SI.Length D_o_shell = 1;
  constant SI.Length D_i_shell = 0.5;
  constant SI.Height dheight=sin(pi/4)*length_shell;
  constant SI.Height height_a=2;
  constant Real nTubes = 18;
  constant SI.Length length_tube=15;
  constant SI.Length D_o_tube=0.15;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end ShellSide_STHX_Test;
