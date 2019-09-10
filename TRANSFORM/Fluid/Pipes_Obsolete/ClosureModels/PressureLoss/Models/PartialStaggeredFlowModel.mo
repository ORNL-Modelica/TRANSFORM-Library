within TRANSFORM.Fluid.Pipes_Obsolete.ClosureModels.PressureLoss.Models;
partial model PartialStaggeredFlowModel
  "Base class for momentum balances in flow models"
  // Implementation of momentum balance
  extends TRANSFORM.Fluid.Pipes_Obsolete.PartialDistributedFlow(
    final lengths = geometry.lengths,
    final nFM = geometry.nNodes);
  parameter SI.Acceleration g=system.g "Constant gravity acceleration";
  // Inputs
  input Medium.ThermodynamicState[nFM+1] states
    "Thermodynamic states along design flow";
  input SI.Velocity[nFM+1] vs "Mean velocities of fluid flow";
  input SI.Temperature[nFM+1] Ts_wall
    "Mean wall temperatures of heat transfer surface";
  // Geometry
  replaceable model Geometry =
      TRANSFORM.Fluid.Volumes.ClosureModels.Geometry.Models.Flow.Generic
    constrainedby
    TRANSFORM.Fluid.Volumes.ClosureModels.Geometry.Models.Flow.PartialGeometry
  "Geometry Type"
  annotation(choicesAllMatching=true);
  Geometry geometry
    annotation (Placement(transformation(extent={{-76,84},{-64,96}})));
  // Geometry parameters and inputs
  parameter Real nParallel = geometry.nParallel "number of identical parallel flow devices" annotation(Dialog(group="Should be defined by closure model"));
  input SI.Area[nFM+1] crossAreas=geometry.crossAreas "Cross flow areas at segment boundaries" annotation(Dialog(group="Should be defined by closure model"));
  input SI.Length[nFM+1] dimensions=geometry.dimensions
    "Characteristic dimensions for fluid flow (diameters for pipe flow)" annotation(Dialog(group="Should be defined by closure model"));
  input SI.Height[nFM+1] roughnesses=geometry.roughnesses "Average height of surface asperities" annotation(Dialog(group="Should be defined by closure model"));
  // Static head
  input SI.Length[nFM] dheights=geometry.dheights "Height(states[2:nFM+1]) - Height(states[1:nFM])" annotation(Dialog(group="Should be defined by closure model"));
  // Advanced parameters
  parameter Boolean useUpstreamScheme = true
    "= false to average upstream and downstream properties across flow segments"
     annotation(Dialog(tab="Advanced"), Evaluate=true);
  parameter Boolean use_Ib_flows = momentumDynamics <>Modelica.Fluid.Types.Dynamics.SteadyState
    "= true to consider differences in flow of momentum through boundaries"
     annotation(Dialog(tab="Advanced"), Evaluate=true);
  // Reynolds Number
  parameter SI.ReynoldsNumber[nFM] Res_turbulent=4000*ones(nFM)
    "Transition from laminar to turbulent";
  parameter Boolean use_rho_nominal = false
    "= true, if rho_nominal is used, otherwise computed from medium"
     annotation(Dialog(tab="Advanced"), Evaluate=true);
  parameter Boolean use_mu_nominal = false
    "= true, if mu_nominal is used, otherwise computed from medium"
     annotation(Dialog(tab="Advanced"), Evaluate=true);
  // Variables
  Medium.Density[nFM+1] rhos=
    if use_rho_nominal then fill(rho_nominal, nFM+1)
    else Medium.density(states);
  Medium.Density[nFM] rhos_act "Actual density per segment";
  Medium.DynamicViscosity[nFM+1] mus=
    if use_mu_nominal then fill(mu_nominal, nFM+1)
    else Medium.dynamicViscosity(states);
  Medium.DynamicViscosity[nFM] mus_act "Actual viscosity per segment";
  // Variables
  SI.Pressure[nFM] dps_fg(start = dps_start)
    "pressure drop between states";
  SI.ReynoldsNumber[nFM+1] Res=
    Utilities.CharacteristicNumbers.ReynoldsNumber(
      vs,
      rhos,
      mus,
      dimensions) "Reynolds numbers";
  Medium.MassFlowRate[nFM] m_flows_turbulent=
      {nParallel*Res_turbulent[i]*mus_act[i]
       *(crossAreas[i] + crossAreas[i+1])/(dimensions[i] + dimensions[i+1])
       for i in 1:nFM} "Start of turbulent flow based on Res_turbulent";
