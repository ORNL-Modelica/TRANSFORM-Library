within TRANSFORM.HeatAndMassTransfer.Interfaces;
connector HeatPort
  "Interface for one-dimensional heat transfer"

  flow Modelica.SIunits.HeatFlowRate Q_flow
    "Heat flow rate. Flow from the connection point into the component is positive.";
  Modelica.SIunits.Temperature T "Temperature at the connection point";

end HeatPort;
