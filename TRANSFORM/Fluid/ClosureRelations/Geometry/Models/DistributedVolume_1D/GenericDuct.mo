within TRANSFORM.Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D;
model GenericDuct

  import Modelica.Constants.pi;

  input SI.Length widths_inner[nV] = zeros(nV) "Inner duct width"
    annotation (Dialog(group="Input Variables"));
  input SI.Length heights_inner[nV] = zeros(nV) "Inner duct height"
    annotation (Dialog(group="Input Variables"));
  input SI.Length widths_outer[nV] = ones(nV) "Outer duct width"
    annotation (Dialog(group="Input Variables"));
  input SI.Length heights_outer[nV] = ones(nV) "Outer duct height"
    annotation (Dialog(group="Input Variables"));

  extends
    TRANSFORM.Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.GenericPipe(
    final figure=3,
    final dimensions=4*crossAreas ./ perimeters,
    final crossAreas=widths_outer .* heights_outer - widths_inner .*
        heights_inner,
    final perimeters=2*widths_outer + 2*heights_outer + 2*widths_inner + 2*
        heights_inner,
    surfaceAreas={2*widths_inner .* dlengths + 2*heights_inner .* dlengths + 2*widths_outer .* dlengths + 2*heights_outer .* dlengths});

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end GenericDuct;
