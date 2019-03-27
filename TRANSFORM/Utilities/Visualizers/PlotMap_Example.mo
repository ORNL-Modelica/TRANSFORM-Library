within TRANSFORM.Utilities.Visualizers;
model PlotMap_Example
  extends TRANSFORM.Utilities.Visualizers.PlotMap_2D(
    imageName="modelica://TRANSFORM/Resources/Images/Icons/Conduction_xy.jpg",
    x_scale={0,1500},
    y_scale={0,6000},
    lowerLeft={10,10},
    upperRight={80,80});

  annotation (defaultComponentName="map",Icon(coordinateSystem(grid={1,1})), Diagram(coordinateSystem(grid=
           {1,1})));
end PlotMap_Example;
