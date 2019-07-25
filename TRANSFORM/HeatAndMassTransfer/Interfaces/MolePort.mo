within TRANSFORM.HeatAndMassTransfer.Interfaces;
connector MolePort "Interface for one-dimensional mole/mass transfer"
  parameter Integer nC = 1 "Number of substances";
  flow SI.MolarFlowRate n_flow[nC]
    "Molar flow rate. Flow from the connection point into the component is positive.";
  Modelica.SIunits.Concentration C[nC] "Concentration at the connection point";
end MolePort;
