within TRANSFORM.HeatAndMassTransfer.BoundaryConditions.Heat;
model ParallelFlow "Scale flow variables for nParallel streams"

  extends TRANSFORM.Fluid.Interfaces.Records.Visualization_showName;

  parameter Real nParallel = 1 "Flow variable is divided by nParallel";
  parameter Boolean showName = true annotation(Dialog(tab="Visualization"));

  TRANSFORM.HeatAndMassTransfer.Interfaces.HeatPort_Flow port_1
    "Connector single flow" annotation (Placement(transformation(extent={{-110,
            -10},{-90,10}}, rotation=0)));
  TRANSFORM.HeatAndMassTransfer.Interfaces.HeatPort_Flow port_n
    "Connector for nParallel flows" annotation (Placement(transformation(
          extent={{110,-10},{90,10}}, rotation=0), iconTransformation(extent={
            {110,-10},{90,10}})));

equation
  // Energy Balance
  0 =port_1.Q_flow + port_n.Q_flow*nParallel;

  // Temperature
  port_1.T = port_n.T;

  annotation (defaultComponentName="nFlow",
        Icon(coordinateSystem(preserveAspectRatio=false), graphics={Bitmap(
            extent={{-100,-100},{100,100}}, fileName="modelica://TRANSFORM/Resources/Images/Icons/nParallel_thermal.jpg"),
        Text(
          extent={{-149,88},{151,48}},
          lineColor={0,0,255},
          textString="%name",
          visible=DynamicSelect(true,showName))}),            Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end ParallelFlow;
