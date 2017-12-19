within TRANSFORM.Fluid.Volumes;
model Condenser2

  import TRANSFORM.Types.Dynamics;
  import Modelica.Constants.pi;

  // Geometry Model
  replaceable model Geometry =
      TRANSFORM.Fluid.ClosureRelations.Geometry.Models.TwoVolume_withLevel.withInternals.Cylinder_wInternalPipe
    constrainedby
    TRANSFORM.Fluid.ClosureRelations.Geometry.Models.TwoVolume_withLevel.withInternals.PartialInternal
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
    medium(phase(start=if (h_start < Medium.bubbleEnthalpy(Medium.setSat_p(
            p_start)) or h_start > Medium.dewEnthalpy(Medium.setSat_p(p_start))
             or p_start > Medium.fluidConstants[1].criticalPressure) then 1
             else 2)));

  parameter Dynamics energyDynamicsWall=Dynamics.DynamicFreeInitial
    "Formulation of energy balances"
    annotation (Dialog(tab="Advanced", group="Dynamics"));

  replaceable package Medium_coolant = Modelica.Media.Water.StandardWater
    constrainedby Modelica.Media.Interfaces.PartialMedium "Cooling medium"
    annotation (choicesAllMatching);

  replaceable package MaterialWall =
      TRANSFORM.Media.Solids.CustomSolids.Lambda_fT_d_7763_cp_fT constrainedby
    TRANSFORM.Media.Interfaces.Solids.PartialAlloy
                                            "Coolant wall material properties"
    annotation (choicesAllMatching=true);

  input SI.CoefficientOfHeatTransfer alphaInt_WExt=1
    "Coeffient for internals outer surface and the fluid state"
    annotation (Dialog(group="Input Variables: Heat Transfer"));
  input SI.CoefficientOfHeatTransfer alphaInt_WInt=16912
    "Coeffient for internals inner surface and the coolant fluid state"
    annotation (Dialog(group="Input Variables: Heat Transfer"));

  input SI.Acceleration g_n=Modelica.Constants.g_n "Gravitational acceleration"
    annotation (Dialog(tab="Advanced", group="Input Variables"));

  parameter SI.Temperature T_start_wall=293.15
    "Tube wall temperature start value"
    annotation (Dialog(tab="Initialization"));

  parameter SI.Pressure p_start_coolant = 2e5 "Coolant start pressure" annotation(Dialog(tab="Initialization",group="Coolant"));
  parameter SI.Temperature T_start_coolant=T_start_wall - 5
    "Coolant start temperature"
    annotation (Dialog(tab="Initialization", group="Coolant"));
  parameter SI.Temperature X_start_coolant[Medium_coolant.nX] = Medium_coolant.X_default "Coolant start temperature" annotation(Dialog(tab="Initialization",group="Coolant"));

  Medium_coolant.ThermodynamicState state_coolant(h(start=
          Medium_coolant.specificEnthalpy(Medium_coolant.setState_pTX(
          p_start_coolant,
          T_start_coolant,
          X_start_coolant))));

  SI.Power Q_cool "Total power to cooling water";
  SI.MassFlowRate m_flow "Total mass flowrate";
  SI.Temperature Tcool_in "Cooling water inlet temperature";
  SI.Temperature Tcool_out "Cooling water outlet temperature";
  SI.Conversions.NonSIunits.Temperature_degC dT_lm
    "Log mean temperature difference, water side";

  Interfaces.FluidPort_State portSteamFeed(redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{-80,60},{-60,80}}),
        iconTransformation(extent={{-80,60},{-60,80}})));
  Interfaces.FluidPort_Flow portCoolant_b(redeclare package Medium =
        Medium_coolant)
    annotation (Placement(transformation(extent={{100,-30},{120,-10}}),
        iconTransformation(extent={{100,-30},{120,-10}})));
  Interfaces.FluidPort_Flow portCoolant_a(redeclare package Medium =
        Medium_coolant)
    annotation (Placement(transformation(extent={{100,30},{120,50}}),
        iconTransformation(extent={{100,30},{120,50}})));
  Interfaces.FluidPort_State portFluidDrain(redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{-10,-110},{10,-90}}),
        iconTransformation(extent={{-10,-110},{10,-90}})));

  TRANSFORM.HeatAndMassTransfer.Volumes.SimpleWall tubeWall(
    T_start=T_start_wall,
    th=geometry.th_tube,
    surfaceArea=(geometry.surfaceAreaInt_WInt + geometry.surfaceAreaInt_WExt)/2,
    energyDynamics=energyDynamicsWall,
    redeclare package Material = MaterialWall) annotation (Placement(
        transformation(
        origin={0,10},
        extent={{-10,10},{10,-10}},
        rotation=180)));

  HeatAndMassTransfer.BoundaryConditions.Heat.Temperature T_cool(each use_port=true)
    annotation (Placement(transformation(extent={{55,2.5},{40,17.5}})));
  Modelica.Blocks.Sources.RealExpression T_coolant(y=tubeWall.material.T -
        dT_lm) annotation (Placement(transformation(extent={{80,0},{60,20}})));
  HeatAndMassTransfer.Resistances.Heat.Convection heatRes_outer(surfaceArea=
        geometry.surfaceAreaInt_WExt, alpha=alphaInt_WExt) annotation (
      Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={-25,10})));

  HeatAndMassTransfer.BoundaryConditions.Heat.Temperature T_shell(each use_port=
       true)
    annotation (Placement(transformation(extent={{-55,2.5},{-40,17.5}})));
  Modelica.Blocks.Sources.RealExpression T_condenser(y=medium.T)
    annotation (Placement(transformation(extent={{-80,0},{-60,20}})));

  HeatAndMassTransfer.Resistances.Heat.ConvectionMedia heatRes_inner(
    dimensions={geometry.r_tube_inner*2},
    redeclare model HeatTransferCoeff =
        HeatAndMassTransfer.ClosureRelations.HeatTransfer.Models.Nus_SinglePhase_2Region,
    redeclare package Medium = Medium_coolant,
    states=heatRes_inner.Medium.setState_pTX(fill(portCoolant_a.p, 1),
        heatRes_inner.port_b.T),
    m_flows={portCoolant_a.m_flow/geometry.nTubes},
    dlengths={geometry.length_tube},
    surfaceAreas={geometry.surfaceAreaInt_WInt})
    annotation (Placement(transformation(extent={{13,0},{33,20}})));

  Media.BaseProperties2Phase mediaProps(redeclare package Medium = Medium,
      state=medium.state)
    annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));

