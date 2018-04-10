within TRANSFORM.Fluid.Volumes.InProgress.Verification;
model AdiabaticCompression
  extends TRANSFORM.Icons.Example;

  package Medium = Modelica.Media.Water.StandardWater "Medium in component";
  constant SI.Pressure p_start = 100e3 "Initial pressure";
  constant SI.Temperature T_start = Medium.saturationTemperature(p_start) "Initial temperature";
  constant SI.SpecificEnthalpy h_start = Medium.specificEnthalpy_pT(p_start,T_start) "Initial temperature";

  constant SI.Pressure p_final = 300e3 "Final pressure";
  constant SI.SpecificEnthalpy h_final = 2888.8e3 "Final enthalpy";
  constant SI.Temperature T_final = Medium.temperature(Medium.setState_ph(p_final,h_final)) "Final temperature";

  Volumes.InProgress.Pressurizer pressurizer(
    redeclare package Medium = Medium,
    redeclare model DrumType =
        Volumes.ClosureModels.Geometry.DrumTypes.SimpleCylinder (r_1=1, h_1=1),
    V_total=pi*1*1,
    p_start=p_start,
    redeclare model MassTransfer_VL =
        Volumes.ClosureModels.MassTransfer.PhaseInterface.ConstantMassTransportCoefficient,
    redeclare model HeatTransfer_VL =
        Volumes.ClosureModels.MassTransfer.PhaseInterface.ConstantHeatTransferCoefficient,
    redeclare model BulkEvaporation =
        Volumes.ClosureModels.MassTransfer.Evaporation.PhaseSeparationHypothesis
        (Ac=pressurizer.drumType.crossArea_liquid),
    redeclare model BulkCondensation =
        Volumes.ClosureModels.MassTransfer.Condensation.PhaseSeparation_TerminalVelocity
        (V_fluid=pressurizer.V_vapor, L_c=0.5*pressurizer.drumType.level_vapor),
    redeclare model HeatTransfer_WL =
        ClosureRelations.HeatTransfer.Models.Lumped.Alphas,
    redeclare model HeatTransfer_WV =
        ClosureRelations.HeatTransfer.Models.Lumped.Alphas)
    annotation (Placement(transformation(extent={{-26,-30},{26,30}})));

  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature T_liquid(T=373.15)
    annotation (Placement(transformation(extent={{70,-30},{50,-10}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow heaterLiquid
    annotation (Placement(transformation(extent={{-60,-20},{-40,0}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow heaterVapor
    annotation (Placement(transformation(extent={{-60,0},{-40,20}})));
  Modelica.Blocks.Sources.Constant heaterVapor_input(k=0)
    annotation (Placement(transformation(extent={{-100,10},{-80,30}})));
  Modelica.Blocks.Sources.Constant heaterLiquid_input(k=0)
    annotation (Placement(transformation(extent={{-100,-30},{-80,-10}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature T_vapor(T=373.15)
    annotation (Placement(transformation(extent={{70,2},{50,22}})));
  Modelica.Fluid.Sources.MassFlowSource_h spray(nPorts=1, redeclare package
              Medium =
               Medium)
    annotation (Placement(transformation(extent={{-48,50},{-28,70}})));
  Modelica.Fluid.Sources.MassFlowSource_h relief(nPorts=1, redeclare package
              Medium =
               Medium)
    annotation (Placement(transformation(extent={{48,50},{28,70}})));
  Modelica.Fluid.Sources.MassFlowSource_T insurge(nPorts=1, use_m_flow_in=true,
    redeclare package Medium = Medium,
    T=363.15)
    annotation (Placement(transformation(extent={{-48,-70},{-28,-50}})));
  inner System    system(energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    annotation (Placement(transformation(extent={{80,80},{100,100}})));
  Modelica.Blocks.Sources.RealExpression realExpression(y=pressurizer.p)
    annotation (Placement(transformation(extent={{-150,-70},{-130,-50}})));
  Modelica.Blocks.Logical.Switch switch1
    annotation (Placement(transformation(extent={{-80,-70},{-60,-50}})));
  Modelica.Blocks.Logical.LessEqual greaterEqual
    annotation (Placement(transformation(extent={{-120,-70},{-100,-50}})));
  Modelica.Blocks.Sources.Constant const(k=p_final)
    annotation (Placement(transformation(extent={{-152,-90},{-132,-70}})));
  Modelica.Blocks.Sources.Step     const1(height=100, startTime=1)
    annotation (Placement(transformation(extent={{-130,-40},{-110,-20}})));
  Modelica.Blocks.Sources.Constant const2(k=0)
    annotation (Placement(transformation(extent={{-118,-98},{-98,-78}})));
  Utilities.ErrorAnalysis.Errors_AbsRelRMSold summary_Error(
    n=1,
    x_2={h_final},
    x_1={pressurizer.h_vapor})
    annotation (Placement(transformation(extent={{60,60},{80,80}})));
equation

  connect(heaterVapor.port, pressurizer.vaporHeater) annotation (Line(points={{-40,
          10},{-34,10},{-34,12},{-26,12}}, color={191,0,0}));
  connect(heaterLiquid.port, pressurizer.liquidHeater)
    annotation (Line(points={{-40,-10},{-26,-10},{-26,-12}}, color={191,0,0}));
  connect(heaterLiquid_input.y, heaterLiquid.Q_flow) annotation (Line(points={{-79,
          -20},{-70,-20},{-70,-10},{-60,-10}}, color={0,0,127}));
  connect(heaterVapor_input.y, heaterVapor.Q_flow) annotation (Line(points={{-79,
          20},{-70,20},{-70,10},{-60,10}}, color={0,0,127}));
  connect(insurge.ports[1], pressurizer.surgePort)
    annotation (Line(points={{-28,-60},{-0.26,-60},{-0.26,-29.7}},
                                                         color={0,127,255}));
  connect(spray.ports[1], pressurizer.sprayPort) annotation (Line(points={{-28,60},
          {-15.6,60},{-15.6,30}}, color={0,127,255}));
  connect(pressurizer.heatPort_WV, T_vapor.port)
    annotation (Line(points={{26,12},{50,12}}, color={191,0,0}));
  connect(pressurizer.heatPort_WL, T_liquid.port) annotation (Line(points={{26,-12},
          {38,-12},{38,-20},{50,-20}}, color={191,0,0}));
  connect(realExpression.y, greaterEqual.u1)
    annotation (Line(points={{-129,-60},{-122,-60}}, color={0,0,127}));
  connect(const.y, greaterEqual.u2) annotation (Line(points={{-131,-80},{-124,-80},
          {-124,-68},{-122,-68}}, color={0,0,127}));
  connect(greaterEqual.y, switch1.u2) annotation (Line(points={{-99,-60},{-90.5,
          -60},{-82,-60}}, color={255,0,255}));
  connect(const1.y, switch1.u1) annotation (Line(points={{-109,-30},{-98,-30},{-98,
          -50},{-82,-50},{-82,-52}}, color={0,0,127}));
  connect(const2.y, switch1.u3) annotation (Line(points={{-97,-88},{-90,-88},{-90,
          -68},{-82,-68}}, color={0,0,127}));
  connect(switch1.y, insurge.m_flow_in) annotation (Line(points={{-59,-60},{-54,
          -60},{-54,-52},{-48,-52}}, color={0,0,127}));
  connect(relief.ports[1], pressurizer.steamPort) annotation (Line(points={{28,60},
          {22,60},{15.6,60},{15.6,30}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(StopTime=10),
    Documentation(info="<html>
<p>Example 7.8 from Introduction to Chemical Engineering Thermodynamics for just the isentropic compression portion.</p>
</html>"));
end AdiabaticCompression;
