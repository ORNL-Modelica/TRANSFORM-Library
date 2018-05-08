within TRANSFORM.Fluid.Volumes;
model BoilerDrum

  import Modelica.Fluid.Types.Dynamics;
  extends BaseClasses.Icon_TwoVolume;

  // Geometry Model
  replaceable model Geometry =
      TRANSFORM.Fluid.ClosureRelations.Geometry.Models.TwoVolume_withLevel.Cylinder
    constrainedby
    TRANSFORM.Fluid.ClosureRelations.Geometry.Models.TwoVolume_withLevel.GenericVolume
    "Geometry" annotation (Dialog(group="Geometry"), choicesAllMatching=true);

  Geometry geometry(V_liquid=V_liquid)
    annotation (Placement(transformation(extent={{-78,82},{-62,98}})));

  extends BaseClasses.PartialTwoVolume_wlevel(
  redeclare replaceable package Medium =
        Modelica.Media.Water.StandardWater
    constrainedby Modelica.Media.Interfaces.PartialTwoPhaseMedium,
    final V_vapor=geometry.V_vapor,
    final level=geometry.level,
    level_start=geometry.level_0,
    p_liquid_start=p_vapor_start,
    T_liquid_start=Medium.saturationTemperature(p_liquid_start),
    T_vapor_start=Medium.saturationTemperature(p_vapor_start),
    h_liquid_start=Medium.bubbleEnthalpy(Medium.setSat_p(p_liquid_start)),
    h_vapor_start=Medium.bubbleEnthalpy(Medium.setSat_p(p_vapor_start)),
    medium_liquid(phase(start=if (h_liquid_start < Medium.bubbleEnthalpy(
            Medium.setSat_p(p_liquid_start)) or h_liquid_start >
            Medium.dewEnthalpy(Medium.setSat_p(p_liquid_start)) or
            p_liquid_start > Medium.fluidConstants[1].criticalPressure) then 1
             else 2)),
    medium_vapor(phase(start=if (h_vapor_start < Medium.bubbleEnthalpy(
            Medium.setSat_p(p_vapor_start)) or h_vapor_start >
            Medium.dewEnthalpy(Medium.setSat_p(p_vapor_start)) or p_vapor_start >
            Medium.fluidConstants[1].criticalPressure) then 1 else 2)));

  parameter SI.Length portPosition_downcomer = geometry.level_0
    "Position of downcomer port. Static head = 0 when position >= level"
    annotation (Dialog(group="Port position", tab="Advanced"));
  parameter SI.Length portPosition_riser=0
    "Position of riser port. Static head = 0 when position >= level"
    annotation (Dialog(group="Port position", tab="Advanced"));

  parameter Boolean use_VaporHeatPort=false "Enable heat connector to vapor"
    annotation (Evaluate=true, Dialog(tab="Advanced"));
  parameter Boolean use_LiquidHeatPort=false "Enable heat connector to liquid"
    annotation (Evaluate=true, Dialog(tab="Advanced"));

  input SI.Density d_wall=0 "Density of wall" annotation (Dialog(group="Inputs"));
  input SI.SpecificHeatCapacity cp_wall= 0 "Wall specific heat capacity" annotation (Dialog(group="Inputs"));

  input Real eta_sep=1.0 "Phase separation efficiency coefficient" annotation (Dialog(group="Inputs Mass Transfer"));
  input SI.Time tau_eBulk=15 "Time constant of bulk evaporation"
    annotation (Dialog(group="Inputs Mass Transfer"));
  input SI.Time tau_cBulk=15 "Time constant of bulk condensation"
    annotation (Dialog(group="Inputs Mass Transfer"));
  input Real alphaM_VL(unit="kg/(s.m2.K)")=0
    "Vapor/liquid surface condensation coefficient"
    annotation (Dialog(group="Inputs Mass Transfer"));

  input SI.Temperature T_external=293.15 "External atmospheric temperature" annotation (Dialog(group="Inputs Heat Transfer"));
  input SI.CoefficientOfHeatTransfer alpha_external=0
    "Heat transfer coefficient between wall and external environment (T_external)"
    annotation (Dialog(group="Inputs Heat Transfer"));
  input SI.CoefficientOfHeatTransfer alpha_WL=200
    "Heat transfer coefficient between wall and liquid phase" annotation (
     Evaluate=true, Dialog(group="Inputs Heat Transfer"));
  input SI.CoefficientOfHeatTransfer alpha_WV=200
    "Heat transfer coefficient between wall and vapor phase" annotation (
      Evaluate=true, Dialog(group="Inputs Heat Transfer"));
  input SI.CoefficientOfHeatTransfer alpha_VL=0
    "Vapor/liquid surface heat transfer coefficient"
    annotation (Dialog(group="Inputs Heat Transfer"));

  parameter SI.Temperature Twall_start=293.15 "Initial wall temperature"
    annotation (Dialog(tab="Initialization"));

  input SI.Acceleration g_n=g_n_start
    "Gravitational acceleration" annotation (Dialog(tab="Advanced"));
  parameter SI.Acceleration g_n_start=Modelica.Constants.g_n
    "Initial gravitational acceleration" annotation (Dialog(tab="Advanced"));

  SI.Temperature Twall(start=Twall_start) "Wall temperature";

  Real x_abs_riser "Steam quality of the fluid from the risers";
  SI.SpecificEnthalpy h_riser "Specific enthalpy of fluid from the risers";
  SI.MassFlowRate m_flow_riser "Mass flowrate from the risers";

  SI.SpecificEnthalpy h_riserSepVap
    "Specific enthalpy of vapor from the risers after separation";
  SI.SpecificEnthalpy h_riserSepLiq
    "Specific enthalpy of liquid from the risers after separation";

  SI.MassFlowRate m_flow_riser_liquid "Mass flowrate of liquid from the risers";
  SI.MassFlowRate m_flow_riser_vapor "Mass flowrate of vapor from the risers";
  SI.MassFlowRate m_flow_cBulk "Mass flowrate of bulk condensation";
  SI.MassFlowRate m_flow_cSurface "Mass flowrate of surface condensation";
  SI.MassFlowRate m_flow_eBulk "Mass flowrate of bulk evaporation";

  SI.HeatFlowRate Q_flow_WV "Heat flow from the wall to the vapor";
  SI.HeatFlowRate Q_flow_VL "Heat flow from the vapor to the liquid";
  SI.HeatFlowRate Q_flow_WL "Heat flow from the wall to the liquid";
  SI.HeatFlowRate Q_flow_WExt "Heat flow from the wall to the atmosphere";

  Real x_abs_riserSep "Steam quality of the separated steam from the risers";

  SI.HeatCapacity Cwall = d_wall*cp_wall*geometry.V_wall "Wall heat capacitance";

  Interfaces.FluidPort_State feedwaterPort(
    p(start=p_vapor_start),
    h_outflow(start=h_liquid_start),
    redeclare package Medium = Medium) annotation (Placement(transformation(
          extent={{90,-10},{110,10}},   rotation=0), iconTransformation(extent={{90,-10},
            {110,10}})));
  Interfaces.FluidPort_State steamPort(
    p(start=p_vapor_start),
    h_outflow(start=h_vapor_start),
    redeclare package Medium = Medium) annotation (Placement(transformation(
          extent={{60,64},{80,84}}, rotation=0), iconTransformation(extent={{60,
            66},{80,86}})));
  Interfaces.FluidPort_State riserPort(
    p(start=p_vapor_start),
    h_outflow(start=h_liquid_start),
    redeclare package Medium = Medium) annotation (Placement(transformation(
        origin={-70,-72},
        extent={{-10,-10},{10,10}},
        rotation=0), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-70,-80})));
  Interfaces.FluidPort_State downcomerPort(
    p(start=p_vapor_start),
    h_outflow(start=h_liquid_start),
    redeclare package Medium = Medium) annotation (Placement(transformation(
        origin={70,-74},
        extent={{-10,-10},{10,10}},
        rotation=0), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={70,-80})));
  Interfaces.FluidPort_State blowdownPort(
    p(start=p_vapor_start),
    h_outflow(start=h_liquid_start),
    redeclare package Medium = Medium) annotation (Placement(transformation(
        origin={0,-74},
        extent={{-10,-10},{10,10}},
        rotation=0), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={0,-80})));

  HeatAndMassTransfer.Interfaces.HeatPort_State heatPort_liquid(T=medium_liquid.T,
      Q_flow=Q_external_liquid) if                    use_LiquidHeatPort
    annotation (Placement(transformation(extent={{60,-50},{80,-30}}),
        iconTransformation(extent={{63,-48},{77,-34}})));
  HeatAndMassTransfer.Interfaces.HeatPort_State heatPort_vapor(T=medium_vapor.T,
      Q_flow=Q_external_vapor) if use_VaporHeatPort annotation (Placement(
        transformation(extent={{60,30},{80,50}}), iconTransformation(extent={{63,
            32},{77,46}})));

  Media.BaseProperties2Phase mediaProps_vapor(redeclare package Medium = Medium,
      state=medium_vapor.state)
    annotation (Placement(transformation(extent={{-100,-80},{-80,-60}})));
  Media.BaseProperties2Phase mediaProps_liquid(redeclare package Medium =
        Medium, state=medium_liquid.state)
    annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));

