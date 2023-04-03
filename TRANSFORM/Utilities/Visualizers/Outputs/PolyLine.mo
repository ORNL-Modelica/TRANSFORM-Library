within TRANSFORM.Utilities.Visualizers.Outputs;
model PolyLine
  input Real x[:]={1} annotation (Dialog);
  input Real y[size(x, 1)]={1} annotation (Dialog);

  parameter UserInteraction.Internal.Color color={255,0,0} annotation (__Dymola_Hide=false);

  extends UserInteraction.Internal.ScalingXYVectors(scaledX=x, scaledY=y);

  final Real[size(x, 1), 2] points=transpose({unScaledX,unScaledY})
    annotation (__Dymola_Hide=false);

  annotation (Icon(coordinateSystem(
        preserveAspectRatio=false,
        extent={{0,0},{1,1}},
        grid={0.01,0.01}), graphics={Line(
          points=DynamicSelect({{0,0},{0.4,0.7},{0.6,0.4},{1,1}}, points),
          color=color,
          pattern=LinePattern.Solid)}));
end PolyLine;
