within TRANSFORM.Fluid.ClosureRelations.HeatTransfer.Models.DistributedPipe_1D_MultiTransferSurface;
partial model PartialHeatTransfer_setQ_flows

  extends PartialHeatTransfer_setT(final flagIdeal=0);

equation

  for i in 1:nHT loop
    for j in 1:nSurfaces loop
    Q_flows[i,j]=alphas[i,j]*surfaceAreas[i,j]*(Ts_wall[i,j] - Ts_fluid[i]);
    end for;
  end for;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end PartialHeatTransfer_setQ_flows;
