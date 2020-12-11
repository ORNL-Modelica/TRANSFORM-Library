within TRANSFORM.Fluid.ClosureRelations.Geometry.Models.Examples;
model StandardPipes
  extends TRANSFORM.Icons.Example;
  DistributedVolume_1D.StandardPipe standardPipe(redeclare model NPS =
        NPS.NPS_125)
    annotation (Placement(transformation(extent={{-40,20},{-20,40}})));
  DistributedVolume_1D.Pipe_Wall.StandardPipe standardPipe1(redeclare model NPS =
        NPS.NPS_125)
    annotation (Placement(transformation(extent={{20,-40},{40,-20}})));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end StandardPipes;
