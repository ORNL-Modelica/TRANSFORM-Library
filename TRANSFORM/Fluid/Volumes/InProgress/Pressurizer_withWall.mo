within TRANSFORM.Fluid.Volumes.InProgress;
model Pressurizer_withWall
  import Modelica.Fluid.Types;
  import Modelica.Fluid.Types.Dynamics;
  outer Modelica.Fluid.System system "System properties";
  replaceable package Medium = Modelica.Media.Water.StandardWater
    constrainedby Modelica.Media.Interfaces.PartialTwoPhaseMedium
    "Medium in the component"
     annotation(choicesAllMatching=true);
  /* General */
  parameter SI.Volume V_total "Total volume (liquid + vapor)" annotation(Dialog(group="Geometry"));
  replaceable model DrumType =
    TRANSFORM.Fluid.Volumes.ClosureModels.Geometry.DrumTypes.PartialDrumType
    "1. Select model 2. Set parameters (Total volume must match V_total)"
    annotation(choicesAllMatching=true, Dialog(group="Geometry"));
  /* Constitutive/Closure Models*/
  replaceable model BulkEvaporation =
      TRANSFORM.Fluid.ClosureRelations.MassTransfer.Models.Lumped.ConstantTimeDelay
    constrainedby TRANSFORM.Fluid.ClosureRelations.MassTransfer.Models.Lumped.PartialMassTransfer
    "Vapor bubble transport from liquid to vapor phase" annotation (
      choicesAllMatching=true, Dialog(group="Closure Models: 1. Select Model 2. Set parameters"));
  replaceable model BulkCondensation =
      TRANSFORM.Fluid.ClosureRelations.MassTransfer.Models.Lumped.ConstantTimeDelay
    constrainedby TRANSFORM.Fluid.ClosureRelations.MassTransfer.Models.Lumped.PartialMassTransfer
    "Liquid droplet transport from vapor to liquid phase" annotation (
      choicesAllMatching=true, Dialog(group="Closure Models: 1. Select Model 2. Set parameters"));
  replaceable model HeatTransfer_WL =
      TRANSFORM.Fluid.ClosureRelations.HeatTransfer.Models.Lumped.Ideal
    constrainedby
    TRANSFORM.Fluid.ClosureRelations.HeatTransfer.Models.Lumped.PartialHeatTransfer_setT
    "Wall-liquid heat transfer coefficient" annotation (choicesAllMatching=true,
      Dialog(group="Closure Models: 1. Select Model 2. Set parameters"));
  replaceable model HeatTransfer_WV =
      TRANSFORM.Fluid.ClosureRelations.HeatTransfer.Models.Lumped.Ideal
    constrainedby
    TRANSFORM.Fluid.ClosureRelations.HeatTransfer.Models.Lumped.PartialHeatTransfer_setT
    "Wall-vapor heat transfer coefficient" annotation (choicesAllMatching=true,
      Dialog(group="Closure Models: 1. Select Model 2. Set parameters"));
  parameter SI.CoefficientOfHeatTransfer alpha=0
    "Vapor-Liquid convection heat transfer coefficient" annotation (Dialog(
        group="Closure Models: 1. Select Model 2. Set parameters"));
  parameter Real alphaM0(unit="kg/(s.m2.K)")=0 "Vapor-Liquid coefficient of mass transfer"
    annotation (Dialog(group="Closure Models: 1. Select Model 2. Set parameters"));
  /* Assumptions */
  parameter Boolean allowFlowReversal=system.allowFlowReversal
    "= true to allow flow reversal, false restrics to design direction"
    annotation(Dialog(tab="Assumptions"));
  parameter Types.Dynamics energyDynamics=system.energyDynamics
    "Formulation of energy balance"
    annotation(Evaluate=true, Dialog(tab = "Assumptions", group="Dynamics"));
  parameter Types.Dynamics massDynamics=system.massDynamics
    "Formulation of mass balance"
    annotation(Evaluate=true, Dialog(tab = "Assumptions", group="Dynamics"));
  parameter Types.Dynamics energyDynamics_wall=system.energyDynamics
    "Formulation of energy balance for the wall"
    annotation(Evaluate=true, Dialog(tab = "Assumptions", group="Dynamics"));
  /* Initialization */
  parameter Real Vfrac_liquid_start=0.5
    "Initial fraction of volume in the liquid phase"
    annotation (Dialog(tab="Initialization"));
  parameter SI.Pressure p_start=system.p_start "Pressure start value"
    annotation (Dialog(tab="Initialization"));
  parameter SI.SpecificEnthalpy h_liquid_start=Medium.bubbleEnthalpy(Medium.setSat_p(p_start))
    "Liquid specific enthalpy start value"
    annotation (Dialog(tab="Initialization"));
  parameter SI.SpecificEnthalpy h_vapor_start=Medium.dewEnthalpy(Medium.setSat_p(p_start))
    "Vapour specific enthalpy start value"
    annotation (Dialog(tab="Initialization"));
  TRANSFORM.Fluid.Volumes.InProgress.Pressurizer drum2Phase(
    Vfrac_liquid_start=Vfrac_liquid_start,
    p_start=p_start,
    h_liquid_start=h_liquid_start,
    h_vapor_start=h_vapor_start,
    redeclare package Medium = Medium,
    redeclare model DrumType = DrumType,
    redeclare model BulkEvaporation = BulkEvaporation,
    redeclare model BulkCondensation = BulkCondensation,
    redeclare model HeatTransfer_WL = HeatTransfer_WL,
    redeclare model HeatTransfer_WV = HeatTransfer_WV,
    V_total=V_total,
    allowFlowReversal=allowFlowReversal,
    energyDynamics=energyDynamics,
    massDynamics=massDynamics)
    annotation (Placement(transformation(extent={{-26,-30},{26,30}})));
  Modelica.Fluid.Interfaces.FluidPort_b sprayPort(redeclare package Medium =
        Medium)
    annotation (Placement(transformation(extent={{-70,90},{-50,110}})));
  Modelica.Fluid.Interfaces.FluidPort_b reliefPort(redeclare package Medium =
        Medium)
    annotation (Placement(transformation(extent={{50,90},{70,110}})));
  Modelica.Fluid.Interfaces.FluidPort_b surgePort(redeclare package Medium =
        Medium)
    annotation (Placement(transformation(extent={{-10,-110},{10,-90}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a liquidHeater
    annotation (Placement(transformation(extent={{-110,-50},{-90,-30}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a vaporHeater
    annotation (Placement(transformation(extent={{-110,30},{-90,50}})));
  parameter SI.Length r_inner "Inner radius of pressurizer wall" annotation(Dialog(tab="Wall Properties"));
  parameter SI.Length r_outer "Outer radius of pressurizer wall" annotation(Dialog(tab="Wall Properties"));
  parameter SI.Temperature T_start=Medium.saturationTemperature_sat(Medium.setSat_p(p_start)) annotation(Dialog(tab="Wall Properties"));
  HeatAndMassTransfer.Volumes.SimpleWall wall_WV(
    th=r_outer - r_inner,
    surfaceArea=drum2Phase.surfaceArea_WV,
    exposeState_a=true,
    exposeState_b=true,
    T_start=T_start,
    energyDynamics=energyDynamics,
    redeclare package Material = Material)
    annotation (Placement(transformation(extent={{50,2},{70,22}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatPort_outerWV
    annotation (Placement(transformation(extent={{90,30},{110,50}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatPort_outerWL
    annotation (Placement(transformation(extent={{90,-50},{110,-30}})));
  replaceable package Material = Media.Solids.SS304 annotation (
      __Dymola_choicesAllMatching=true);
  HeatAndMassTransfer.Volumes.SimpleWall wall_WL(
    th=r_outer - r_inner,
    surfaceArea=drum2Phase.surfaceArea_WV,
    exposeState_a=true,
    exposeState_b=true,
    T_start=T_start,
    energyDynamics=energyDynamics,
    redeclare package Material = Material)
    annotation (Placement(transformation(extent={{50,-22},{70,-2}})));
equation
  connect(sprayPort, drum2Phase.sprayPort) annotation (Line(points={{-60,100},{-60,
          60},{-15.6,60},{-15.6,30}}, color={0,127,255}));
  connect(reliefPort, drum2Phase.steamPort) annotation (Line(points={{60,100},{60,
          60},{15.6,60},{15.6,30}}, color={0,127,255}));
  connect(surgePort, drum2Phase.surgePort) annotation (Line(points={{0,-100},{0,
          -29.7},{-0.26,-29.7}}, color={0,127,255}));
  connect(drum2Phase.vaporHeater, vaporHeater) annotation (Line(points={{-26,12},
          {-26,12},{-60,12},{-60,40},{-100,40}}, color={191,0,0}));
  connect(drum2Phase.liquidHeater, liquidHeater) annotation (Line(points={{-26,-12},
          {-60,-12},{-60,-40},{-100,-40}}, color={191,0,0}));
  connect(drum2Phase.heatPort_WV, wall_WV.port_a)
    annotation (Line(points={{26,12},{50,12},{50,12}}, color={191,0,0}));
  connect(drum2Phase.heatPort_WL, wall_WL.port_a)
    annotation (Line(points={{26,-12},{38,-12},{50,-12}}, color={191,0,0}));
  connect(wall_WV.port_b, heatPort_outerWV) annotation (Line(points={{70,12},{80,
          12},{80,40},{100,40}}, color={191,0,0}));
  connect(wall_WL.port_b, heatPort_outerWL) annotation (Line(points={{70,-12},{80,
          -12},{80,-40},{100,-40}}, color={191,0,0}));
   annotation (defaultComponentName="pressurizer",
         Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}})),       Icon(coordinateSystem(preserveAspectRatio=false,
          extent={{-100,-100},{100,100}}), graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-82,88},{84,-86}},
          fillColor={0,128,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-82,88},{84,0}},
          pattern=LinePattern.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Ellipse(
          extent={{-54,40},{-48,32}},
          pattern=LinePattern.None,
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-52,-38},{-46,-46}},
          pattern=LinePattern.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Ellipse(
          extent={{-70,56},{-64,48}},
          pattern=LinePattern.None,
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-68,-22},{-62,-30}},
          pattern=LinePattern.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Ellipse(
          extent={{-28,34},{-22,26}},
          pattern=LinePattern.None,
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-26,-44},{-20,-52}},
          pattern=LinePattern.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Ellipse(
          extent={{28,40},{34,32}},
          pattern=LinePattern.None,
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{30,-38},{36,-46}},
          pattern=LinePattern.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Ellipse(
          extent={{-12,48},{-6,40}},
          pattern=LinePattern.None,
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-10,-30},{-4,-38}},
          pattern=LinePattern.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Ellipse(
          extent={{50,26},{56,18}},
          pattern=LinePattern.None,
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{52,-52},{58,-60}},
          pattern=LinePattern.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Ellipse(
          extent={{8,20},{14,12}},
          pattern=LinePattern.None,
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{10,-58},{16,-66}},
          pattern=LinePattern.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Ellipse(
          extent={{56,56},{62,48}},
          pattern=LinePattern.None,
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{58,-22},{64,-30}},
          pattern=LinePattern.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Rectangle(
          extent={{-65,92},{-55,80}},
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Ellipse(
          extent={{2,5},{-2,-5}},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0},
          origin={-68,75},
          rotation=-30),
        Ellipse(
          extent={{-61,79},{-65,69}},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Ellipse(
          extent={{-56,79},{-60,69}},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Ellipse(
          extent={{2,5},{-2,-5}},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0},
          origin={-52,75},
          rotation=30)}));
end Pressurizer_withWall;
