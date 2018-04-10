within TRANSFORM.Fluid.ClosureRelations.HeatTransfer.Models.DistributedPipe_1D;
partial model PartialIdeal

extends PartialHeatTransfer_setT(final flagIdeal=1);

  TRANSFORM.Media.BaseProperties1Phase[nHT] mediums(redeclare package
              Medium =
        Medium, state=states) "Bulk fluid properties"
    annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));

equation

  m_flows = vs.*mediums.d .* crossAreas;
  //vs_film = vs;
  Res =mediums.d .* dimensions .* abs(vs) ./ mediums.mu;
  //Res_film = Res;
  Prs =mediums.mu .* mediums.cp ./ mediums.lambda;
  //Prs_film = Prs;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end PartialIdeal;
