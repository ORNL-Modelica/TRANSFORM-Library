within TRANSFORM.Fluid.Pipes;
model parallelFlow
  "Scale mass flow rate: simulates parallel flow streams"
  replaceable package Medium = Modelica.Media.Water.StandardWater
    constrainedby Modelica.Media.Interfaces.PartialMedium "Medium properties"
    annotation (choicesAllMatching=true);
  Interfaces.FluidPort_Flow             port_1(redeclare package Medium =
        Medium) "Fluid connector single flow" annotation (Placement(
        transformation(extent={{-110,-10},{-90,10}}, rotation=0)));
  Interfaces.FluidPort_Flow             port_n(redeclare package Medium =
        Medium) "Fluid connector for nParallel flows" annotation (Placement(
        transformation(extent={{110,-10},{90,10}}, rotation=0),
        iconTransformation(extent={{110,-10},{90,10}})));
  parameter Real nParallel = 1 "port_a.m_flow is divided by nParallel";
equation
  // mass balance
  0 =port_1.m_flow + port_n.m_flow*nParallel;
  // momentum equation (no pressure loss)
  port_1.p = port_n.p;
  // isenthalpic state transformation (no storage and no loss of energy)
  port_1.h_outflow = inStream(port_n.h_outflow);
  port_n.h_outflow = inStream(port_1.h_outflow);
   port_1.Xi_outflow = inStream(port_n.Xi_outflow);
   port_n.Xi_outflow = inStream(port_1.Xi_outflow);
   port_1.C_outflow = inStream(port_n.C_outflow);
   port_n.C_outflow = inStream(port_1.C_outflow);
  annotation (defaultComponentName="nFlow",
        Icon(coordinateSystem(preserveAspectRatio=false), graphics={Bitmap(
            extent={{-100,-100},{100,100}}, fileName=
              "modelica://TRANSFORM/Resources/Images/Icons/nParallel_fluid.jpg")}),
                                                                 Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end parallelFlow;
