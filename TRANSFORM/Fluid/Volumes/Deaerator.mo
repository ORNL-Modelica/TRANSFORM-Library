within TRANSFORM.Fluid.Volumes;
model Deaerator

  import TRANSFORM.Types.Dynamics;
  import Modelica.Constants.pi;
  extends BaseClasses.Icon_TwoVolume;

  // Geometry Model
  replaceable model Geometry =
      TRANSFORM.Fluid.ClosureRelations.Geometry.Models.TwoVolume_withLevel.Cylinder
    constrainedby
    TRANSFORM.Fluid.ClosureRelations.Geometry.Models.TwoVolume_withLevel.GenericVolume
    "Geometry" annotation (Dialog(group="Geometry"), choicesAllMatching=true);

  Geometry geometry(V_liquid=V)
    annotation (Placement(transformation(extent={{-78,82},{-62,98}})));

  extends TRANSFORM.Fluid.Volumes.BaseClasses.PartialVolume_wlevel(
  redeclare replaceable package Medium =
        Modelica.Media.Water.StandardWater
    constrainedby Modelica.Media.Interfaces.PartialTwoPhaseMedium,
    final level=geometry.level,
    level_start=geometry.level_0,
    T_start=Medium.saturationTemperature(p_start),
    h_start=Medium.bubbleEnthalpy(Medium.setSat_p(p_start)),
    medium(phase(start = if (h_start < Medium.bubbleEnthalpy(Medium.setSat_p(p_start)) or h_start > Medium.dewEnthalpy(Medium.setSat_p(p_start)) or p_start >
             Medium.fluidConstants[1].criticalPressure) then 1 else 2)));

  input SI.Density d_wall=0 "Density of wall" annotation (Dialog(group="Input Variables"));
  input SI.SpecificHeatCapacity cp_wall= 0 "Wall specific heat capacity" annotation (Dialog(group="Input Variables"));

  input SI.Temperature T_external=293.15 "External atmospheric temperature" annotation (Dialog(group="Input Variables: Heat Transfer"));
  input SI.CoefficientOfHeatTransfer alpha_external=0
    "Heat transfer coefficient between wall and external environment (T_external)"
    annotation (Dialog(group="Input Variables: Heat Transfer"));
  input SI.CoefficientOfHeatTransfer alpha_internal=200
    "Heat transfer coefficient between wall and internal state" annotation (
     Evaluate=true, Dialog(group="Input Variables: Heat Transfer"));

  parameter SI.Temperature Twall_start=293.15 "Initial wall temperature"
    annotation (Dialog(tab="Initialization"));

  input SI.Acceleration g_n=g_n_start
    "Gravitational acceleration" annotation (Dialog(tab="Advanced"));
  parameter SI.Acceleration g_n_start=Modelica.Constants.g_n
    "Initial gravitational acceleration" annotation (Dialog(tab="Advanced"));

  SI.HeatFlowRate Q_flow_WInt "Heat flow from the wall to the internal state";
  SI.HeatFlowRate Q_flow_WExt "Heat flow from the wall to the atmosphere";

  SI.Temperature Twall(start=Twall_start) "Wall temperature";
  SI.HeatCapacity Cwall = d_wall*cp_wall*geometry.V_wall "Wall heat capacitance";

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
    level=geometry.level_meas,
    level_max=geometry.level_meas_max,
    level_min=geometry.level_meas_min,
    x=mediaProps.x_abs,
    T_gas=medium.T,
    T_liquid=medium.T,
    T_wall=300,
    Q_loss=0,
    m=m) annotation (Placement(transformation(extent={{80,-100},{100,-80}})));

  Media.BaseProperties2Phase mediaProps(redeclare package Medium = Medium,
      state=medium.state)
    annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));

  // Visualization
  parameter Boolean showName=true annotation (Dialog(tab="Visualization"));

initial equation

  if energyDynamics == Dynamics.FixedInitial then
      Twall = Twall_start;
  elseif energyDynamics == Dynamics.SteadyStateInitial then
      der(Twall) = 0;
  end if;

equation

  //Wall energy balance
  if energyDynamics == Dynamics.SteadyState then
    0 = -Q_flow_WInt - Q_flow_WExt;
  else
    Cwall*der(Twall) = -Q_flow_WInt - Q_flow_WExt;
  end if;

  mb = feed.m_flow + steam.m_flow + drain.m_flow;
  Ub = feed.m_flow*actualStream(feed.h_outflow) + steam.m_flow*actualStream(
    steam.h_outflow) + drain.m_flow*actualStream(drain.h_outflow);

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

  V =(1 - mediaProps.x_abs)*m/mediaProps.rho_lsat;

  Q_flow_WExt = alpha_external*geometry.surfaceArea*(Twall - T_external);
  Q_flow_WInt = alpha_internal*geometry.surfaceArea_outer*(Twall - medium.T);

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
end Deaerator;