protected
  SI.HeatFlowRate Q_external_vapor;
  SI.HeatFlowRate Q_external_liquid;

initial equation

  if energyDynamics == Dynamics.FixedInitial then
      Twall = Twall_start;
  elseif energyDynamics == Dynamics.SteadyStateInitial then
      der(Twall) = 0;
  end if;

equation

  if not use_VaporHeatPort then
    Q_external_vapor = 0;
  end if;
  if not use_LiquidHeatPort then
    Q_external_liquid = 0;
  end if;

  //Wall energy balance
  if energyDynamics == Dynamics.SteadyState then
    0 = -Q_flow_WL - Q_flow_WV - Q_flow_WExt;
  else
    Cwall*der(Twall) = -Q_flow_WL - Q_flow_WV - Q_flow_WExt;
  end if;

  mb_vapor = m_flow_riser_vapor + m_flow_eBulk + steamPort.m_flow -
    m_flow_cBulk - m_flow_cSurface;
  mb_liquid = feedwaterPort.m_flow + m_flow_riser_liquid + m_flow_cBulk +
    m_flow_cSurface + downcomerPort.m_flow + blowdownPort.m_flow - m_flow_eBulk;

  Ub_vapor = m_flow_riser_vapor*h_riserSepVap + (m_flow_eBulk - m_flow_cSurface)
    *mediaProps_vapor.h_vsat - m_flow_cBulk*mediaProps_vapor.h_lsat + steamPort.m_flow
    *actualStream(steamPort.h_outflow) + Q_flow_WV - Q_flow_VL +
    Q_external_vapor - medium_vapor.p*der(V_vapor);
  Ub_liquid = feedwaterPort.m_flow*actualStream(feedwaterPort.h_outflow) +
    m_flow_riser_liquid*h_riserSepLiq + m_flow_cBulk*mediaProps_vapor.h_lsat + (
    m_flow_cSurface - m_flow_eBulk)*mediaProps_vapor.h_vsat + downcomerPort.m_flow
    *actualStream(downcomerPort.h_outflow) + blowdownPort.m_flow*actualStream(
    blowdownPort.h_outflow) + Q_flow_WL + Q_flow_VL + Q_external_liquid -
    medium_vapor.p*der(V_liquid);

  // mXib equations are wrong and must be revisited
  for i in 1:Medium.nXi loop
    mXib_vapor[i] = 0;
    mXib_liquid[i] = 0;
  end for;

  mCb_vapor = m_flow_riser_vapor*actualStream(riserPort.C_outflow) +
    m_flow_eBulk*C_liquid + steamPort.m_flow*actualStream(steamPort.C_outflow) -
    (m_flow_cBulk - m_flow_cSurface)*C_vapor;
  mCb_liquid = feedwaterPort.m_flow*actualStream(feedwaterPort.C_outflow) +
    m_flow_riser_liquid*actualStream(riserPort.C_outflow) + (m_flow_cBulk +
    m_flow_cSurface)*C_vapor + downcomerPort.m_flow*actualStream(downcomerPort.C_outflow)
     + blowdownPort.m_flow*actualStream(blowdownPort.C_outflow) - m_flow_eBulk*
    C_liquid;

  m_flow_eBulk = mediaProps_liquid.x_abs*medium_liquid.d*V_liquid/tau_eBulk;
  m_flow_cBulk = (1 - mediaProps_vapor.x_abs)*medium_vapor.d*V_vapor/tau_cBulk;
  m_flow_cSurface = alphaM_VL*geometry.surfaceArea_VL*(mediaProps_vapor.sat.Tsat- medium_liquid.T);

  Q_flow_WExt = alpha_external*geometry.surfaceArea*(Twall - T_external);
  Q_flow_WL = alpha_WL*geometry.surfaceArea_WL*(Twall - medium_liquid.T);
  Q_flow_WV = alpha_WV*geometry.surfaceArea_WV*(Twall - medium_vapor.T);
  Q_flow_VL = alpha_VL*geometry.surfaceArea_VL*(medium_vapor.T -
    mediaProps_vapor.sat.Tsat);

  h_riserSepVap = mediaProps_vapor.h_lsat + x_abs_riserSep*(mediaProps_vapor.h_vsat
     - mediaProps_vapor.h_lsat);
  x_abs_riserSep = 1 - (medium_vapor.d/medium_liquid.d)^eta_sep;
  h_riser = actualStream(riserPort.h_outflow);
  x_abs_riser = smooth(0, if m_flow_riser >= 0 then (if h_riser >
    mediaProps_vapor.h_lsat then (h_riser - mediaProps_vapor.h_lsat)/(
    mediaProps_vapor.h_vsat - mediaProps_vapor.h_lsat) else 0) else
    mediaProps_liquid.x_abs);
  h_riserSepLiq = smooth(0, if m_flow_riser >= 0 then (if h_riser >
    mediaProps_vapor.h_lsat then mediaProps_vapor.h_lsat else h_riser) else
    medium_liquid.h);
  m_flow_riser = riserPort.m_flow;
  m_flow_riser_vapor = smooth(0, if m_flow_riser >= 0 then x_abs_riser*
    m_flow_riser/x_abs_riserSep else 0);
  m_flow_riser_liquid = m_flow_riser - m_flow_riser_vapor;

  // Boundary conditions
  medium_vapor.p = medium_liquid.p;

  feedwaterPort.p = medium_vapor.p;
  feedwaterPort.h_outflow = medium_liquid.h;
  feedwaterPort.Xi_outflow = medium_liquid.Xi;
  feedwaterPort.C_outflow = C_liquid;

  downcomerPort.p = medium_vapor.p + medium_liquid.d*g_n*max(0, (level - portPosition_downcomer));
  downcomerPort.h_outflow = medium_liquid.h;
  downcomerPort.Xi_outflow = medium_liquid.Xi;
  downcomerPort.C_outflow = C_liquid;

  blowdownPort.p = medium_vapor.p;
  blowdownPort.h_outflow = medium_liquid.h;
  blowdownPort.Xi_outflow = medium_liquid.Xi;
  blowdownPort.C_outflow = C_liquid;

  riserPort.p = medium_vapor.p + medium_liquid.d*g_n*max(0, (level - portPosition_riser));
  riserPort.h_outflow = medium_liquid.h;
  riserPort.Xi_outflow = medium_liquid.Xi;
  riserPort.C_outflow = C_liquid;

  steamPort.p = medium_vapor.p;
  steamPort.h_outflow = medium_vapor.h;
  steamPort.Xi_outflow = medium_vapor.Xi;
  steamPort.C_outflow = C_vapor;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-6,-22},{6,-80}},
          lineColor={0,0,0},
          fillColor={135,135,135},
          fillPattern=FillPattern.VerticalCylinder),
        Rectangle(
          extent={{-76,-58},{-65,-80}},
          lineColor={0,0,0},
          fillColor={135,135,135},
          fillPattern=FillPattern.VerticalCylinder),
        Rectangle(
          extent={{64,-58},{75,-80}},
          lineColor={0,0,0},
          fillColor={135,135,135},
          fillPattern=FillPattern.VerticalCylinder)}),
                                            Diagram(coordinateSystem(
          preserveAspectRatio=false)));
end BoilerDrum;
