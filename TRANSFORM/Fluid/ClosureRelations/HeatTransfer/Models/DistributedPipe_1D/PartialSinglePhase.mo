within TRANSFORM.Fluid.ClosureRelations.HeatTransfer.Models.DistributedPipe_1D;
partial model PartialSinglePhase

extends PartialHeatTransfer_setQ_flows;

  TRANSFORM.Media.BaseProperties1Phase[nHT] mediaProps(redeclare package Medium =
        Medium, state=states) "Bulk fluid properties"
    annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));
//   TRANSFORM.Media.BaseProperties1Phase[nHT] mediums_film(redeclare package
//       Medium =
//         Medium, state=states_film) "Film fluid properties"
//     annotation (Placement(transformation(extent={{-80,-100},{-60,-80}})));

equation
  m_flows =vs .* mediaProps.d .* crossAreas;
  //vs_film =m_flows ./ (mediums_film.d .* crossAreas);
  Res =mediaProps.d .* dimensions .* abs(vs) ./ mediaProps.mu;
  //Res_film =mediums_film.d .* dimensions .* abs(vs_film) ./ mediums_film.mu;
  Prs =mediaProps.mu .* mediaProps.cp ./ mediaProps.lambda;
  //Prs_film =mediums_film.mu .* mediums_film.cp ./ mediums_film.lambda;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end PartialSinglePhase;
