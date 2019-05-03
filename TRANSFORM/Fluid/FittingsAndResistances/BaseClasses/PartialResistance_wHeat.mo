within TRANSFORM.Fluid.FittingsAndResistances.BaseClasses;
partial model PartialResistance_wHeat
  replaceable package Medium = Modelica.Media.Water.StandardWater
    constrainedby Modelica.Media.Interfaces.PartialMedium "Medium properties"
    annotation (choicesAllMatching=true);
  Interfaces.FluidPort_Flow port_a(redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}}),
        iconTransformation(extent={{-80,-10},{-60,10}})));
  Interfaces.FluidPort_Flow port_b(redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{60,-10},{80,10}}),
        iconTransformation(extent={{60,-10},{80,10}})));
  Medium.ThermodynamicState state;
  SI.PressureDifference dp;
  SI.MassFlowRate m_flow;
  SI.SpecificEnthalpy dh;
  parameter Boolean showName=true annotation (Dialog(tab="Visualization"));

  parameter Boolean use_HeatPort=false "=true to toggle heat port"
    annotation (Dialog(tab="Advanced", group="Heat Transfer"), Evaluate=true);
  input SI.HeatFlowRate Q_gen=0 "Internal heat generation"
    annotation (Dialog(tab="Advanced", group="Heat Transfer"));

  HeatAndMassTransfer.Interfaces.HeatPort_State heatPort(T=Medium.temperature(
        state), Q_flow=Q_flow_internal) if
                               use_HeatPort annotation (Placement(
        transformation(extent={{-10,50},{10,70}}), iconTransformation(extent={{-10,
            50},{10,70}})));
protected
  SI.HeatFlowRate Q_flow_internal;

equation
  if not use_HeatPort then
    Q_flow_internal = 0;
  end if;

  if (not use_HeatPort and Q_gen == 0) then
    dh = 0;
  else
    m_flow*dh = Q_flow_internal + Q_gen;
  end if;

  port_a.m_flow + port_b.m_flow = 0;
  dp = port_a.p - port_b.p;

  m_flow = port_a.m_flow;

  state = Medium.setState_phX(
    port_a.p,
    inStream(port_a.h_outflow),
    inStream(port_a.Xi_outflow));

  // Stream variables balance
  port_a.h_outflow = inStream(port_b.h_outflow) + dh;
  port_b.h_outflow = inStream(port_a.h_outflow) + dh;
  port_a.Xi_outflow = inStream(port_b.Xi_outflow);
  port_b.Xi_outflow = inStream(port_a.Xi_outflow);
  port_a.C_outflow = inStream(port_b.C_outflow);
  port_b.C_outflow = inStream(port_a.C_outflow);
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
          Bitmap(extent={{-60,-60},{60,60}}, fileName="modelica://TRANSFORM/Resources/Images/Icons/Resistance_Fluid.jpg"),
          Text(
          extent={{-149,-68},{151,-108}},
          lineColor={0,0,255},
          textString="%name",
          visible=DynamicSelect(true, showName))}), Diagram(coordinateSystem(
          preserveAspectRatio=false)));
end PartialResistance_wHeat;
