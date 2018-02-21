within TRANSFORM.Fluid.Volumes;
model Separator

  extends TRANSFORM.Fluid.Volumes.MixingVolume(
    mb=sum(port_a.m_flow) + sum(port_b.m_flow) + portLiquid.m_flow,
    Ub=sum(H_flows_a) + sum(H_flows_b) + portLiquid.m_flow*actualStream(
        portLiquid.h_outflow) + Q_flow_internal + Q_gen,
    mXib={sum(mXi_flows_a[:, i]) + sum(mXi_flows_b[:, i]) + portLiquid.m_flow*
        actualStream(portLiquid.Xi_outflow[i]) for i in 1:Medium.nXi},
    mCb={sum(mC_flows_a[:, i]) + sum(mC_flows_b[:, i]) + portLiquid.m_flow*
        actualStream(portLiquid.C_outflow[i]) + mC_flow_internal[i] + mC_gen[i]
        for i in 1:Medium.nC});

  parameter SI.Efficiency eta_sep(
    min=0,
    max=1) = 0.99 "Separation efficiency";

  SI.MassFlowRate m_cond;
  SI.MassFraction x_abs;
  SI.Pressure p_crit=Medium.fluidConstants[1].criticalPressure;
  SI.SpecificEnthalpy h_lsat;
  SI.SpecificEnthalpy h_vsat;

  Interfaces.FluidPort_Flow portLiquid(redeclare package Medium = Medium, p(
        start=p_start)) annotation (Placement(transformation(extent={{-50,-50},
            {-30,-30}}), iconTransformation(extent={{-50,-50},{-30,-30}})));

equation

  x_abs = noEvent(if medium.p/p_crit < 1.0 then max(0.0, min(1.0, (medium.h -
    h_lsat)/max(h_vsat - h_lsat, 1e-6))) else 1.0) "Steam quality";

  h_lsat = Medium.specificEnthalpy(Medium.setBubbleState(Medium.setSat_p(medium.p)));
  h_vsat = Medium.specificEnthalpy(Medium.setDewState(Medium.setSat_p(medium.p)));
  assert(x_abs > 0, "Steam separator is full with liquid.");

  m_cond = -max(0, 1 - x_abs)*max({sum(port_a.m_flow),sum(port_b.m_flow),0})*
    eta_sep;

  portLiquid.m_flow = m_cond;
  portLiquid.h_outflow = h_lsat;
  portLiquid.Xi_outflow = medium.Xi;
  portLiquid.C_outflow = C;

  annotation (
    defaultComponentName="volume",
    Icon(coordinateSystem(preserveAspectRatio=false), graphics={Ellipse(
          extent={{60,60},{-60,-60}},
          lineColor={0,0,0},
          fillColor={0,128,255},
          fillPattern=FillPattern.Sphere), Text(
          extent={{-151,104},{149,64}},
          lineColor={0,0,255},
          textString="%name",
          visible=DynamicSelect(true, showName))}),
    Diagram(coordinateSystem(preserveAspectRatio=false)));
end Separator;
