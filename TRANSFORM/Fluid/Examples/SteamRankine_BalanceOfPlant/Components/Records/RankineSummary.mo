within TRANSFORM.Fluid.Examples.SteamRankine_BalanceOfPlant.Components.Records;
record RankineSummary "Summary record for Rankine example"
  extends TRANSFORM.Icons.Record;

  // Pressure
  Modelica.SIunits.Pressure p_turbine_HP_stage1_feed "Turbine HP feed pressure"
                               annotation(Dialog(group="Pressure"));
  Modelica.SIunits.Pressure p_turbine_HP_stage1_drain
    "Turbine HP drain pressure" annotation(Dialog(group="Pressure"));
  Modelica.SIunits.Pressure p_turbine_LP_feed
    "Turbine IP feed pressure" annotation(Dialog(group="Pressure"));
  Modelica.SIunits.Pressure p_turbine_LP_drain
    "Turbine LP drain pressure" annotation(Dialog(group="Pressure"));
  Modelica.SIunits.Pressure p_condenser "Condenser pressure"
                                 annotation(Dialog(group="Pressure"));
  Modelica.SIunits.Pressure p_feedWaterPump_drain
    "Feed water pump pressure (at drain)" annotation(Dialog(group="Pressure"));
  Modelica.SIunits.Pressure p_preheater_LP "LP preheater pressure"
                            annotation(Dialog(group="Pressure"));
  Modelica.SIunits.Pressure p_dearator "LP preheater pressure"
                                    annotation(Dialog(group="Pressure"));
  Modelica.SIunits.Pressure p_preheater_HP "HP preheater pressure"
                            annotation(Dialog(group="Pressure"));
  Modelica.SIunits.Pressure p_preheater_HP_cooling_in
    "HP preheater cooling inlet pressure" annotation(Dialog(group="Pressure"));
  Modelica.SIunits.Pressure p_preheater_HP_cooling_out
    "HP preheater cooling outlet pressure" annotation(Dialog(group="Pressure"));

  // Temperature
  Modelica.SIunits.Temperature T_turbine_HP_stage1_feed
    "Turbine HP feed temperature" annotation(Dialog(group="Temperature"));
  Modelica.SIunits.Temperature T_turbine_HP_stage1_drain
    "Turbine HP drain temperature" annotation(Dialog(group="Temperature"));
  Modelica.SIunits.Temperature T_turbine_LP_feed
    "Turbine LP feed temperature" annotation(Dialog(group="Temperature"));
  Modelica.SIunits.Temperature T_turbine_LP_drain
    "Turbine LP drain temperature" annotation(Dialog(group="Temperature"));
  Modelica.SIunits.Temperature T_preheater_HP_cooling_out
    "HP preheater cooling temperrature" annotation(Dialog(group="Temperature"));
  Modelica.SIunits.Temperature T_condenser "Condenser temperature"
                            annotation(Dialog(group="Temperature"));
  Modelica.SIunits.Temperature T_condenser_cooling_in
    "Condenser inlet cooling temperature"
                            annotation(Dialog(group="Temperature"));
  Modelica.SIunits.Temperature T_condenser_cooling_out
    "Condenser outlet cooling temperature"
                            annotation(Dialog(group="Temperature"));

  // Mass-flow
  Modelica.SIunits.MassFlowRate m_flow_turbine_HP
    "Turbine HP mass flow rate" annotation(Dialog(group="Flow"));
  Modelica.SIunits.MassFlowRate m_flow_turbine_LP_feed
    "Turbine LP feed mass flow rate" annotation(Dialog(group="Flow"));
  Modelica.SIunits.MassFlowRate m_flow_turbine_LP_drain
    "Turbine LP drain mass flow rate" annotation(Dialog(group="Flow"));
  Modelica.SIunits.MassFlowRate m_flow_feedWaterPump
    "Feed water pump mass flow rate" annotation(Dialog(group="Flow"));

  // Levels
  Modelica.SIunits.Height level_preheater_LP
    "LP preheater codensate level"
                            annotation(Dialog(group="Condensate level"));
  Modelica.SIunits.Height level_dearator "Dearator codensate level"
                                    annotation(Dialog(group="Condensate level"));
  Modelica.SIunits.Height level_preheater_HP
    "HP preheater codensate level"
                            annotation(Dialog(group="Condensate level"));
  Modelica.SIunits.Height level_condenser "Condenser codensate level"
                            annotation(Dialog(group="Condensate level"));

  // Power production
  Modelica.SIunits.Power power_generator "Generator power"
                            annotation(Dialog(group="Power production"));
  // Power consumption
  Modelica.SIunits.Power power_pump_lp "Pump lp power consumption"
                            annotation(Dialog(group="Power consumption"));
  Modelica.SIunits.Power power_pump_ip "Pump ip  power consumption"
                            annotation(Dialog(group="Power consumption"));
  Modelica.SIunits.Power power_pump_hp "Pump hp power consumption"
                            annotation(Dialog(group="Power consumption"));
  Modelica.SIunits.Power power_consumption_total=power_pump_lp+power_pump_ip+power_pump_hp
    "Total power consumption"
                            annotation(Dialog(group="Power consumption"));

 // Heat flow
  Modelica.SIunits.HeatFlowRate Q_preheater_LP "LP preheater heat duty"
                            annotation(Dialog(group="Heat"));
  Modelica.SIunits.HeatFlowRate Q_preheater_HP "HP preheater heat duty"
                            annotation(Dialog(group="Heat"));
  Modelica.SIunits.HeatFlowRate Q_condenser "Condenser heat duty"
                            annotation(Dialog(group="Heat"));

 // Control inputs
  Real u_pump_lp "Pump lp control input"
                            annotation(Dialog(group="Control input"));
  Real u_pump_ip "Pump ip control input"
                            annotation(Dialog(group="Control input"));
  Real u_pump_hp "Pump hp control input"
                            annotation(Dialog(group="Control input"));
  Real u_valve_preheat_hp "Valve preheat hp control input"
                            annotation(Dialog(group="Control input"));

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(revisions="<html>
<!--copyright-->
</html>"));
end RankineSummary;