protected
  parameter SI.Density rho_nominal=Medium.density_pTX(
      Medium.p_default,
      Medium.T_default,
      Medium.X_default)
    "Nominal density (e.g., rho_liquidWater = 995, rho_air = 1.2)"
    annotation (Dialog(group="Advanced", enable=use_rho_nominal));
  parameter SI.DynamicViscosity mu_nominal=
      Medium.dynamicViscosity(Medium.setState_pTX(
      Medium.p_default,
      Medium.T_default,
      Medium.X_default))
    "Nominal dynamic viscosity (e.g., mu_liquidWater = 1e-3, mu_air = 1.8e-5)"
    annotation (Dialog(group="Advanced", enable=use_mu_nominal));
equation
  if not allowFlowReversal then
    rhos_act = rhos[1:nFM];
    mus_act = mus[1:nFM];
  elseif not useUpstreamScheme then
    rhos_act = 0.5*(rhos[1:nFM] + rhos[2:nFM+1]);
    mus_act = 0.5*(mus[1:nFM] + mus[2:nFM+1]);
  else
    for i in 1:nFM loop
      rhos_act[i] = noEvent(if m_flows[i] > 0 then rhos[i] else rhos[i+1]);
      mus_act[i] = noEvent(if m_flows[i] > 0 then mus[i] else mus[i+1]);
    end for;
  end if;
  if use_Ib_flows then
    Ib_flows = nParallel*{rhos[i]*vs[i]*vs[i]*crossAreas[i] - rhos[i+1]*vs[i+1]*vs[i+1]*crossAreas[i+1] for i in 1:nFM};
  else
    Ib_flows = zeros(nFM);
  end if;
  Fs_p = nParallel*{0.5*(crossAreas[i]+crossAreas[i+1])*(Medium.pressure(states[i+1])-Medium.pressure(states[i])) for i in 1:nFM};
  // Note: the equation is written for dps_fg instead of Fs_fg to help the translator
  dps_fg = {Fs_fg[i]/nParallel*2/(crossAreas[i]+crossAreas[i+1]) for i in 1:nFM};
  annotation (Documentation(info="<html>
<p>
This partial model defines a common interface for <code>nFM</code> flow models between <code>nFM+1</code> device segments.
The flow models provide a steady-state or dynamic momentum balance using an upwind discretization scheme per default.
Extending models must add pressure loss terms for friction and gravity.
</p>
<p>
The fluid is specified in the interface with the thermodynamic <code>states[nFM+1]</code> for a given <code>Medium</code> model.
The geometry is specified with the <code>pathLengths[nFM]</code> between the device segments as well as
with the <code>crossAreas[nFM+1]</code> and the <code>roughnesses[nFM+1]</code> of the device segments.
Moreover the fluid flow is characterized for different types of devices by the characteristic <code>dimensions[nFM+1]</code>
and the average velocities <code>vs[nFM+1]</code> of fluid flow in the device segments.
See <a href=\"modelica://Modelica.Fluid.Pipes.BaseClasses.CharacteristicNumbers.ReynoldsNumber\">Pipes.BaseClasses.CharacteristicNumbers.ReynoldsNumber</a>
for example definitions.
</p>
<p>
The parameter <code>Res_turbulent</code> can be specified for the least mass flow rate of the turbulent regime.
It defaults to 4000, which is appropriate for pipe flow.
The <code>m_flows_turbulent[nFM]</code> resulting from <code>Res_turbulent</code> can optionally be calculated together with the Reynolds numbers
<code>Res[nFM+1]</code> of the device segments (<code>show_Res=true</code>).
</p>
<p>
Using the thermodynamic states[nFM+1] of the device segments, the densities rhos[nFM+1] and the dynamic viscosities mus[nFM+1]
of the segments as well as the actual densities rhos_act[nFM] and the actual viscosities mus_act[nFM] of the flows are predefined
in this base model. Note that no events are raised on flow reversal. This needs to be treated by an extending model,
e.g., with numerical smoothing or by raising events as appropriate.
</p>
</html>"),
     Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
        -100},{100,100}}), graphics={Bitmap(extent={{-118,-100},{118,100}},
            fileName=
              "modelica://TRANSFORM/Resources/Images/Icons/FlowModel_dps.jpg")}));
end PartialStaggeredFlowModel;
