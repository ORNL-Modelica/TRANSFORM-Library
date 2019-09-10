within TRANSFORM.HeatAndMassTransfer.BoundaryConditions.Mass;
model ParallelFlow "Scale flow variables for nParallel streams"
  parameter Integer nC = 1 "Number of substances";
  parameter Real nParallel = 1 "Flow variable is divided by nParallel";
  TRANSFORM.HeatAndMassTransfer.Interfaces.MolePort_Flow port_1(nC=nC)
    "Connector single flow" annotation (Placement(transformation(extent={{-110,
            -10},{-90,10}}, rotation=0)));
  TRANSFORM.HeatAndMassTransfer.Interfaces.MolePort_Flow port_n(nC=nC)
    "Connector for nParallel flows" annotation (Placement(transformation(
          extent={{110,-10},{90,10}}, rotation=0), iconTransformation(extent={
            {110,-10},{90,10}})));
equation
  // Mass Balance
  zeros(nC) =port_1.n_flow +port_n.n_flow *nParallel;
  // Concentration
  port_1.C = port_n.C;
  annotation (defaultComponentName="nFlow",
        Icon(coordinateSystem(preserveAspectRatio=false), graphics={Bitmap(
            extent={{-100,-100},{100,100}}, fileName="modelica://TRANSFORM/Resources/Images/Icons/nParallel_mass.jpg")}),
                                                                 Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end ParallelFlow;
