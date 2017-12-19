within TRANSFORM.Controls;
block PI_Control "Proportional-Integral controller: y = yb + Kc*e + Kc/Ti*integral(e)"

  import Modelica.Blocks.Types.Init;

  extends Modelica.Blocks.Interfaces.SVcontrol;

  parameter Real k(unit="1") = 1 "Error Gain";
  parameter SI.Time Ti(
    start=1,
    min=Modelica.Constants.small) = 1 "Time Constant (Ti>0 required)";
  parameter Modelica.Blocks.Types.Init initType=Modelica.Blocks.Types.Init.NoInit
    "Type of initialization (1: no init, 2: steady state, 3: initial state, 4: initial output)"
    annotation (Evaluate=true, Dialog(group="Initialization"));
  parameter Real yb=0 "Output bias";
  parameter Real k_s=1 "Scaling factor for setpoint: k_s*u_s";
  parameter Real k_m=1 "Scaling factor for measurement: k_m*u_m";
  parameter Boolean directActing=true "=false reverse acting"
    annotation (Evaluate=true);

  parameter Real x_start=0 "Initial or guess value of error integral (state)"
    annotation (Dialog(group="Initialization"));
  parameter Real y_start=0 "Initial value of output" annotation (Dialog(enable=
          initType == Init.SteadyState or initType == Init.InitialOutput, group=
         "Initialization"));

  Real x(start=x_start) "Error integral (state)";

  Real Kc=k*(if directActing then +1 else -1);
  Real e=k_s*u_s - k_m*u_m;

initial equation
  if initType == Init.SteadyState then
    der(x) = 0;
  elseif initType == Init.InitialState then
    x = x_start;
  elseif initType == Init.InitialOutput then
    y = y_start;
  end if;

equation
  der(x) = e;
  y = yb + Kc*e + Kc/Ti*x;
  annotation (
    defaultComponentName="PI",
    Documentation(info="<html>
<p>
This blocks defines the transfer function between the input u and
the output y (element-wise) as <i>PI</i> system:
</p>
<pre>
                 1
   y = k * (1 + ---) * u
                T*s
           T*s + 1
     = k * ------- * u
             T*s
</pre>
<p>
If you would like to be able to change easily between different
transfer functions (FirstOrder, SecondOrder, ... ) by changing
parameters, use the general model class <b>TransferFunction</b>
instead and model a PI SISO system with parameters<br>
b = {k*T, k}, a = {T, 0}.
</p>
<pre>
Example:

   parameter: k = 0.3,  T = 0.4

   results in:
               0.4 s + 1
      y = 0.3 ----------- * u
                 0.4 s
</pre>

<p>
It might be difficult to initialize the PI component in steady state
due to the integrator part.
This is discussed in the description of package
<a href=\"modelica://Modelica.Blocks.Continuous#info\">Continuous</a>.
</p>

</html>"),
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}}), graphics={
        Line(points={{-80,78},{-80,-90}}, color={192,192,192}),
        Polygon(
          points={{-80,90},{-88,68},{-72,68},{-80,90}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(points={{-90,-80},{82,-80}}, color={192,192,192}),
        Polygon(
          points={{90,-80},{68,-72},{68,-88},{90,-80}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(points={{-80.0,-80.0},{-80.0,-20.0},{60.0,80.0}}, color={0,0,127}),
        Text(
          extent={{0,6},{60,-56}},
          lineColor={192,192,192},
          textString="PI"),
        Text(
          extent={{-150,-150},{150,-110}},
          lineColor={0,0,0},
          textString="T=%T")}),
    Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}})));
end PI_Control;
