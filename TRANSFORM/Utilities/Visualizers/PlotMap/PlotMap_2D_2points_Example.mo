within TRANSFORM.Utilities.Visualizers.PlotMap;
model PlotMap_2D_2points_Example
  extends TRANSFORM.Utilities.Visualizers.PlotMap.PlotMap_2D_2points(
    imageName="modelica://TRANSFORM/Resources/Images/Icons/Conduction_xy.jpg",
    x_scale={0,1500},
    y_scale={0,6000},
    lowerLeft={10,10},
    upperRight={80,80});

  annotation (defaultComponentName="map",Icon(coordinateSystem(grid={1,1})), Diagram(coordinateSystem(grid=
           {1,1})));
end PlotMap_2D_2points_Example;
