within TRANSFORM.Fluid.Volumes.ClosureModels.Geometry.Models.Flow;
partial model PartialGeometry
  parameter Real nParallel(min=1)=1 "Number of identical parallel components"
    annotation(Dialog);
  parameter Integer nNodes(min=1)=2 "Number of discrete serial nodes"
    annotation(Dialog,  Evaluate=true);
  input SI.Length[nNodes] lengths = ones(nNodes) "Length of node segment"
    annotation (Dialog(group="General"));
  parameter Boolean use_Dimensions=true
    "=true to specify characteristic dimension"
   annotation(Dialog(group="General"), Evaluate=true);
  input SI.Length[nNodes+1] dimensions = if use_Dimensions then zeros(nNodes+1) else 4*crossAreas./perimeters "Characteristic dimension (e.g., hydraulic diameter)"
   annotation (Dialog(group="General", enable=use_Dimensions));
  input SI.Area[nNodes+1] crossAreas = pi*dimensions.*dimensions./4 "Cross-sectional flow areas"
   annotation (Dialog(group="General", enable=not use_Dimensions));
  input SI.Length[nNodes+1] perimeters=4*crossAreas./dimensions "Wetted perimeters"
   annotation (Dialog(group="General", enable=not use_Dimensions));
  input SI.Height[nNodes+1] roughnesses = fill(2.5e-5,nNodes+1) "Average heights of surface asperities"
    annotation (Dialog(group="General"));
  // Static head
  input SI.Length[nNodes] dheights=fill(0,nNodes)
    "Height(port_b) - Height(port_a) distributed by flow segment"
    annotation (Dialog(group="Static head"), Evaluate=true);
  input SI.Length height_a=0
    "Elevation at port_a: Reference value only. No impact on calculations."
    annotation (Dialog(group="Static head"), Evaluate=true);
  SI.Length height_b=height_a + sum(dheights)
    "Elevation at port_b: Reference value only. No impact on calculations."
    annotation (Dialog(group="Static head", enable= false), Evaluate=true);
  Real[nNodes] dxs = lengths/sum(lengths) "Fractional lengths";
equation
  for i in 1:nNodes loop
    assert(dimensions[i]>0, "Characteristic dimension must be > 0");
    assert(lengths[i] >= abs(dheights[i]), "Parameter lengths must be greater or equal to abs(dheights)");
  end for;
  annotation (defaultComponentName="geometry",
    Icon(coordinateSystem(preserveAspectRatio=false), graphics={
          Bitmap(extent={{-116,-100},{116,100}}, fileName=
              "modelica://TRANSFORM/Resources/Images/Icons/Geometry_genericFlow.jpg")}),
                                                                 Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end PartialGeometry;
