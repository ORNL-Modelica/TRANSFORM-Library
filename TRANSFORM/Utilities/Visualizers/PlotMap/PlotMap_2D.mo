within TRANSFORM.Utilities.Visualizers.PlotMap;
model PlotMap_2D

  parameter String imageName="" "Location of image" annotation (Dialog(
        loadSelector(filter="All files (*.*);;PNG files (*.png)", caption="Open image file")));
  parameter Real dotSize=1 "Dot size" annotation (Dialog(group="Effects"));
  parameter Integer[3] dotColor={50,205,50} "Dot color" annotation (choices(
      choice={0,0,0} "Black",
      choice={255,0,0} "Red",
      choice={255,230,0} "Yellow",
      choice={0,0,255} "Blue",
      choice={50,205,50} "Green",
      choice={255,255,255} "White"), Dialog(group="Effects"));
  parameter Real x_scale[2]={0,1} "x-axis bounds";
  parameter Real y_scale[2]={0,1} "y-axis bounds";

  input Real x=0 "Units (i.e., scale) should match x-scale"
    annotation (Dialog(group="Inputs"));
  input Real y=0 "Units (i.e., scale) should match y-scale"
    annotation (Dialog(group="Inputs"));

  parameter Boolean showAnchors=true
    annotation (Dialog(tab="Anchor Coordinates {x,y}"));
  parameter Real anchorSize=1
    annotation (Dialog(tab="Anchor Coordinates {x,y}"));
  parameter Real lowerLeft[2]={0,0}
    annotation (Dialog(tab="Anchor Coordinates {x,y}"));
  parameter Real upperRight[2]={100,100}
    annotation (Dialog(tab="Anchor Coordinates {x,y}"));
  parameter Real upperLeft[2]={lowerLeft[1],upperRight[2]}
    annotation (Dialog(tab="Anchor Coordinates {x,y}"));
  parameter Real lowerRight[2]={upperRight[1],lowerLeft[2]}
    annotation (Dialog(tab="Anchor Coordinates {x,y}"));

  Real x_scaled "Normalized space";
  Real y_scaled "Normalized space";

  Real x_pixel "Coordinates in pixel space";
  Real y_pixel "Coordinates in pixel space";

  parameter Boolean log_scale[2]={false,false}
    "=true if x or y axis are log-scaled";
equation

  assert(x_scale[2] > x_scale[1], "x_scale[2] must be greater than x_scale[1]");
  assert(y_scale[2] > y_scale[1], "y_scale[2] must be greater than y_scale[1]");

// Normalize input to give values between 0 and 1 when within nominal range
  if log_scale[1] then
    x_scaled = (log10(x + 1) - log10(x_scale[1] + 1))/(log10(x_scale[2] + 1) -
      log10(x_scale[1] + 1));
  else
    x_scaled = (x - x_scale[1])/(x_scale[2] - x_scale[1]);
  end if;

  if log_scale[2] then
    y_scaled = (log10(y)  - log10(y_scale[1])) /(log10(y_scale[2])  -
      log10(y_scale[1]));
  else
    y_scaled = (y - y_scale[1])/(y_scale[2] - y_scale[1]);
  end if;

  // Map the normalized values to pixel space
  x_scaled = (x_pixel - lowerLeft[1])/(lowerRight[1] - lowerLeft[1]);
  y_scaled = (y_pixel - lowerLeft[2])/(upperLeft[2] - lowerLeft[2]);

  annotation (
    defaultComponentName="map",
    Icon(coordinateSystem(
        preserveAspectRatio=true,
        extent={{0,0},{100,100}},
        grid={1,1}), graphics={
        Bitmap(extent={{0,0},{100,100}}, fileName=imageName),
        Ellipse(
          extent=DynamicSelect({{-anchorSize,-anchorSize},{anchorSize,
              anchorSize}}, {{lowerLeft[1] - anchorSize,lowerLeft[2] -
              anchorSize},{lowerLeft[1] + anchorSize,lowerLeft[2] + anchorSize}}),
          lineColor={0,0,0},
          fillColor={255,255,0},
          fillPattern=FillPattern.Sphere,
          visible=showAnchors),
        Ellipse(
          extent=DynamicSelect({{-anchorSize,-anchorSize},{anchorSize,
              anchorSize}}, {{lowerRight[1] - anchorSize,lowerRight[2] -
              anchorSize},{lowerRight[1] + anchorSize,lowerRight[2] +
              anchorSize}}),
          lineColor={0,0,0},
          fillColor={255,255,0},
          fillPattern=FillPattern.Sphere,
          visible=showAnchors),
        Ellipse(
          extent=DynamicSelect({{-anchorSize,-anchorSize},{anchorSize,
              anchorSize}}, {{upperLeft[1] - anchorSize,upperLeft[2] -
              anchorSize},{upperLeft[1] + anchorSize,upperLeft[2] + anchorSize}}),
          lineColor={0,0,0},
          fillColor={255,255,0},
          fillPattern=FillPattern.Sphere,
          visible=showAnchors),
        Ellipse(
          extent=DynamicSelect({{-anchorSize,-anchorSize},{anchorSize,
              anchorSize}}, {{upperRight[1] - anchorSize,upperRight[2] -
              anchorSize},{upperRight[1] + anchorSize,upperRight[2] +
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
end PlotMap_2D;
