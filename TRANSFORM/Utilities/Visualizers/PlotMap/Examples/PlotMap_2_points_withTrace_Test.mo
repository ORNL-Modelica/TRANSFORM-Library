within TRANSFORM.Utilities.Visualizers.PlotMap.Examples;
model PlotMap_2_points_withTrace_Test
  extends TRANSFORM.Icons.Example;
  Modelica.Blocks.Sources.ExpSine
                               y_coordinate(
    amplitude=3000,
    freqHz=1/10,
    damping=0.05,
    offset=3000,
    startTime=10)
    annotation (Placement(transformation(extent={{10,-80},{30,-60}})));
  Modelica.Blocks.Sources.ExpSine
                               x_coordinate(
    amplitude=750,
    freqHz=1/10,
    phase=1.5707963267949,
    damping=0.05,
    offset=750,
    startTime=10)
    annotation (Placement(transformation(extent={{-30,-80},{-10,-60}})));
  PlotMap_2D_2points_withTrace map(
    x_scale={0,1500},
    y_scale={0,6000},
    x=x_coordinate.y,
    y=y_coordinate.y,
    imageName=ModelicaServices.ExternalReferences.loadResource(
        "modelica://TRANSFORM/Resources/Images/Icons/Conduction_xy.jpg"),
    dotColor_2={255,0,0},
    x_2=x_coordinate.y + 100,
    y_2=y_coordinate.y + 400,
    pattern=TRANSFORM.Utilities.Visualizers.BaseClasses.Types.LinePattern.Dash,

    t_end=100,
    f=0.5) annotation (Placement(transformation(extent={{-40,-40},{40,40}})));

  ErrorAnalysis.UnitTests unitTests(x={map.x_scaled})
    annotation (Placement(transformation(extent={{80,80},{100,100}})));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(StopTime=100));
end PlotMap_2_points_withTrace_Test;
