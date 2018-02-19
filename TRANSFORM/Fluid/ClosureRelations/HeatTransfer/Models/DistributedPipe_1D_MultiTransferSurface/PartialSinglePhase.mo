within TRANSFORM.Fluid.ClosureRelations.HeatTransfer.Models.DistributedPipe_1D_MultiTransferSurface;
partial model PartialSinglePhase

extends PartialHeatTransfer_setQ_flows;

  TRANSFORM.Media.BaseProperties1Phase[nHT] mediaProps(redeclare package Medium =
        Medium, state=states) "Bulk fluid properties"
    annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));
//   TRANSFORM.Media.BaseProperties1Phase[nHT,nSurfaces] mediums_film(redeclare
//       package
//       Medium =
//         Medium, state=states_film) "Film fluid properties"
//     annotation (Placement(transformation(extent={{-80,-100},{-60,-80}})));

equation
  m_flows =vs .* mediaProps.d .* crossAreas;
  Res =mediaProps.d .* dimensions .* abs(vs) ./ mediaProps.mu;
  Prs =TRANSFORM.Math.smoothMax(0,mediaProps.mu .* mediaProps.cp ./ mediaProps.lambda,1e-8);

//   for i in 1:nHT loop
//     for j in 1:nSurfaces loop
//       vs_film[i, j] = m_flows[i]/ (mediums_film[i,j].d .* crossAreas[i]);
//       Res_film[i, j] = mediums_film[i,j].d* dimensions[i]* abs(vs_film[i,j])/ mediums_film[i,j].mu;
//       Prs_film[i, j] = mediums_film[i,j].mu* mediums_film[i,j].cp/ mediums_film[i,j].lambda;
//     end for;
//   end for;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end PartialSinglePhase;
