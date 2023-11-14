within TRANSFORM.Utilities.Visualizers;
model DynamicGraph "Dynamic graphical display of one variable"
  parameter Boolean use_port=false "=true to use input port"
    annotation (choices(checkBox=true));
  input Real y_var=0 "Input variable for plotting"
    annotation (Dialog(enable=not use_port));
  parameter String y_name="VariableName" "y-axis label name"
    annotation (Dialog(group="Layout"));
  parameter String Unit="[-]" "y-axis unit for label"
    annotation (Dialog(group="Layout"));
  parameter Integer[3] color={50,205,50} "Line color" annotation (Dialog(group="Layout"),
      choices(
      choice={255,0,0} "Red",
      choice={255,230,0} "Yellow",
      choice={0,0,255} "Blue",
      choice={50,205,50} "Green",
      choice={255,255,255} "White"));
  parameter Real y_min=0 "Minimum value of the y-axis"
    annotation (Dialog(group="Scaling"));
  parameter Real y_max(min=y_min + Modelica.Constants.eps) = 1
    "Maximum value of the y-axis"
    annotation (Dialog(group="Scaling"));
  parameter Modelica.Units.SI.Time t_start=0 "Start time of display"
    annotation (Dialog(group="Scaling"));
  parameter Modelica.Units.SI.Time t_end=1 "End time of display"
    annotation (Dialog(group="Scaling"));
  parameter SI.Time dt(min=Modelica.Constants.eps) = (t_end - t_start)/100
    "Time interval for plot" annotation (Dialog(group="Scaling"));
  parameter SI.Time tau=0.01
    "Stabilizing time constant, = 0 then no stabilization"
    annotation (Dialog(group="Numerics"));
  Modelica.Blocks.Interfaces.RealInput u = u_aux if use_port
    "Input signal" annotation (Placement(transformation(extent={{-70,30},{-30,70}}),
        iconTransformation(extent={{-42,44},{-30,56}})));
protected
  final parameter Integer nPoints=integer((t_end - t_start)/dt + 1)
    "Number of points";
  final parameter Real x[nPoints]=linspace(
      1,
      100,
      nPoints) "x-positions of line points";
  Real y[nPoints] "y-positions of line points";
  Real f "Horizontal position of the cover-rectangle";
  Real u_int "Value to be displayed";
  Real u_aux "Auxilliary variable";
initial equation
  if tau > 0 then
    u_int = u_aux;
  end if;
equation
  assert(y_max > y_min, "Error: y_max must be greater than y_min.");
  assert(t_end > t_start, "Error: t_end must be greater than t_start");
  if not use_port then
    u_aux = y_var;
  end if;
  if tau > 0 then
    der(u_int) =(u_aux - u_int)/tau;
  else
    u_int = u_aux;
  end if;
  for i in 1:nPoints loop
    when time < (i)*dt + t_start and time >= (i - 1)*dt + t_start and sample(
        t_start, dt) then
      y[i] = if u_int < y_min then (1 - (y_max - y_min)/(y_max - y_min))*100
         else if u_int > y_max then (1 - (y_max - y_max)/(y_max - y_min))*100
         else (1 - (y_max - u_int)/(y_max - y_min))*100;
    end when;
  end for;
  f = if time <= t_start then 0 else if time >= (t_end - t_start) + t_start
     then 100 else (time - dt - t_start)*100/(t_end - t_start);
  annotation (
    defaultComponentName="graph",
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-30,-10},{110,120}}),
        graphics={
        Rectangle(
          extent={{-30,102},{110,-10}},
          lineColor={135,135,135},
          fillColor={221,222,223},
          fillPattern=FillPattern.VerticalCylinder),
        Rectangle(
          extent={{0,100},{100,0}},
          lineColor={27,36,42},
          fillColor={27,36,42},
          fillPattern=FillPattern.Solid),
        Line(
          points=DynamicSelect({{0,0},{50,52},{70,40},{100,100}}, [x,y]),
          color=DynamicSelect({0,131,169}, color),
          pattern=LinePattern.Solid,
          thickness=0.5),
        Rectangle(
          extent=DynamicSelect({{0,100},{100,0}}, {{f,100},{100,0}}),
          pattern=LinePattern.Solid,
          lineColor={27,36,42},
          fillColor=DynamicSelect({27,36,42}, {27,36,42}),
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-8,-2},{10,-8}},
          lineColor={27,36,42},
          textString=String(t_start, format="1.0f")),
        Text(
          extent={{90,-2},{108,-8}},
          lineColor={27,36,42},
          textString=String(t_end, format="1.0f")),
        Text(
          extent={{-2,94},{-30,100}},
          lineColor={27,36,42},
          horizontalAlignment=TextAlignment.Right,
          textString=String(y_max, format="1.0f")),
        Text(
          extent={{-30,6},{-2,0}},
          lineColor={27,36,42},
          horizontalAlignment=TextAlignment.Right,
          textString=String(y_min, format="1.0f")),
        Text(
          extent={{64,-2},{34,-10}},
          lineColor={27,36,42},
          textString="Time [s]"),
        Text(
          extent={{44,4},{-44,-4}},
          lineColor={27,36,42},
          origin={-20,50},
          rotation=90,
          textString="%y_name"),
        Text(
          extent={{44,4},{-44,-4}},
          lineColor={27,36,42},
          origin={-10,50},
          rotation=90,
          textString="%Unit")}),
    Diagram(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-30,-10},{110,120}},
        grid={2,2},
        initialScale=0.1)));
end DynamicGraph;
