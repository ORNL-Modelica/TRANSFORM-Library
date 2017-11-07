within TRANSFORM.Fluid.ClosureRelations.HeatTransfer.Models.Lumped;
partial model PartialHeatTransfer_setQ_flows

  extends PartialHeatTransfer_setT(final flagIdeal=0);

equation

  Q_flow = alpha .* surfaceArea .* (T_wall - T_fluid);

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end PartialHeatTransfer_setQ_flows;
