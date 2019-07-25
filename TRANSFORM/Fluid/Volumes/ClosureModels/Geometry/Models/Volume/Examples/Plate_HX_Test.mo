within TRANSFORM.Fluid.Volumes.ClosureModels.Geometry.Models.Volume.Examples;
model Plate_HX_Test
  extends Icons.Example;
  extends
    TRANSFORM.Fluid.Volumes.ClosureModels.Geometry.Models.Volume.Examples.PartialGeometryTest(
    dimensions_Exp=0.019047619,
    crossAreas_Exp=0.002,
    perimeters_Exp=0.42,
    surfaceAreas_Exp=0.0366666667,
    height_b_Exp=2.353553391,
    Volume_total_Exp=0.006,
    dxs_Exp=0.2,
    surfaceArea_total_Exp=1.1,
    redeclare PlateHX geometry(
      nParallel=nParallel,
      nNodes=nNodes,
      H=H,
      W=W,
      L=L,
      nAreas_NoHT=nAreas_NoHT,
      dheight=dheight,
      height_a=height_a));
  constant Real nParallel=6;
  constant Integer nNodes=5;
  constant SI.Length H=0.01;
  constant SI.Length W=0.2;
  constant SI.Length L=0.5;
  constant Real nAreas_NoHT=1;
  constant SI.Height dheight=sin(pi/4)*L;
  constant SI.Height height_a=2;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Plate_HX_Test;
