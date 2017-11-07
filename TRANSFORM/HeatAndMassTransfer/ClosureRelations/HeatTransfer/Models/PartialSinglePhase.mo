within TRANSFORM.HeatAndMassTransfer.ClosureRelations.HeatTransfer.Models;
partial model PartialSinglePhase "Base model"

extends
    TRANSFORM.HeatAndMassTransfer.ClosureRelations.HeatTransfer.Models.PartialHeatTransfer(
      final flagIdeal=0);

  TRANSFORM.Media.BaseProperties1Phase[nHT] mediums(redeclare package Medium =
        Medium, state=states) "Bulk fluid properties"
    annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));
  TRANSFORM.Media.BaseProperties1Phase[nHT] mediums_film(redeclare package
      Medium = Medium, state=states_film) "Film fluid properties"
    annotation (Placement(transformation(extent={{-80,-100},{-60,-80}})));

equation
  m_flows =vs.*mediums.d .* crossAreas;
  vs_film =vs .*mediums.d./mediums_film.d;
  Res =mediums.d .* dimensions .* abs(vs) ./ mediums.mu;
  Res_film =mediums_film.d .* dimensions .* abs(vs_film) ./ mediums_film.mu;
  Prs =mediums.mu .* mediums.cp ./ mediums.lambda;
  Prs_film =mediums_film.mu .* mediums_film.cp ./ mediums_film.lambda;

  annotation (
    defaultComponentName="heatTransfer",
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)));
end PartialSinglePhase;
