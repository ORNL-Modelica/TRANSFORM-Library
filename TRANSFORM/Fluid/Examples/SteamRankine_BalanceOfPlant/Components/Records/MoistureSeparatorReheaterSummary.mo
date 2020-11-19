within TRANSFORM.Fluid.Examples.SteamRankine_BalanceOfPlant.Components.Records;
record MoistureSeparatorReheaterSummary
  "Summary record for moisture separrator reheater model"
  extends TRANSFORM.Icons.Record;
  Modelica.SIunits.MassFlowRate m_flow_main_steam_in
    "Mass flow rate of main ingoing steam" annotation (Dialog);
  Modelica.SIunits.MassFlowRate m_flow_main_steam_out
    "Mass flow rate of main outgoing steam" annotation (Dialog);
  Modelica.SIunits.MassFlowRate m_flow_main_condensate_out
    "Mass flow rate of condensate from main steam" annotation (Dialog);
  Modelica.SIunits.MassFlowRate m_flow_hot_steam_in
    "Mass flow rate of hot ingoing steam" annotation (Dialog);
  Modelica.SIunits.MassFlowRate m_flow_hot_out
    "Mass flow rate of outgoing hot condensated flow" annotation (Dialog);
  Modelica.SIunits.Power Q_hex "Total heat flow from hot stream to main steam"
    annotation (Dialog);
  Real x_main_steam_in "Steam mass fraction of main inlet steam"
    annotation (Dialog);
  Real x_main_steam_out "Steam mass fraction of main outlet steam"
    annotation (Dialog);
  Modelica.SIunits.Temperature T_main_steam_in "Temperature of main inlet steam"
    annotation (Dialog);
  Modelica.SIunits.Temperature T_main_steam_out "Temperature of main outlet steam"
    annotation (Dialog);
  Modelica.SIunits.Temperature T_hot_steam_in "Temperature of hot inlet steam"
    annotation (Dialog);
  Modelica.SIunits.Temperature T_hot_out "Temperature of hot outlet flow"
    annotation (Dialog);
  annotation ();
end MoistureSeparatorReheaterSummary;
