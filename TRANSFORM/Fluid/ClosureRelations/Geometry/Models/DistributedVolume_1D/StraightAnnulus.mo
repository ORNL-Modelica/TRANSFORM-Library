within TRANSFORM.Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D;
model StraightAnnulus

  import Modelica.Constants.pi;

  input SI.Length r_inner = 0 "Inner radius"
    annotation (Dialog(group="Inputs"));
  input SI.Length r_outer = 1.0 "Outer radius"
    annotation (Dialog(group="Inputs"));

  input SI.Length length = 1.0 "Pipe length"
    annotation (Dialog(group="Inputs"));
  input SI.Height roughness = 2.5e-5 "Average heights of surface asperities"
    annotation (Dialog(group="Inputs"));

  input SI.Area surfaceArea[nSurfaces] = {if i == 1 then 2*pi*r_inner*length + 2*pi*r_outer*length else 0 for i in 1:nSurfaces} "Area per transfer surface"
   annotation (Dialog(group="Inputs"));

  // Static head
  input SI.Angle angle=0.0 "Vertical angle from the horizontal  (-pi/2 < x <= pi/2)"
    annotation (Dialog(group="Inputs Elevation"));
  input SI.Length dheight= length*sin(angle)
    "Height(port_b) - Height(port_a) distributed by flow segment"
    annotation (Dialog(group="Inputs Elevation"));

  extends
    TRANSFORM.Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.GenericPipe(
    final figure=2,
    final dimensions=4*crossAreas ./ perimeters,
    final crossAreas=fill(pi*(r_outer^2 - r_inner^2), nV),
    final perimeters=fill(2*pi*(r_outer + r_inner), nV),
    final dlengths=fill(length/nV, nV),
    final roughnesses=fill(roughness, nV),
    final surfaceAreas=transpose({fill(surfaceArea[i]/nV,nV) for i in 1:nSurfaces}),
    final angles=fill(angle,nV),
    final dheights=fill(dheight/nV, nV));

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end StraightAnnulus;
