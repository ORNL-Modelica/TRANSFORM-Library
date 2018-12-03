within TRANSFORM.HeatAndMassTransfer.ClosureRelations.Geometry.Models;
partial model PartialGeometry_1D

  parameter Integer figure=1 "Index for Icon figure" annotation (choices(
      choice=1 "Plane",
      choice=2 "Cylinder",
      choice=3 "Sphere"));

  parameter Integer ns[1](min=1) = {1} "Number of nodes in each dimension {1}";

  final parameter Integer n_total=ns[1] "Total number of nodes";

  parameter Boolean closedDim_1(fixed=false) "=true if the conduction path is closed on itself for specified dimension";

  output SI.Volume Vs[ns[1]] "Unit volumes" annotation (Dialog(
      tab="Internal Interface",
      group="Outputs",
      enable=false));
  output SI.Area crossAreas_1[ns[1] + 1]
    "Cross sectional area of unit volume faces perpendicular to dimension-1"
    annotation (Dialog(
      group="Outputs",
      tab="Internal Interface",
      enable=false));
  output SI.Length dlengths_1[ns[1]] "Unit cell length in dimension-1"
    annotation (Dialog(
      group="Outputs",
      tab="Internal Interface",
      enable=false));

  SI.Volume V_total=sum(Vs) "Total volume of component";

  SI.Area surfaceAreas_2a[ns[1]] "Surface area in non-discretized dimension 2a";
  SI.Area surfaceAreas_2b[ns[1]] "Surface area in non-discretized dimension 2a";
  SI.Area surfaceAreas_3a[ns[1]] "Surface area in non-discretized dimension 3a";
  SI.Area surfaceAreas_3b[ns[1]] "Surface area in non-discretized dimension 3b";

  SI.Area surfaceAreas_2[ns[1]]={surfaceAreas_2a[i] + surfaceAreas_2b[i] for i in
          1:ns[1]} "Dimension 2 discretized surface area";
  SI.Area surfaceAreas_3[ns[1]]={surfaceAreas_3a[i] + surfaceAreas_3b[i] for i in
          1:ns[1]} "Dimension 3 discretized surface area";
  SI.Area surfaceAreas_23[ns[1]]={surfaceAreas_2[i] + surfaceAreas_3[i] for i in
          1:ns[1]} "Dimension 2 and 3 total discretized surface area";
  SI.Area surfaceArea_total=sum(surfaceAreas_23) "Total surface area";

  SI.Length cs_1[ns[1]] "Unit cell centers dimension-1 cartesian coordinate";


  annotation (
    defaultComponentName="geometry",
    Icon(coordinateSystem(preserveAspectRatio=false), graphics={Bitmap(extent={{
              -116,-100},{116,100}}, fileName="modelica://TRANSFORM/Resources/Images/Icons/Geometry_genericVolume.jpg")}),
    Diagram(coordinateSystem(preserveAspectRatio=false)));

end PartialGeometry_1D;
