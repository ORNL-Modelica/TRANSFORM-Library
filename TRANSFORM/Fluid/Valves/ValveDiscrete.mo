within TRANSFORM.Fluid.Valves;
model ValveDiscrete "Valve for water/steam flows with linear pressure drop"
  extends TRANSFORM.Fluid.Valves.BaseClasses.PartialTwoPortTransport;
  parameter SI.AbsolutePressure dp_nominal
    "Nominal pressure drop at full opening=1"
    annotation(Dialog(group="Nominal operating point"));
  parameter Medium.MassFlowRate m_flow_nominal
    "Nominal mass flowrate at full opening=1";
  final parameter Modelica.Fluid.Types.HydraulicConductance k=m_flow_nominal/
      dp_nominal "Hydraulic conductance at full opening=1";
  Modelica.Blocks.Interfaces.BooleanInput open
  annotation (Placement(transformation(
        origin={0,80},
        extent={{-20,-20},{20,20}},
        rotation=270)));
  parameter Real opening_min(min=0)=0
    "Remaining opening if closed, causing small leakage flow";
equation
  m_flow = if open then 1*k*dp else opening_min*k*dp;
  // Isenthalpic state transformation (no storage and no loss of energy)
  port_a.h_outflow = inStream(port_b.h_outflow);
  port_b.h_outflow = inStream(port_a.h_outflow);
annotation (
  Icon(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}}), graphics={
        Line(points={{0,50},{0,0}}),
        Rectangle(
          extent={{-20,60},{20,50}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-100,50},{100,-50},{100,50},{0,0},{-100,-50},{-100,50}},
          fillColor=DynamicSelect({255,255,255}, if open > 0.5 then {0,255,0} else
                    {255,255,255}),
          lineColor={0,0,0},
          fillPattern=FillPattern.Solid)}),
  Documentation(info="<html>
<p>
This very simple model provides a (small) pressure drop which is proportional to the flowrate if the Boolean open signal is <b>true</b>. Otherwise, the mass flow rate is zero. If opening_min > 0, a small leakage mass flow rate occurs when open = <b>false</b>.
</p>
<p>This model can be used for simplified modelling of on-off valves, when it is not important to accurately describe the pressure loss when the valve is open. Although the medium model is not used to determine the pressure loss, it must be nevertheless be specified, so that the fluid ports can be connected to other components using the same medium model.</p>
<p>The model is adiabatic (no heat losses to the ambient) and neglects changes in kinetic energy from the inlet to the outlet.</p>
<p>
In a diagram animation, the valve is shown in \"green\", when
it is open.
</p>
</html>",
    revisions="<html>
<ul>
<li><i>Nov 2005</i>
    by Katja Poschlad (based on ValveLinear).</li>
</ul>
</html>"));
end ValveDiscrete;
