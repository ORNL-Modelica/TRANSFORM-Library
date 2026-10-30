within TRANSFORM.Fluid.ClosureRelations.MassTransfer.Models.DistributedPipe_TraceMass_1D;
partial model PartialMassTransfer_setn_flows
  extends PartialMassTransfer_setC(final flagIdeal = 0);
equation
  for i in 1:nMT loop
    nC_flows[i, :] = alphasM[i, :] .* surfaceAreas[i] .* (Cs_wall[i, :] -
      Cs_fluid[i, :]);
  end for;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end PartialMassTransfer_setn_flows;
