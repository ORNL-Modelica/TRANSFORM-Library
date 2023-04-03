within TRANSFORM.Fluid.Pipes_Obsolete.ClosureModels.HeatTransfer.Models;
partial model PartialHeatTransfer_setQ_flows
  "Base model required to allow for models that set Q_flows state rather than temperature state"
  extends TRANSFORM.Fluid.Pipes_Obsolete.ClosureModels.HeatTransfer.Models.PartialHeatTransfer_setT;
equation
  Q_flows=alphas.*surfaceAreas.*(Ts_wall - Ts_fluid)*nParallel;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end PartialHeatTransfer_setQ_flows;
