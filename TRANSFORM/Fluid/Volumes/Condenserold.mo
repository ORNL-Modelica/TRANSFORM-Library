within TRANSFORM.Fluid.Volumes;
model Condenserold

  extends TRANSFORM.Fluid.Volumes.BaseClasses.PartialVolume_wlevelold(
    redeclare replaceable package Medium =
        Modelica.Media.Water.WaterIF97_ph
      constrainedby Modelica.Media.Interfaces.PartialTwoPhaseMedium,
    final V=V_hotwell + length*pi*diameter^2/4,
    use_T_start=false,
    T_start=Medium.saturationTemperature(p_start),
    h_start=Medium.bubbleEnthalpy(Medium.setSat_p(p_start)));

  import Modelica.Fluid.Types.Dynamics;

  parameter Dynamics energyDynamicsWall=Dynamics.FixedInitial
    "Formulation of energy balances"
    annotation (Dialog(tab="Initialization", group="Dynamics"));

  import Modelica.Constants.pi;

  replaceable package CoolMedium = Modelica.Media.Water.StandardWater
    constrainedby Modelica.Media.Interfaces.PartialMedium "Cooling medium"
    annotation (choicesAllMatching);

  parameter Integer DrumOrientation=0 "0: Horizontal; 1: Vertical"
    annotation (Dialog(tab="General", group="Geometry"));
  parameter SI.Length diameter=1 "Shell cylinder diameter"
    annotation (Dialog(tab="General", group="Geometry"));
  parameter SI.Length length=5 "Shell cylinder length (along tubes)"
    annotation (Dialog(tab="General", group="Geometry"));

  parameter Integer N_tubes=1000 "Total number of parallel tubes"
    annotation (Dialog(tab="General", group="Geometry - cooling tubes"));
  parameter SI.Length tubelength=length "Effective tubelength (single tube)"
    annotation (Dialog(tab="General", group="Geometry - cooling tubes"));
  parameter SI.Length d_inner=0.016 "Inner diameter (single tube)"
    annotation (Dialog(tab="General", group="Geometry - cooling tubes"));
  parameter SI.Length d_outer=0.020 "Outer diameter (single tube)"
    annotation (Dialog(tab="General", group="Geometry - cooling tubes"));
  parameter SI.Volume V_hotwell=1.0 "Hotwell liquid volume"
    annotation (Dialog(tab="General", group="Geometry"));
  parameter SI.Area A_hotwell=1.0 "Hotwell surface area"
    annotation (Dialog(tab="General", group="Geometry"));

  final parameter SI.Area surfaceArea_inner=N_tubes*pi*tubelength*d_inner
    "Inner heat transfer area (total)";
  final parameter SI.Area surfaceArea_outer=N_tubes*pi*tubelength*d_outer
    "Inner heat transfer area (total)";
  final parameter SI.Area Afreeflow=tubelength*(diameter - d_outer*sqrt(N_tubes))
    "Outer free flow area";

  replaceable package MaterialWall =
      TRANSFORM.Media.Solids.CustomSolids.Lambda_fT_d_7763_cp_fT constrainedby
    TRANSFORM.Media.Interfaces.Solids.PartialAlloy
                                            "Coolant wall material properties" annotation (
      choicesAllMatching=true);

  final parameter SI.Length level_max=if DrumOrientation == 0 then diameter
       else length
    "Maximum possible level (relative to the condenser bottom outlet)";
  final parameter SI.Length level_min=min(-V_hotwell/A_hotwell, -1e-5)
    "Minimum possible Level (relative to the condenser bottom outlet)";
  constant SI.Area Aunit=1.0 "Unit area to match units of levels and volumes";

  parameter SI.CoefficientOfHeatTransfer alpha=1
    "Convection heat transfer coefficient";
  input SI.Acceleration g_n=Modelica.Constants.g_n "Gravitational acceleration"
    annotation (Dialog(tab="Advanced", group="Inputs"));

  parameter SI.Temperature Twall_start=300 "Tube wall temperature start value"
    annotation (Dialog(tab="Initialization"));

  CoolMedium.ThermodynamicState state_coolingwater(h(start=
          CoolMedium.specificEnthalpy(CoolMedium.setState_pTX(
          2e5,
          Twall_start - 5,
          CoolMedium.X_default))));

  SI.Volume V_liquid(start=V_hotwell + level_start*Aunit) "Liquid volume";
  SI.Power Q_cool "Total power to cooling water";
  SI.MassFlowRate m_flow "Total mass flowrate";
  SI.Temperature Tcool_in "Cooling water inlet temperature";
  SI.Temperature Tcool_out "Cooling water outlet temperature";
  SI.Conversions.NonSIunits.Temperature_degC dT_lm
    "Log mean temperature difference, water side";

  TRANSFORM.HeatAndMassTransfer.Volumes.SimpleWall tubeWall(
    T_start=Twall_start,
    th=(d_outer - d_inner)/2,
    surfaceArea=N_tubes*pi*tubelength*(d_inner + d_outer)/2,
    energyDynamics=energyDynamicsWall,
    redeclare package Material = MaterialWall)
                                       annotation (Placement(transformation(
        origin={0,10},
        extent={{-10,10},{10,-10}},
        rotation=180)));

  Interfaces.FluidPort_State feed(redeclare package Medium = Medium)
    "portSteam_a" annotation (Placement(transformation(extent={{-80,60},{-60,80}}),
        iconTransformation(extent={{-80,60},{-60,80}})));
  Interfaces.FluidPort_Flow drain_cool(redeclare package Medium = CoolMedium)
    "portCoolant_b" annotation (Placement(transformation(extent={{100,-30},{120,
            -10}}),iconTransformation(extent={{100,-30},{120,-10}})));
  Interfaces.FluidPort_Flow feed_cool(redeclare package Medium = CoolMedium)
    "portCoolant_a"
    annotation (Placement(transformation(extent={{100,30},{120,50}}),
        iconTransformation(extent={{100,30},{120,50}})));
  Interfaces.FluidPort_State drain(redeclare package Medium = Medium)
    "portSteam_b" annotation (Placement(transformation(extent={{-10,-110},{10,-90}}),
        iconTransformation(extent={{-10,-110},{10,-90}})));

  HeatAndMassTransfer.BoundaryConditions.Heat.Temperature T_cool(each use_port=
        true)
    annotation (Placement(transformation(extent={{55,2.5},{40,17.5}})));
  Modelica.Blocks.Sources.RealExpression T_coolant(y=tubeWall.material.T -
        dT_lm) annotation (Placement(transformation(extent={{80,0},{60,20}})));
  HeatAndMassTransfer.Resistances.Heat.Convection heatRes_outer(surfaceArea=
        surfaceArea_outer, alpha=alpha) annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={-25,10})));

  HeatAndMassTransfer.BoundaryConditions.Heat.Temperature T_shell(each use_port=
       true)
    annotation (Placement(transformation(extent={{-55,2.5},{-40,17.5}})));
  Modelica.Blocks.Sources.RealExpression T_condenser(y=medium.T)
    annotation (Placement(transformation(extent={{-80,0},{-60,20}})));

  HeatAndMassTransfer.Resistances.Heat.ConvectionMedia heatRes_inner(
    dimensions={d_inner},
    redeclare model HeatTransferCoeff =
        HeatAndMassTransfer.ClosureRelations.HeatTransfer.Models.Nus_SinglePhase_2Region,
    redeclare package Medium = CoolMedium,
    states=heatRes_inner.Medium.setState_pTX(fill(feed_cool.p, 1),
        heatRes_inner.port_b.T),
    m_flows={feed_cool.m_flow/N_tubes},
    dlengths={tubelength},
    surfaceAreas={surfaceArea_inner})
    annotation (Placement(transformation(extent={{13,0},{33,20}})));

  Media.BaseProperties2Phase mediaProps(redeclare package Medium = Medium,
      state=medium.state)
    annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));

