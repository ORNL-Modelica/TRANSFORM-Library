within TRANSFORM.Utilities.Visualizers.PlotMap;
model PlotMap_2D_2points_withTrace

  import TRANSFORM.Utilities.Visualizers.BaseClasses.Types.LinePattern;

  extends TRANSFORM.Utilities.Visualizers.PlotMap.PlotMap_2D_2points;

   parameter Integer[3] lineColor=dotColor "Trace color" annotation (Dialog(tab="Tracing",
         group="Effects"), choices(
       choice={0,0,0} "Black",
       choice={255,0,0} "Red",
       choice={255,230,0} "Yellow",
       choice={0,0,255} "Blue",
       choice={50,205,50} "Green",
       choice={255,255,255} "White"));
   parameter LinePattern pattern=LinePattern.DashDot "Line type" annotation (
       choicesAllMatching=true, Dialog(tab="Tracing", group="Effects"));

  parameter Integer[3] lineColor_2=dotColor_2 "Trace color" annotation (Dialog(tab="Tracing",
        group="Effects"), choices(
      choice={0,0,0} "Black",
      choice={255,0,0} "Red",
      choice={255,230,0} "Yellow",
      choice={0,0,255} "Blue",
      choice={50,205,50} "Green",
      choice={255,255,255} "White"));
  parameter LinePattern pattern_2=LinePattern.DashDot "Line type" annotation (
      choicesAllMatching=true, Dialog(tab="Tracing", group="Effects"));

   parameter Modelica.SIunits.Time t_start=0 "Start time of display"
     annotation (Dialog(tab="Tracing"));
   parameter Modelica.SIunits.Time t_end=1 "End time of display"
     annotation (Dialog(tab="Tracing"));

   parameter String plotControl="Frequency" annotation (choices(choice="Frequency",
         choice="Time interval"), Dialog(tab="Tracing"));
   parameter SI.Frequency f=1 "Plot frequency"
     annotation (Dialog(tab="Tracing", enable=plotControl == "Frequency"));
   parameter SI.Time dt(min=Modelica.Constants.eps) = (t_end - t_start)/100
     "Time interval for plot"
     annotation (Dialog(tab="Tracing", enable=plotControl == "Time interval"));

   Real x_trace[nPoints] "x-positions of line points";
   Real y_trace[nPoints] "y-positions of line points";

  Real x_trace_2[nPoints] "x-positions of line points";
  Real y_trace_2[nPoints] "y-positions of line points";

protected
   final parameter Integer nPoints=if plotControl == "Frequency" then integer((
       t_end - t_start)*f + 1) else integer((t_end - t_start)/dt + 1)
     "Number of points";
   final parameter SI.Time dt_int=(t_end - t_start)/(nPoints - 1)
     "Internal time stepping based on user input";

equation
  for i in 1:nPoints loop
    when time < (i)*dt_int + t_start and time >= (i - 1)*dt_int + t_start and
        sample(t_start, dt_int) then
       y_trace[i] = y_pixel;
       x_trace[i] = x_pixel;
      y_trace_2[i] = y_pixel_2;
      x_trace_2[i] = x_pixel_2;
    end when;
  end for;

  annotation (
    defaultComponentName="map",
    Icon(coordinateSystem(preserveAspectRatio=false), graphics={
    Line( points=DynamicSelect({{0,0},{50,52},{70,40},{100,100}}, [x_trace,
              y_trace]),
          color=DynamicSelect({0,0,0}, lineColor),
          pattern=pattern,
          thickness=0.5),
    Line( points=DynamicSelect({{0,0},{50,52},{70,40},{100,100}}, [x_trace_2,
              y_trace_2]),
          color=DynamicSelect({0,0,0}, lineColor_2),
          pattern=pattern_2,
          thickness=0.5)}),
    Diagram(coordinateSystem(preserveAspectRatio=false)));
end PlotMap_2D_2points_withTrace;
