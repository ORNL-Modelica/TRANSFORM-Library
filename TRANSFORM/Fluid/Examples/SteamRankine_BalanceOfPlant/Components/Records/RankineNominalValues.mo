within TRANSFORM.Fluid.Examples.SteamRankine_BalanceOfPlant.Components.Records;
record RankineNominalValues
  extends TRANSFORM.Icons.Record;
  replaceable package Medium =
      Modelica.Media.Water.WaterIF97_ph
    annotation (__Dymola_choicesAllMatching=true);
  // Pressure
  parameter Modelica.SIunits.Pressure p_nom_turbine_HP_stage1_feed=70e5
    "Nominal turbine HP feed pressure" annotation(Evaluate=true,Dialog(group="Pressure"));
  parameter Modelica.SIunits.Pressure p_nom_turbine_HP_stage1_drain=25e5
    "Nominal turbine HP drain pressure" annotation(Evaluate=true,Dialog(group="Pressure"));
  parameter Modelica.SIunits.Pressure p_nom_turbine_HP_stage2_feed=p_nom_turbine_HP_stage1_drain
    "Nominal turbine HP feed pressure" annotation(Evaluate=true,Dialog(group="Pressure"));
  parameter Modelica.SIunits.Pressure p_nom_turbine_HP_stage2_drain=13e5
    "Nominal turbine HP drain pressure" annotation(Evaluate=true,Dialog(group="Pressure"));
  parameter Modelica.SIunits.Pressure p_nom_turbine_LP_stage1_feed=12e5
    "Nominal turbine LP feed pressure" annotation(Evaluate=true,Dialog(group="Pressure"));
  parameter Modelica.SIunits.Pressure p_nom_turbine_LP_stage1_drain=7e5
    "Nominal turbine LP drain pressure" annotation(Evaluate=true,Dialog(group="Pressure"));
  parameter Modelica.SIunits.Pressure p_nom_turbine_LP_stage2_drain=2e5
    "Nominal turbine LP drain pressure" annotation(Evaluate=true,Dialog(group="Pressure"));
  parameter Modelica.SIunits.Pressure p_nom_condenser=0.033e5
    "Nominal condenser pressure" annotation(Evaluate=true,Dialog(group="Pressure"));
  parameter Modelica.SIunits.Pressure p_nom_feedWaterPump_drain=82e5
    "Nominal feed water pump pressure (at drain)" annotation(Evaluate=true,Dialog(group="Pressure"));
  parameter Modelica.SIunits.Pressure p_nom_preheater_LP=1.95e5
    "Nominal LP preheater pressure" annotation(Evaluate=true,Dialog(group="Pressure"));
  parameter Modelica.SIunits.Pressure p_nom_dearator=6.9e5
    "Nominal LP preheater pressure" annotation(Evaluate=true,Dialog(group="Pressure"));
  parameter Modelica.SIunits.Pressure p_nom_preheater_HP=24.5e5
    "Nominal HP preheater pressure" annotation(Evaluate=true,Dialog(group="Pressure"));
  parameter Modelica.SIunits.Pressure p_nom_preheater_HP_cooling_in=77e5
    "Nominal HP preheater cooling inlet pressure" annotation(Evaluate=true,Dialog(group="Pressure"));
  parameter Modelica.SIunits.Pressure p_nom_preheater_HP_cooling_out=73e5
    "Nominal HP preheater cooling outlet pressure" annotation(Evaluate=true,Dialog(group="Pressure"));
  parameter Modelica.SIunits.Pressure p_nom_to_SG_drain=72e5
    "Nominal drain to steam generator pressure" annotation(Evaluate=true,Dialog(group="Pressure"));
  // Temperature
  parameter Modelica.SIunits.Temperature T_nom_turbine_HP_stage1_feed= 580+273.15
    "Nominal turbine HP feed temperature" annotation(Evaluate=true,Dialog(group="Temperature"));
  parameter Modelica.SIunits.Temperature T_nom_turbine_HP_stage1_drain=Medium.saturationTemperature(p_nom_turbine_HP_stage1_drain)+5
    "Nominal turbine HP drain temperature" annotation(Evaluate=true,Dialog(group="Temperature"));
  parameter Modelica.SIunits.Temperature T_nom_turbine_LP_stage1_feed=Medium.saturationTemperature(p_nom_turbine_LP_stage1_feed)+5
    "Nominal turbine LP feed temperature" annotation(Evaluate=true,Dialog(group="Temperature"));
  parameter Modelica.SIunits.Temperature T_nom_turbine_LP_stage1_drain=Medium.saturationTemperature(p_nom_turbine_LP_stage1_drain)+5
    "Nominal turbine LP drain temperature" annotation(Evaluate=true,Dialog(group="Temperature"));
  parameter Modelica.SIunits.Temperature T_nom_turbine_LP_stage2_drain=Medium.saturationTemperature(p_nom_turbine_LP_stage2_drain)+5
    "Nominal turbine LP drain temperature" annotation(Evaluate=true,Dialog(group="Temperature"));
  parameter Modelica.SIunits.Temperature T_nom_preheater_HP_cooling_out=256+273.15
    "Nominal HP preheater cooling temperrature" annotation(Evaluate=true,Dialog(group="Temperature"));
  // Mass-flow
  parameter Modelica.SIunits.MassFlowRate m_flow_nom_turbine_HP_stage1=290*0.78*3
    "Nominal turbine HP mass flow rate" annotation(Evaluate=true,Dialog(group="Flow"));
  parameter Modelica.SIunits.MassFlowRate m_flow_nom_turbine_HP_stage2=245*0.78*3
    "Nominal turbine HP mass flow rate" annotation(Evaluate=true,Dialog(group="Flow"));
  parameter Modelica.SIunits.MassFlowRate m_flow_nom_turbine_LP_stage1=245*0.78*3
    "Nominal turbine IP1 mass flow rate" annotation(Evaluate=true,Dialog(group="Flow"));
  parameter Modelica.SIunits.MassFlowRate m_flow_nom_turbine_LP_stage2=230*0.78*3
    "Nominal turbine LP mass flow rate" annotation(Evaluate=true,Dialog(group="Flow"));
  parameter Modelica.SIunits.MassFlowRate m_flow_nom_turbine_LP_stage3=200*0.78*3
    "Nominal turbine LP2 mass flow rate" annotation(Evaluate=true,Dialog(group="Flow"));
  parameter Modelica.SIunits.MassFlowRate m_flow_nom_feedWaterPump=300*0.78*3
    "Nominal feed water pump mass flow rate" annotation(Dialog(group="Flow"));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(revisions="<html>
<!--copyright-->
</html>"));
end RankineNominalValues;