equation

  assert(medium.p > 1000, "Condenser pressure is too low, check liquid level.");
  assert(level < 0.99*level_max, "Condenser is full of liquid, invalid condition.");

  mb = feed.m_flow + drain.m_flow;
  Ub = feed.m_flow*actualStream(feed.h_outflow) + drain.m_flow*actualStream(
    drain.h_outflow) + heatRes_outer.port_a.Q_flow;

  for i in 1:Medium.nXi loop
    mXib[i] = feed.m_flow*actualStream(feed.Xi_outflow[i]) + drain.m_flow*
      actualStream(drain.Xi_outflow[i]);
  end for;
  for i in 1:Medium.nC loop
    mCb[i] = feed.m_flow*actualStream(feed.C_outflow[i]) + drain.m_flow*
      actualStream(drain.C_outflow[i]);
  end for;

  level = noEvent(if V_liquid < V_hotwell then (V_liquid - V_hotwell)/A_hotwell
     else if DrumOrientation == 0 then (V_liquid - V_hotwell - length*diameter^2
    /4*acos((diameter - 2*level)/diameter))/sqrt(diameter*level - level^2)/
    length + diameter/2 else (V_liquid - V_hotwell)/(pi*diameter^2/4));
  V_liquid =(1 - mediaProps.x_abs)*m/mediaProps.rho_lsat
                                                      "Liquid volume";

  // Boundary Conditions
  m_flow = feed.m_flow;
  feed.p = medium.p;
  feed.h_outflow = medium.h;

  feed.C_outflow = C;
  drain.p =medium.p + mediaProps.rho_lsat*g_n*(level + V_hotwell/A_hotwell);
  drain.h_outflow =TRANSFORM.Math.spliceTanh(
    medium.h,
    mediaProps.h_lsat,
    mediaProps.x_abs - 0.75,
    0.25);
  feed.Xi_outflow = medium.Xi;
  drain.Xi_outflow = medium.Xi;
  drain.C_outflow = C;

  /* Coolant Equations */
  state_coolingwater = CoolMedium.setState_phX(
    drain_cool.p,
    actualStream(drain_cool.h_outflow),
    CoolMedium.X_default);

  // Boundary Conditions
  feed_cool.p = drain_cool.p;
  Tcool_in = CoolMedium.temperature(CoolMedium.setState_phX(
    feed_cool.p,
    actualStream(feed_cool.h_outflow),
    CoolMedium.X_default));
  Tcool_out = CoolMedium.temperature(state_coolingwater);
  dT_lm =TRANSFORM.HeatExchangers.Utilities.Functions.logMean(tubeWall.material.T
     - Tcool_in, tubeWall.material.T - Tcool_out);
  Q_cool = heatRes_inner.Q_flows[1];

  drain_cool.h_outflow = inStream(feed_cool.h_outflow) + Q_cool/feed_cool.m_flow;
  feed_cool.h_outflow = inStream(drain_cool.h_outflow) - Q_cool/feed_cool.m_flow;
  feed_cool.m_flow + drain_cool.m_flow = 0;
  drain_cool.Xi_outflow = inStream(feed_cool.Xi_outflow);
  feed_cool.Xi_outflow = inStream(drain_cool.Xi_outflow);
  drain_cool.C_outflow = inStream(feed_cool.C_outflow);
  feed_cool.C_outflow = inStream(drain_cool.C_outflow);

  connect(T_condenser.y, T_shell.T_ext)
    annotation (Line(points={{-59,10},{-50.5,10}}, color={0,0,127}));
  connect(T_shell.port, heatRes_outer.port_b) annotation (Line(
      points={{-40,10},{-32,10}},
      color={191,0,0},
      thickness=0.5));
  connect(T_cool.port, heatRes_inner.port_b[1]) annotation (Line(
      points={{40,10},{30,10}},
      color={191,0,0},
      thickness=0.5));
  connect(T_coolant.y, T_cool.T_ext)
    annotation (Line(points={{59,10},{50.5,10}}, color={0,0,127}));
  connect(tubeWall.port_a, heatRes_inner.port_a[1])
    annotation (Line(points={{10,10},{16,10}}, color={191,0,0}));
  connect(tubeWall.port_b, heatRes_outer.port_a)
    annotation (Line(points={{-10,10},{-18,10}}, color={191,0,0}));
  annotation (
    Icon(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}}), graphics={
        Text(
          extent={{-147,111},{153,71}},
          lineColor={0,0,255},
          textString="%name",
          visible=DynamicSelect(true,showName))}),
    Documentation(info="<html><ul>
<li>As the liquid level goes to zero, the drain enthalpy will approach the mixed volume enthalpy. This will most often result in too low pressure, and is protected with an assert(p&GT;1000 Pa).</li>
<li>The drum liquid level should not be too large, an assert is triggered when the condenser gets full.</li>
</ul>
</html>"),
    Diagram(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}})));
end Condenserold;
