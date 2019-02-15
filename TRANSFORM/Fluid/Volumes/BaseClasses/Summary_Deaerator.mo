within TRANSFORM.Fluid.Volumes.BaseClasses;
record Summary_Deaerator
  extends TRANSFORM.Icons.Record;
  Modelica.SIunits.Temperature T_gas "Gas temperature"
    annotation (Dialog);
  Modelica.SIunits.Temperature T_liquid "Liquid temperature"
    annotation (Dialog);
  Modelica.SIunits.Temperature T_wall "Wall temperature"
    annotation (Dialog);
  Modelica.SIunits.Pressure p "Pressure" annotation (Dialog);
  Modelica.SIunits.SpecificEnthalpy h_in "Inlet specific enthalpy"
    annotation (Dialog);
  Modelica.SIunits.SpecificEnthalpy h_out_steam
    "Outlet specific enthalpy of outgoing steam" annotation (Dialog);
  Modelica.SIunits.SpecificEnthalpy h_out_condensate
    "Outlet specific enthalpy of outgoing condensate" annotation (Dialog);
  Modelica.SIunits.Power Q_loss "Total heat flow rate to ambient"
    annotation (Dialog);
  Modelica.SIunits.MassFlowRate m_flow_in "Mass flow rate inlet"
    annotation (Dialog);
  Modelica.SIunits.MassFlowRate m_flow_out_steam
    "Mass flow rate of outgoing steam" annotation (Dialog);
  Modelica.SIunits.MassFlowRate m_flow_out_condensate
    "Mass flow rate of outgoing condensate" annotation (Dialog);
  Modelica.SIunits.Length level
    "Liquid level (relative to the condenser bottom outlet)"
    annotation (Dialog);
  Modelica.SIunits.Length level_max
    "Maximum possible level (relative to the condenser bottom outlet)"
    annotation (Dialog);
  Modelica.SIunits.Length level_min
    "Minimum possible Level (relative to the condenser bottom outlet)"
    annotation (Dialog);
  Modelica.SIunits.Mass m "Total fluid mass" annotation (Dialog);
  Real x "Mass fraction of vapor in the fluid volume"
    annotation (Dialog);
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Summary_Deaerator;
