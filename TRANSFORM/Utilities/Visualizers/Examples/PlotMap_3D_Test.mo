within TRANSFORM.Utilities.Visualizers.Examples;
model PlotMap_3D_Test
  extends TRANSFORM.Icons.Example;
  Modelica.Blocks.Sources.Sine y_coordinate(
    freqHz=1/10,
    startTime=10,
    amplitude=100)
    annotation (Placement(transformation(extent={{10,-80},{30,-60}})));
  Modelica.Blocks.Sources.Sine x_coordinate(
    freqHz=1/10,
    startTime=10,
    amplitude=100,
    phase=1.5707963267949)
    annotation (Placement(transformation(extent={{-30,-80},{-10,-60}})));
  PlotMap_3D map(
    x=x_coordinate.y,
    y=y_coordinate.y,
    imageName=ModelicaServices.ExternalReferences.loadResource(
        "modelica://TRANSFORM/Resources/Images/Icons/Conduction_xy.jpg"),
    z=z_coordinate.y)
    annotation (Placement(transformation(extent={{20,-40},{100,40}})));
  Modelica.Blocks.Sources.Sine z_coordinate(
    freqHz=1/10,
    startTime=10,
    amplitude=100,
    offset=101)
    annotation (Placement(transformation(extent={{50,-80},{70,-60}})));
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
end PlotMap_3D_Test;
