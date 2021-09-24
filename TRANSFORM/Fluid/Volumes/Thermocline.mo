within TRANSFORM.Fluid.Volumes;
model Thermocline
  replaceable package Medium = Modelica.Media.Interfaces.PartialMedium "Medium in the component"
    annotation (choicesAllMatching=true);

  SI.Energy Q_storage = volume_upper.m*(volume_upper.h - Medium.specificEnthalpy(Medium.setState_pT(p_start,T_start_lower)));
  Real Q_storage_MWt_h = Q_storage/1e6/3600;
  SI.Volume V_total = volume_upper.V + volume_lower.V;
  Units.NonDim levelFrac = volume_upper.V/V_total;
  SI.Mass m_total = volume_upper.m + volume_lower.m;

  ExpansionTank_1Port
                volume_upper(
    redeclare package Medium = Medium,
    A=A,
    p_surface=p_surface,
    p_start=p_start,
    level_start=levelFrac_start*length,
    T_start=T_start_upper,
    h_start=Medium.specificEnthalpy(Medium.setState_pTX(p_start, T_start_upper)))
    annotation (Placement(transformation(extent={{-10,16},{10,36}})));
  ExpansionTank_1Port
                volume_lower(
    redeclare package Medium = Medium,
    A=A,
    p_surface=p_surface + Medium.density(Medium.setState_pTX(p_surface, Medium.temperature(
        volume_upper.state_liquid)))*Modelica.Constants.g_n*volume_upper.level,
    p_start=p_start + Medium.density(Medium.setState_pTX(p_start, T_start_upper))*Modelica.Constants.g_n
        *volume_upper.level_start,
    level_start=(1 - levelFrac_start)*length,
    T_start=T_start_lower,
    h_start=Medium.specificEnthalpy(Medium.setState_pTX(volume_lower.p_start, T_start_lower)))
    annotation (Placement(transformation(extent={{-10,-24},{10,-4}})));

  Interfaces.FluidPort_Flow  port_upper(redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{-10,90},{10,110}})));
  Interfaces.FluidPort_Flow  port_lower(redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{-10,-110},{10,-90}})));
  parameter SI.Area A "Cross-sectional area";
  parameter SI.Length length "Total thermocline length";
  input SI.Pressure p_surface=p_start "Liquid surface/gas pressure" annotation (Dialog(group="Inputs"));
  parameter SI.Pressure p_start=1e5 "Pressure at upper surface"
    annotation (Dialog(tab="Initialization"));
  parameter Units.NonDim levelFrac_start=0.5 "Fraction of length filling the upper volume" annotation (Dialog(tab="Initialization"));

  parameter SI.Temperature T_start_upper=293.15 annotation (Dialog(tab="Initialization"));
  parameter SI.Temperature T_start_lower=293.15 annotation (Dialog(tab="Initialization"));

  Machines.Pump_SimpleMassFlow pump_upper(redeclare package Medium = Medium, use_input=true)
    annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=270,
        origin={0,80})));
  Modelica.Blocks.Interfaces.RealInput m_flow_upper
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Machines.Pump_SimpleMassFlow pump_lower(redeclare package Medium = Medium, use_input=true)
    annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=270,
        origin={0,-40})));
  Modelica.Blocks.Sources.RealExpression m_flow_lower(y=m_flow_upper*sensor_d_lower.d/sensor_d_upper.d)
    annotation (Placement(transformation(extent={{-60,-50},{-40,-30}})));
  Sensors.DensityTwoPort sensor_d_upper(redeclare package Medium = Medium) annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-20,30})));
  Sensors.DensityTwoPort sensor_d_lower(redeclare package Medium = Medium) annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={0,-70})));
equation
  connect(pump_upper.port_a, port_upper)
    annotation (Line(points={{1.77636e-15,90},{0,100}}, color={0,127,255}));
  connect(pump_upper.in_m_flow, m_flow_upper)
    annotation (Line(points={{-7.3,80},{-94,80},{-94,0},{-120,0}}, color={0,0,127}));
  connect(pump_lower.port_a, volume_lower.port)
    annotation (Line(points={{1.83187e-15,-30},{0,-22.4}}, color={0,127,255}));
  connect(m_flow_lower.y, pump_lower.in_m_flow)
    annotation (Line(points={{-39,-40},{-7.3,-40}}, color={0,0,127}));
  connect(volume_upper.port, sensor_d_upper.port_b)
    annotation (Line(points={{0,17.6},{0,10},{-20,10},{-20,20}}, color={0,127,255}));
  connect(sensor_d_upper.port_a, pump_upper.port_b)
    annotation (Line(points={{-20,40},{-20,52},{0,52},{0,70}}, color={0,127,255}));
  connect(pump_lower.port_b, sensor_d_lower.port_a) annotation (Line(points={{-1.83187e-15,-50},{-1.83187e-15,
          -55},{6.10623e-16,-55},{6.10623e-16,-60}}, color={0,127,255}));
  connect(sensor_d_lower.port_b, port_lower) annotation (Line(points={{-5.55112e-16,-80},{-5.55112e-16,
          -90},{0,-90},{0,-100}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-100,100},{100,0}},
          fillColor={238,46,47},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-100,0},{100,-100}},
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Rectangle(extent={{-100,100},{100,-100}}, lineColor={0,0,0})}),
                                                                 Diagram(coordinateSystem(
          preserveAspectRatio=false)));
end Thermocline;
