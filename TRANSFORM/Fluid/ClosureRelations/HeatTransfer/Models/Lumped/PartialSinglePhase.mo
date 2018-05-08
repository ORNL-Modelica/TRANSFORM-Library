within TRANSFORM.Fluid.ClosureRelations.HeatTransfer.Models.Lumped;
partial model PartialSinglePhase

extends PartialHeatTransfer_setQ_flows;

  TRANSFORM.Media.BaseProperties1Phase mediaProps(redeclare package Medium =
        Medium, state=state) "Bulk fluid properties"
    annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));
//   TRANSFORM.Media.BaseProperties1Phase medium_film(redeclare package Medium =
//         Medium, state=state_film) "Film fluid properties"
//     annotation (Placement(transformation(extent={{-80,-100},{-60,-80}})));

equation
  m_flow =v .* mediaProps.d .* crossArea;
  //v_film =m_flow ./ (medium_film.d .* crossArea);
  Re =mediaProps.d .* dimension .* abs(v) ./ mediaProps.mu;
  //Re_film =medium_film.d .* dimension .* abs(v_film) ./ medium_film.mu;
  Pr =mediaProps.mu .* mediaProps.cp ./ mediaProps.lambda;
  //Pr_film =medium_film.mu .* medium_film.cp ./ medium_film.lambda;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end PartialSinglePhase;
