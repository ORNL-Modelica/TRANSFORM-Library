within TRANSFORM.HeatAndMassTransfer.ClosureRelations.HeatTransfer.Models;
partial model PartialTwoPhase

  extends
    TRANSFORM.HeatAndMassTransfer.ClosureRelations.HeatTransfer.Models.PartialHeatTransfer(
      final flagIdeal=0, replaceable package Medium =
        Modelica.Media.Water.StandardWater constrainedby
      Modelica.Media.Interfaces.PartialTwoPhaseMedium);

  TRANSFORM.Media.BaseProperties2Phase[nHT] mediums(redeclare package Medium =
        Medium, state=states) "Bulk fluid properties"
    annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));

  TRANSFORM.Media.BaseProperties2Phase[nHT] mediums_film(redeclare package
      Medium = Medium, state=states_film) "Film fluid properties"
    annotation (Placement(transformation(extent={{-80,-100},{-60,-80}})));

equation
  m_flows =vs.*mediums.d .* crossAreas;
  vs_film =vs .*mediums.d./mediums_film.d;
  Res =mediums.d .* dimensions .* abs(vs) ./ mediums.mu;
  Res_film =mediums_film.d .* dimensions .* abs(vs_film) ./ mediums_film.mu;
  Prs =Medium.prandtlNumber(states);
  Prs_film =Medium.prandtlNumber(states_film);

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end PartialTwoPhase;
