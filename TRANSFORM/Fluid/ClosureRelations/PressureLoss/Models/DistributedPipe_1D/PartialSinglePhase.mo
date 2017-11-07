within TRANSFORM.Fluid.ClosureRelations.PressureLoss.Models.DistributedPipe_1D;
partial model PartialSinglePhase

  extends PartialMomentumBalance;

  TRANSFORM.Media.BaseProperties1Phase[nFM + 1] mediaProps(redeclare package
      Medium = Medium, state=states) "Bulk fluid properties"
    annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));
//   TRANSFORM.Media.BaseProperties1Phase[nFM + 1] mediums_film(redeclare package
//               Medium =
//         Medium, state=states_film) "Film fluid properties"
//     annotation (Placement(transformation(extent={{-80,-100},{-60,-80}})));

equation

  for i in 1:nFM loop
    Res[i] =0.5 .* (dimensions[i] + dimensions[i + 1]) .* abs(m_flows[i]) ./ (
      0.25*(crossAreas[i] + crossAreas[i + 1]) .* (mediaProps[i].mu +
      mediaProps[i + 1].mu));
    //Res_film[i] = 0.5.*(dimensions[i] + dimensions[i+1]).*abs(m_flows[i])./(0.25*(crossAreas[i]+crossAreas[i+1]).*(mediums_film[i].mu+mediums_film[i+1].mu));
  end for;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end PartialSinglePhase;
