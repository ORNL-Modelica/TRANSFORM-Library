within TRANSFORM.Fluid.Pipes_Obsolete.ClosureModels.HeatTransfer.Lumped.BaseClasses;
partial model PartialLumpedHeatTransfer
  "Common interface for heat transfer models"

  // Parameters
  replaceable package Medium =
    Modelica.Media.Water.StandardWater
    constrainedby Modelica.Media.Interfaces.PartialTwoPhaseMedium
    "Medium in the component"
    annotation(Dialog(tab="Internal Interface"));

  // Inputs provided to heat transfer model
  input Medium.ThermodynamicState state
    "Thermodynamic state" annotation(Dialog(tab="Internal Interface"));
  input SI.MassFlowRate m_flow "Mass flow rate";
  input SI.Area crossArea "Cross sectional flow area";
  input SI.Area surfaceArea "Heat transfer area";
  input SI.Length dimension "Characteristic dimension (e.g. hydraulic diameter or length)";

  parameter Real nParallel "number of identical parallel flow devices"
     annotation(Dialog(tab="Internal Interface",enable=false,group="Geometry"));

  SI.HeatFlowRate Q_flow "Heat flow rates";
  SI.Temperature T_wall "Wall temperature";

  Media.BaseProperties2Phase medium2(redeclare package Medium = Medium, state=
        state)
    annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));

  Media.BaseProperties2Phase medium2_film(redeclare package Medium = Medium,
      state=state)
    annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));

  HeatAndMassTransfer.Interfaces.HeatPorts_Flow heatPort annotation (Placement(
        transformation(extent={{-10,90},{10,110}}), iconTransformation(extent={
            {-40,90},{40,110}})));

equation
  Q_flow = heatPort.Q_flow;
  T_wall = heatPort.T;

  annotation (Documentation(info="<html>
<p>
This component is a common interface for heat transfer models. The heat flow rates <code>Q_flows</code> through the boundaries of nHT flow segments
are obtained as function of the thermodynamic <code>states</code> of the flow segments for a given fluid <code>Medium</code>,
the <code>surfaceAreas</code> and the boundary temperatures <code>heatPorts.T</code>.
</p>
<p>
The heat loss coefficient <code>k</code> can be used to model a thermal isolation between <code>heatPorts.T</code> and <code>T_ambient</code>.</p>
<p>
An extending model implementing this interface needs to define one equation: the relation between the predefined fluid temperatures <code>Ts</code>,
the boundary temperatures <code>heatPorts.T</code>, and the heat flow rates <code>Q_flows</code>.
</p>
</html>"), Icon(graphics={   Ellipse(
          extent={{100,100},{-100,-100}},
          lineColor={0,0,0},
          fillColor={199,0,0},
          fillPattern=FillPattern.Sphere),Text(
          extent={{-64,12},{64,-14}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="%name")}));
end PartialLumpedHeatTransfer;
