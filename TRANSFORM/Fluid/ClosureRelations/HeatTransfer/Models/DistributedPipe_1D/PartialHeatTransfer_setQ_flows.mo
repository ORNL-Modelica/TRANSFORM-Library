within TRANSFORM.Fluid.ClosureRelations.HeatTransfer.Models.DistributedPipe_1D;
partial model PartialHeatTransfer_setQ_flows

  extends PartialHeatTransfer_setT(final flagIdeal=0);

equation

    Q_flows=CF.*alphas.*surfaceAreas.*(Ts_wall - Ts_fluid);

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end PartialHeatTransfer_setQ_flows;
