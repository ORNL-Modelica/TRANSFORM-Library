within TRANSFORM.Fluid.Pipes_Obsolete.ClosureModels.HeatTransfer.Models;
model Constant_alphas "Constant heat transfer coefficient"
  extends
    TRANSFORM.Fluid.Pipes_Obsolete.ClosureModels.HeatTransfer.Models.PartialHeatTransfer_setQ_flows;
  parameter SI.CoefficientOfHeatTransfer alpha0 = 0.0 "Coefficient of heat transfer" annotation(Dialog(group="Heat Transfer Model:"));
equation
  alphas=alpha0*ones(nHT);
  annotation (defaultComponentName="heatTransfer",
Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Constant_alphas;
