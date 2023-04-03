within TRANSFORM.HeatExchangers.BellDelaware_STHX.BaseClasses.FlowModels;
model ShellEndCrossFlow
  "ShellFlow End Cross: Shell-side End Cross (of a shell and tube heat exchanger) flow pressure loss and gravity with replaceable WallFriction package"
  extends TRANSFORM.Fluid.ClosureRelations.PressureLoss.Models.DistributedPipe_1D.PartialSinglePhase;
  parameter SI.DynamicViscosity mu_w__nominal = Medium.dynamicViscosity(
      Medium.setState_pTX(Medium.p_default, Medium.T_default, Medium.X_default))
    "Nominal wall viscosity";
  // Shell Model (Window) Parameters
  parameter Boolean toggleStaggered
    "true = staggered grid type; false = in-line"
  annotation(Dialog(tab="Shell Model (End Cross) Parameters"));
  parameter SI.Length d_o "Outer diameter of tubes"
  annotation(Dialog(tab="Shell Model (End Cross) Parameters"));
  parameter SI.Length D_i "Inside shell diameter"
  annotation(Dialog(tab="Shell Model (End Cross) Parameters"));
  parameter SI.Length DB "Tube bundle diameter"
  annotation(Dialog(tab="Shell Model (End Cross) Parameters"));
  parameter SI.Length s1 "Tube to tube pitch parallel to baffel edge"
  annotation(Dialog(tab="Shell Model (End Cross) Parameters"));
  parameter SI.Length s2 "Tube to tube pitch perpindicular to baffel edge"
  annotation(Dialog(tab="Shell Model (End Cross) Parameters"));
  parameter SI.Length S "Baffle spacing between baffles"
  annotation(Dialog(tab="Shell Model (End Cross) Parameters"));
  parameter SI.Length S_E
    "Baffle spacing between the heat exchanger sheets and adjacent baffles"
      annotation(Dialog(tab="Shell Model (End Cross) Parameters"));
  parameter SI.Length e1 "Space between tubes and shell"
  annotation(Dialog(tab="Shell Model (End Cross) Parameters"));
  parameter Real nes "# of shortest connections connecting neighboring tubes"
  annotation(Dialog(tab="Shell Model (End Cross) Parameters"));
  parameter Real n_MR "# of  main resistances in cross flow path"
  annotation(Dialog(tab="Shell Model (End Cross) Parameters"));
  parameter Real n_MRE "# of main resistances in end cross flow path"
  annotation(Dialog(tab="Shell Model (End Cross) Parameters"));
  parameter Real n_s "# of pairs of sealing strips"
  annotation(Dialog(tab="Shell Model (End Cross) Parameters"));
  TRANSFORM.Fluid.Pipes_Obsolete.ClosureModels.PressureLoss.HeatExchangers.BellDelawareShell.EndCross.dp_IN_con[
    nFM] IN_con(
    length=lengths,
    diameter_a=dimensions[1:nFM],
    diameter_b=dimensions[2:nFM + 1],
    crossArea_a=crossAreas[1:nFM],
    crossArea_b=crossAreas[2:nFM + 1],
    roughness_a=roughnesses[1:nFM],
    roughness_b=roughnesses[2:nFM + 1],
    each toggleStaggered=toggleStaggered,
    each d_o=d_o,
    each D_i=D_i,
    each DB=DB,
    each s1=s1,
    each s2=s2,
    each S=S,
    each S_E=S_E,
    each e1=e1,
    each nes=nes,
    each n_MR=n_MR,
    each n_MRE=n_MRE,
    each n_s=n_s,
    each nNodes=nFM)
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
  TRANSFORM.Fluid.Pipes_Obsolete.ClosureModels.PressureLoss.HeatExchangers.BellDelawareShell.EndCross.dp_IN_var[
    nFM] IN_var(
    rho_a=rhos_a,
    rho_b=rhos_b,
    mu_a=mus_a,
    mu_b=mus_b,
    mu_w=mu_w)
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));
protected
  SI.Density[nFM] rhos_a "Density at port_a";
  SI.Density[nFM] rhos_b "Density at port_b";
  SI.DynamicViscosity[nFM] mus_a
    "Dynamic viscosity at port_a (dummy if use_mu = false)";
  SI.DynamicViscosity[nFM] mus_b
    "Dynamic viscosity at port_b (dummy if use_mu = false)";
  TRANSFORM.Fluid.Pipes_Obsolete.ClosureModels.PressureLoss.HeatExchangers.BellDelawareShell.EndCross.dp_IN_var
    IN_var_nominal(
    rho_a=rho_nominal,
    rho_b=rho_nominal,
    mu_a=mu_nominal,
    mu_b=mu_nominal,
    mu_w=mu_w__nominal);
  parameter SI.AbsolutePressure dp_small(start=1, fixed=false)
    "Within regularization if |dp| < dp_small (may be wider for large discontinuities in static head)"
    annotation (Dialog(enable=from_dp and use_dp_small));
  final parameter Boolean constantPressureLossCoefficient=
     use_rho_nominal and (use_mu_nominal or not use_mu)
    "= true if the pressure loss does not depend on fluid states"
     annotation(Evaluate=true);
  final parameter Boolean continuousFlowReversal=
     (not useUpstreamScheme)
     or constantPressureLossCoefficient
     or not allowFlowReversal
    "= true if the pressure loss is continuous around zero flow"
     annotation(Evaluate=true);
  SI.Pressure[nFM+1] Ps = Medium.pressure(states);
  Medium.ThermodynamicState[nFM+1] states_w = Medium.setState_pTX(Ps,Ts_w);
   SI.DynamicViscosity[nFM+1] mus_w = Medium.dynamicViscosity(states_w)
    "Viscosity of fluid at average wall temperature";
   SI.DynamicViscosity[nFM] mu_w=0.5*(mus_w[1:nFM] +
       mus_w[2:nFM+1]) "mean viscosity between segments";
  SI.AbsolutePressure dp_fric_nominal=sum(
      TRANSFORM.Fluid.Pipes_Obsolete.ClosureModels.PressureLoss.HeatExchangers.BellDelawareShell.EndCross.dp_DP(
      IN_con,
      IN_var_nominal,
      m_flow_nominal/nParallel,
      m_flow_small/nParallel)) "pressure loss for nominal conditions";
