within TRANSFORM.Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D;
model StandardPipe "StandardPipe | Uses NPS Schedules"
  replaceable model NPS =
      TRANSFORM.Fluid.ClosureRelations.Geometry.NPS.NPS_6
  constrainedby TRANSFORM.Fluid.ClosureRelations.Geometry.NPS.PartialNPSrecord     annotation(Dialog(group="Geometry"),choicesAllMatching=true);
  NPS nps;

  input SI.Length length = 1.0 "Pipe length"
    annotation (Dialog(group="Inputs"));
  input SI.Height roughness = 2.5e-5 "Average heights of surface asperities"
    annotation (Dialog(group="Inputs"));
  input SI.Area surfaceArea[nSurfaces] = {if i == 1 then nps.perimeter*length else 0 for i in 1:nSurfaces} "Area per transfer surface"
   annotation (Dialog(group="Inputs"));
  // Static head
  input SI.Angle angle=0.0 "Vertical angle from the horizontal (-pi/2 < x <= pi/2)"
    annotation (Dialog(group="Inputs Elevation"));
  input SI.Length dheight= length*sin(angle)
    "Height(port_b) - Height(port_a) distributed by flow segment"
    annotation (Dialog(group="Inputs Elevation"));
  extends
    TRANSFORM.Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.GenericPipe(
    final figure=1,
    final dimensions=fill(nps.dimension, nV),
    final crossAreas=fill(nps.crossArea, nV),
    final perimeters=fill(nps.perimeter, nV),
    final dlengths=fill(length/nV, nV),
    final roughnesses=fill(roughness, nV),
    final surfaceAreas=transpose({fill(surfaceArea[i]/nV,nV) for i in 1:nSurfaces}),
    final angles=fill(angle,nV),
    final dheights=fill(dheight/nV, nV));

  extends Icons.UnderConstruction;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end StandardPipe;
