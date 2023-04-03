within TRANSFORM.Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D;
model StraightPipe
  input SI.Length dimension = 4*crossArea/perimeter "Characteristic dimension (e.g., hydraulic diameter)"
   annotation (Dialog(group="Inputs"));
  input SI.Area crossArea = pi*dimension*dimension/4 "Cross-sectional flow areas"
   annotation (Dialog(group="Inputs"));
  input SI.Length perimeter=4*crossArea/dimension "Wetted perimeters"
   annotation (Dialog(group="Inputs"));
  input SI.Length length = 1.0 "Pipe length"
    annotation (Dialog(group="Inputs"));
  input SI.Height roughness = 2.5e-5 "Average heights of surface asperities"
    annotation (Dialog(group="Inputs"));
  input SI.Area surfaceArea[nSurfaces] = {if i == 1 then perimeter*length else 0 for i in 1:nSurfaces} "Area per transfer surface"
   annotation (Dialog(group="Inputs"));
  // Static head
  input SI.Angle angle=0.0 "Vertical angle from the horizontal (-pi/2 < x <= pi/2)"
    annotation (Dialog(group="Inputs Elevation"));
  input SI.Length dheight= length*sin(angle)
    "Height(port_b) - Height(port_a) distributed by flow segment"
    annotation (Dialog(group="Inputs Elevation"));
  extends TRANSFORM.Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.GenericPipe(
    final figure=1,
    final dimensions=fill(4*crossArea/perimeter, nV),
    final crossAreas=fill(crossArea, nV),
    final perimeters=fill(perimeter, nV),
    final dlengths=fill(length/nV, nV),
    final roughnesses=fill(roughness, nV),
    final surfaceAreas=transpose({fill(surfaceArea[i]/nV,nV) for i in 1:nSurfaces}),
    final angles=fill(angle,nV),
    final dheights=fill(dheight/nV, nV));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end StraightPipe;
