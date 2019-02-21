within TRANSFORM.Fluid.Volumes;
model Deaeratorold
  import Modelica.Constants.pi;
  extends TRANSFORM.Fluid.Volumes.BaseClasses.PartialVolume_wlevel(
    redeclare replaceable package Medium =
        Modelica.Media.Water.WaterIF97_ph
      constrainedby Modelica.Media.Interfaces.PartialTwoPhaseMedium,
    final V=pi*rint^2*L,
    use_T_start=false,
    T_start=Medium.saturationTemperature(p_start),
    h_start=Medium.bubbleEnthalpy(Medium.setSat_p(p_start)));
  input SI.Acceleration g_n=Modelica.Constants.g_n "Gravitational acceleration"
    annotation (Dialog(tab="Advanced", group="Inputs"));
  constant SI.Pressure p_crit=Medium.fluidConstants[1].criticalPressure;
  parameter SI.Length rint=0 "Internal radius"
    annotation (Dialog(group="Geometry"));
  parameter SI.Length rext=0 "External radius"
    annotation (Dialog(group="Geometry"));
  parameter SI.Length L=0 "Length" annotation (Dialog(group="Geometry"));
  parameter Integer DrumOrientation=0 "0: Horizontal; 1: Vertical"
    annotation (Dialog(group="Geometry"));
  final parameter SI.Length level_max=if DrumOrientation == 0 then rint else L/2
    "Maximum possible level (relative to the centerline)";
  final parameter SI.Length level_min=if DrumOrientation == 0 then -rint else -
      L/2 "Minimum possible level (relative to the centerline)";
  SI.Volume V_liquid(start=pi*rint^2*L/2) "Liquid volume";
  Interfaces.FluidPort_State feed(redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{-80,60},{-60,80}}),
        iconTransformation(extent={{-80,60},{-60,80}})));
  Interfaces.FluidPort_State steam(redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{60,60},{80,80}}),
        iconTransformation(extent={{60,60},{80,80}})));
  Interfaces.FluidPort_State drain(redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{-10,-90},{10,-70}}),
        iconTransformation(extent={{-10,-90},{10,-70}})));
  BaseClasses.Summary_Deaerator summary(
    p=medium.p,
    h_in=actualStream(feed.h_outflow),
    h_out_steam=actualStream(steam.h_outflow),
    h_out_condensate=actualStream(drain.h_outflow),
    m_flow_in=feed.m_flow,
    m_flow_out_steam=-steam.m_flow,
    m_flow_out_condensate=-drain.m_flow,
    level=level,
    level_max=level_max,
    level_min=level_min,
    x=mediaProps.x_abs,
    T_gas=medium.T,
    T_liquid=medium.T,
    T_wall=300,
    Q_loss=0,
    m=m) annotation (Placement(transformation(extent={{80,-100},{100,-80}})));
  Media.BaseProperties2Phase mediaProps(redeclare package Medium = Medium,
      state=medium.state)
    annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));
  HeatAndMassTransfer.Interfaces.HeatPort_State heatPort annotation (Placement(
        transformation(extent={{90,-10},{110,10}}), iconTransformation(extent={
            {90,-10},{110,10}})));
  // Visualization
  parameter Boolean showName=true annotation (Dialog(tab="Visualization"));
equation
  // Heat Transfer connections
  heatPort.T = medium.T;
  mb = feed.m_flow + steam.m_flow + drain.m_flow "Mass balance";
  Ub = feed.m_flow*actualStream(feed.h_outflow) + steam.m_flow*actualStream(
    steam.h_outflow) + drain.m_flow*actualStream(drain.h_outflow) + heatPort.Q_flow
    "Energy balance";
  for i in 1:Medium.nXi loop
    mXib[i] = feed.m_flow*actualStream(feed.Xi_outflow[i]) + drain.m_flow*
      actualStream(drain.Xi_outflow[i]) + steam.m_flow*actualStream(steam.C_outflow[
      i]);
  end for;
  for i in 1:Medium.nC loop
    mCb[i] = feed.m_flow*actualStream(feed.C_outflow[i]) + drain.m_flow*
      actualStream(drain.C_outflow[i]) + steam.m_flow*actualStream(steam.C_outflow[
      i]);
  end for;
  if DrumOrientation == 0 then
    V_liquid = L*(rint^2*acos(-level/rint) + level*sqrt(rint^2 - level^2))
      "Liquid volume";
  else
    V_liquid = pi*rint^2*(level + L/2) "Liquid volume";
  end if;
  V_liquid =(1 - mediaProps.x_abs)*m/mediaProps.rho_lsat;
  // Boundary conditions
  feed.p = medium.p;
  feed.h_outflow =mediaProps.h_lsat;
  feed.Xi_outflow = medium.Xi;
  feed.C_outflow = C;
  drain.p =medium.p + mediaProps.rho_lsat*g_n*level;
  drain.h_outflow =mediaProps.h_lsat;
  drain.Xi_outflow = medium.Xi;
  drain.C_outflow = C;
  steam.p = medium.p;
  steam.h_outflow =mediaProps.h_vsat;
  steam.Xi_outflow = medium.Xi;
  steam.C_outflow = C;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Deaeratorold;