initial equation
  // initialize dp_small from flow model
  if system.use_eps_Re then
    dp_small = dp_fric_nominal/m_flow_nominal*m_flow_small;
  else
    dp_small = system.dp_small;
  end if;
  // initialize dp_nominal from flow model
  if system.use_eps_Re then
    dp_nominal = dp_fric_nominal + g*sum(dheights)*rho_nominal;
  else
    dp_nominal = 1e3*dp_small;
  end if;
equation
  for i in 1:nFM loop
    assert(m_flows[i] > -m_flow_small or allowFlowReversal, "Reverting flow occurs even though allowFlowReversal is false");
  end for;
  if continuousFlowReversal then
    // simple regularization
    rhos_a = rhos_act;
    rhos_b = rhos_act;
    mus_a = mus_act;
    mus_b = mus_act;
    if from_dp and not dp_is_zero then
      m_flows =homotopy(actual=
        TRANSFORM.Fluid.Pipes_Obsolete.ClosureModels.PressureLoss.HeatExchangers.BellDelawareShell.EndCross.dp_MFLOW(
        IN_con,
        IN_var,
        dps_fg - {g*dheights[i]*rhos_act[i] for i in 1:nFM},
        dp_small/(nFM))*nParallel, simplified=m_flow_nominal/dp_nominal*(dps_fg
         - g*dheights*rho_nominal));
    else
      dps_fg =homotopy(actual=
        TRANSFORM.Fluid.Pipes_Obsolete.ClosureModels.PressureLoss.HeatExchangers.BellDelawareShell.EndCross.dp_DP(
        IN_con,
        IN_var,
        m_flows/nParallel,
        m_flow_small/nParallel) + {g*dheights[i]*rhos_act[i] for i in 1:nFM},
        simplified=dp_nominal/m_flow_nominal*m_flows + g*dheights*rho_nominal);
    end if;
  else
    // regularization for discontinuous flow reversal and static head
    rhos_a = rhos[1:nFM];
    rhos_b = rhos[2:nFM+1];
    mus_a = mus[1:nFM];
    mus_b = mus[2:nFM+1];
    if from_dp and not dp_is_zero then
      m_flows =homotopy(actual=
        TRANSFORM.Fluid.Pipes_Obsolete.ClosureModels.PressureLoss.HeatExchangers.BellDelawareShell.EndCross.dp_MFLOW_staticHead(
        IN_con,
        IN_var,
        dps_fg,
        dp_small/(nFM),
        g*dheights)*nParallel, simplified=m_flow_nominal/dp_nominal*(dps_fg - g
        *dheights*rho_nominal));
    else
      dps_fg =homotopy(actual=
        TRANSFORM.Fluid.Pipes_Obsolete.ClosureModels.PressureLoss.HeatExchangers.BellDelawareShell.EndCross.dp_DP_staticHead(
        IN_con,
        IN_var,
        m_flows/nParallel,
        m_flow_small/nParallel,
        g*dheights), simplified=dp_nominal/m_flow_nominal*m_flows + g*dheights*
        rho_nominal);
    end if;
  end if;
    annotation (Documentation(info="<html>
<p>
This model describes pressure losses due to <b>wall friction</b> in a pipe
and due to <b>gravity</b>.
Correlations of different complexity and validity can be
selected via the replaceable package <b>WallFriction</b> (see parameter menu below).
The details of the pipe wall friction model are described in the
<a href=\"modelica://Modelica.Fluid.UsersGuide.ComponentDefinition.WallFriction\">UsersGuide</a>.
Basically, different variants of the equation
</p>

<pre>
   dp = &lambda;(Re,<font face=\"Symbol\">D</font>)*(L/D)*&rho;*v*|v|/2.
</pre>

<p>

By default, the correlations are computed with media data at the actual time instant.
In order to reduce non-linear equation systems, the parameters
<b>use_mu_nominal</b> and <b>use_rho_nominal</b> provide the option
to compute the correlations with constant media values
at the desired operating point. This might speed-up the
simulation and/or might give a more robust simulation.
</p>
</html>"),
    Diagram(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}}), graphics={
    Rectangle(
      extent={{-100,64},{100,-64}},
      lineColor={0,0,0},
      fillColor={255,255,255},
      fillPattern=FillPattern.Backward),
    Rectangle(
      extent={{-100,50},{100,-49}},
      lineColor={0,0,0},
      fillColor={255,255,255},
      fillPattern=FillPattern.Solid),
    Line(
      points={{-60,-49},{-60,50}},
      color={0,0,255},
      arrow={Arrow.Filled,Arrow.Filled}),
    Text(
      extent={{-50,16},{6,-10}},
      lineColor={0,0,255},
      textString="diameters"),
    Line(
      points={{-100,74},{100,74}},
      color={0,0,255},
      arrow={Arrow.Filled,Arrow.Filled}),
    Text(
      extent={{-32,93},{32,74}},
      lineColor={0,0,255},
      textString="pathLengths")}));
end ShellEndCrossFlow;
