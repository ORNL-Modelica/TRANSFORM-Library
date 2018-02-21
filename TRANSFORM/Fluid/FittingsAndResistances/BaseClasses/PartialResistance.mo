within TRANSFORM.Fluid.FittingsAndResistances.BaseClasses;
partial model PartialResistance

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

  parameter Boolean showName = true annotation(Dialog(tab="Visualization"));
equation

  port_a.m_flow + port_b.m_flow = 0;
  dp = port_a.p - port_b.p;
  m_flow=port_a.m_flow;

   state = Medium.setState_phX(
     port_a.p,
     inStream(port_a.h_outflow),
     inStream(port_a.Xi_outflow));

  // Stream variables balance
  port_a.h_outflow = inStream(port_b.h_outflow);
  port_b.h_outflow = inStream(port_a.h_outflow);
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
          visible=DynamicSelect(true,showName))}),
                                  Diagram(coordinateSystem(preserveAspectRatio=false)));
end PartialResistance;
