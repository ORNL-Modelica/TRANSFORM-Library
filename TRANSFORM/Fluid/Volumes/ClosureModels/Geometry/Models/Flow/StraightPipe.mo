within TRANSFORM.Fluid.Volumes.ClosureModels.Geometry.Models.Flow;
model StraightPipe

  input SI.Length length = 1.0 "Length for flow models"
    annotation (Dialog(group="General"));
  parameter Boolean use_Dimension=true
    "=true to specify characteristic dimension"
   annotation(Dialog(group="General"), Evaluate=true);
  input SI.Length dimension = if use_Dimension then 0.0 else 4*crossArea/perimeter "Characteristic dimension (e.g., hydraulic diameter)"
   annotation (Dialog(group="General", enable=use_Dimension));
  input SI.Area crossArea = pi*dimension*dimension/4 "Cross-sectional flow areas"
   annotation (Dialog(group="General", enable=not use_Dimension));
  input SI.Length perimeter=4*crossArea/dimension "Wetted perimeters"
   annotation (Dialog(group="General", enable=not use_Dimension));
  input SI.Height roughness = 2.5e-5 "Average heights of surface asperities"
    annotation (Dialog(group="General"));

  // Static head
  input SI.Length dheight= 0.0
    "Height(port_b) - Height(port_a) distributed by flow segment"
    annotation (Dialog(group="Static head"), Evaluate=true);

  extends
    TRANSFORM.Fluid.Volumes.ClosureModels.Geometry.Models.Flow.PartialGeometry(
    final lengths=fill(length/nNodes, nNodes),
    final use_Dimensions=use_Dimension,
    final dimensions=fill(4*crossArea/perimeter, nNodes + 1),
    final crossAreas=fill(crossArea, nNodes + 1),
    final perimeters=fill(perimeter, nNodes + 1),
    final roughnesses=fill(roughness, nNodes + 1),
    final dheights=fill(dheight/nNodes, nNodes));

  annotation (defaultComponentName="geometry",
    Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end StraightPipe;
