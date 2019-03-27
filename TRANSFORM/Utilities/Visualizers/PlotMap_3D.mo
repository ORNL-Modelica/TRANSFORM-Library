within TRANSFORM.Utilities.Visualizers;
model PlotMap_3D

  extends TRANSFORM.Icons.UnderConstruction;

  parameter String imageName="" "Location of image" annotation (Dialog(
        loadSelector(filter="All files (*.*);;PNG files (*.png)", caption="Open image file")));
  parameter Real dotSize=1 "Dot size" annotation(Dialog(group="Effects"));
  parameter Integer[3] dotColor={50,205,50} "Dot color" annotation (choices(
      choice={0,0,0} "Black",
      choice={255,0,0} "Red",
      choice={255,230,0} "Yellow",
      choice={0,0,255} "Blue",
      choice={50,205,50} "Green",
      choice={255,255,255} "White"),Dialog(group="Effects"));
  parameter Real x_scale[2]={0,1} "x-axis bounds";
  parameter Real y_scale[2]={0,1} "y-axis bounds";
  parameter Real z_scale[2]={0,1} "z-axis bounds";

  input Real x=0 "Units (i.e., scale) should match x-scale"
    annotation (Dialog(group="Inputs"));
  input Real y=0 "Units (i.e., scale) should match y-scale"
    annotation (Dialog(group="Inputs"));
  input Real z=0 "Units (i.e., scale) should match z-scale"
    annotation (Dialog(group="Inputs"));

  parameter Boolean showAnchors=true
    annotation (Dialog(tab="Anchor Coordinates {x,y}"));
  parameter Real anchorSize=1
    annotation (Dialog(tab="Anchor Coordinates {x,y}"));
  parameter Real anchor_origin[2]={0,0}
    annotation (Dialog(tab="Anchor Coordinates {x,y}"));
  parameter Real anchor_x[2]={100,-100}
    annotation (Dialog(tab="Anchor Coordinates {x,y}"));
  parameter Real anchor_y[2]={0,100}
    annotation (Dialog(tab="Anchor Coordinates {x,y}"));
  parameter Real anchor_z[2]={-100,-100}
    annotation (Dialog(tab="Anchor Coordinates {x,y}"));

  Real x_scaled "Normalized space";
  Real y_scaled "Normalized space";
  Real z_scaled "Normalized space";

  Real x_pixel "Coordinates in pixel space";
  Real y_pixel "Coordinates in pixel space";

  final parameter Real frame_width = max({anchor_x[1],anchor_y[1],anchor_z[1]})  - min({anchor_x[1],anchor_y[1],anchor_z[1]});
  final parameter Real frame_heigth = max({anchor_x[2],anchor_y[2],anchor_z[2]})  - min({anchor_x[2],anchor_y[2],anchor_z[2]});

equation

  assert(x_scale[2] > x_scale[1], "x_scale[2] must be greater than x_scale[1]");
  assert(y_scale[2] > y_scale[1], "y_scale[2] must be greater than y_scale[1]");
  assert(z_scale[2] > z_scale[1], "y_scale[2] must be greater than y_scale[1]");

  // Normalize input to give values between 0 and 1 when within nominal range
  x_scaled = (x - x_scale[1])/(x_scale[2] - x_scale[1]);
  y_scaled = (y - y_scale[1])/(y_scale[2] - y_scale[1]);
  z_scaled = (z - z_scale[1])/(z_scale[2] - z_scale[1]);

//   A = [-Y, X, 0]
//   B = [-X*Z, -Y*Z, X*X+Y*Y]

  // Map the normalized values to pixel space
  x_scaled/z_scaled = (x_pixel - anchor_origin[1]);///frame_width;
  y_scaled/z_scaled = (y_pixel - anchor_origin[2]);///frame_heigth;

  annotation (
    defaultComponentName="map",
    Icon(coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100,-100},{100,100}},
        grid={1,1}), graphics={
        Bitmap(extent={{-101,-100},{101,100}},
                                         fileName=imageName),
        Ellipse(
          extent=DynamicSelect({{-anchorSize,-anchorSize},{anchorSize,
              anchorSize}}, {{anchor_origin[1] - anchorSize,anchor_origin[2] -
              anchorSize},{anchor_origin[1] + anchorSize,anchor_origin[2] + anchorSize}}),
          lineColor={0,0,0},
          fillColor={255,255,0},
          fillPattern=FillPattern.Sphere,
          visible=showAnchors),
        Ellipse(
          extent=DynamicSelect({{-anchorSize,-anchorSize},{anchorSize,
              anchorSize}}, {{anchor_x[1] - anchorSize,anchor_x[2] -
              anchorSize},{anchor_x[1] + anchorSize,anchor_x[2] +
              anchorSize}}),
          lineColor={0,0,0},
          fillColor={255,255,0},
          fillPattern=FillPattern.Sphere,
          visible=showAnchors),
        Ellipse(
          extent=DynamicSelect({{-anchorSize,-anchorSize},{anchorSize,
              anchorSize}}, {{anchor_y[1] - anchorSize,anchor_y[2] -
              anchorSize},{anchor_y[1] + anchorSize,anchor_y[2] + anchorSize}}),
          lineColor={0,0,0},
          fillColor={255,255,0},
          fillPattern=FillPattern.Sphere,
          visible=showAnchors),
        Ellipse(
          extent=DynamicSelect({{-anchorSize,-anchorSize},{anchorSize,
              anchorSize}}, {{anchor_z[1] - anchorSize,anchor_z[2] -
              anchorSize},{anchor_z[1] + anchorSize,anchor_z[2] +
              anchorSize}}),
          lineColor={0,0,0},
          fillColor={255,255,0},
          fillPattern=FillPattern.Sphere,
          visible=showAnchors),
        Ellipse(
          extent=DynamicSelect({{-dotSize,-dotSize},{dotSize,dotSize}}, {{
              x_pixel - dotSize,y_pixel - dotSize},{x_pixel + dotSize,y_pixel +
              dotSize}}),
          lineColor={0,0,0},
          fillColor=dotColor,
          fillPattern=FillPattern.Sphere)}),
    Diagram(coordinateSystem(extent={{0,0},{100,100}}, grid={1,1})));
end PlotMap_3D;
