within TRANSFORM.Fluid.Examples.SteamRankine_BalanceOfPlant.Components.Control.ControlBuses;
expandable connector ControlBus_Rankine
  "Control bus that is adapted to the signals connected to it"
  extends
    TRANSFORM.Fluid.Examples.SteamRankine_BalanceOfPlant.Components.Control.Interfaces.SignalBus;
  // Valve inputs
 input Real u_TStopValve "Turbine Stop Valve input [0-1]" annotation ();
 input Real u_TControlValve "Turbine Control Valve input [0-1]" annotation ();
 input Real u_TBypassValve_1 "Turbine Bypass Valve 2 input [0-1]" annotation ();
 input Real u_TBypassValve_2 "Turbine Bypass Valve 2 input [0-1]" annotation ();
 input Real u_TValve_LPT_1 "Low Pressure Turbine 1 Valve input [0-1]" annotation ();
 input Real u_TValve_LPT_2 "Low Pressure Turbine 2 Valve input [0-1]" annotation ();
 input Real u_MSRControlValve_1 "MSR Control Valve 1 input [0-1]" annotation ();
 input Real u_MSRLevelControlValve_1 "MSR Level Control Valve 1 input [0-1]" annotation ();
 input Real u_FWIsolationValve_1 "Feed Water Isolation Valve 1 input [0-1]" annotation ();
 input Real u_FWIsolationValve_2 "Feed Water Isolation Valve 2 input [0-1]" annotation ();
 input Real u_FWIsolationValve_3 "Feed Water Isolation Valve 3 input [0-1]" annotation ();
 input Real u_FWControlValve_1 "FeedWater Control Valve 1 input [0-1]" annotation ();
 input Real u_FWControlValve_2 "FeedWater Control Valve 2 input [0-1]" annotation ();
 input Real u_FWControlValve_3 "FeedWater Control Valve 3 input [0-1]" annotation ();
 input Real u_FWBypassValve_1 "FeedWater Bypass Valve 1 input [0-1]" annotation ();
 input Real u_FWBypassValve_2 "FeedWater Bypass Valve 2 input [0-1]" annotation ();
 input Real u_FWBypassValve_3 "FeedWater Bypass Valve 3 input [0-1]" annotation ();
 input Real u_FWBlockValve_1 "FeedWater Block Valve 1 input [0-1]" annotation ();
 input Real u_FWBlockValve_2 "FeedWater Block Valve 2 input [0-1]" annotation ();
 input Real u_FWBlockValve_3 "FeedWater Block Valve 3 input [0-1]" annotation ();
  // old inputs
 input Real u_valve_HP "Valve input [0-1]" annotation ();
 input Real u_valve_IP "Valve input [0-1]" annotation ();
 input Real u_valve_LP "Valve input [0-1]" annotation ();
 input Real u_valve_preheat_HP "Valve input [0-1]" annotation ();
 input Real u_pumpspeed_HP[3] "Pump speed [rpm]" annotation ();
 input Real u_pumpspeed_IP "Pump speed [rpm]" annotation ();
 input Real u_pumpspeed_LP[3] "Pump speed [rpm]" annotation ();
  // Outputs
 output Real y_FW_To_FWH_HP_flow "FeedWater flow to high pressure feedwater heaters [kg/s]" annotation ();
 output Real y_FW_To_SG_1_flow "FeedWater flow to SG_1 [kg/s]" annotation ();
 output Real y_FW_To_SG_2_flow "FeedWater flow to SG_2 [kg/s]" annotation ();
 output Real y_FW_To_SG_3_flow "FeedWater flow to SG_3 [kg/s]" annotation ();
 output Real y_FWH_HP_level "High Pressure feedwater heater condensate level [%]" annotation ();
 output Real y_FWH_HP_flow_in "High Pressure feedwater heater inlet flow [kg/s]" annotation ();
 output Real y_FWH_HP_flow_out "High Pressure feedwater heater outlet flow [kg/s]" annotation ();
 output Real y_FWH_LP_level "Low Pressure feedwater heaters condensate level [%]" annotation ();
 output Real y_FWH_LP_flow_in "Low Pressure feedwater heater inlet flow [kg/s]" annotation ();
 output Real y_FWH_LP_flow_out "Low Pressure feedwater heater outlet flow [kg/s]" annotation ();
 output Real y_MSR_level "MSR condensate level [%]" annotation ();
 output Real y_MSR_flow_in "MSR inlet flow [kg/s]" annotation ();
 output Real y_MSR_flow_out "MSR outlet flow [kg/s]" annotation ();
 output Real y_Condenser_level "Condenser condensate level [%]" annotation ();
 output Real y_Condenser_flow_in "Condenser inlet flow [kg/s]" annotation ();
 output Real y_Condenser_flow_out "Condenser outlet flow [kg/s]" annotation ();
 output Real y_Generator_Power "Generator power [W]" annotation ();
 output Real y_TurbineHeader_pressure "Steam pressure [Pa]" annotation ();
 output Real y_CondenserPump_dp "Differential pressure over condensate pumps [Pa]" annotation ();
 output Real y_FWH_LP_Pump_dp "Differential pressure over FWH_LP condensate pump [Pa]" annotation ();
 output Real y_FWH_HP_Valve_dp "Differential pressure over FWH_HP condensate control valve [Pa]" annotation ();
 output Real y_MSR_Valve_dp "Differential pressure over MSR condensate control valve [Pa]" annotation ();
 output Real y_FWControlValve_1_dp "Differential pressure over control valve FWControlValve_1 [Pa]" annotation ();
 output Real y_FWControlValve_2_dp "Differential pressure over control valve FWControlValve_2 [Pa]" annotation ();
 output Real y_FWControlValve_3_dp "Differential pressure over control valve FWControlValve_3 [Pa]" annotation ();
  annotation (Documentation(info="<html>
<h4>Description</h4>
<p>Control bus for the Rankine example. </p>
</html>",
    revisions="<html>
<!--copyright-->
</html>"));
end ControlBus_Rankine;
