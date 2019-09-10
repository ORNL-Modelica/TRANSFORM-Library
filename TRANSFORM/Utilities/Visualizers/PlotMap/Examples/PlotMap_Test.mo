within TRANSFORM.Utilities.Visualizers.PlotMap.Examples;
model PlotMap_Test
  extends TRANSFORM.Icons.Example;
  Modelica.Blocks.Sources.Sine y_coordinate(
    amplitude=3000,
    freqHz=1/10,
    offset=3000,
    startTime=10)
    annotation (Placement(transformation(extent={{10,-80},{30,-60}})));
  Modelica.Blocks.Sources.Sine x_coordinate(
    amplitude=750,
    freqHz=1/10,
    phase=1.5707963267949,
    offset=750,
    startTime=10)
    annotation (Placement(transformation(extent={{-30,-80},{-10,-60}})));
  TRANSFORM.Utilities.Visualizers.PlotMap.PlotMap_2D_Example map_example(x=
        x_coordinate.y, y=y_coordinate.y)
    annotation (Placement(transformation(extent={{-100,-40},{-20,40}})));
  PlotMap.PlotMap_2D map(
    x_scale={0,1500},
    y_scale={0,6000},
    x=x_coordinate.y,
    y=y_coordinate.y,
    imageName=ModelicaServices.ExternalReferences.loadResource(
        "modelica://TRANSFORM/Resources/Images/Icons/Conduction_xy.jpg"))
    annotation (Placement(transformation(extent={{20,-40},{100,40}})));
  ErrorAnalysis.UnitTests unitTests(n=2, x={map.x_scaled,map_example.x_scaled})
    annotation (Placement(transformation(extent={{80,80},{100,100}})));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false), graphics={Text(
          extent={{-80,58},{-40,48}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Sphere,
          fillColor={255,255,0},
          textString="Using pre-scaled pixels"), Text(
          extent={{22,60},{96,48}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Sphere,
          fillColor={255,255,0},
          textString="Non-scaled pixels and manual loaded image")}),
    experiment(StopTime=100));
end PlotMap_Test;
