within TRANSFORM.Fluid.Examples.SteamRankine_BalanceOfPlant.Components.Records;
record RankineStartValues
  extends TRANSFORM.Icons.Record;
  // Pressure
  parameter Modelica.SIunits.Pressure p_start_turbine_HP_stage1_feed
    "Start value turbine HP feed pressure" annotation(Evaluate=true,Dialog(group="Pressure"));
  parameter Modelica.SIunits.Pressure p_start_turbine_HP_stage1_drain
    "Start value turbine HP drain pressure" annotation(Evaluate=true,Dialog(group="Pressure"));
  parameter Modelica.SIunits.Pressure p_start_turbine_HP_stage2_feed
    "Start value turbine HP feed pressure" annotation(Evaluate=true,Dialog(group="Pressure"));
  parameter Modelica.SIunits.Pressure p_start_turbine_HP_stage2_drain
    "Start value turbine HP drain pressure" annotation(Evaluate=true,Dialog(group="Pressure"));
  parameter Modelica.SIunits.Pressure p_start_turbine_LP_stage1_feed
    "Start value turbine LP feed pressure" annotation(Evaluate=true,Dialog(group="Pressure"));
  parameter Modelica.SIunits.Pressure p_start_turbine_LP_stage1_drain
    "Start value turbine IP drain pressure" annotation(Evaluate=true,Dialog(group="Pressure"));
  parameter Modelica.SIunits.Pressure p_start_turbine_LP_stage2_drain
    "Start value turbine LP drain pressure" annotation(Evaluate=true,Dialog(group="Pressure"));
  parameter Modelica.SIunits.Pressure p_start_condenser
    "Start value condenser pressure" annotation(Evaluate=true,Dialog(group="Pressure"));
  parameter Modelica.SIunits.Pressure p_start_feedWaterPump_drain
    "Start value feed water pump pressure (at drain)" annotation(Evaluate=true,Dialog(group="Pressure"));
  parameter Modelica.SIunits.Pressure p_start_preheater_LP
    "Start value LP preheater pressure" annotation(Evaluate=true,Dialog(group="Pressure"));
  parameter Modelica.SIunits.Pressure p_start_dearator
    "Start value LP preheater pressure" annotation(Evaluate=true,Dialog(group="Pressure"));
  parameter Modelica.SIunits.Pressure p_start_preheater_HP
    "Start value HP preheater pressure" annotation(Evaluate=true,Dialog(group="Pressure"));
  parameter Modelica.SIunits.Pressure p_start_preheater_HP_cooling_in
    "Start value HP preheater pressure cooling inlet " annotation(Evaluate=true,Dialog(group="Pressure"));
  parameter Modelica.SIunits.Pressure p_start_preheater_HP_cooling_out
    "Start value HP preheater pressure cooling outlet" annotation(Evaluate=true,Dialog(group="Pressure"));
  parameter Modelica.SIunits.Pressure p_start_to_SG_drain
    "Start value drain to steam generator pressure" annotation(Evaluate=true,Dialog(group="Pressure"));
  // Temperature
  parameter Modelica.SIunits.Temperature T_start_turbine_HP_stage1_feed
    "Start value turbine HP feed temperature" annotation(Evaluate=true,Dialog(group="Temperature"));
  parameter Modelica.SIunits.Temperature T_start_turbine_HP_stage1_drain
    "Start value turbine HP drain temperature" annotation(Evaluate=true,Dialog(group="Temperature"));
  parameter Modelica.SIunits.Temperature T_start_turbine_LP_feed
    "Start value turbine LP feed temperature" annotation(Evaluate=true,Dialog(group="Temperature"));
  parameter Modelica.SIunits.Temperature T_start_turbine_IP_drain
    "Start value turbine IP drain temperature" annotation(Evaluate=true,Dialog(group="Temperature"));
  parameter Modelica.SIunits.Temperature T_start_turbine_LP_drain
    "Start value turbine IP drain temperature" annotation(Evaluate=true,Dialog(group="Temperature"));
  parameter Modelica.SIunits.Temperature T_start_preheater_HP_cooling_out
    "Start value HP preheater cooling outlet temperature" annotation(Evaluate=true,Dialog(group="Temperature"));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(revisions="<html>
<!--copyright-->
</html>"));
end RankineStartValues;
