within TRANSFORM.HeatAndMassTransfer.Volumes;
model SimpleWall_Cylinder "Lumped cylindrical wall between two heat ports"
  import Modelica.Fluid.Types.Dynamics;
  input SI.Length length "Length"
    annotation (Dialog(group="Inputs"));
  input SI.Length r_inner "Inner radius"
    annotation (Dialog(group="Inputs"));
  input SI.Length r_outer "Outer radius"
    annotation (Dialog(group="Inputs"));
  SI.Area surfaceArea_inner = 2*pi*r_inner*length "Inner surface area for heat transfer";
  SI.Area surfaceArea_outer = 2*pi*r_outer*length "Outer surface area for heat transfer";
  extends BaseClasses.PartialVolume(
    final V=pi*(r_outer^2-r_inner^2)*length);
  input SI.ThermalResistance R=log(r_outer/r_inner)/(2*pi*length*lambda) "Thermal resistance"
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
  annotation (defaultComponentName="simpleWall",
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})), Icon(coordinateSystem(preserveAspectRatio=false,
          extent={{-100,-100},{100,100}}), graphics={
        Ellipse(
          extent={{80,80},{-80,-80}},
          lineColor={0,0,0},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid),
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
        Ellipse(
          extent={{40,38},{-40,-40}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}),
    Documentation(info="<html>
<p>Cylindrical wall with one temperature, between two heat ports. <code>SimpleWall</code> is the same model for a plane wall, and <code>Conduction_1D</code> with a cylindrical geometry divides a wall into several volumes.</p>
<h4>Assumptions and limits</h4>
<ul>
<li>The energy balance has no term for the mass that a change of <code>length</code>, <code>r_inner</code> or <code>r_outer</code> adds or removes during a run.</li>
</ul>
<h4>Use</h4>
<ul>
<li><code>R</code> is split between the ports as in <code>SimpleWall</code>.</li>
<li>The two ports are treated alike, so either can be connected at the inner surface.</li>
</ul>
</html>"));
end SimpleWall_Cylinder;
