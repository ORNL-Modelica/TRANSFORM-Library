within TRANSFORM.Fluid.Pipes_Obsolete.ClosureModels.HeatTransfer.Examples;
model dfa "HT to DHT adaptor"
  extends Modelica.Blocks.Icons.Block;
  Modelica.Blocks.Interfaces.RealInput temperature_node1 annotation (
      Placement(transformation(
        origin={-120,30},
        extent={{-20,-20},{20,20}},
        rotation=0)));
  Modelica.Blocks.Interfaces.RealInput temperature_nodeN annotation (
      Placement(transformation(
        origin={-120,-30},
        extent={{-20,-20},{20,20}},
        rotation=0)));

  parameter Integer nNodes=2;

  Modelica.Blocks.Interfaces.RealOutput[nNodes] y annotation (
      Placement(transformation(
        origin={120,0},
        extent={{-20,-20},{20,20}},
        rotation=0)));
equation
  y = linspace(
      temperature_node1,
      temperature_nodeN,
      nNodes);
  annotation (Icon(graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          pattern=LinePattern.None)}), Diagram(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}})));
end dfa;
