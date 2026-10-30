within TRANSFORM.HeatAndMassTransfer.Interfaces;
connector HeatPort_Flow
  "Generic connector for defined flow variable (e.g., heat flow rate - Q_flow)"
  extends HeatPort;
  annotation(defaultComponentName = "port_a",
    Documentation(info="<html>
<p>This connector is used for 1-dimensional heat flow between components.
The variables in the connector are:</p>
<pre>
   T       Temperature in [Kelvin].
   Q_flow  Heat flow rate in [Watt].
</pre>
<p>According to the Modelica sign convention, a <b>positive</b> heat flow
rate <b>Q_flow</b> is considered to flow <b>into</b> a component. This
convention has to be used whenever this connector is used in a model
class.</p>
<p>Note, that the two connector classes <b>HeatPort_a</b> and
<b>HeatPort_b</b> are identical with the only exception of the different
<b>icon layout</b>.</p></html>"), Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,100}}), graphics={Rectangle(
          extent={{40,20},{80,-20}},
          lineColor={191,0,0},
          fillColor={191,0,0},
          fillPattern=FillPattern.Solid),
                                  Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={191,0,0},
          fillColor={191,0,0},
          fillPattern=FillPattern.Solid)}),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}), graphics={Rectangle(
          extent={{-40,40},{40,-40}},
          lineColor={191,0,0},
          fillColor={191,0,0},
          fillPattern=FillPattern.Solid), Text(extent={{-150,110},{150,50}},
            textString="%name")}));
end HeatPort_Flow;
