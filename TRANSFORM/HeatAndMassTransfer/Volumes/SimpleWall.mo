within TRANSFORM.HeatAndMassTransfer.Volumes;
model SimpleWall

  import Modelica.Fluid.Types.Dynamics;

  input SI.Length th "Wall thickness"
    annotation (Dialog(group="Input Variables"));
  input SI.Area surfaceArea "Surface area for heat transfer"
    annotation (Dialog(group="Input Variables"));

  extends BaseClasses.PartialVolume(
    final V=th*surfaceArea);

  input SI.ThermalResistance R=th/(lambda*surfaceArea) "Thermal resistance"
    annotation (Dialog(group="Input Variables"));
  input SI.HeatFlowRate Q_gen=0 "Internal heat generation"
    annotation (Dialog(group="Input Variables"));

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
          fillPattern=FillPattern.Solid)}));
end SimpleWall;
