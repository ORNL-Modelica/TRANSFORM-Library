within TRANSFORM.Blocks;
block IntegratorWithReset "Output the integral of the input signal"
  extends Modelica.Blocks.Interfaces.SISO(y(start=y_start));
  parameter Real k(unit="1")=1 "Integrator gain";
  /* InitialState is the default, because it was the default in Modelica 2.2
     and therefore this setting is backward compatible
  */
  parameter Modelica.Blocks.Types.Init initType=Modelica.Blocks.Types.Init.InitialState
    "Type of initialization (1: no init, 2: steady state, 3,4: initial output)"
    annotation(Evaluate=true,
      Dialog(group="Initialization"));
  parameter Real y_start=0 "Initial or guess value of output (= state)"
    annotation (Dialog(group="Initialization"));
  parameter TRANSFORM.Types.Reset reset = TRANSFORM.Types.Reset.Disabled
    "Type of integrator reset";
  parameter Real y_reset = 0
    "Value to which integrator is reset, used if reset = TRANSFORM.Types.Reset.Parameter"
    annotation(Evaluate=true,
               Dialog(
                 enable=reset == TRANSFORM.Types.Reset.Parameter,
                 group="Integrator reset"));
  Modelica.Blocks.Interfaces.RealInput y_reset_in
    if reset == TRANSFORM.Types.Reset.Input
    "Input signal for state to which integrator is reset, enabled if reset = TRANSFORM.Types.Reset.Input"
    annotation (Placement(transformation(extent={{-140,-100},{-100,-60}})));
  Modelica.Blocks.Interfaces.BooleanInput trigger
    if reset <> TRANSFORM.Types.Reset.Disabled
    "Resets the integrator output when trigger becomes true"
    annotation (Placement(transformation(extent={{-20,-20},{20,20}}, rotation=90,
        origin={0,-120}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={0,-120})));
protected
  Modelica.Blocks.Interfaces.RealInput y_reset_internal
   "Internal connector for integrator reset"
   annotation(Evaluate=true);
  Modelica.Blocks.Interfaces.BooleanInput trigger_internal
    "Needed to use conditional connector trigger";
initial equation
  if initType == Modelica.Blocks.Types.Init.SteadyState then
     der(y) = 0;
  elseif initType == Modelica.Blocks.Types.Init.InitialState or
         initType == Modelica.Blocks.Types.Init.InitialOutput then
    y = y_start;
  end if;
equation
  der(y) = k*u;
  // Equations for integrator reset
  connect(trigger, trigger_internal);
  connect(y_reset_in, y_reset_internal);
  if reset <> TRANSFORM.Types.Reset.Input then
    y_reset_internal = y_reset;
  end if;
  if reset == TRANSFORM.Types.Reset.Disabled then
    trigger_internal = false;
  else
    when trigger_internal then
      reinit(y, y_reset_internal);
    end when;
  end if;
  annotation (
defaultComponentName="intWitRes",
    Documentation(info="<html>
<p>
This model is similar to
<a href=\"modelica://Modelica.Blocks.Continuous.Integrator\">
Modelica.Blocks.Continuous.Integrator</a>
except that it optionally allows to reset the output <code>y</code>
of the integrator.
</p>
<p>
The output of the integrator can be reset as follows:
</p>
<ul>
<li>
If <code>reset = TRANSFORM.Types.Reset.Disabled</code>, which is the default,
then the integrator is never reset.
</li>
<li>
If <code>reset = TRANSFORM.Types.Reset.Parameter</code>, then a boolean
input signal <code>trigger</code> is enabled. Whenever the value of
this input changes from <code>false</code> to <code>true</code>,
the integrator is reset by setting <code>y</code>
to the value of the parameter <code>y_reset</code>.
</li>
<li>
If <code>reset = TRANSFORM.Types.Reset.Input</code>, then a boolean
input signal <code>trigger</code> is enabled. Whenever the value of
this input changes from <code>false</code> to <code>true</code>,
the integrator is reset by setting <code>y</code>
to the value of the input signal <code>y_reset_in</code>.
</li>
</ul>
<p>
See <a href=\"modelica://TRANSFORM.Blocks.Examples.IntegratorWithReset\">
TRANSFORM.Blocks.Examples.IntegratorWithReset</a> for an example.
</p>
<h4>Implementation</h4>
<p>
To adjust the icon layer, the code of
<a href=\"modelica://Modelica.Blocks.Continuous.Integrator\">
Modelica.Blocks.Continuous.Integrator</a>
has been copied into this model rather than extended.
</p>
</html>", revisions="<html>
<p>Modified from IBPSA Library</p>
</html>"),
Icon(coordinateSystem(
          preserveAspectRatio=true,
          extent={{-100.0,-100.0},{100.0,100.0}}),
        graphics={
        Bitmap(extent={{-62,-76},{72,88}}, fileName=
              "modelica://TRANSFORM/Resources/Images/Icons/Integral.jpg"),
          Text(
            extent={{-88,-94},{212,-54}},
          lineColor={0,0,0},
          textString="y_reset_in",
          visible=reset == TRANSFORM.Types.Reset.Input,
          horizontalAlignment=TextAlignment.Left),
          Text(
            extent={{-88,56},{206,92}},
          lineColor={0,0,0},
          textString="k=%k",
          horizontalAlignment=TextAlignment.Left),
          Text(
            extent={{-92,-12},{208,28}},
          lineColor={0,0,0},
          horizontalAlignment=TextAlignment.Left,
          textString="u"),
          Text(
            extent={{70,-14},{370,26}},
          lineColor={0,0,0},
          horizontalAlignment=TextAlignment.Left,
          textString="y")}));
end IntegratorWithReset;
