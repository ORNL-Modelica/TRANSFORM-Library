within TRANSFORM.Fluid.Sensors.BaseClasses;
connector statePort
//   Real p annotation ();
//   Real T annotation ();
//   Real m_flow annotation ();
//   Real h_out annotation ();
  extends TRANSFORM.Icons.UnderConstruction;
  SI.Pressure p "Absolute pressure";
  SI.Temperature T "Temperature";
  SI.SpecificEnthalpy h_out "Specific Enthalpy";
  SI.MassFlowRate m_flow "Mass flow rate";
  annotation (Icon(graphics={Ellipse(
          extent={{-100,100},{98,-100}},
          lineColor={0,0,0},
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid)}));
end statePort;