equation

  mb =portSteamFeed.m_flow + portFluidDrain.m_flow;
  Ub =portSteamFeed.m_flow*actualStream(portSteamFeed.h_outflow) +
    portFluidDrain.m_flow*actualStream(portFluidDrain.h_outflow) +
    heatRes_outer.port_a.Q_flow;

  for i in 1:Medium.nXi loop
    mXib[i] =portSteamFeed.m_flow*actualStream(portSteamFeed.Xi_outflow[i]) +
      portFluidDrain.m_flow*actualStream(portFluidDrain.Xi_outflow[i]);
  end for;
  for i in 1:Medium.nC loop
    mCb[i] =portSteamFeed.m_flow*actualStream(portSteamFeed.C_outflow[i]) +
      portFluidDrain.m_flow*actualStream(portFluidDrain.C_outflow[i]);
  end for;

  V = (1 - mediaProps.x_abs)*m/mediaProps.rho_lsat;

  // Boundary Conditions
  m_flow =portSteamFeed.m_flow;
  portSteamFeed.p = medium.p;
  portSteamFeed.h_outflow = medium.h;

  portSteamFeed.C_outflow = C;
  portFluidDrain.p = medium.p + mediaProps.rho_lsat*g_n*level;
  portFluidDrain.h_outflow = TRANSFORM.Math.spliceTanh(
    medium.h,
    mediaProps.h_lsat,
    mediaProps.x_abs - 0.75,
    0.25);
  portSteamFeed.Xi_outflow = medium.Xi;
  portFluidDrain.Xi_outflow = medium.Xi;
  portFluidDrain.C_outflow = C;

  /* Coolant Equations */
  state_coolant = Medium_coolant.setState_phX(
    portCoolant_b.p,
    actualStream(portCoolant_b.h_outflow),
    Medium_coolant.X_default);

  // Boundary Conditions
  portCoolant_a.p = portCoolant_b.p;
  Tcool_in =Medium_coolant.temperature(Medium_coolant.setState_phX(
    portCoolant_a.p,
    actualStream(portCoolant_a.h_outflow),
    Medium_coolant.X_default));
  Tcool_out =Medium_coolant.temperature(state_coolant);
  dT_lm = TRANSFORM.HeatExchangers.Utilities.Functions.logMean(tubeWall.material.T
     - Tcool_in, tubeWall.material.T - Tcool_out);
  Q_cool = heatRes_inner.Q_flows[1];

  portCoolant_b.h_outflow = inStream(portCoolant_a.h_outflow) + Q_cool/
    portCoolant_a.m_flow;
  portCoolant_a.h_outflow = inStream(portCoolant_b.h_outflow) - Q_cool/
    portCoolant_a.m_flow;
  portCoolant_a.m_flow + portCoolant_b.m_flow = 0;
  portCoolant_b.Xi_outflow = inStream(portCoolant_a.Xi_outflow);
  portCoolant_a.Xi_outflow = inStream(portCoolant_b.Xi_outflow);
  portCoolant_b.C_outflow = inStream(portCoolant_a.C_outflow);
  portCoolant_a.C_outflow = inStream(portCoolant_b.C_outflow);

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
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
        graphics={Text(
          extent={{-147,111},{153,71}},
          lineColor={0,0,255},
          textString="%name",
          visible=DynamicSelect(true, showName))}),
    Documentation(info="<html><ul>
<li>As the liquid level goes to zero, the drain enthalpy will approach the mixed volume enthalpy. This will most often result in too low pressure, and is protected with an assert(p&GT;1000 Pa).</li>
<li>The drum liquid level should not be too large, an assert is triggered when the condenser gets full.</li>
</ul>
</html>"),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}})));
end Condenser2;
