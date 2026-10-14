within TRANSFORM.HeatAndMassTransfer.Volumes;
model SimpleWall
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
    "=true, T is calculated at port_a1 else Q_flow"
    annotation (Dialog(group="Model Structure", tab="Advanced"));
  parameter Boolean exposeState_b=false
    "=true, T is calculated at port_b1 else Q_flow"
    annotation (Dialog(group="Model Structure", tab="Advanced"));
  Interfaces.HeatPort_Flow port_a(T(start=T_start)) annotation (Placement(
        transformation(extent={{-110,-10},{-90,10}}), iconTransformation(extent=
           {{-110,-10},{-90,10}})));
  Interfaces.HeatPort_Flow port_b(T(start=T_start)) annotation (Placement(
        transformation(extent={{90,-10},{110,10}}), iconTransformation(extent={{
            90,-10},{110,10}})));
  SI.ThermalConductivity lambda = Material.thermalConductivity(material.state);
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
<p>Lumped solid wall that stores energy and connects two heat ports. Thickness <code>th</code> and <code>surfaceArea</code> set the inherited volume; the default thermal resistance is <code>th/(lambda*surfaceArea)</code>, where <code>lambda</code> comes from the selected material state.</p>
<p><code>Q_gen</code> is an internal heat source. The <code>exposeState_a</code> and <code>exposeState_b</code> settings choose whether the material temperature is exposed directly at a port or the port heat flow is determined through the resistance. With neither state exposed, each port uses half of the total resistance. Review the selected material, initialization, and connected components when choosing these settings.</p>
</html>"));
end SimpleWall;
