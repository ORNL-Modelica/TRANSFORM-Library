within TRANSFORM.HeatAndMassTransfer.Volumes;
model SimpleWall_noMedia "Lumped plane wall with properties set as inputs"
  import Modelica.Fluid.Types.Dynamics;
  input SI.Length th "Wall thickness"
    annotation (Dialog(group="Inputs"));
  input SI.Area surfaceArea "Surface area for heat transfer"
    annotation (Dialog(group="Inputs"));
  extends BaseClasses.PartialVolume_noMedia(
    final V=th*surfaceArea,
    d=7763,
    cp=0.3986*T + 341.74);
  input SI.ThermalConductivity lambda=-0.0469*T + 76.813 "Thermal conductivity"
    annotation (Dialog(group="Inputs"));
  input SI.ThermalResistance R=th/(lambda*surfaceArea) "Thermal resistance"
    annotation (Dialog(group="Inputs"));
  input SI.HeatFlowRate Q_gen=0 "Internal heat generation"
    annotation (Dialog(group="Inputs"));
  // Advanced
  parameter Boolean exposeState_a=false
    "= true to define T at port_a, false to define Q_flow"
    annotation (Dialog(group="Model Structure", tab="Advanced"));
  parameter Boolean exposeState_b=false
    "= true to define T at port_b, false to define Q_flow"
    annotation (Dialog(group="Model Structure", tab="Advanced"));
  Interfaces.HeatPort_Flow port_a(T(start=T_start)) "Heat port at one face of the wall" annotation (Placement(
        transformation(extent={{-110,-10},{-90,10}}), iconTransformation(extent=
           {{-110,-10},{-90,10}})));
  Interfaces.HeatPort_Flow port_b(T(start=T_start)) "Heat port at the opposite face of the wall" annotation (Placement(
        transformation(extent={{90,-10},{110,10}}), iconTransformation(extent={
            {90,-10},{110,10}})));
equation
  Ub = port_a.Q_flow + port_b.Q_flow + Q_gen;
  if exposeState_a and exposeState_b then
    port_a.T = T;
    port_b.T = T;
  elseif exposeState_a and not exposeState_b then
    port_a.T = T;
    port_b.Q_flow = (port_b.T - T)/R;
  elseif not exposeState_a and exposeState_b then
    port_a.Q_flow = (port_a.T - T)/R;
    port_b.T = T;
  else
    port_a.Q_flow = (port_a.T - T)*2/R;
    port_b.Q_flow = (port_b.T - T)*2/R;
  end if;
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})), Icon(coordinateSystem(preserveAspectRatio=false,
          extent={{-100,-100},{100,100}}), graphics={
        Ellipse(
          extent={{-92,30},{-108,-30}},
          lineColor={191,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          visible=exposeState_a),
        Ellipse(
          extent={{108,30},{92,-30}},
          lineColor={191,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          visible=exposeState_b),
        Rectangle(
          extent={{-80,80},{80,-80}},
          lineColor={0,0,0},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid)}),
    Documentation(info="<html>
<p>Plane wall with one temperature, between two heat ports, whose density, specific heat capacity and thermal conductivity are inputs. <code>SimpleWall</code> takes the properties from a material package instead.</p>
<h4>Assumptions and limits</h4>
<ul>
<li>The energy balance has no term for the mass that a change of <code>th</code>, <code>surfaceArea</code> or <code>d</code> adds or removes during a run.</li>
</ul>
<h4>Use</h4>
<ul>
<li><code>d</code>, <code>cp</code> and <code>lambda</code> are inputs, so they can be expressions of the wall temperature <code>T</code>. The stored energy is <code>m*cp*(T - T_reference)</code>, so where <code>cp</code> depends on <code>T</code>, as the default does, the heat capacity of the wall is not <code>m*cp</code>.</li>
<li><code>R</code> is split between the ports as in <code>SimpleWall</code>.</li>
</ul>
</html>"));
end SimpleWall_noMedia;
