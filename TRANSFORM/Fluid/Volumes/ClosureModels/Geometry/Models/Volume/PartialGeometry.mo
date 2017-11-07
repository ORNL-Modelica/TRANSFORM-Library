within TRANSFORM.Fluid.Volumes.ClosureModels.Geometry.Models.Volume;
partial model PartialGeometry

  parameter Real nParallel(min=1)=1 "Number of identical parallel components"
    annotation(Dialog);

  parameter Integer nNodes(min=1)=2 "Number of discrete serial nodes"
    annotation(Dialog,  Evaluate=true);

  parameter SI.Length[nNodes] lengths = ones(nNodes) "Length of node segment"
    annotation (Dialog(group="General"));
  parameter Boolean use_Dimensions=true
    "=true to specify characteristic dimension"
   annotation(Dialog(group="General"), Evaluate=true);
  parameter SI.Length[nNodes] dimensions = if use_Dimensions then zeros(nNodes) else 4*crossAreas./perimeters "Characteristic dimension (e.g., hydraulic diameter)"
   annotation (Dialog(group="General", enable=use_Dimensions));
  parameter SI.Area[nNodes] crossAreas = pi*dimensions.*dimensions./4 "Cross-sectional flow areas"
   annotation (Dialog(group="General", enable=not use_Dimensions));
  parameter SI.Length[nNodes] perimeters=4*crossAreas./dimensions "Wetted perimeters"
   annotation (Dialog(group="General", enable=not use_Dimensions));
  parameter SI.Height[nNodes] roughnesses = fill(2.5e-5,nNodes) "Average heights of surface asperities"
    annotation (Dialog(group="General"));

  // Heat Transfer
  parameter SI.Area[nNodes] surfaceAreas = perimeters.*lengths
    "Heat transfer surface area of each volume node (not including parallel)"
  annotation (Dialog(group="Heat transfer"));

  // Static head
  parameter SI.Length[nNodes] dheights=fill(0,nNodes)
    "Height(port_b) - Height(port_a) distributed by flow segment"
    annotation (Dialog(group="Static head"), Evaluate=true);
  parameter SI.Length height_a=0
    "Elevation at port_a: Reference value only. No impact on calculations."
    annotation (Dialog(group="Static head"), Evaluate=true);
  final parameter SI.Length height_b=height_a + sum(dheights)
    "Elevation at port_b: Reference value only. No impact on calculations."
    annotation (Dialog(group="Static head", enable= false), Evaluate=true);

  final parameter Real[nNodes] dxs = lengths/sum(lengths) "Fractional lengths";

  final parameter SI.Volume[nNodes] nodeVolume = crossAreas.*lengths "Volume of discrete serial nodes (not including parallel)";
  final parameter SI.Volume[nNodes] nodeVolume_parallel = nodeVolume*nParallel "Total volume of parallel nodes";
  final parameter SI.Volume nodeVolume_serial = sum(nodeVolume) "Total volume of serial nodes";
  final parameter SI.Volume Volume_total = nodeVolume_serial*nParallel "Total component volume";

  final parameter SI.Area[nNodes] surfaceArea_parallel = surfaceAreas*nParallel "Total heat transfer surface area of parallel nodes";
  final parameter SI.Area surfaceArea_serial = sum(surfaceAreas) "Total heat transfer surface area of serial nodes";
  final parameter SI.Area surfaceArea_total = surfaceArea_serial*nParallel "Total heat transfer surface area";
equation
  for i in 1:nNodes loop
    assert(dimensions[i]>0, "Characteristic dimension must be > 0");
    assert(lengths[i] >= abs(dheights[i]), "Parameter lengths must be greater or equal to abs(dheights)");
  end for;

  annotation (defaultComponentName="geometry",
    Icon(coordinateSystem(preserveAspectRatio=false), graphics={
          Bitmap(extent={{-116,-100},{116,100}}, fileName=
              "modelica://TRANSFORM/Resources/Images/Icons/Geometry_genericVolume.jpg")}),
                                                                 Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end PartialGeometry;
