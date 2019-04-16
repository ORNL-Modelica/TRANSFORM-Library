within TRANSFORM.Fluid.Machines.BaseClasses.TurbineCharacteristics.Flow;
model HyperbolicTangent
  extends PartialFlowChar;

  final parameter Real beta =  0.5*log((1+m_flow_c_nominal)/(1-m_flow_c_nominal))/(PR_nominal-1) "Fitting constant";

equation

  m_flow_c = Modelica.Math.tanh(beta*(PR-1));

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end HyperbolicTangent;
