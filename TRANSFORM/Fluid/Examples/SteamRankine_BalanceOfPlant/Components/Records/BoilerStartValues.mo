within TRANSFORM.Fluid.Examples.SteamRankine_BalanceOfPlant.Components.Records;
record BoilerStartValues
  extends TRANSFORM.Icons.Record;

  // Pressure
  parameter Modelica.SIunits.Pressure p_start_boiler
    "Start value boiler pressure" annotation(Evaluate=true,Dialog(group="Pressure"));
  parameter Modelica.SIunits.PressureDifference dp_start_riser=1e5
    "Start value frictional pressure drop riser tubes" annotation(Evaluate=true,Dialog(group="Pressure drop"));

  // Mass-flow
  parameter Modelica.SIunits.MassFlowRate m_flow_start_feedWater
    "Start value  feed water mass flow rate" annotation(Dialog(group="Flow"));
  parameter Modelica.SIunits.MassFlowRate m_flow_start_circulation
    "Start value boiler circulation flow rate" annotation(Evaluate=true,Dialog(group="Flow"));

  // Level
  parameter Modelica.SIunits.Length boiler_level_start=0 "Level start value"
    annotation(Evaluate=true,Dialog(group="Level"));

  // Riser vapor quality
  parameter Modelica.SIunits.MassFraction riser_vaporQuality_start_out=0.83 "Riser outlet vapor quality"
    annotation(Evaluate=true,Dialog(group="Vapor quality"));

 // Temperature
    parameter Modelica.SIunits.Temperature T_SG_water_inlet=NominalData.T_SG_water_in                         "Steam generator inlet water temperature"
    annotation(Evaluate=true,Dialog(group="Temperature"));

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(revisions="<html>
<!--copyright-->
</html>"));
end BoilerStartValues;
