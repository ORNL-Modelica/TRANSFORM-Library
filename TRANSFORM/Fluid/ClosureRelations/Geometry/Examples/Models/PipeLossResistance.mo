within TRANSFORM.Fluid.ClosureRelations.Geometry.Examples.Models;
model PipeLossResistance

  extends TRANSFORM.Icons.Example;

  ClosureRelations.Geometry.Models.PipeLossResistance.Generic generic
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
  ClosureRelations.Geometry.Models.PipeLossResistance.Circle circle
    annotation (Placement(transformation(extent={{-40,60},{-20,80}})));
  ClosureRelations.Geometry.Models.PipeLossResistance.Rectangle rectangle
    annotation (Placement(transformation(extent={{20,60},{40,80}})));
  ClosureRelations.Geometry.Models.PipeLossResistance.Trapezoid trapezoid
    annotation (Placement(transformation(extent={{60,60},{80,80}})));
  ClosureRelations.Geometry.Models.PipeLossResistance.Ellipse ellipse
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
  ClosureRelations.Geometry.Models.PipeLossResistance.Annulus concentricAnnulus
    annotation (Placement(transformation(extent={{-40,20},{-20,40}})));
  ClosureRelations.Geometry.Models.PipeLossResistance.Triangle triangle
    annotation (Placement(transformation(extent={{20,20},{40,40}})));
  ClosureRelations.Geometry.Models.PipeLossResistance.CircleSector circleSector
    annotation (Placement(transformation(extent={{60,20},{80,40}})));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end PipeLossResistance;
