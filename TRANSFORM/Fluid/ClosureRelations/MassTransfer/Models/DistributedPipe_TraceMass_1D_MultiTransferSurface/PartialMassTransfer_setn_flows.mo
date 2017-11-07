within TRANSFORM.Fluid.ClosureRelations.MassTransfer.Models.DistributedPipe_TraceMass_1D_MultiTransferSurface;
partial model PartialMassTransfer_setn_flows

  extends PartialMassTransfer_setC(final flagIdeal=0);

equation

  for i in 1:nMT loop
    for j in 1:nSurfaces loop
      nC_flows[i, j, :] = alphasM[i, j, :] .* surfaceAreas[i, j] .* (Cs_wall[i,
        j, :] - Cs_fluid[i, :]);
    end for;
  end for;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end PartialMassTransfer_setn_flows;
