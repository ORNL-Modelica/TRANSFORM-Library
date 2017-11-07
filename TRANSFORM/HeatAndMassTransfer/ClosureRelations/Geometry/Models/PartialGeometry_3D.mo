within TRANSFORM.HeatAndMassTransfer.ClosureRelations.Geometry.Models;
partial model PartialGeometry_3D

  parameter Integer figure=1 "Index for Icon figure" annotation (choices(
      choice=1 "Plane",
      choice=2 "Cylinder",
      choice=3 "Sphere"));

  parameter Integer ns[3](min=1) = {1,1,1}
    "Number of nodes in each dimension {1,2,3}";

  final parameter Integer n_total=ns[1]*ns[2]*ns[3] "Total number of nodes";

  output SI.Volume Vs[ns[1],ns[2],ns[3]] "Unit volumes" annotation (Dialog(
      tab="Internal Interface",
      group="Output Variables",
      enable=false));
  output SI.Area crossAreas_1[ns[1] + 1,ns[2],ns[3]]
    "Cross sectional area of unit volume faces perpendicular to dimension-1"
    annotation (Dialog(
      tab="Internal Interface",
      group="Output Variables",
      enable=false));
  output SI.Length dlengths_1[ns[1],ns[2],ns[3]]
    "Unit cell length in dimension-1" annotation (Dialog(
      tab="Internal Interface",
      group="Output Variables",
      enable=false));
  output SI.Area crossAreas_2[ns[1],ns[2] + 1,ns[3]]
    "Cross sectional area of unit volume faces perpendicular to dimension-2"
    annotation (Dialog(
      tab="Internal Interface",
      group="Output Variables",
      enable=false));
  output SI.Length dlengths_2[ns[1],ns[2],ns[3]]
    "Unit cell length in dimension-2" annotation (Dialog(
      tab="Internal Interface",
      group="Output Variables",
      enable=false));
  output SI.Area crossAreas_3[ns[1],ns[2],ns[3] + 1]
    "Cross sectional area of unit volume faces perpendicular to dimension-3"
    annotation (Dialog(
      tab="Internal Interface",
      group="Output Variables",
      enable=false));
  output SI.Length dlengths_3[ns[1],ns[2],ns[3]]
    "Unit cell length in dimension-3" annotation (Dialog(
      tab="Internal Interface",
      group="Output Variables",
      enable=false));

  SI.Volume V_total=sum(Vs) "Total volume of component";

  SI.Length cs_1[ns[1],ns[2],ns[3]]
    "Unit cell centers dimension-1 cartesian coordinate";
  SI.Length cs_2[ns[1],ns[2],ns[3]]
    "Unit cell centers dimension-2 cartesian coordinate";
  SI.Length cs_3[ns[1],ns[2],ns[3]]
    "Unit cell centers dimension-3 cartesian coordinate";

  annotation (
    defaultComponentName="geometry",
    Icon(coordinateSystem(preserveAspectRatio=false), graphics={Bitmap(extent={
              {-116,-100},{116,100}}, fileName=
              "modelica://TRANSFORM/Resources/Images/Icons/Geometry_genericVolume.jpg")}),
    Diagram(coordinateSystem(preserveAspectRatio=false)));

end PartialGeometry_3D;
