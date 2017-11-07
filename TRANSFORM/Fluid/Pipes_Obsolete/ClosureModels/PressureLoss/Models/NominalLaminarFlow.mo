within TRANSFORM.Fluid.Pipes_Obsolete.ClosureModels.PressureLoss.Models;
model NominalLaminarFlow
  "NominalLaminarFlow: Linear laminar flow for given nominal values"
  extends
    TRANSFORM.Fluid.Pipes_Obsolete.ClosureModels.PressureLoss.Models.PartialStaggeredFlowModel(
      use_mu_nominal=not show_Res);

  // Operational conditions
  parameter SI.AbsolutePressure dp_nominal "Nominal pressure loss";
  parameter SI.MassFlowRate m_flow_nominal
    "Mass flow rate for dp_nominal";

  // Inverse parameterization assuming pipe flow and WallFriction.Laminar
  // Laminar.massFlowRate_dp:
  //   m_flow = dp*pi*diameter^4*d/(128*length*mu);
  SI.Length[nFM] lengths_nominal=
    {(dp_nominal/(nFM-1)-g*dheights[i])*Modelica.Constants.pi*((dimensions[i]+dimensions[i+1])/2)^4*rhos_act[i]/(128*mus_act[i])/
     (m_flow_nominal/nParallel) for i in 1:nFM-1} if show_Res
    "Lengths resulting from given nominal values for circular tubes";

equation
  // linear pressure loss
  if  not allowFlowReversal or use_rho_nominal or not useUpstreamScheme then
    dps_fg = {g*dheights[i]*rhos_act[i] for i in 1:nFM} + dp_nominal/(nFM)/m_flow_nominal*m_flows;
  else
    dps_fg = {g*dheights[i]*(if m_flows[i] > 0 then rhos[i] else rhos[i+1]) for i in 1:nFM} + dp_nominal/(nFM)/m_flow_nominal*m_flows;
  end if;

  annotation (Documentation(info="<html>
<p>
This model defines a simple linear pressure loss assuming laminar flow for
specified <code>dp_nominal</code> and <code>m_flow_nominal</code>.
</p>
<p>
Select <code>show_Res = true</code> to analyze the actual flow and the lengths of a pipe that would fulfill the
specified nominal values for given geometry parameters <code>crossAreas</code>, <code>dimensions</code> and <code>roughnesses</code>.
</p>
</html>"));
end NominalLaminarFlow;
