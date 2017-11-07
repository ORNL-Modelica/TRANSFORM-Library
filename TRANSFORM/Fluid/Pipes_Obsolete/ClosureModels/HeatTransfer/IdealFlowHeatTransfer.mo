within TRANSFORM.Fluid.Pipes_Obsolete.ClosureModels.HeatTransfer;
model IdealFlowHeatTransfer
  "IdealHeatTransfer: Ideal heat transfer without thermal resistance"
  extends
    TRANSFORM.Fluid.Pipes_Obsolete.ClosureModels.HeatTransfer.BaseClasses.PartialFlowHeatTransfer(
      alphas_start=Modelica.Constants.inf*ones(nHT));
equation
  Ts = heatPorts.T;
  alphas = Modelica.Constants.inf*ones(nHT);
  annotation(Documentation(info="<html>
Ideal heat transfer without thermal resistance.
</html>"));
end IdealFlowHeatTransfer;
