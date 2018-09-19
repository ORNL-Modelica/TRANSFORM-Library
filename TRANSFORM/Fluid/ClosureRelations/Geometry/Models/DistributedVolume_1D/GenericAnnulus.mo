within TRANSFORM.Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D;
model GenericAnnulus

  import Modelica.Constants.pi;

  input SI.Length rs_inner[nV] = zeros(nV) "Inner radius"
    annotation (Dialog(group="Inputs"));
  input SI.Length rs_outer[nV] = ones(nV) "Outer radius"
    annotation (Dialog(group="Inputs"));

  extends
    TRANSFORM.Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.GenericPipe(
    final figure=2,
    final dimensions=4*crossAreas ./ perimeters,
    final crossAreas=pi*(rs_outer .^ 2 - rs_inner .^ 2),
    final perimeters=2*pi*(rs_outer + rs_inner),
    surfaceAreas={{if j == 1 then 2*pi*rs_inner[i]*dlengths[i] + 2*pi*rs_outer[i]*dlengths[i] else 0 for j in 1:nSurfaces} for i in 1:nV});

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end GenericAnnulus;
