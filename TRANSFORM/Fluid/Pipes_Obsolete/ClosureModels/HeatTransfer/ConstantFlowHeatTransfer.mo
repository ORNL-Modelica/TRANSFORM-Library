within TRANSFORM.Fluid.Pipes_Obsolete.ClosureModels.HeatTransfer;
model ConstantFlowHeatTransfer "Constant Heat Transfer Coefficient"
  extends TRANSFORM.Fluid.Pipes_Obsolete.ClosureModels.HeatTransfer.BaseClasses.PartialFlowHeatTransfer(
      alphas_start=alphas0);
  parameter SI.CoefficientOfHeatTransfer[nHT] alphas0=1000*ones(nHT) "heat transfer coefficient";
equation
  alphas = alphas0;
  Q_flows = {alphas[i]*surfaceAreas[i]*(heatPorts[i].T - Ts[i])*nParallel for i in 1:nHT};
  annotation(Documentation(info="<html>
<p>
Simple heat transfer correlation with constant heat transfer coefficient, used as default component in distributed pipe models.
</p>
</html>"));
end ConstantFlowHeatTransfer;
