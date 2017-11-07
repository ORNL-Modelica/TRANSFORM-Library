within TRANSFORM.Fluid.Volumes.ClosureModels.Geometry.Models.Volume.Examples;
model StraightPipe_Test
  extends Icons.Example;

  extends
    TRANSFORM.Fluid.Volumes.ClosureModels.Geometry.Models.Volume.Examples.PartialGeometryTest(
    dimensions_Exp=0.3,
    crossAreas_Exp=0.0706858347,
    perimeters_Exp=0.9424777961,
    surfaceAreas_Exp=1.696460033,
    height_b_Exp=8.363961031,
    Volume_total_Exp=3.817035074,
    dxs_Exp=0.2,
    surfaceArea_total_Exp=50.89380099,
    redeclare StraightPipe geometry(
      length=length,
      dimension=dimension,
      dheight=dheight,
      nParallel=nParallel,
      nNodes=nNodes,
      height_a=height_a));

  constant Real nParallel=6;
  constant Integer nNodes=5;
  constant SI.Length length=9;
  constant SI.Length dimension=0.3;
  constant SI.Height dheight=sin(pi/4)*length;
  constant SI.Height height_a=2;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end StraightPipe_Test;
