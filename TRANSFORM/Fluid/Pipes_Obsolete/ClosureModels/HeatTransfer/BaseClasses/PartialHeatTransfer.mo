within TRANSFORM.Fluid.Pipes_Obsolete.ClosureModels.HeatTransfer.BaseClasses;
partial model PartialHeatTransfer "Common interface for heat transfer models"

  // Parameters
  replaceable package Medium =
      Modelica.Media.Interfaces.PartialMedium
    "Medium in the component"
    annotation(Dialog(tab="Internal Interface",enable=false));

  parameter Integer nHT=1 "Number of heat transfer segments"
    annotation(Dialog(tab="Internal Interface",enable=false), Evaluate=true);

  // Inputs provided to heat transfer model
  input Medium.ThermodynamicState[nHT] states
    "Thermodynamic states of flow segments";

  input SI.Area[nHT] surfaceAreas "Heat transfer areas";

  // Outputs defined by heat transfer model
  output SI.HeatFlowRate[nHT] Q_flows "Heat flow rates";

  // Parameters
  parameter Boolean use_k = false
    "= true to use k value for thermal isolation"
    annotation(Dialog(tab="Internal Interface",enable=false));
  parameter SI.CoefficientOfHeatTransfer k = 0
    "Heat transfer coefficient to ambient"
    annotation(Dialog(group="Ambient"),Evaluate=true);
  parameter SI.Temperature T_ambient = system.T_ambient "Ambient temperature"
    annotation(Dialog(group="Ambient"));
  outer Modelica.Fluid.System system "System wide properties";

  // Heat ports
  Modelica.Fluid.Interfaces.HeatPorts_a[nHT] heatPorts
    "Heat port to component boundary"
    annotation (Placement(transformation(extent={{-10,60},{10,80}},
            rotation=0), iconTransformation(extent={{-20,60},{20,80}})));

  // Variables
  SI.Temperature[nHT] Ts = Medium.temperature(states)
    "Temperatures defined by fluid states";

equation
  if use_k then
    Q_flows = heatPorts.Q_flow + {k*surfaceAreas[i]*(T_ambient - heatPorts[i].T) for i in 1:nHT};
  else
    Q_flows = heatPorts.Q_flow;
  end if;

  annotation (Documentation(info="<html>
<p>
This component is a common interface for heat transfer models. The heat flow rates <code>Q_flows[nHT]</code> through the boundaries of nHT flow segments
are obtained as function of the thermodynamic <code>states</code> of the flow segments for a given fluid <code>Medium</code>,
the <code>surfaceAreas[nHT]</code> and the boundary temperatures <code>heatPorts[nHT].T</code>.
</p>
<p>
The heat loss coefficient <code>k</code> can be used to model a thermal isolation between <code>heatPorts.T</code> and <code>T_ambient</code>.</p>
<p>
An extending model implementing this interface needs to define one equation: the relation between the predefined fluid temperatures <code>Ts[nHT]</code>,
the boundary temperatures <code>heatPorts[nHT].T</code>, and the heat flow rates <code>Q_flows[nHT]</code>.
</p>
</html>"));
end PartialHeatTransfer;
