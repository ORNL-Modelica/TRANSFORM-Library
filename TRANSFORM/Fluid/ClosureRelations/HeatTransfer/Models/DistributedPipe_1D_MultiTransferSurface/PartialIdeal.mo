within TRANSFORM.Fluid.ClosureRelations.HeatTransfer.Models.DistributedPipe_1D_MultiTransferSurface;
partial model PartialIdeal

  extends PartialHeatTransfer_setT(final flagIdeal=1);

  TRANSFORM.Media.BaseProperties1Phase[nHT] mediums(redeclare package Medium =
        Medium, state=states) "Bulk fluid properties"
    annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));

equation

  m_flows = vs .* mediums.d .* crossAreas;
  Res = mediums.d .* dimensions .* abs(vs) ./ mediums.mu;
  Prs = mediums.mu .* mediums.cp ./ mediums.lambda;

//   for i in 1:nHT loop
//     for j in 1:nSurfaces loop
//       vs_film[i, j] = vs[i];
//       Res_film[i, j] = Res[i];
//       Prs_film[i, j] = Prs[i];
//     end for;
//   end for;

  annotation (defaultComponentName="heatTransfer",Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end PartialIdeal;
