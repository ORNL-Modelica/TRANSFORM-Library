within TRANSFORM.Fluid.Volumes.ClosureModels.Geometry.Models.Volume;
model StraightPipe

  parameter SI.Length length = 1.0 "Length for flow models"
    annotation (Dialog(group="General"));
  parameter Boolean use_Dimension=true
    "=true to specify characteristic dimension"
   annotation(Dialog(group="General"), Evaluate=true);
  parameter SI.Length dimension = if use_Dimension then 0.0 else 4*crossArea/perimeter "Characteristic dimension (e.g., hydraulic diameter)"
   annotation (Dialog(group="General", enable=use_Dimension));
  parameter SI.Area crossArea = pi*dimension*dimension/4 "Cross-sectional flow areas"
   annotation (Dialog(group="General", enable=not use_Dimension));
  parameter SI.Length perimeter=4*crossArea/dimension "Wetted perimeters"
   annotation (Dialog(group="General", enable=not use_Dimension));
  parameter SI.Height roughness = 2.5e-5 "Average heights of surface asperities"
    annotation (Dialog(group="General"));

  // Heat Transfer
  parameter SI.Area surfaceArea = perimeter*length
    "Heat transfer surface area (not including parallel)"
  annotation (Dialog(group="Heat transfer"));

  // Static head
  parameter SI.Length dheight= 0.0
    "Height(port_b) - Height(port_a) distributed by flow segment"
    annotation (Dialog(group="Static head"), Evaluate=true);

  extends
    TRANSFORM.Fluid.Volumes.ClosureModels.Geometry.Models.Volume.PartialGeometry(
    final lengths=fill(length/nNodes, nNodes),
    final use_Dimensions=use_Dimension,
    final dimensions=fill(4*crossArea/perimeter, nNodes),
    final crossAreas=fill(crossArea, nNodes),
    final perimeters=fill(perimeter, nNodes),
    final roughnesses=fill(roughness, nNodes),
    final surfaceAreas=fill(surfaceArea/nNodes, nNodes),
    final dheights=fill(dheight/nNodes, nNodes));

  annotation (defaultComponentName="geometry",
    Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end StraightPipe;
