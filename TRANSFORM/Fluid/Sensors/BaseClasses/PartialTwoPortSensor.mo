within TRANSFORM.Fluid.Sensors.BaseClasses;
partial model PartialTwoPortSensor
  extends TRANSFORM.Fluid.Interfaces.Records.Medium_fluid;
  parameter Boolean allowFlowReversal=true
    "= true to allow flow reversal, false restricts to design direction (port_a -> port_b)"
    annotation (Dialog(tab="Assumptions"), Evaluate=true);
  parameter Boolean showName=true "= false to hide component name"
    annotation (Dialog(tab="Visualization"));
  TRANSFORM.Fluid.Interfaces.FluidPort_Flow port_a(
    redeclare package Medium = Medium,
    m_flow(min=if allowFlowReversal then -Modelica.Constants.inf else 0),
    h_outflow(start=h_start))
    "Fluid connector a (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}}, rotation=
           0)));
  TRANSFORM.Fluid.Interfaces.FluidPort_Flow port_b(
    redeclare package Medium = Medium,
    m_flow(max=if allowFlowReversal then +Modelica.Constants.inf else 0),
    h_outflow(start=h_start))
    "Fluid connector b (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{110,-10},{90,10}}, rotation=0),
        iconTransformation(extent={{110,-10},{90,10}})));
  parameter Medium.MassFlowRate m_flow_small(min=0) = 1e-4
    "Regularization for zero flow:|m_flow| < m_flow_small"
    annotation(Dialog(tab="Advanced"));
  parameter SI.AbsolutePressure p_start=Medium.p_default "Pressure" annotation (
     Dialog(tab="Initialization", group="Start Value: Absolute Pressure"));
  parameter Boolean use_T_start=true "Use T_start if true, otherwise h_start"
    annotation (Evaluate=true, Dialog(tab="Initialization", group=
          "Start Value: Temperature"));
  parameter SI.Temperature T_start=Medium.T_default "Temperature" annotation (
      Evaluate=true, Dialog(
      tab="Initialization",
      group="Start Value: Temperature",
      enable=use_T_start));
  parameter SI.SpecificEnthalpy h_start=Medium.specificEnthalpy_pTX(
      p_start,
      T_start,
      X_start) "Specific enthalpy" annotation (Dialog(
      tab="Initialization",
      group="Start Value: Specific Enthalpy",
      enable=not use_T_start));
  parameter SI.MassFraction X_start[Medium.nX]=Medium.X_default "Mass fraction"
    annotation (Dialog(
      tab="Initialization",
      group="Start Value: Species Mass Fraction",
      enable=Medium.nXi > 0));
equation
  // Mass balance
  0 = port_a.m_flow + port_b.m_flow;
  // Momentum equation (no pressure loss)
  port_a.p = port_b.p;
  // No storage, loss of energy, etc.
  port_a.h_outflow = inStream(port_b.h_outflow);
  port_b.h_outflow = inStream(port_a.h_outflow);
  port_a.Xi_outflow = inStream(port_b.Xi_outflow);
  port_b.Xi_outflow = inStream(port_a.Xi_outflow);
  port_a.C_outflow = inStream(port_b.C_outflow);
  port_b.C_outflow = inStream(port_a.C_outflow);
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Text(
          extent={{-149,-68},{151,-108}},
          lineColor={0,0,255},
          textString="%name",
          visible=DynamicSelect(true, showName))}), Diagram(coordinateSystem(
          preserveAspectRatio=false)));
end PartialTwoPortSensor;
