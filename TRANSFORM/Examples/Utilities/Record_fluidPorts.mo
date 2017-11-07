within TRANSFORM.Examples.Utilities;
record Record_fluidPorts

  replaceable package Medium = Modelica.Media.Interfaces.PartialMedium
    "Medium at fluid ports" annotation (choicesAllMatching=true);

  parameter SI.Pressure p "Absolute pressure";
  parameter SI.Temperature T "Temperature";
  parameter SI.SpecificEnthalpy h "Specific enthalpy";
  parameter SI.MassFlowRate m_flow "Mass flow rate";

  // These will need to be revisited
//   parameter Medium.MassFraction Xi_outflow[Medium.nXi]
//     "Independent mixture mass fractions m_i/m close to the connection point if m_flow < 0";
//   parameter Medium.ExtraProperty C_outflow[Medium.nC]
//     "Properties c_i/m close to the connection point if m_flow < 0";

  annotation (defaultComponentName="BCs_port",
  Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Record_fluidPorts;
