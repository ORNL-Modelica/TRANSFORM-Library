within TRANSFORM.Examples.LightWaterReactor_PWR_Westinghouse.Components;
record dataold
  // parameters to reference in model
  parameter SI.MassFlowRate m_flow_steam_nominal=
      Units.Conversions.Functions.MassFlowRate_kg_s.from_lbm_hr(1.8e6);                                                       // steamRate*lb_to_kg/3600;
  parameter SI.MassFlowRate m_flow_circulation_nominal=
      Units.Conversions.Functions.MassFlowRate_kg_s.from_lbm_hr(2.2e6);                                                                   //drumRecirculationRate*lb_to_kg/3600*10^6;
  parameter SI.Pressure p_steam_nominal=
      Units.Conversions.Functions.Pressure_Pa.from_psi(1000);                                                 // steamPressure*psi_to_Pa;
  parameter SI.Pressure p_SG_inlet_nominal=
      Units.Conversions.Functions.Pressure_Pa.from_psi(1036);                                                //pin_SG_water*psi_to_Pa;
  parameter SI.Pressure p_condenser_nominal=
      Units.Conversions.Functions.Pressure_Pa.from_inHg(2.5);                                                     //condenserPressure*inchMercuryAbs_to_Pa;
  parameter SI.HeatFlowRate Q_condenser_nominal=
      Units.Conversions.Functions.Power_W.from_btu_hr(3.1e9);                                                       // condenserHeatRate*btu_per_h_to_Watt/3600;
  parameter SI.Temperature T_steam_nominal=
      Units.Conversions.Functions.Temperature_K.from_degF(545);
  parameter SI.Temperature T_feedwater_nominal=
      Units.Conversions.Functions.Temperature_K.from_degF(420);
  parameter SI.Temperature T_SG_inlet_nominal=
      Units.Conversions.Functions.Temperature_K.from_degF(440);
  // Pressure
  parameter SI.Pressure p_boiler_nominal=p_steam_nominal
    "Nominal boiler pressure"
    annotation (Evaluate=true, Dialog(group="Pressure"));
  parameter SI.PressureDifference dp_riser_nominal=1e5
    "Nominal frictional pressure drop riser tubes" annotation(Evaluate=true,Dialog(group=
          "Pressure drop"));
  parameter SI.PressureDifference dp_feedwatervalve_nominal=1e5
    "Nominal pressure feed water valve" annotation(Evaluate=true,Dialog(group=
          "Pressure drop"));
  // Mass-flow
  parameter SI.MassFlowRate m_flow_feedWater_nominal=m_flow_steam_nominal
    "Nominal feed water mass flow rate" annotation (Dialog(group="Flow"));
  parameter Modelica.SIunits.MassFlowRate m_flow_nom_circulation=
      m_flow_feedWater_nominal*1.1 "Nominal boiler circulation flow rate"
    annotation (Evaluate=true, Dialog(group="Flow"));
  // Temperature
  parameter Modelica.SIunits.Temperature T_nom_feedWater=T_feedwater_nominal
    "Nominal feed water temperature" annotation (Dialog(group="Flow"));
  // Pressure
  parameter Modelica.SIunits.Pressure p_start_boiler=p_boiler_nominal
    "Start value boiler pressure"
    annotation (Evaluate=true, Dialog(group="Pressure"));
  parameter Modelica.SIunits.PressureDifference dp_start_riser=dp_riser_nominal
    "Start value frictional pressure drop riser tubes"
    annotation (Evaluate=true, Dialog(group="Pressure drop"));
  // Mass-flow
  parameter Modelica.SIunits.MassFlowRate m_flow_start_feedWater=
      m_flow_feedWater_nominal "Start value  feed water mass flow rate"
    annotation (Dialog(group="Flow"));
  parameter Modelica.SIunits.MassFlowRate m_flow_start_circulation=m_flow_nom_circulation
    "Start value boiler circulation flow rate" annotation(Evaluate=true,Dialog(group="Flow"));
  // Level
  parameter Modelica.SIunits.Length boiler_level_start=0 "Level start value"
    annotation(Evaluate=true,Dialog(group="Level"));
  // Riser vapor quality
  parameter Modelica.SIunits.MassFraction riser_vaporQuality_start_out=0.83 "Riser outlet vapor quality"
    annotation(Evaluate=true,Dialog(group="Vapor quality"));
 // Temperature
  parameter Modelica.SIunits.Temperature T_SG_water_inlet=T_SG_inlet_nominal
    "Steam generator inlet water temperature"
    annotation (Evaluate=true, Dialog(group="Temperature"));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end dataold;
