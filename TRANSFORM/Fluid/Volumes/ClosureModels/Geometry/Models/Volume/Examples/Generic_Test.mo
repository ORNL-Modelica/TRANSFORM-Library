within TRANSFORM.Fluid.Volumes.ClosureModels.Geometry.Models.Volume.Examples;
model Generic_Test
  extends Icons.Example;
  extends TRANSFORM.Fluid.Volumes.ClosureModels.Geometry.Models.Volume.Examples.PartialGeometryTest(
    dimensions_Exp=0.7525,
    crossAreas_Exp=0.4447366188,
    perimeters_Exp=2.364048472,
    surfaceAreas_Exp=7.683157533,
    height_b_Exp=21.44543648,
    Volume_total_Exp=22.42081046,
    dxs_Exp=0.1181818182,
    surfaceArea_total_Exp=156.8047433,
    redeclare Generic geometry(
      nParallel=nParallel,
      nNodes=nNodes,
      lengths=lengths,
      dimensions=dimensions,
      dheights=dheights,
      height_a=height_a));
  constant Real nParallel=6;
  constant Integer nNodes=5;
  constant SI.Length[nNodes] lengths=linspace(
      1,
      10,
      nNodes);
  constant SI.Length[nNodes] dimensions=linspace(
      1,
      0.01,
      nNodes);
  constant SI.Height[nNodes] dheights=sin(pi/4)*lengths;
  constant SI.Height height_a=2;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Generic_Test;
