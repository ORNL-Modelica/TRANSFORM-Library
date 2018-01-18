within TRANSFORM.Fluid.Volumes.ClosureModels.Geometry.Models.Volume.Examples;
partial model PartialGeometryTest
  extends Icons.Example;

  constant Integer nCs = 8 "Number of comparisons";
  constant Integer[nCs] n = {1,1,1,1,1,1,1,1} "Length of array of each compared value";
  Utilities.ErrorAnalysis.Errors_AbsRelRMSold[nCs] summary_Error(
    n=n,
    x_1={{geometry.dimensions[2]},{geometry.crossAreas[2]},{geometry.perimeters[
        2]},{geometry.surfaceAreas[2]},{geometry.height_b},{geometry.Volume_total},
        {geometry.dxs[2]},{geometry.surfaceArea_total}},
    x_2={{dimensions_Exp},{crossAreas_Exp},{perimeters_Exp},{surfaceAreas_Exp},
        {height_b_Exp},{Volume_total_Exp},{dxs_Exp},{surfaceArea_total_Exp}})
    annotation (Placement(transformation(extent={{60,60},{80,80}})));

  // Compare the results with indpendent calculation.
  // If array then just the second value.
  constant SI.Length dimensions_Exp;
  constant SI.Area crossAreas_Exp;
  constant SI.Length perimeters_Exp;
  constant SI.Area surfaceAreas_Exp;
  constant SI.Height height_b_Exp;
  constant SI.Volume Volume_total_Exp;
  constant Units.NonDim dxs_Exp;
  constant SI.Area surfaceArea_total_Exp;

  replaceable PartialGeometry geometry
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end PartialGeometryTest;
