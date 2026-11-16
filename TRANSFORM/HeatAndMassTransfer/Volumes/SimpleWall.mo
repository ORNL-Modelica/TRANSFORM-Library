within TRANSFORM.HeatAndMassTransfer.Volumes;
model SimpleWall "Lumped plane wall between two heat ports"
  import Modelica.Fluid.Types.Dynamics;
  input SI.Length th "Wall thickness"
    annotation (Dialog(group="Inputs"));
  input SI.Area surfaceArea "Surface area for heat transfer"
    annotation (Dialog(group="Inputs"));
  extends BaseClasses.PartialVolume(
    final V=th*surfaceArea);
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
        transformation(extent={{90,-10},{110,10}}), iconTransformation(extent={{
            90,-10},{110,10}})));
  SI.ThermalConductivity lambda = Material.thermalConductivity(material.state) "Thermal conductivity";
equation
  Ub = port_a.Q_flow + port_b.Q_flow + Q_gen;
  if exposeState_a and exposeState_b then
    port_a.T = material.T;
    port_b.T = material.T;
  elseif exposeState_a and not exposeState_b then
    port_a.T = material.T;
    port_b.Q_flow = (port_b.T - material.T)/R;
  elseif not exposeState_a and exposeState_b then
    port_a.Q_flow = (port_a.T - material.T)/R;
    port_b.T = material.T;
  else
    port_a.Q_flow = (port_a.T - material.T)*2/R;
    port_b.Q_flow = (port_b.T - material.T)*2/R;
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
<p>Plane wall with one temperature, between two heat ports. <code>SimpleWall_Cylinder</code> is the same model for a cylindrical wall, <code>SimpleWall_noMedia</code> takes the properties as inputs instead, and <code>Conduction_1D</code> divides a wall into several volumes.</p>
<h4>Assumptions and limits</h4>
<ul>
<li>The energy balance has no term for the mass that a change of <code>th</code> or <code>surfaceArea</code> adds or removes during a run.</li>
</ul>
<h4>Use</h4>
<ul>
<li>With <code>exposeState_a</code> and <code>exposeState_b</code> both false, each port is joined to the wall temperature through half of <code>R</code>. With one of them true, that port is at the wall temperature and the other is joined to it through all of <code>R</code>; with both true, <code>R</code> is not used.</li>
</ul>
</html>"));
end SimpleWall;
