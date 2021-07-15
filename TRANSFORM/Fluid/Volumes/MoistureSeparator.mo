within TRANSFORM.Fluid.Volumes;
model MoistureSeparator
  extends BaseClasses.PartialSimpleVolume(
    redeclare replaceable package Medium =
        Modelica.Media.Interfaces.PartialTwoPhaseMedium,
    mb=port_a.m_flow + port_b.m_flow + port_Liquid.m_flow,
    Ub=port_a.m_flow*actualStream(port_a.h_outflow) + port_b.m_flow*
        actualStream(port_b.h_outflow) + Q_flow_internal + Q_gen + port_Liquid.m_flow
        *actualStream(port_Liquid.h_outflow),
    mXib=port_a.m_flow*actualStream(port_a.Xi_outflow) + port_b.m_flow*
        actualStream(port_b.Xi_outflow) + port_Liquid.m_flow*actualStream(
        port_Liquid.Xi_outflow),
    mCb=port_a.m_flow*actualStream(port_a.C_outflow) + port_b.m_flow*
        actualStream(port_b.C_outflow) + mC_flow_internal + mC_gen +
        port_Liquid.m_flow*actualStream(port_Liquid.C_outflow));

  Interfaces.FluidPort_Flow port_Liquid(redeclare package Medium = Medium, p(
        start=p_start)) annotation (Placement(transformation(extent={{-50,-50},{
            -30,-30}}), iconTransformation(extent={{-50,-50},{-30,-30}})));

  input SI.Efficiency eta_sep(
    min=0,
    max=1) = 1.0 "Separation efficiency" annotation(Dialog(group="Inputs"));

  SI.MassFlowRate m_cond;
  SI.MassFraction x_abs;
  SI.Pressure p_crit=Medium.fluidConstants[1].criticalPressure;
  SI.SpecificEnthalpy h_lsat;
  SI.SpecificEnthalpy h_vsat;
  SI.SpecificEnthalpy enthalpy_usedfor_inlet;

equation

  x_abs = noEvent(if medium.p/p_crit < 1.0 then max(0.0, min(1.0, (medium.h -
    h_lsat)/max(h_vsat - h_lsat, 1e-6))) else 1.0) "Steam quality";

  h_lsat = Medium.specificEnthalpy(Medium.setBubbleState(Medium.setSat_p(medium.p)));
  h_vsat = Medium.specificEnthalpy(Medium.setDewState(Medium.setSat_p(medium.p)));
  assert(x_abs > 0, "Steam separator is full with liquid.");

  m_cond = -max(0, 1 - x_abs)*max({port_a.m_flow,port_b.m_flow,0})*eta_sep;

  port_Liquid.m_flow = m_cond;
  port_Liquid.h_outflow = h_lsat;
  port_Liquid.Xi_outflow = medium.Xi;
  port_Liquid.C_outflow = C;

  port_b.h_outflow = h_lsat + eta_sep*(h_vsat - h_lsat);
  port_b.Xi_outflow = medium.Xi;
  port_b.p = medium.p;
  port_b.C_outflow = C;

  port_a.p = medium.p + medium.d*g_n*0.5*geometry.dheight;
  port_a.h_outflow = medium.h;
  port_a.Xi_outflow = medium.Xi;
  port_a.C_outflow = C;

  enthalpy_usedfor_inlet = actualStream(port_a.h_outflow);

  annotation (defaultComponentName="separator");
end MoistureSeparator;
