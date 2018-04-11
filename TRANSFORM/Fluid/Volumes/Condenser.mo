within TRANSFORM.Fluid.Volumes;
model Condenser

  import TRANSFORM.Types.Dynamics;
  import Modelica.Constants.pi;

  extends BaseClasses.Icon_TwoVolume;

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
    "Heat transfer coeffient for coolant wall outer surface and the condenser fluid state"
    annotation (Dialog(group="Inputs Heat Transfer"));

  input SI.Acceleration g_n=Modelica.Constants.g_n "Gravitational acceleration"
    annotation (Dialog(tab="Advanced", group="Inputs"));

  parameter SI.Temperature T_start_wall=293.15
    "Tube wall temperature start value"
    annotation (Dialog(tab="Initialization"));

  parameter SI.Pressure p_start_coolant = 2e5 "Coolant start pressure" annotation(Dialog(tab="Initialization",group="Coolant"));
  parameter SI.Temperature T_start_coolant=T_start_wall - 5
    "Coolant start temperature"
    annotation (Dialog(tab="Initialization", group="Coolant"));
  parameter SI.Temperature X_start_coolant[Medium_coolant.nX] = Medium_coolant.X_default "Coolant start temperature" annotation(Dialog(tab="Initialization",group="Coolant"));
  parameter SIadd.ExtraProperty C_start_coolant[Medium_coolant.nC]=fill(0, Medium_coolant.nC)
    "Mass-Specific value" annotation (Dialog(
      tab="Initialization",
      group="Coolant",
      enable=Medium_coolant.nC > 0));

  parameter Boolean exposeState_a_coolant = true "=false to use resistance between port and volume" annotation(Dialog(tab="Advanced",group="Inputs Coolant"),Evaluate=true);
  parameter Boolean exposeState_b_coolant = false "=false to use resistance between port and volume" annotation(Dialog(tab="Advanced",group="Inputs Coolant"),Evaluate=true);
  input Units.HydraulicResistance R_a_coolant=1
    "Hydraulic resistance at portCoolant_a" annotation(Dialog(tab="Advanced",group="Inputs Coolant",enable=not exposeState_a_coolant));
  input Units.HydraulicResistance R_b_coolant=1
    "Hydraulic resistance at portCoolant_b" annotation(Dialog(tab="Advanced",group="Inputs Coolant",enable= not exposeState_b_coolant));

  Interfaces.FluidPort_State portSteamFeed(redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{-80,60},{-60,80}}),
        iconTransformation(extent={{-80,60},{-60,80}})));
  Interfaces.FluidPort_Flow portCoolant_b(redeclare package Medium =
        Medium_coolant)
    annotation (Placement(transformation(extent={{100,-30},{120,-10}}),
        iconTransformation(extent={{100,-30},{120,-10}})));
  Interfaces.FluidPort_State portCoolant_a(
                                          redeclare package Medium =
        Medium_coolant)
    annotation (Placement(transformation(extent={{100,30},{120,50}}),
        iconTransformation(extent={{100,30},{120,50}})));
  Interfaces.FluidPort_State portFluidDrain(redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{-10,-88},{10,-68}}),
        iconTransformation(extent={{-10,-88},{10,-68}})));

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
    m_flows={portCoolant_a.m_flow/geometry.nTubes},
    dlengths={geometry.length_tube},
    surfaceAreas={geometry.surfaceAreaInt_WInt},
    states={volume_coolant.medium.state})
    annotation (Placement(transformation(extent={{13,0},{33,20}})));

  Media.BaseProperties2Phase mediaProps(redeclare package Medium = Medium,
      state=medium.state)
    annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));

  MixingVolume volume_coolant(
    use_HeatPort=true,
    nPorts_a=1,
    nPorts_b=1,
    redeclare package Medium = Medium_coolant,
    p_start=p_start_coolant,
    T_start=T_start_coolant,
    X_start=X_start_coolant,
    C_start=C_start_coolant,
    redeclare model Geometry =
        ClosureRelations.Geometry.Models.LumpedVolume.Cylinder (length=geometry.length_tube,
          crossArea=geometry.nTubes*pi*geometry.r_tube_inner^2),
    energyDynamics=energyDynamics)
                             annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=90,
        origin={60,10})));
  FittingsAndResistances.SpecifiedResistance resistance_a(redeclare package
              Medium =
               Medium_coolant, R=R_a_coolant) if not exposeState_a_coolant
                                    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={60,30})));
  FittingsAndResistances.SpecifiedResistance resistance_b(redeclare package
              Medium =
               Medium_coolant, R=R_b_coolant) if not exposeState_b_coolant
                                    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={60,-10})));

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

  // Total liquid volume
  V = (1 - mediaProps.x_abs)*m/mediaProps.rho_lsat;

  // Boundary Conditions
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

  connect(T_condenser.y, T_shell.T_ext)
    annotation (Line(points={{-59,10},{-50.5,10}}, color={0,0,127}));
  connect(T_shell.port, heatRes_outer.port_b) annotation (Line(
      points={{-40,10},{-32,10}},
      color={191,0,0},
      thickness=0.5));
  connect(tubeWall.port_a, heatRes_inner.port_a[1])
    annotation (Line(points={{10,10},{16,10}}, color={191,0,0}));
  connect(tubeWall.port_b, heatRes_outer.port_a)
    annotation (Line(points={{-10,10},{-18,10}}, color={191,0,0}));
  connect(heatRes_inner.port_b[1], volume_coolant.heatPort)
    annotation (Line(points={{30,10},{42,10},{54,10}}, color={191,0,0}));

  if exposeState_a_coolant then
    connect(volume_coolant.port_a[1],portCoolant_a);
  else
    connect(volume_coolant.port_a[1], resistance_a.port_b);
    connect(resistance_a.port_a, portCoolant_a);
  end if;

  if exposeState_b_coolant then
    connect(volume_coolant.port_b[1],portCoolant_b);
  else
    connect(volume_coolant.port_b[1], resistance_b.port_a);
    connect(resistance_b.port_b, portCoolant_b);
  end if;

  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
        graphics={
        Line(
          points={{100,40},{-59.1953,40},{-64,40},{-68,36},{-70,30},{-68,24},{-64,
              20},{-60,20},{58,20},{64,20},{68,16},{70,10},{68,4},{64,0},{58,0},
              {-58,0},{-64,0},{-68,-4},{-70,-10},{-68,-16},{-64,-20},{-58,-20},{
              100,-20}},
          color={0,0,0},
          smooth=Smooth.Bezier),
        Polygon(
          points={{10,40},{16,38},{20,36},{20,34},{22,36},{26,38},{32,38},{34,38},
              {36,40},{10,40}},
          lineColor={0,0,0},
          smooth=Smooth.Bezier,
          fillColor={85,170,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{22,32},{20,28}},
          lineColor={0,0,0},
          fillColor={85,170,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-60,20},{-54,18},{-50,16},{-50,14},{-48,16},{-44,18},{-38,18},
              {-36,18},{-34,20},{-60,20}},
          lineColor={0,0,0},
          smooth=Smooth.Bezier,
          fillColor={85,170,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-48,12},{-50,8}},
          lineColor={0,0,0},
          fillColor={85,170,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{4,0},{10,-2},{14,-4},{14,-6},{16,-4},{20,-2},{26,-2},{28,-2},
              {30,0},{4,0}},
          lineColor={0,0,0},
          smooth=Smooth.Bezier,
          fillColor={85,170,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{14,-8},{12,-12}},
          lineColor={0,0,0},
          fillColor={85,170,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-66,-20},{-60,-22},{-56,-24},{-56,-26},{-54,-24},{-50,-22},{-44,
              -22},{-42,-22},{-40,-20},{-66,-20}},
          lineColor={0,0,0},
          smooth=Smooth.Bezier,
          fillColor={85,170,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-56,-28},{-58,-32}},
          lineColor={0,0,0},
          fillColor={85,170,255},
          fillPattern=FillPattern.Solid)}),
    Documentation(info="<html><ul>
<li>As the liquid level goes to zero, the drain enthalpy will approach the mixed volume enthalpy. This will most often result in too low pressure, and is protected with an assert(p&GT;1000 Pa).</li>
<li>The drum liquid level should not be too large, an assert is triggered when the condenser gets full.</li>
</ul>
</html>"),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}})));
end Condenser;
