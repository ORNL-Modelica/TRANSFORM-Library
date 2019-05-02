within TRANSFORM.Utilities.Visualizers.PlotMap;
model PlotMap_2D_2points

  extends TRANSFORM.Utilities.Visualizers.PlotMap.PlotMap_2D;

  parameter Real x_scale_2[2]=x_scale "x-axis bounds" annotation(Dialog(tab="More Dots"));
  parameter Real y_scale_2[2]=y_scale "y-axis bounds" annotation(Dialog(tab="More Dots"));

  parameter Real dotSize_2=dotSize "Dot size" annotation(Dialog(tab="More Dots",group="Effects"));
  parameter Integer[3] dotColor_2=dotColor "Dot color" annotation (choices(
      choice={0,0,0} "Black",
      choice={255,0,0} "Red",
      choice={255,230,0} "Yellow",
      choice={0,0,255} "Blue",
      choice={50,205,50} "Green",
      choice={255,255,255} "White"),Dialog(tab="More Dots",group="Effects"));

  input Real x_2=0 "Units (i.e., scale) should match x-scale"
    annotation (Dialog(tab="More Dots",group="Inputs"));
  input Real y_2=0 "Units (i.e., scale) should match y-scale"
    annotation (Dialog(tab="More Dots",group="Inputs"));

  Real x_scaled_2 "Normalized space";
  Real y_scaled_2 "Normalized space";

  Real x_pixel_2 "Coordinates in pixel space";
  Real y_pixel_2 "Coordinates in pixel space";

equation

  assert(x_scale_2[2] > x_scale_2[1], "x_scale_2[2] must be greater than x_scale_2[1]");
  assert(y_scale_2[2] > y_scale_2[1], "y_scale_2[2] must be greater than y_scale_2[1]");

  // Normalize input to give values between 0 and 1 when within nominal range
  x_scaled_2 = (x_2 - x_scale_2[1])/(x_scale_2[2] - x_scale_2[1]);
  y_scaled_2 = (y_2 - y_scale_2[1])/(y_scale_2[2] - y_scale_2[1]);

  // Map the normalized values to pixel space
  x_scaled_2 = (x_pixel_2 - lowerLeft[1])/(lowerRight[1] - lowerLeft[1]);
  y_scaled_2 = (y_pixel_2 - lowerLeft[2])/(upperLeft[2] - lowerLeft[2]);

  annotation (
    defaultComponentName="map",
    Icon(coordinateSystem(
        preserveAspectRatio=true,
        extent={{0,0},{100,100}},
        grid={1,1}), graphics={
        Ellipse(
          extent=DynamicSelect({{-dotSize_2,-dotSize_2},{dotSize_2,dotSize_2}}, {{
              x_pixel_2 - dotSize_2,y_pixel_2 - dotSize_2},{x_pixel_2 + dotSize_2,y_pixel_2 +
              dotSize_2}}),
          lineColor={0,0,0},
          fillColor=dotColor_2,
          fillPattern=FillPattern.Sphere)}),
    Diagram(coordinateSystem(extent={{0,0},{100,100}}, grid={1,1})));
end PlotMap_2D_2points;
