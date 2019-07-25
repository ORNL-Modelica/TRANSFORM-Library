within TRANSFORM.HeatAndMassTransfer.ClosureRelations.Geometry.Models;
partial model PartialGeometry_2D
  parameter Integer figure=1 "Index for Icon figure" annotation (choices(
      choice=1 "Plane",
      choice=2 "Cylinder",
      choice=3 "Sphere"));
  parameter Integer ns[2](min=1) = {1,1}
    "Number of nodes in each dimension {1,2}";
  final parameter Integer n_total=ns[1]*ns[2] "Total number of nodes";
  parameter Boolean closedDim_1[ns[2]](fixed=false) "=true if the conduction path is closed on itself for specified dimension" annotation(Dialog(tab="Internal Interface"));
  parameter Boolean closedDim_2[ns[1]](fixed=false) "=true if the conduction path is closed on itself for specified dimension" annotation(Dialog(tab="Internal Interface"));
  output SI.Volume Vs[ns[1],ns[2]] "Unit volumes" annotation (Dialog(
      tab="Internal Interface",
      group="Outputs",
      enable=false));
  output SI.Area crossAreas_1[ns[1] + 1,ns[2]]
    "Cross sectional area of unit volume faces perpendicular to dimension-1"
    annotation (Dialog(
      tab="Internal Interface",
      group="Outputs",
      enable=false));
  output SI.Length dlengths_1[ns[1],ns[2]] "Unit cell length in dimension-1"
    annotation (Dialog(
      tab="Internal Interface",
      group="Outputs",
      enable=false));
  output Modelica.Blocks.Interfaces.RealOutput crossAreas_2[ns[1],ns[2] + 1]
    "Cross sectional area of unit volume faces perpendicular to dimension-2"
    annotation (Dialog(
      tab="Internal Interface",
      group="Outputs",
      enable=false));
  output SI.Length dlengths_2[ns[1],ns[2]] "Unit cell length in dimension-2"
    annotation (Dialog(
      tab="Internal Interface",
      group="Outputs",
      enable=false));
  SI.Volume V_total=sum(Vs) "Total volume of component";
  SI.Area surfaceAreas_3a[ns[1],ns[2]]
    "Surface area in non-discretized dimension 3a";
  SI.Area surfaceAreas_3b[ns[1],ns[2]]
    "Surface area in non-discretized dimension 3b";
  SI.Area surfaceAreas_3[ns[1],ns[2]]={{surfaceAreas_3a[i, j] + surfaceAreas_3b[
      i, j] for j in 1:ns[2]} for i in 1:ns[1]}
    "Dimension 3 discretized surface area";
  SI.Area surfaceArea_total=sum(surfaceAreas_3) "Total surface area";
  SI.Length cs_1[ns[1],ns[2]]
    "Unit cell centers dimension-1 cartesian coordinate";
  SI.Length cs_2[ns[1],ns[2]]
    "Unit cell centers dimension-2 cartesian coordinate";
  annotation (
    defaultComponentName="geometry",
    Icon(coordinateSystem(preserveAspectRatio=false), graphics={Bitmap(extent={
              {-116,-100},{116,100}}, fileName=
              "modelica://TRANSFORM/Resources/Images/Icons/Geometry_genericVolume.jpg")}),
    Diagram(coordinateSystem(preserveAspectRatio=false)));
end PartialGeometry_2D;
