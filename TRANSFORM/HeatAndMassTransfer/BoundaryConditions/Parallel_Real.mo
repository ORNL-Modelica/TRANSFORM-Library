within TRANSFORM.HeatAndMassTransfer.BoundaryConditions;
model Parallel_Real "Scale real variables for nParallel values"

  parameter Real nParallel = 1 "Flow variable is divided by nParallel";

  Modelica.Blocks.Interfaces.RealInput       port_1 "Connector single flow"
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}}, rotation=
           0), iconTransformation(extent={{-110,-10},{-90,10}})));
  Modelica.Blocks.Interfaces.RealOutput      port_n
    "Connector for nParallel flows" annotation (Placement(transformation(extent={{94,-10},
            {114,10}},          rotation=0), iconTransformation(extent={{94,-10},
            {114,10}})));

equation

  port_1 = port_n*nParallel;

  annotation (defaultComponentName="nFlow",
        Icon(coordinateSystem(preserveAspectRatio=false), graphics={Bitmap(
            extent={{-100,-100},{100,100}}, fileName="modelica://TRANSFORM/Resources/Images/Icons/nParallel_real.jpg")}),
                                                                 Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Parallel_Real;
