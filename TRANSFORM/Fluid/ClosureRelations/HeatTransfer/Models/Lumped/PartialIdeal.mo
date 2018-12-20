within TRANSFORM.Fluid.ClosureRelations.HeatTransfer.Models.Lumped;
partial model PartialIdeal

extends PartialHeatTransfer_setT(final flagIdeal=1);

  TRANSFORM.Media.BaseProperties1Phase mediums(redeclare package Medium =
        Medium, state=state) "Bulk fluid properties"
    annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));

equation

  m_flow = v .* mediums.d .* crossArea;
  //v_film = v;
  Re = mediums.d .* dimension .* abs(v) ./ mediums.mu;
  //Re_film = Re;
  Pr = mediums.mu .* mediums.cp ./ mediums.lambda;
  //Pr_film = Pr;

  annotation (defaultComponentName="heatTransfer",Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end PartialIdeal;
